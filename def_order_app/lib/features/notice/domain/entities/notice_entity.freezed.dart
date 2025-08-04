// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NoticeEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isImportant => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int? get viewCount => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  List<String>? get attachmentUrls =>
      throw _privateConstructorUsedError; // 푸시 알림 관련
  bool? get isPushSent => throw _privateConstructorUsedError;
  DateTime? get pushSentAt =>
      throw _privateConstructorUsedError; // 읽음 상태 (클라이언트 측에서 관리)
  bool get isRead => throw _privateConstructorUsedError;

  /// Create a copy of NoticeEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoticeEntityCopyWith<NoticeEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeEntityCopyWith<$Res> {
  factory $NoticeEntityCopyWith(
          NoticeEntity value, $Res Function(NoticeEntity) then) =
      _$NoticeEntityCopyWithImpl<$Res, NoticeEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      DateTime createdAt,
      bool isImportant,
      bool isActive,
      String? imageUrl,
      DateTime? updatedAt,
      int? viewCount,
      String? category,
      List<String>? tags,
      List<String>? attachmentUrls,
      bool? isPushSent,
      DateTime? pushSentAt,
      bool isRead});
}

/// @nodoc
class _$NoticeEntityCopyWithImpl<$Res, $Val extends NoticeEntity>
    implements $NoticeEntityCopyWith<$Res> {
  _$NoticeEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoticeEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? isImportant = null,
    Object? isActive = null,
    Object? imageUrl = freezed,
    Object? updatedAt = freezed,
    Object? viewCount = freezed,
    Object? category = freezed,
    Object? tags = freezed,
    Object? attachmentUrls = freezed,
    Object? isPushSent = freezed,
    Object? pushSentAt = freezed,
    Object? isRead = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isImportant: null == isImportant
          ? _value.isImportant
          : isImportant // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      viewCount: freezed == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attachmentUrls: freezed == attachmentUrls
          ? _value.attachmentUrls
          : attachmentUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isPushSent: freezed == isPushSent
          ? _value.isPushSent
          : isPushSent // ignore: cast_nullable_to_non_nullable
              as bool?,
      pushSentAt: freezed == pushSentAt
          ? _value.pushSentAt
          : pushSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoticeEntityImplCopyWith<$Res>
    implements $NoticeEntityCopyWith<$Res> {
  factory _$$NoticeEntityImplCopyWith(
          _$NoticeEntityImpl value, $Res Function(_$NoticeEntityImpl) then) =
      __$$NoticeEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      DateTime createdAt,
      bool isImportant,
      bool isActive,
      String? imageUrl,
      DateTime? updatedAt,
      int? viewCount,
      String? category,
      List<String>? tags,
      List<String>? attachmentUrls,
      bool? isPushSent,
      DateTime? pushSentAt,
      bool isRead});
}

/// @nodoc
class __$$NoticeEntityImplCopyWithImpl<$Res>
    extends _$NoticeEntityCopyWithImpl<$Res, _$NoticeEntityImpl>
    implements _$$NoticeEntityImplCopyWith<$Res> {
  __$$NoticeEntityImplCopyWithImpl(
      _$NoticeEntityImpl _value, $Res Function(_$NoticeEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of NoticeEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? isImportant = null,
    Object? isActive = null,
    Object? imageUrl = freezed,
    Object? updatedAt = freezed,
    Object? viewCount = freezed,
    Object? category = freezed,
    Object? tags = freezed,
    Object? attachmentUrls = freezed,
    Object? isPushSent = freezed,
    Object? pushSentAt = freezed,
    Object? isRead = null,
  }) {
    return _then(_$NoticeEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isImportant: null == isImportant
          ? _value.isImportant
          : isImportant // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      viewCount: freezed == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attachmentUrls: freezed == attachmentUrls
          ? _value._attachmentUrls
          : attachmentUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isPushSent: freezed == isPushSent
          ? _value.isPushSent
          : isPushSent // ignore: cast_nullable_to_non_nullable
              as bool?,
      pushSentAt: freezed == pushSentAt
          ? _value.pushSentAt
          : pushSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NoticeEntityImpl extends _NoticeEntity {
  const _$NoticeEntityImpl(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.isImportant,
      required this.isActive,
      this.imageUrl,
      this.updatedAt,
      this.viewCount,
      this.category,
      final List<String>? tags,
      final List<String>? attachmentUrls,
      this.isPushSent,
      this.pushSentAt,
      this.isRead = false})
      : _tags = tags,
        _attachmentUrls = attachmentUrls,
        super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final bool isImportant;
  @override
  final bool isActive;
  @override
  final String? imageUrl;
  @override
  final DateTime? updatedAt;
  @override
  final int? viewCount;
  @override
  final String? category;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _attachmentUrls;
  @override
  List<String>? get attachmentUrls {
    final value = _attachmentUrls;
    if (value == null) return null;
    if (_attachmentUrls is EqualUnmodifiableListView) return _attachmentUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// 푸시 알림 관련
  @override
  final bool? isPushSent;
  @override
  final DateTime? pushSentAt;
// 읽음 상태 (클라이언트 측에서 관리)
  @override
  @JsonKey()
  final bool isRead;

  @override
  String toString() {
    return 'NoticeEntity(id: $id, title: $title, content: $content, createdAt: $createdAt, isImportant: $isImportant, isActive: $isActive, imageUrl: $imageUrl, updatedAt: $updatedAt, viewCount: $viewCount, category: $category, tags: $tags, attachmentUrls: $attachmentUrls, isPushSent: $isPushSent, pushSentAt: $pushSentAt, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isImportant, isImportant) ||
                other.isImportant == isImportant) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._attachmentUrls, _attachmentUrls) &&
            (identical(other.isPushSent, isPushSent) ||
                other.isPushSent == isPushSent) &&
            (identical(other.pushSentAt, pushSentAt) ||
                other.pushSentAt == pushSentAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      content,
      createdAt,
      isImportant,
      isActive,
      imageUrl,
      updatedAt,
      viewCount,
      category,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_attachmentUrls),
      isPushSent,
      pushSentAt,
      isRead);

  /// Create a copy of NoticeEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeEntityImplCopyWith<_$NoticeEntityImpl> get copyWith =>
      __$$NoticeEntityImplCopyWithImpl<_$NoticeEntityImpl>(this, _$identity);
}

abstract class _NoticeEntity extends NoticeEntity {
  const factory _NoticeEntity(
      {required final String id,
      required final String title,
      required final String content,
      required final DateTime createdAt,
      required final bool isImportant,
      required final bool isActive,
      final String? imageUrl,
      final DateTime? updatedAt,
      final int? viewCount,
      final String? category,
      final List<String>? tags,
      final List<String>? attachmentUrls,
      final bool? isPushSent,
      final DateTime? pushSentAt,
      final bool isRead}) = _$NoticeEntityImpl;
  const _NoticeEntity._() : super._();

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  bool get isImportant;
  @override
  bool get isActive;
  @override
  String? get imageUrl;
  @override
  DateTime? get updatedAt;
  @override
  int? get viewCount;
  @override
  String? get category;
  @override
  List<String>? get tags;
  @override
  List<String>? get attachmentUrls; // 푸시 알림 관련
  @override
  bool? get isPushSent;
  @override
  DateTime? get pushSentAt; // 읽음 상태 (클라이언트 측에서 관리)
  @override
  bool get isRead;

  /// Create a copy of NoticeEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoticeEntityImplCopyWith<_$NoticeEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
