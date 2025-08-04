// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OnboardingState {
  Map<String, OnboardingProgressEntity> get screenProgress =>
      throw _privateConstructorUsedError;
  bool get isOnboardingEnabled => throw _privateConstructorUsedError;
  bool get isFirstLaunch => throw _privateConstructorUsedError;
  List<OnboardingStepEntity> get currentSteps =>
      throw _privateConstructorUsedError;
  String? get currentScreenId => throw _privateConstructorUsedError;
  int get currentStepIndex => throw _privateConstructorUsedError;
  bool get isShowcasing => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingStateCopyWith<OnboardingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<$Res> {
  factory $OnboardingStateCopyWith(
    OnboardingState value,
    $Res Function(OnboardingState) then,
  ) = _$OnboardingStateCopyWithImpl<$Res, OnboardingState>;
  @useResult
  $Res call({
    Map<String, OnboardingProgressEntity> screenProgress,
    bool isOnboardingEnabled,
    bool isFirstLaunch,
    List<OnboardingStepEntity> currentSteps,
    String? currentScreenId,
    int currentStepIndex,
    bool isShowcasing,
    String? error,
  });
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res, $Val extends OnboardingState>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? screenProgress = null,
    Object? isOnboardingEnabled = null,
    Object? isFirstLaunch = null,
    Object? currentSteps = null,
    Object? currentScreenId = freezed,
    Object? currentStepIndex = null,
    Object? isShowcasing = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            screenProgress: null == screenProgress
                ? _value.screenProgress
                : screenProgress // ignore: cast_nullable_to_non_nullable
                      as Map<String, OnboardingProgressEntity>,
            isOnboardingEnabled: null == isOnboardingEnabled
                ? _value.isOnboardingEnabled
                : isOnboardingEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            isFirstLaunch: null == isFirstLaunch
                ? _value.isFirstLaunch
                : isFirstLaunch // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentSteps: null == currentSteps
                ? _value.currentSteps
                : currentSteps // ignore: cast_nullable_to_non_nullable
                      as List<OnboardingStepEntity>,
            currentScreenId: freezed == currentScreenId
                ? _value.currentScreenId
                : currentScreenId // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentStepIndex: null == currentStepIndex
                ? _value.currentStepIndex
                : currentStepIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            isShowcasing: null == isShowcasing
                ? _value.isShowcasing
                : isShowcasing // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OnboardingStateImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingStateImplCopyWith(
    _$OnboardingStateImpl value,
    $Res Function(_$OnboardingStateImpl) then,
  ) = __$$OnboardingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, OnboardingProgressEntity> screenProgress,
    bool isOnboardingEnabled,
    bool isFirstLaunch,
    List<OnboardingStepEntity> currentSteps,
    String? currentScreenId,
    int currentStepIndex,
    bool isShowcasing,
    String? error,
  });
}

