// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OrderState {
  List<OrderModel> get orders => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isCreating => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;
  OrderModel? get selectedOrder => throw _privateConstructorUsedError;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderStateCopyWith<OrderState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStateCopyWith<$Res> {
  factory $OrderStateCopyWith(
          OrderState value, $Res Function(OrderState) then) =
      _$OrderStateCopyWithImpl<$Res, OrderState>;
  @useResult
  $Res call(
      {List<OrderModel> orders,
      bool isLoading,
      bool isCreating,
      Failure? error,
      OrderModel? selectedOrder});

  $OrderModelCopyWith<$Res>? get selectedOrder;
}

/// @nodoc
class _$OrderStateCopyWithImpl<$Res, $Val extends OrderState>
    implements $OrderStateCopyWith<$Res> {
  _$OrderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orders = null,
    Object? isLoading = null,
    Object? isCreating = null,
    Object? error = freezed,
    Object? selectedOrder = freezed,
  }) {
    return _then(_value.copyWith(
      orders: null == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Failure?,
      selectedOrder: freezed == selectedOrder
          ? _value.selectedOrder
          : selectedOrder // ignore: cast_nullable_to_non_nullable
              as OrderModel?,
    ) as $Val);
  }

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderModelCopyWith<$Res>? get selectedOrder {
    if (_value.selectedOrder == null) {
      return null;
    }

    return $OrderModelCopyWith<$Res>(_value.selectedOrder!, (value) {
      return _then(_value.copyWith(selectedOrder: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderStateImplCopyWith<$Res>
    implements $OrderStateCopyWith<$Res> {
  factory _$$OrderStateImplCopyWith(
          _$OrderStateImpl value, $Res Function(_$OrderStateImpl) then) =
      __$$OrderStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<OrderModel> orders,
      bool isLoading,
      bool isCreating,
      Failure? error,
      OrderModel? selectedOrder});

  @override
  $OrderModelCopyWith<$Res>? get selectedOrder;
}

/// @nodoc
class __$$OrderStateImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$OrderStateImpl>
    implements _$$OrderStateImplCopyWith<$Res> {
  __$$OrderStateImplCopyWithImpl(
      _$OrderStateImpl _value, $Res Function(_$OrderStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orders = null,
    Object? isLoading = null,
    Object? isCreating = null,
    Object? error = freezed,
    Object? selectedOrder = freezed,
  }) {
    return _then(_$OrderStateImpl(
      orders: null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Failure?,
      selectedOrder: freezed == selectedOrder
          ? _value.selectedOrder
          : selectedOrder // ignore: cast_nullable_to_non_nullable
              as OrderModel?,
    ));
  }
}

/// @nodoc

class _$OrderStateImpl implements _OrderState {
  const _$OrderStateImpl(
      {final List<OrderModel> orders = const [],
      this.isLoading = false,
      this.isCreating = false,
      this.error,
      this.selectedOrder})
      : _orders = orders;

  final List<OrderModel> _orders;
  @override
  @JsonKey()
  List<OrderModel> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isCreating;
  @override
  final Failure? error;
  @override
  final OrderModel? selectedOrder;

  @override
  String toString() {
    return 'OrderState(orders: $orders, isLoading: $isLoading, isCreating: $isCreating, error: $error, selectedOrder: $selectedOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStateImpl &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedOrder, selectedOrder) ||
                other.selectedOrder == selectedOrder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_orders),
      isLoading,
      isCreating,
      error,
      selectedOrder);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStateImplCopyWith<_$OrderStateImpl> get copyWith =>
      __$$OrderStateImplCopyWithImpl<_$OrderStateImpl>(this, _$identity);
}

abstract class _OrderState implements OrderState {
  const factory _OrderState(
      {final List<OrderModel> orders,
      final bool isLoading,
      final bool isCreating,
      final Failure? error,
      final OrderModel? selectedOrder}) = _$OrderStateImpl;

  @override
  List<OrderModel> get orders;
  @override
  bool get isLoading;
  @override
  bool get isCreating;
  @override
  Failure? get error;
  @override
  OrderModel? get selectedOrder;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderStateImplCopyWith<_$OrderStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
