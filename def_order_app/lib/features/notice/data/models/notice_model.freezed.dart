// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) {
  return _NoticeModel.fromJson(json);
}

/// @nodoc
mixin _$NoticeModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_important')
  bool get isImportant => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'view_count')
  int? get viewCount => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'attachment_urls')
  List<String>? get attachmentUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_push_sent')
  bool? get isPushSent => throw _privateConstructorUsedError;
  @JsonKey(name: 'push_sent_at')
  DateTime? get pushSentAt => throw _privateConstructorUsedError;

  /// Serializes this NoticeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoticeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoticeModelCopyWith<NoticeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeModelCopyWith<$Res> {
  factory $NoticeModelCopyWith(
    NoticeModel value,
    $Res Function(NoticeModel) then,
  ) = _$NoticeModelCopyWithImpl<$Res, NoticeModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'is_important') bool isImportant,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'view_count') int? viewCount,
    String? category,
    List<String>? tags,
    @JsonKey(name: 'attachment_urls') List<String>? attachmentUrls,
    @JsonKey(name: 'is_push_sent') bool? isPushSent,
    @JsonKey(name: 'push_sent_at') DateTime? pushSentAt,
  });
}

/// @nodoc
class _$NoticeModelCopyWithImpl<$Res, $Val extends NoticeModel>
    implements $NoticeModelCopyWith<$Res> {
  _$NoticeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoticeModel
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
  }) {
    return _then(
      _value.copyWith(
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NoticeModelImplCopyWith<$Res>
    implements $NoticeModelCopyWith<$Res> {
  factory _$$NoticeModelImplCopyWith(
    _$NoticeModelImpl value,
    $Res Function(_$NoticeModelImpl) then,
  ) = __$$NoticeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'is_important') bool isImportant,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'view_count') int? viewCount,
    String? category,
    List<String>? tags,
    @JsonKey(name: 'attachment_urls') List<String>? attachmentUrls,
    @JsonKey(name: 'is_push_sent') bool? isPushSent,
    @JsonKey(name: 'push_sent_at') DateTime? pushSentAt,
  });
}

/// @nodoc
class __$$NoticeModelImplCopyWithImpl<$Res>
    extends _$NoticeModelCopyWithImpl<$Res, _$NoticeModelImpl>
    implements _$$NoticeModelImplCopyWith<$Res> {
  __$$NoticeModelImplCopyWithImpl(
    _$NoticeModelImpl _value,
    $Res Function(_$NoticeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoticeModel
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
  }) {
    return _then(
      _$NoticeModelImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NoticeModelImpl extends _NoticeModel {
  const _$NoticeModelImpl({
    required this.id,
    required this.title,
    required this.content,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'is_important') required this.isImportant,
    @JsonKey(name: 'is_active') required this.isActive,
    @JsonKey(name: 'image_url') this.imageUrl,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(name: 'view_count') this.viewCount,
    this.category,
    final List<String>? tags,
    @JsonKey(name: 'attachment_urls') final List<String>? attachmentUrls,
    @JsonKey(name: 'is_push_sent') this.isPushSent,
    @JsonKey(name: 'push_sent_at') this.pushSentAt,
  }) : _tags = tags,
       _attachmentUrls = attachmentUrls,
       super._();

  factory _$NoticeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoticeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'is_important')
  final bool isImportant;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'view_count')
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
  @JsonKey(name: 'attachment_urls')
  List<String>? get attachmentUrls {
    final value = _attachmentUrls;
    if (value == null) return null;
    if (_attachmentUrls is EqualUnmodifiableListView) return _attachmentUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'is_push_sent')
  final bool? isPushSent;
  @override
  @JsonKey(name: 'push_sent_at')
  final DateTime? pushSentAt;

  @override
  String toString() {
    return 'NoticeModel(id: $id, title: $title, content: $content, createdAt: $createdAt, isImportant: $isImportant, isActive: $isActive, imageUrl: $imageUrl, updatedAt: $updatedAt, viewCount: $viewCount, category: $category, tags: $tags, attachmentUrls: $attachmentUrls, isPushSent: $isPushSent, pushSentAt: $pushSentAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeModelImpl &&
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
            const DeepCollectionEquality().equals(
              other._attachmentUrls,
              _attachmentUrls,
            ) &&
            (identical(other.isPushSent, isPushSent) ||
                other.isPushSent == isPushSent) &&
            (identical(other.pushSentAt, pushSentAt) ||
                other.pushSentAt == pushSentAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
  );

  /// Create a copy of NoticeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeModelImplCopyWith<_$NoticeModelImpl> get copyWith =>
      __$$NoticeModelImplCopyWithImpl<_$NoticeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoticeModelImplToJson(this);
  }
}

abstract class _NoticeModel extends NoticeModel {
  const factory _NoticeModel({
    required final String id,
    required final String title,
    required final String content,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'is_important') required final bool isImportant,
    @JsonKey(name: 'is_active') required final bool isActive,
    @JsonKey(name: 'image_url') final String? imageUrl,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(name: 'view_count') final int? viewCount,
    final String? category,
    final List<String>? tags,
    @JsonKey(name: 'attachment_urls') final List<String>? attachmentUrls,
    @JsonKey(name: 'is_push_sent') final bool? isPushSent,
    @JsonKey(name: 'push_sent_at') final DateTime? pushSentAt,
  }) = _$NoticeModelImpl;
  const _NoticeModel._() : super._();

  factory _NoticeModel.fromJson(Map<String, dynamic> json) =
      _$NoticeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'is_important')
  bool get isImportant;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'view_count')
  int? get viewCount;
  @override
  String? get category;
  @override
  List<String>? get tags;
  @override
  @JsonKey(name: 'attachment_urls')
  List<String>? get attachmentUrls;
  @override
  @JsonKey(name: 'is_push_sent')
  bool? get isPushSent;
  @override
  @JsonKey(name: 'push_sent_at')
  DateTime? get pushSentAt;

  /// Create a copy of NoticeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoticeModelImplCopyWith<_$NoticeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
