// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoticeModelImpl _$$NoticeModelImplFromJson(Map<String, dynamic> json) =>
    _$NoticeModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isImportant: json['is_important'] as bool,
      isActive: json['is_active'] as bool,
      imageUrl: json['image_url'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      viewCount: (json['view_count'] as num?)?.toInt(),
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      attachmentUrls: (json['attachment_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isPushSent: json['is_push_sent'] as bool?,
      pushSentAt: json['push_sent_at'] == null
          ? null
          : DateTime.parse(json['push_sent_at'] as String),
    );

Map<String, dynamic> _$$NoticeModelImplToJson(_$NoticeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'is_important': instance.isImportant,
      'is_active': instance.isActive,
      'image_url': instance.imageUrl,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'view_count': instance.viewCount,
      'category': instance.category,
      'tags': instance.tags,
      'attachment_urls': instance.attachmentUrls,
      'is_push_sent': instance.isPushSent,
      'push_sent_at': instance.pushSentAt?.toIso8601String(),
    };
