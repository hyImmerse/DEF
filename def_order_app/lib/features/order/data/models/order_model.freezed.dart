// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number')
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_type')
  ProductType get productType => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'javara_quantity')
  int? get javaraQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_tank_quantity')
  int? get returnTankQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_date')
  DateTime get deliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_method')
  DeliveryMethod get deliveryMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_address_id')
  String? get deliveryAddressId => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_memo')
  String? get deliveryMemo => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  double get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price')
  double get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_by')
  String? get confirmedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipped_at')
  DateTime? get shippedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_reason')
  String? get cancelledReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError; // Relations (JSON에서 제외)
  @JsonKey(includeFromJson: false, includeToJson: false)
  ProfileModel? get profile => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  DeliveryAddressModel? get deliveryAddress =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
    OrderModel value,
    $Res Function(OrderModel) then,
  ) = _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_number') String orderNumber,
    @JsonKey(name: 'user_id') String userId,
    OrderStatus status,
    @JsonKey(name: 'product_type') ProductType productType,
    int quantity,
    @JsonKey(name: 'javara_quantity') int? javaraQuantity,
    @JsonKey(name: 'return_tank_quantity') int? returnTankQuantity,
    @JsonKey(name: 'delivery_date') DateTime deliveryDate,
    @JsonKey(name: 'delivery_method') DeliveryMethod deliveryMethod,
    @JsonKey(name: 'delivery_address_id') String? deliveryAddressId,
    @JsonKey(name: 'delivery_memo') String? deliveryMemo,
    @JsonKey(name: 'unit_price') double unitPrice,
    @JsonKey(name: 'total_price') double totalPrice,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'confirmed_by') String? confirmedBy,
    @JsonKey(name: 'shipped_at') DateTime? shippedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'cancelled_reason') String? cancelledReason,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    ProfileModel? profile,
    @JsonKey(includeFromJson: false, includeToJson: false)
    DeliveryAddressModel? deliveryAddress,
  });

  $ProfileModelCopyWith<$Res>? get profile;
  $DeliveryAddressModelCopyWith<$Res>? get deliveryAddress;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? userId = null,
    Object? status = null,
    Object? productType = null,
    Object? quantity = null,
    Object? javaraQuantity = freezed,
    Object? returnTankQuantity = freezed,
    Object? deliveryDate = null,
    Object? deliveryMethod = null,
    Object? deliveryAddressId = freezed,
    Object? deliveryMemo = freezed,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? confirmedAt = freezed,
    Object? confirmedBy = freezed,
    Object? shippedAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledAt = freezed,
    Object? cancelledReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? profile = freezed,
    Object? deliveryAddress = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNumber: null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            productType: null == productType
                ? _value.productType
                : productType // ignore: cast_nullable_to_non_nullable
                      as ProductType,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            javaraQuantity: freezed == javaraQuantity
                ? _value.javaraQuantity
                : javaraQuantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            returnTankQuantity: freezed == returnTankQuantity
                ? _value.returnTankQuantity
                : returnTankQuantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            deliveryDate: null == deliveryDate
                ? _value.deliveryDate
                : deliveryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deliveryMethod: null == deliveryMethod
                ? _value.deliveryMethod
                : deliveryMethod // ignore: cast_nullable_to_non_nullable
                      as DeliveryMethod,
            deliveryAddressId: freezed == deliveryAddressId
                ? _value.deliveryAddressId
                : deliveryAddressId // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryMemo: freezed == deliveryMemo
                ? _value.deliveryMemo
                : deliveryMemo // ignore: cast_nullable_to_non_nullable
                      as String?,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            confirmedAt: freezed == confirmedAt
                ? _value.confirmedAt
                : confirmedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            confirmedBy: freezed == confirmedBy
                ? _value.confirmedBy
                : confirmedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            shippedAt: freezed == shippedAt
                ? _value.shippedAt
                : shippedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cancelledAt: freezed == cancelledAt
                ? _value.cancelledAt
                : cancelledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cancelledReason: freezed == cancelledReason
                ? _value.cancelledReason
                : cancelledReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            profile: freezed == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as ProfileModel?,
            deliveryAddress: freezed == deliveryAddress
                ? _value.deliveryAddress
                : deliveryAddress // ignore: cast_nullable_to_non_nullable
                      as DeliveryAddressModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileModelCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileModelCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliveryAddressModelCopyWith<$Res>? get deliveryAddress {
    if (_value.deliveryAddress == null) {
      return null;
    }

    return $DeliveryAddressModelCopyWith<$Res>(_value.deliveryAddress!, (
      value,
    ) {
      return _then(_value.copyWith(deliveryAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
    _$OrderModelImpl value,
    $Res Function(_$OrderModelImpl) then,
  ) = __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_number') String orderNumber,
    @JsonKey(name: 'user_id') String userId,
    OrderStatus status,
    @JsonKey(name: 'product_type') ProductType productType,
    int quantity,
    @JsonKey(name: 'javara_quantity') int? javaraQuantity,
    @JsonKey(name: 'return_tank_quantity') int? returnTankQuantity,
    @JsonKey(name: 'delivery_date') DateTime deliveryDate,
    @JsonKey(name: 'delivery_method') DeliveryMethod deliveryMethod,
    @JsonKey(name: 'delivery_address_id') String? deliveryAddressId,
    @JsonKey(name: 'delivery_memo') String? deliveryMemo,
    @JsonKey(name: 'unit_price') double unitPrice,
    @JsonKey(name: 'total_price') double totalPrice,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'confirmed_by') String? confirmedBy,
    @JsonKey(name: 'shipped_at') DateTime? shippedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'cancelled_reason') String? cancelledReason,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    ProfileModel? profile,
    @JsonKey(includeFromJson: false, includeToJson: false)
    DeliveryAddressModel? deliveryAddress,
  });

  @override
  $ProfileModelCopyWith<$Res>? get profile;
  @override
  $DeliveryAddressModelCopyWith<$Res>? get deliveryAddress;
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
    _$OrderModelImpl _value,
    $Res Function(_$OrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? userId = null,
    Object? status = null,
    Object? productType = null,
    Object? quantity = null,
    Object? javaraQuantity = freezed,
    Object? returnTankQuantity = freezed,
    Object? deliveryDate = null,
    Object? deliveryMethod = null,
    Object? deliveryAddressId = freezed,
    Object? deliveryMemo = freezed,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? confirmedAt = freezed,
    Object? confirmedBy = freezed,
    Object? shippedAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledAt = freezed,
    Object? cancelledReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? profile = freezed,
    Object? deliveryAddress = freezed,
  }) {
    return _then(
      _$OrderModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNumber: null == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        productType: null == productType
            ? _value.productType
            : productType // ignore: cast_nullable_to_non_nullable
                  as ProductType,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        javaraQuantity: freezed == javaraQuantity
            ? _value.javaraQuantity
            : javaraQuantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        returnTankQuantity: freezed == returnTankQuantity
            ? _value.returnTankQuantity
            : returnTankQuantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        deliveryDate: null == deliveryDate
            ? _value.deliveryDate
            : deliveryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deliveryMethod: null == deliveryMethod
            ? _value.deliveryMethod
            : deliveryMethod // ignore: cast_nullable_to_non_nullable
                  as DeliveryMethod,
        deliveryAddressId: freezed == deliveryAddressId
            ? _value.deliveryAddressId
            : deliveryAddressId // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryMemo: freezed == deliveryMemo
            ? _value.deliveryMemo
            : deliveryMemo // ignore: cast_nullable_to_non_nullable
                  as String?,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        confirmedAt: freezed == confirmedAt
            ? _value.confirmedAt
            : confirmedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        confirmedBy: freezed == confirmedBy
            ? _value.confirmedBy
            : confirmedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        shippedAt: freezed == shippedAt
            ? _value.shippedAt
            : shippedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelledAt: freezed == cancelledAt
            ? _value.cancelledAt
            : cancelledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelledReason: freezed == cancelledReason
            ? _value.cancelledReason
            : cancelledReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        profile: freezed == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as ProfileModel?,
        deliveryAddress: freezed == deliveryAddress
            ? _value.deliveryAddress
            : deliveryAddress // ignore: cast_nullable_to_non_nullable
                  as DeliveryAddressModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl({
    required this.id,
    @JsonKey(name: 'order_number') required this.orderNumber,
    @JsonKey(name: 'user_id') required this.userId,
    required this.status,
    @JsonKey(name: 'product_type') required this.productType,
    required this.quantity,
    @JsonKey(name: 'javara_quantity') this.javaraQuantity,
    @JsonKey(name: 'return_tank_quantity') this.returnTankQuantity,
    @JsonKey(name: 'delivery_date') required this.deliveryDate,
    @JsonKey(name: 'delivery_method') required this.deliveryMethod,
    @JsonKey(name: 'delivery_address_id') this.deliveryAddressId,
    @JsonKey(name: 'delivery_memo') this.deliveryMemo,
    @JsonKey(name: 'unit_price') required this.unitPrice,
    @JsonKey(name: 'total_price') required this.totalPrice,
    @JsonKey(name: 'confirmed_at') this.confirmedAt,
    @JsonKey(name: 'confirmed_by') this.confirmedBy,
    @JsonKey(name: 'shipped_at') this.shippedAt,
    @JsonKey(name: 'completed_at') this.completedAt,
    @JsonKey(name: 'cancelled_at') this.cancelledAt,
    @JsonKey(name: 'cancelled_reason') this.cancelledReason,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) this.profile,
    @JsonKey(includeFromJson: false, includeToJson: false) this.deliveryAddress,
  });

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final OrderStatus status;
  @override
  @JsonKey(name: 'product_type')
  final ProductType productType;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'javara_quantity')
  final int? javaraQuantity;
  @override
  @JsonKey(name: 'return_tank_quantity')
  final int? returnTankQuantity;
  @override
  @JsonKey(name: 'delivery_date')
  final DateTime deliveryDate;
  @override
  @JsonKey(name: 'delivery_method')
  final DeliveryMethod deliveryMethod;
  @override
  @JsonKey(name: 'delivery_address_id')
  final String? deliveryAddressId;
  @override
  @JsonKey(name: 'delivery_memo')
  final String? deliveryMemo;
  @override
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @override
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @override
  @JsonKey(name: 'confirmed_at')
  final DateTime? confirmedAt;
  @override
  @JsonKey(name: 'confirmed_by')
  final String? confirmedBy;
  @override
  @JsonKey(name: 'shipped_at')
  final DateTime? shippedAt;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;
  @override
  @JsonKey(name: 'cancelled_reason')
  final String? cancelledReason;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  // Relations (JSON에서 제외)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ProfileModel? profile;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DeliveryAddressModel? deliveryAddress;

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, userId: $userId, status: $status, productType: $productType, quantity: $quantity, javaraQuantity: $javaraQuantity, returnTankQuantity: $returnTankQuantity, deliveryDate: $deliveryDate, deliveryMethod: $deliveryMethod, deliveryAddressId: $deliveryAddressId, deliveryMemo: $deliveryMemo, unitPrice: $unitPrice, totalPrice: $totalPrice, confirmedAt: $confirmedAt, confirmedBy: $confirmedBy, shippedAt: $shippedAt, completedAt: $completedAt, cancelledAt: $cancelledAt, cancelledReason: $cancelledReason, createdAt: $createdAt, updatedAt: $updatedAt, profile: $profile, deliveryAddress: $deliveryAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.javaraQuantity, javaraQuantity) ||
                other.javaraQuantity == javaraQuantity) &&
            (identical(other.returnTankQuantity, returnTankQuantity) ||
                other.returnTankQuantity == returnTankQuantity) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.deliveryMethod, deliveryMethod) ||
                other.deliveryMethod == deliveryMethod) &&
            (identical(other.deliveryAddressId, deliveryAddressId) ||
                other.deliveryAddressId == deliveryAddressId) &&
            (identical(other.deliveryMemo, deliveryMemo) ||
                other.deliveryMemo == deliveryMemo) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.confirmedBy, confirmedBy) ||
                other.confirmedBy == confirmedBy) &&
            (identical(other.shippedAt, shippedAt) ||
                other.shippedAt == shippedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.cancelledReason, cancelledReason) ||
                other.cancelledReason == cancelledReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    orderNumber,
    userId,
    status,
    productType,
    quantity,
    javaraQuantity,
    returnTankQuantity,
    deliveryDate,
    deliveryMethod,
    deliveryAddressId,
    deliveryMemo,
    unitPrice,
    totalPrice,
    confirmedAt,
    confirmedBy,
    shippedAt,
    completedAt,
    cancelledAt,
    cancelledReason,
    createdAt,
    updatedAt,
    profile,
    deliveryAddress,
  ]);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(this);
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel({
    required final String id,
    @JsonKey(name: 'order_number') required final String orderNumber,
    @JsonKey(name: 'user_id') required final String userId,
    required final OrderStatus status,
    @JsonKey(name: 'product_type') required final ProductType productType,
    required final int quantity,
    @JsonKey(name: 'javara_quantity') final int? javaraQuantity,
    @JsonKey(name: 'return_tank_quantity') final int? returnTankQuantity,
    @JsonKey(name: 'delivery_date') required final DateTime deliveryDate,
    @JsonKey(name: 'delivery_method')
    required final DeliveryMethod deliveryMethod,
    @JsonKey(name: 'delivery_address_id') final String? deliveryAddressId,
    @JsonKey(name: 'delivery_memo') final String? deliveryMemo,
    @JsonKey(name: 'unit_price') required final double unitPrice,
    @JsonKey(name: 'total_price') required final double totalPrice,
    @JsonKey(name: 'confirmed_at') final DateTime? confirmedAt,
    @JsonKey(name: 'confirmed_by') final String? confirmedBy,
    @JsonKey(name: 'shipped_at') final DateTime? shippedAt,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
    @JsonKey(name: 'cancelled_at') final DateTime? cancelledAt,
    @JsonKey(name: 'cancelled_reason') final String? cancelledReason,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final ProfileModel? profile,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final DeliveryAddressModel? deliveryAddress,
  }) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'order_number')
  String get orderNumber;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  OrderStatus get status;
  @override
  @JsonKey(name: 'product_type')
  ProductType get productType;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'javara_quantity')
  int? get javaraQuantity;
  @override
  @JsonKey(name: 'return_tank_quantity')
  int? get returnTankQuantity;
  @override
  @JsonKey(name: 'delivery_date')
  DateTime get deliveryDate;
  @override
  @JsonKey(name: 'delivery_method')
  DeliveryMethod get deliveryMethod;
  @override
  @JsonKey(name: 'delivery_address_id')
  String? get deliveryAddressId;
  @override
  @JsonKey(name: 'delivery_memo')
  String? get deliveryMemo;
  @override
  @JsonKey(name: 'unit_price')
  double get unitPrice;
  @override
  @JsonKey(name: 'total_price')
  double get totalPrice;
  @override
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt;
  @override
  @JsonKey(name: 'confirmed_by')
  String? get confirmedBy;
  @override
  @JsonKey(name: 'shipped_at')
  DateTime? get shippedAt;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt;
  @override
  @JsonKey(name: 'cancelled_reason')
  String? get cancelledReason;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt; // Relations (JSON에서 제외)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  ProfileModel? get profile;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  DeliveryAddressModel? get deliveryAddress;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeliveryAddressModel _$DeliveryAddressModelFromJson(Map<String, dynamic> json) {
  return _DeliveryAddressModel.fromJson(json);
}

