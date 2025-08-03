import '../../../../core/utils/logger.dart';
import '../../data/services/push_notification_service.dart';

/// 공지사항 알림 발송 파라미터
class SendNoticeNotificationParams {
  final String noticeId;
  final String title;
  final String content;
  final List<String>? targetUserTypes; // null이면 전체 발송
  
  const SendNoticeNotificationParams({
    required this.noticeId,
    required this.title,
    required this.content,
    this.targetUserTypes,
  });
}

/// 공지사항 알림 UseCase
class SendNoticeNotificationUseCase {
  final PushNotificationService pushNotificationService;
  
  SendNoticeNotificationUseCase({
    PushNotificationService? pushNotificationService,
  }) : pushNotificationService = pushNotificationService ?? PushNotificationService();

  Future<void> call(SendNoticeNotificationParams params) async {
    try {
      logger.i('공지사항 알림 발송 시작: ${params.noticeId}');
      
      await pushNotificationService.sendNoticeNotification(
        noticeId: params.noticeId,
        title: params.title,
        content: params.content,
        targetUserTypes: params.targetUserTypes,
      );
      
      logger.i('공지사항 알림 발송 완료');
    } catch (e) {
      logger.e('공지사항 알림 발송 실패', e);
      rethrow;
    }
  }
}