/// @nodoc
class __$$OnboardingStateImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingStateImpl>
    implements _$$OnboardingStateImplCopyWith<$Res> {
  __$$OnboardingStateImplCopyWithImpl(
    _$OnboardingStateImpl _value,
    $Res Function(_$OnboardingStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? screenProgress = null,
    Object? isOnboardingEnabled = null,
    Object? isFirstLaunch = null,
    Object? currentSteps = null,
    Object? currentScreenId = freezed,
    Object? currentStepIndex = null,
    Object? isShowcasing = null,
    Object? error = freezed,
  }) {
    return _then(
      _$OnboardingStateImpl(
        screenProgress: null == screenProgress
            ? _value._screenProgress
            : screenProgress // ignore: cast_nullable_to_non_nullable
                  as Map<String, OnboardingProgressEntity>,
        isOnboardingEnabled: null == isOnboardingEnabled
            ? _value.isOnboardingEnabled
            : isOnboardingEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFirstLaunch: null == isFirstLaunch
            ? _value.isFirstLaunch
            : isFirstLaunch // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentSteps: null == currentSteps
            ? _value._currentSteps
            : currentSteps // ignore: cast_nullable_to_non_nullable
                  as List<OnboardingStepEntity>,
        currentScreenId: freezed == currentScreenId
            ? _value.currentScreenId
            : currentScreenId // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentStepIndex: null == currentStepIndex
            ? _value.currentStepIndex
            : currentStepIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        isShowcasing: null == isShowcasing
            ? _value.isShowcasing
            : isShowcasing // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OnboardingStateImpl extends _OnboardingState {
  const _$OnboardingStateImpl({
    final Map<String, OnboardingProgressEntity> screenProgress = const {},
    this.isOnboardingEnabled = false,
    this.isFirstLaunch = false,
    final List<OnboardingStepEntity> currentSteps = const [],
    this.currentScreenId,
    this.currentStepIndex = 0,
    this.isShowcasing = false,
    this.error,
  }) : _screenProgress = screenProgress,
       _currentSteps = currentSteps,
       super._();

  final Map<String, OnboardingProgressEntity> _screenProgress;
  @override
  @JsonKey()
  Map<String, OnboardingProgressEntity> get screenProgress {
    if (_screenProgress is EqualUnmodifiableMapView) return _screenProgress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_screenProgress);
  }

  @override
  @JsonKey()
  final bool isOnboardingEnabled;
  @override
  @JsonKey()
  final bool isFirstLaunch;
  final List<OnboardingStepEntity> _currentSteps;
  @override
  @JsonKey()
  List<OnboardingStepEntity> get currentSteps {
    if (_currentSteps is EqualUnmodifiableListView) return _currentSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentSteps);
  }

  @override
  final String? currentScreenId;
  @override
  @JsonKey()
  final int currentStepIndex;
  @override
  @JsonKey()
  final bool isShowcasing;
  @override
  final String? error;

  @override
  String toString() {
    return 'OnboardingState(screenProgress: $screenProgress, isOnboardingEnabled: $isOnboardingEnabled, isFirstLaunch: $isFirstLaunch, currentSteps: $currentSteps, currentScreenId: $currentScreenId, currentStepIndex: $currentStepIndex, isShowcasing: $isShowcasing, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStateImpl &&
            const DeepCollectionEquality().equals(
              other._screenProgress,
              _screenProgress,
            ) &&
            (identical(other.isOnboardingEnabled, isOnboardingEnabled) ||
                other.isOnboardingEnabled == isOnboardingEnabled) &&
            (identical(other.isFirstLaunch, isFirstLaunch) ||
                other.isFirstLaunch == isFirstLaunch) &&
            const DeepCollectionEquality().equals(
              other._currentSteps,
              _currentSteps,
            ) &&
            (identical(other.currentScreenId, currentScreenId) ||
                other.currentScreenId == currentScreenId) &&
            (identical(other.currentStepIndex, currentStepIndex) ||
                other.currentStepIndex == currentStepIndex) &&
            (identical(other.isShowcasing, isShowcasing) ||
                other.isShowcasing == isShowcasing) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_screenProgress),
    isOnboardingEnabled,
    isFirstLaunch,
    const DeepCollectionEquality().hash(_currentSteps),
    currentScreenId,
    currentStepIndex,
    isShowcasing,
    error,
  );

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      __$$OnboardingStateImplCopyWithImpl<_$OnboardingStateImpl>(
        this,
        _$identity,
      );
}

abstract class _OnboardingState extends OnboardingState {
  const factory _OnboardingState({
    final Map<String, OnboardingProgressEntity> screenProgress,
    final bool isOnboardingEnabled,
    final bool isFirstLaunch,
    final List<OnboardingStepEntity> currentSteps,
    final String? currentScreenId,
    final int currentStepIndex,
    final bool isShowcasing,
    final String? error,
  }) = _$OnboardingStateImpl;
  const _OnboardingState._() : super._();

  @override
  Map<String, OnboardingProgressEntity> get screenProgress;
  @override
  bool get isOnboardingEnabled;
  @override
  bool get isFirstLaunch;
  @override
  List<OnboardingStepEntity> get currentSteps;
  @override
  String? get currentScreenId;
  @override
  int get currentStepIndex;
  @override
  bool get isShowcasing;
  @override
  String? get error;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
