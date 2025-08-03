import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/services/fcm_service.dart';
import '../../data/services/push_notification_service.dart';
import '../../domain/usecases/send_order_notification_usecase.dart';
import '../../domain/usecases/send_notice_notification_usecase.dart';
import '../../../order/presentation/providers/order_provider.dart';

/// FCM 서비스 Provider
final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService.instance;
});

/// 푸시 알림 서비스 Provider
final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService();
});

/// 주문 상태 변경 알림 UseCase Provider
final sendOrderNotificationUseCaseProvider = Provider<SendOrderNotificationUseCase>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);
  
  return SendOrderNotificationUseCase(
    orderRepository: orderRepository,
    pushNotificationService: pushNotificationService,
  );
});

/// 공지사항 알림 UseCase Provider
final sendNoticeNotificationUseCaseProvider = Provider<SendNoticeNotificationUseCase>((ref) {
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);
  
  return SendNoticeNotificationUseCase(
    pushNotificationService: pushNotificationService,
  );
});

/// FCM 초기화 Provider
final fcmInitializationProvider = FutureProvider<void>((ref) async {
  final fcmService = ref.watch(fcmServiceProvider);
  await fcmService.initialize();
});

/// FCM 토큰 Provider
final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final fcmService = ref.watch(fcmServiceProvider);
  
  // FCM 초기화 대기
  await ref.watch(fcmInitializationProvider.future);
  
  return fcmService.fcmToken;
});

/// 알림 메시지 스트림 Provider
final notificationMessageStreamProvider = StreamProvider<RemoteMessage>((ref) {
  final fcmService = ref.watch(fcmServiceProvider);
  return fcmService.onMessage;
});

/// 주제 구독 관리
class TopicSubscriptionNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    // 초기 구독 주제 로드 (로컬 저장소에서)
    return {};
  }
  
  /// 주제 구독
  Future<void> subscribeToTopic(String topic) async {
    final fcmService = ref.read(fcmServiceProvider);
    
    try {
      await fcmService.subscribeToTopic(topic);
      state = AsyncData({...state.value ?? {}, topic});
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
  
  /// 주제 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    final fcmService = ref.read(fcmServiceProvider);
    
    try {
      await fcmService.unsubscribeFromTopic(topic);
      final topics = state.value ?? {};
      topics.remove(topic);
      state = AsyncData(topics);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}

/// 주제 구독 Provider
final topicSubscriptionProvider = 
    AsyncNotifierProvider<TopicSubscriptionNotifier, Set<String>>(
  TopicSubscriptionNotifier.new,
);