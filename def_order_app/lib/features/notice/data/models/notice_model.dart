import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notice_entity.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
class NoticeModel with _$NoticeModel {
  const factory NoticeModel({
    required String id,
    required String title,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'is_important') required bool isImportant,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'view_count') int? viewCount,
    String? category,
    List<String>? tags,
    @JsonKey(name: 'attachment_urls') List<String>? attachmentUrls,
    @JsonKey(name: 'is_push_sent') bool? isPushSent,
    @JsonKey(name: 'push_sent_at') DateTime? pushSentAt,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);

  const NoticeModel._();

  // Entity로 변환
  NoticeEntity toEntity({bool isRead = false}) {
    return NoticeEntity(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      isImportant: isImportant,
      isActive: isActive,
      imageUrl: imageUrl,
      updatedAt: updatedAt,
      viewCount: viewCount,
      category: category,
      tags: tags,
      attachmentUrls: attachmentUrls,
      isPushSent: isPushSent,
      pushSentAt: pushSentAt,
      isRead: isRead,
    );
  }

  // Entity에서 생성
  static NoticeModel fromEntity(NoticeEntity entity) {
    return NoticeModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      isImportant: entity.isImportant,
      isActive: entity.isActive,
      imageUrl: entity.imageUrl,
      updatedAt: entity.updatedAt,
      viewCount: entity.viewCount,
      category: entity.category,
      tags: entity.tags,
      attachmentUrls: entity.attachmentUrls,
      isPushSent: entity.isPushSent,
      pushSentAt: entity.pushSentAt,
    );
  }
}