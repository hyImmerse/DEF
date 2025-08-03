import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/services/navigation_service.dart';
import '../screens/notice_detail_screen.dart';

final noticePushHandlerProvider = Provider<NoticePushHandler>((ref) {
  return NoticePushHandler();
});

class NoticePushHandler {
  // FCM 메시지 처리
  void handleMessage(RemoteMessage message) {
    final data = message.data;
    
    // 공지사항 알림인지 확인
    if (data['type'] == 'notice' && data['notice_id'] != null) {
      final noticeId = data['notice_id'] as String;
      
      // 공지사항 상세 화면으로 이동
      NavigationService.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => NoticeDetailScreen(noticeId: noticeId),
        ),
      );
    }
  }

  // 백그라운드 메시지 처리
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // 백그라운드에서는 앱이 포그라운드로 전환될 때 처리
    print('백그라운드 공지사항 알림: ${message.data}');
  }

  // 초기 메시지 처리 (앱이 종료된 상태에서 알림 클릭)
  Future<void> handleInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      handleMessage(message);
    }
  }

  // 포그라운드 알림 표시
  void showInAppNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      // 앱 내 알림 표시 (예: SnackBar, Dialog 등)
      final context = NavigationService.navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  notification.title ?? '새로운 공지사항',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (notification.body != null)
                  Text(notification.body!),
              ],
            ),
            action: SnackBarAction(
              label: '확인',
              onPressed: () {
                handleMessage(message);
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // FCM 토큰 갱신 시 서버에 전송
  Future<void> updateFCMToken(String token) async {
    // TODO: 서버에 FCM 토큰 업데이트 API 호출
    print('FCM Token updated: $token');
  }
}