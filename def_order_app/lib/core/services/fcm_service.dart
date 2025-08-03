import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/logger.dart';
import '../error/exceptions.dart';

/// FCM 백그라운드 메시지 핸들러
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logger.i('백그라운드 메시지 수신: ${message.messageId}');
}

/// FCM 서비스
class FCMService {
  static FCMService? _instance;
  static FCMService get instance => _instance ??= FCMService._();
  
  FCMService._();
  
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  StreamController<RemoteMessage>? _messageStreamController;
  Stream<RemoteMessage> get onMessage => _messageStreamController!.stream;
  
  String? _fcmToken;
  String? get fcmToken => _fcmToken;
  
  /// FCM 초기화
  Future<void> initialize() async {
    try {
      logger.i('FCM 서비스 초기화 시작');
      
      // 백그라운드 메시지 핸들러 등록
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // 권한 요청
      final settings = await _requestPermission();
      logger.i('알림 권한 상태: ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        
        // iOS APNS 토큰 확인
        if (Platform.isIOS) {
          final apnsToken = await _messaging.getAPNSToken();
          if (apnsToken == null) {
            logger.w('APNS 토큰을 받을 수 없습니다');
            return;
          }
          logger.i('APNS 토큰 수신 완료');
        }
        
        // FCM 토큰 획득
        await _getFCMToken();
        
        // 로컬 알림 초기화
        await _initializeLocalNotifications();
        
        // 메시지 스트림 설정
        _setupMessageHandlers();
        
        // 토큰 갱신 리스너
        _messaging.onTokenRefresh.listen(_onTokenRefresh);
        
        logger.i('FCM 서비스 초기화 완료');
      } else {
        logger.w('알림 권한이 거부되었습니다');
      }
    } catch (e) {
      logger.e('FCM 초기화 실패', error: e);
      throw ServerException('FCM 초기화에 실패했습니다: $e');
    }
  }
  
  /// 권한 요청
  Future<NotificationSettings> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true, // iOS 임시 권한
      sound: true,
    );
    
    return settings;
  }
  
  /// FCM 토큰 획득
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      
      if (_fcmToken != null) {
        logger.i('FCM 토큰: $_fcmToken');
        await _saveFCMToken(_fcmToken!);
      } else {
        logger.w('FCM 토큰을 받을 수 없습니다');
      }
    } catch (e) {
      logger.e('FCM 토큰 획득 실패', error: e);
    }
  }
  
  /// FCM 토큰 저장 (Supabase)
  Future<void> _saveFCMToken(String token) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      
      if (userId == null) {
        logger.w('로그인된 사용자가 없습니다');
        return;
      }
      
      // profiles 테이블에 FCM 토큰 업데이트
      await supabase
          .from('profiles')
          .update({
            'fcm_token': token,
            'fcm_token_updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
          
      logger.i('FCM 토큰 저장 완료');
    } catch (e) {
      logger.e('FCM 토큰 저장 실패', error: e);
    }
  }
  
  /// 토큰 갱신 핸들러
  void _onTokenRefresh(String token) {
    logger.i('FCM 토큰 갱신: $token');
    _fcmToken = token;
    _saveFCMToken(token);
  }
  
  /// 로컬 알림 초기화
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Android 알림 채널 생성
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }
  
  /// Android 알림 채널 생성
  Future<void> _createNotificationChannels() async {
    const orderChannel = AndroidNotificationChannel(
      'order_channel',
      '주문 알림',
      description: '주문 상태 변경 알림',
      importance: Importance.high,
    );
    
    const noticeChannel = AndroidNotificationChannel(
      'notice_channel',
      '공지사항',
      description: '공지사항 알림',
      importance: Importance.defaultImportance,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(orderChannel);
        
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(noticeChannel);
  }
  
  /// 메시지 핸들러 설정
  void _setupMessageHandlers() {
    _messageStreamController = StreamController<RemoteMessage>.broadcast();
    
    // 포그라운드 메시지
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // 백그라운드에서 알림 클릭
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // 앱이 종료된 상태에서 알림으로 실행
    _checkInitialMessage();
  }
  
  /// 포그라운드 메시지 처리
  void _handleForegroundMessage(RemoteMessage message) {
    logger.i('포그라운드 메시지 수신: ${message.messageId}');
    
    _messageStreamController?.add(message);
    
    // 로컬 알림 표시
    _showLocalNotification(message);
  }
  
  /// 백그라운드에서 알림 클릭 처리
  void _handleMessageOpenedApp(RemoteMessage message) {
    logger.i('알림 클릭으로 앱 열림: ${message.messageId}');
    _messageStreamController?.add(message);
  }
  
  /// 초기 메시지 확인
  Future<void> _checkInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    
    if (initialMessage != null) {
      logger.i('초기 메시지 감지: ${initialMessage.messageId}');
      _messageStreamController?.add(initialMessage);
    }
  }
  
  /// 로컬 알림 표시
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;
    final data = message.data;
    
    if (notification == null) return;
    
    // 채널 선택
    String channelId = 'default_channel';
    if (data['type'] == 'order') {
      channelId = 'order_channel';
    } else if (data['type'] == 'notice') {
      channelId = 'notice_channel';
    }
    
    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId == 'order_channel' ? '주문 알림' : '공지사항',
          channelDescription: channelId == 'order_channel' 
              ? '주문 상태 변경 알림' 
              : '공지사항 알림',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          icon: android?.smallIcon,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }
  
  /// 알림 클릭 핸들러
  void _onNotificationTapped(NotificationResponse response) {
    logger.i('알림 클릭: ${response.payload}');
    // TODO: 알림 타입에 따른 네비게이션 처리
  }
  
  /// 주제 구독
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      logger.i('주제 구독 완료: $topic');
    } catch (e) {
      logger.e('주제 구독 실패: $topic', error: e);
    }
  }
  
  /// 주제 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      logger.i('주제 구독 해제 완료: $topic');
    } catch (e) {
      logger.e('주제 구독 해제 실패: $topic', error: e);
    }
  }
  
  /// FCM 토큰 삭제 (로그아웃 시)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = null;
      logger.i('FCM 토큰 삭제 완료');
    } catch (e) {
      logger.e('FCM 토큰 삭제 실패', error: e);
    }
  }
  
  /// 리소스 정리
  void dispose() {
    _messageStreamController?.close();
  }
}