/// @nodoc
mixin _$DeliveryAddressModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_detail')
  String? get addressDetail => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  String? get postalCode => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool? get isDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DeliveryAddressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryAddressModelCopyWith<DeliveryAddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryAddressModelCopyWith<$Res> {
  factory $DeliveryAddressModelCopyWith(
    DeliveryAddressModel value,
    $Res Function(DeliveryAddressModel) then,
  ) = _$DeliveryAddressModelCopyWithImpl<$Res, DeliveryAddressModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String name,
    String address,
    @JsonKey(name: 'address_detail') String? addressDetail,
    @JsonKey(name: 'postal_code') String? postalCode,
    String? phone,
    @JsonKey(name: 'is_default') bool? isDefault,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$DeliveryAddressModelCopyWithImpl<
  $Res,
  $Val extends DeliveryAddressModel
>
    implements $DeliveryAddressModelCopyWith<$Res> {
  _$DeliveryAddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? address = null,
    Object? addressDetail = freezed,
    Object? postalCode = freezed,
    Object? phone = freezed,
    Object? isDefault = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            addressDetail: freezed == addressDetail
                ? _value.addressDetail
                : addressDetail // ignore: cast_nullable_to_non_nullable
                      as String?,
            postalCode: freezed == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDefault: freezed == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeliveryAddressModelImplCopyWith<$Res>
    implements $DeliveryAddressModelCopyWith<$Res> {
  factory _$$DeliveryAddressModelImplCopyWith(
    _$DeliveryAddressModelImpl value,
    $Res Function(_$DeliveryAddressModelImpl) then,
  ) = __$$DeliveryAddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String name,
    String address,
    @JsonKey(name: 'address_detail') String? addressDetail,
    @JsonKey(name: 'postal_code') String? postalCode,
    String? phone,
    @JsonKey(name: 'is_default') bool? isDefault,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$DeliveryAddressModelImplCopyWithImpl<$Res>
    extends _$DeliveryAddressModelCopyWithImpl<$Res, _$DeliveryAddressModelImpl>
    implements _$$DeliveryAddressModelImplCopyWith<$Res> {
  __$$DeliveryAddressModelImplCopyWithImpl(
    _$DeliveryAddressModelImpl _value,
    $Res Function(_$DeliveryAddressModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? address = null,
    Object? addressDetail = freezed,
    Object? postalCode = freezed,
    Object? phone = freezed,
    Object? isDefault = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$DeliveryAddressModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        addressDetail: freezed == addressDetail
            ? _value.addressDetail
            : addressDetail // ignore: cast_nullable_to_non_nullable
                  as String?,
        postalCode: freezed == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDefault: freezed == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryAddressModelImpl implements _DeliveryAddressModel {
  const _$DeliveryAddressModelImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.name,
    required this.address,
    @JsonKey(name: 'address_detail') this.addressDetail,
    @JsonKey(name: 'postal_code') this.postalCode,
    this.phone,
    @JsonKey(name: 'is_default') this.isDefault,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$DeliveryAddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryAddressModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  final String address;
  @override
  @JsonKey(name: 'address_detail')
  final String? addressDetail;
  @override
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'is_default')
  final bool? isDefault;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'DeliveryAddressModel(id: $id, userId: $userId, name: $name, address: $address, addressDetail: $addressDetail, postalCode: $postalCode, phone: $phone, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryAddressModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.addressDetail, addressDetail) ||
                other.addressDetail == addressDetail) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    name,
    address,
    addressDetail,
    postalCode,
    phone,
    isDefault,
    createdAt,
    updatedAt,
  );

  /// Create a copy of DeliveryAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryAddressModelImplCopyWith<_$DeliveryAddressModelImpl>
  get copyWith =>
      __$$DeliveryAddressModelImplCopyWithImpl<_$DeliveryAddressModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryAddressModelImplToJson(this);
  }
}

abstract class _DeliveryAddressModel implements DeliveryAddressModel {
  const factory _DeliveryAddressModel({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    required final String name,
    required final String address,
    @JsonKey(name: 'address_detail') final String? addressDetail,
    @JsonKey(name: 'postal_code') final String? postalCode,
    final String? phone,
    @JsonKey(name: 'is_default') final bool? isDefault,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$DeliveryAddressModelImpl;

  factory _DeliveryAddressModel.fromJson(Map<String, dynamic> json) =
      _$DeliveryAddressModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  String get address;
  @override
  @JsonKey(name: 'address_detail')
  String? get addressDetail;
  @override
  @JsonKey(name: 'postal_code')
  String? get postalCode;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'is_default')
  bool? get isDefault;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of DeliveryAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryAddressModelImplCopyWith<_$DeliveryAddressModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
