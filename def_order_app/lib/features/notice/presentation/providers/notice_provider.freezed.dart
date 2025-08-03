// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NoticeState {
  List<NoticeEntity> get notices => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get selectedCategory => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  /// Create a copy of NoticeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoticeStateCopyWith<NoticeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeStateCopyWith<$Res> {
  factory $NoticeStateCopyWith(
    NoticeState value,
    $Res Function(NoticeState) then,
  ) = _$NoticeStateCopyWithImpl<$Res, NoticeState>;
  @useResult
  $Res call({
    List<NoticeEntity> notices,
    bool isLoading,
    bool isLoadingMore,
    bool hasMore,
    String? error,
    String? selectedCategory,
    String? searchQuery,
    int offset,
    int limit,
  });
}

/// @nodoc
class _$NoticeStateCopyWithImpl<$Res, $Val extends NoticeState>
    implements $NoticeStateCopyWith<$Res> {
  _$NoticeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoticeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notices = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? hasMore = null,
    Object? error = freezed,
    Object? selectedCategory = freezed,
    Object? searchQuery = freezed,
    Object? offset = null,
    Object? limit = null,
  }) {
    return _then(
      _value.copyWith(
            notices: null == notices
                ? _value.notices
                : notices // ignore: cast_nullable_to_non_nullable
                      as List<NoticeEntity>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoadingMore: null == isLoadingMore
                ? _value.isLoadingMore
                : isLoadingMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedCategory: freezed == selectedCategory
                ? _value.selectedCategory
                : selectedCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            searchQuery: freezed == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String?,
            offset: null == offset
                ? _value.offset
                : offset // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NoticeStateImplCopyWith<$Res>
    implements $NoticeStateCopyWith<$Res> {
  factory _$$NoticeStateImplCopyWith(
    _$NoticeStateImpl value,
    $Res Function(_$NoticeStateImpl) then,
  ) = __$$NoticeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<NoticeEntity> notices,
    bool isLoading,
    bool isLoadingMore,
    bool hasMore,
    String? error,
    String? selectedCategory,
    String? searchQuery,
    int offset,
    int limit,
  });
}

/// @nodoc
class __$$NoticeStateImplCopyWithImpl<$Res>
    extends _$NoticeStateCopyWithImpl<$Res, _$NoticeStateImpl>
    implements _$$NoticeStateImplCopyWith<$Res> {
  __$$NoticeStateImplCopyWithImpl(
    _$NoticeStateImpl _value,
    $Res Function(_$NoticeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoticeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notices = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? hasMore = null,
    Object? error = freezed,
    Object? selectedCategory = freezed,
    Object? searchQuery = freezed,
    Object? offset = null,
    Object? limit = null,
  }) {
    return _then(
      _$NoticeStateImpl(
        notices: null == notices
            ? _value._notices
            : notices // ignore: cast_nullable_to_non_nullable
                  as List<NoticeEntity>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedCategory: freezed == selectedCategory
            ? _value.selectedCategory
            : selectedCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        searchQuery: freezed == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String?,
        offset: null == offset
            ? _value.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$NoticeStateImpl implements _NoticeState {
  const _$NoticeStateImpl({
    final List<NoticeEntity> notices = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.error,
    this.selectedCategory,
    this.searchQuery,
    this.offset = 0,
    this.limit = 20,
  }) : _notices = notices;

  final List<NoticeEntity> _notices;
  @override
  @JsonKey()
  List<NoticeEntity> get notices {
    if (_notices is EqualUnmodifiableListView) return _notices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notices);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  final String? error;
  @override
  final String? selectedCategory;
  @override
  final String? searchQuery;
  @override
  @JsonKey()
  final int offset;
  @override
  @JsonKey()
  final int limit;

  @override
  String toString() {
    return 'NoticeState(notices: $notices, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, error: $error, selectedCategory: $selectedCategory, searchQuery: $searchQuery, offset: $offset, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeStateImpl &&
            const DeepCollectionEquality().equals(other._notices, _notices) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_notices),
    isLoading,
    isLoadingMore,
    hasMore,
    error,
    selectedCategory,
    searchQuery,
    offset,
    limit,
  );

  /// Create a copy of NoticeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeStateImplCopyWith<_$NoticeStateImpl> get copyWith =>
      __$$NoticeStateImplCopyWithImpl<_$NoticeStateImpl>(this, _$identity);
}

abstract class _NoticeState implements NoticeState {
  const factory _NoticeState({
    final List<NoticeEntity> notices,
    final bool isLoading,
    final bool isLoadingMore,
    final bool hasMore,
    final String? error,
    final String? selectedCategory,
    final String? searchQuery,
    final int offset,
    final int limit,
  }) = _$NoticeStateImpl;

  @override
  List<NoticeEntity> get notices;
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  bool get hasMore;
  @override
  String? get error;
  @override
  String? get selectedCategory;
  @override
  String? get searchQuery;
  @override
  int get offset;
  @override
  int get limit;

  /// Create a copy of NoticeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoticeStateImplCopyWith<_$NoticeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
