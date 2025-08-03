import '../../../../core/utils/logger.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../../../order/data/models/order_model.dart';
import '../../../order/domain/repositories/order_repository.dart';
import '../../data/services/push_notification_service.dart';

/// 주문 알림 발송 파라미터
class SendOrderNotificationParams {
  final String orderId;
  final OrderStatus newStatus;
  final String? customMessage;
  
  const SendOrderNotificationParams({
    required this.orderId,
    required this.newStatus,
    this.customMessage,
  });
}

/// 주문 상태 변경 알림 UseCase
class SendOrderNotificationUseCase {
  final OrderRepository orderRepository;
  final PushNotificationService pushNotificationService;
  
  SendOrderNotificationUseCase({
    required this.orderRepository,
    PushNotificationService? pushNotificationService,
  }) : pushNotificationService = pushNotificationService ?? PushNotificationService();

  Future<void> call(SendOrderNotificationParams params) async {
    try {
      logger.i('주문 알림 발송 시작: ${params.orderId}');
      
      // 1. 주문 정보 조회
      final order = await orderRepository.getOrderById(params.orderId);
      
      if (order == null) {
        throw Exception('주문을 찾을 수 없습니다');
      }
      
      // 2. 상태 변경 가능 여부 확인
      if (!_canChangeStatus(order.status, params.newStatus)) {
        throw Exception(
          '${order.status}에서 ${params.newStatus}로 변경할 수 없습니다'
        );
      }
      
      // 3. 푸시 알림 발송
      try {
        await pushNotificationService.sendOrderStatusNotification(
          userId: order.userId,
          order: order,
          newStatus: params.newStatus,
        );
        
        logger.i('주문 알림 발송 완료');
      } catch (e) {
        logger.e('알림 발송 실패', e);
        // 알림 발송 실패해도 주문 처리는 계속
      }
    } catch (e) {
      logger.e('주문 알림 처리 중 오류', e);
      rethrow;
    }
  }
  
  /// 상태 변경 가능 여부 확인
  bool _canChangeStatus(OrderStatus current, OrderStatus next) {
    // 상태 전이 규칙
    final transitions = <OrderStatus, List<OrderStatus>>{
      OrderStatus.draft: [OrderStatus.pending, OrderStatus.cancelled],
      OrderStatus.pending: [OrderStatus.confirmed, OrderStatus.cancelled],
      OrderStatus.confirmed: [OrderStatus.shipped, OrderStatus.cancelled],
      OrderStatus.shipped: [OrderStatus.completed],
      OrderStatus.completed: [], // 완료 상태는 변경 불가
      OrderStatus.cancelled: [], // 취소 상태는 변경 불가
    };
    
    return transitions[current]?.contains(next) ?? false;
  }
}