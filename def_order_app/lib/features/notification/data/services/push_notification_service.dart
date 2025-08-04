import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../../../order/data/models/order_model.dart';

/// 푸시 알림 발송 서비스
class PushNotificationService {
  final SupabaseClient _supabase;
  
  PushNotificationService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? SupabaseConfig.client;

  /// 주문 상태 변경 알림 발송
  Future<void> sendOrderStatusNotification({
    required String userId,
    required OrderEntity order,
    required OrderStatus newStatus,
  }) async {
    try {
      final title = _getOrderStatusTitle(newStatus);
      final body = _getOrderStatusBody(order, newStatus);
      
      final response = await _supabase.functions.invoke(
        'send-push-notification',
        body: {
          'userId': userId,
          'notification': {
            'title': title,
            'body': body,
            'data': {
              'type': 'order',
              'orderId': order.id,
              'orderNumber': order.orderNumber,
              'status': newStatus.name,
            },
          },
          'options': {
            'priority': 'high',
            'channelId': 'order_channel',
          },
        },
      );

      // response.data가 null이면 에러로 처리
      if (response.data == null) {
        throw ServerException(message: '푸시 알림 발송 실패');
      }

      logger.i('주문 상태 알림 발송 성공: $userId');
    } catch (e) {
      logger.e('주문 상태 알림 발송 실패', e);
      if (e is ServerException) rethrow;
      throw ServerException(message: '푸시 알림 발송 중 오류가 발생했습니다');
    }
  }

  /// 공지사항 알림 발송
  Future<void> sendNoticeNotification({
    required String noticeId,
    required String title,
    required String content,
    required List<String>? targetUserTypes,
  }) async {
    try {
      // 대상 설정
      final targets = <String>[];
      if (targetUserTypes == null || targetUserTypes.isEmpty) {
        targets.add('all'); // 전체 발송
      } else {
        targets.addAll(targetUserTypes); // dealer, general
      }
      
      final response = await _supabase.functions.invoke(
        'send-push-notification',
        body: {
          'topic': targets, // 주제별 발송
          'notification': {
            'title': title,
            'body': content,
            'data': {
              'type': 'notice',
              'noticeId': noticeId,
            },
          },
          'options': {
            'priority': 'normal',
            'channelId': 'notice_channel',
          },
        },
      );

      // response.data가 null이면 에러로 처리
      if (response.data == null) {
        throw ServerException(message: '공지사항 알림 발송 실패');
      }

      logger.i('공지사항 알림 발송 성공: ${targets.join(', ')}');
    } catch (e) {
      logger.e('공지사항 알림 발송 실패', e);
      if (e is ServerException) rethrow;
      throw ServerException(message: '푸시 알림 발송 중 오류가 발생했습니다');
    }
  }

  /// 일괄 알림 발송
  Future<void> sendBatchNotification({
    required List<String> userIds,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'send-push-notification',
        body: {
          'userIds': userIds,
          'notification': {
            'title': title,
            'body': body,
            'data': data,
          },
          'options': {
            'priority': 'normal',
          },
        },
      );

      // response.data가 null이면 에러로 처리
      if (response.data == null) {
        throw ServerException(message: '일괄 알림 발송 실패');
      }

      logger.i('일괄 알림 발송 성공: ${userIds.length}명');
    } catch (e) {
      logger.e('일괄 알림 발송 실패', e);
      if (e is ServerException) rethrow;
      throw ServerException(message: '푸시 알림 발송 중 오류가 발생했습니다');
    }
  }

  /// 주문 상태별 알림 제목
  String _getOrderStatusTitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return '주문 접수';
      case OrderStatus.confirmed:
        return '주문 확정';
      case OrderStatus.shipped:
        return '출고 완료';
      case OrderStatus.completed:
        return '거래 완료';
      case OrderStatus.cancelled:
        return '주문 취소';
      default:
        return '주문 상태 변경';
    }
  }

  /// 주문 상태별 알림 내용
  String _getOrderStatusBody(OrderEntity order, OrderStatus status) {
    final productName = order.productType == ProductType.box 
        ? '요소수 박스(10L)' 
        : '요소수 벌크(1,000L)';
    
    switch (status) {
      case OrderStatus.pending:
        return '주문번호 ${order.orderNumber}의 $productName ${order.quantity}개 주문이 접수되었습니다.';
      case OrderStatus.confirmed:
        return '주문번호 ${order.orderNumber}이(가) 확정되었습니다. 출고 예정일: ${_formatDate(order.deliveryDate)}';
      case OrderStatus.shipped:
        return '주문번호 ${order.orderNumber}의 제품이 출고되었습니다.';
      case OrderStatus.completed:
        return '주문번호 ${order.orderNumber}의 거래가 완료되었습니다. 감사합니다.';
      case OrderStatus.cancelled:
        return '주문번호 ${order.orderNumber}이(가) 취소되었습니다.';
      default:
        return '주문번호 ${order.orderNumber}의 상태가 변경되었습니다.';
    }
  }

  /// 날짜 포맷
  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}