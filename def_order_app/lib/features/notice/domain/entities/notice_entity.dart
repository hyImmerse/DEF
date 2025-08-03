import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_entity.freezed.dart';

@freezed
class NoticeEntity with _$NoticeEntity {
  const factory NoticeEntity({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
    required bool isImportant,
    required bool isActive,
    String? imageUrl,
    DateTime? updatedAt,
    int? viewCount,
    String? category,
    List<String>? tags,
    List<String>? attachmentUrls,
    // 푸시 알림 관련
    bool? isPushSent,
    DateTime? pushSentAt,
    // 읽음 상태 (클라이언트 측에서 관리)
    @Default(false) bool isRead,
  }) = _NoticeEntity;

  const NoticeEntity._();

  // 중요 공지 여부와 활성 상태를 체크하는 헬퍼 메서드
  bool get shouldDisplay => isActive && (isImportant || createdAt.isAfter(
    DateTime.now().subtract(const Duration(days: 30))
  ));
}