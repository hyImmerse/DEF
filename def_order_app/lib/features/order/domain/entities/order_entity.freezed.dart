// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderEntity {
  String get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  ProductType get productType => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int? get javaraQuantity => throw _privateConstructorUsedError;
  int? get returnTankQuantity => throw _privateConstructorUsedError;
  DateTime get deliveryDate => throw _privateConstructorUsedError;
  DeliveryMethod get deliveryMethod => throw _privateConstructorUsedError;
  String? get deliveryAddressId => throw _privateConstructorUsedError;
  String? get deliveryMemo => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String? get cancelledReason => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  String? get confirmedBy => throw _privateConstructorUsedError;
  DateTime? get shippedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError; // 관계 데이터
  UserProfile? get userProfile => throw _privateConstructorUsedError;
  DeliveryAddress? get deliveryAddress => throw _privateConstructorUsedError;

  /// Create a copy of OrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderEntityCopyWith<OrderEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderEntityCopyWith<$Res> {
  factory $OrderEntityCopyWith(
    OrderEntity value,
    $Res Function(OrderEntity) then,
  ) = _$OrderEntityCopyWithImpl<$Res, OrderEntity>;
  @useResult
  $Res call({
    String id,
    String orderNumber,
    String userId,
    OrderStatus status,
    ProductType productType,
    int quantity,
    int? javaraQuantity,
    int? returnTankQuantity,
    DateTime deliveryDate,
    DeliveryMethod deliveryMethod,
    String? deliveryAddressId,
    String? deliveryMemo,
    double unitPrice,
    double totalPrice,
    String? cancelledReason,
    DateTime? confirmedAt,
    String? confirmedBy,
    DateTime? shippedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime createdAt,
    DateTime updatedAt,
    UserProfile? userProfile,
    DeliveryAddress? deliveryAddress,
  });

  $UserProfileCopyWith<$Res>? get userProfile;
  $DeliveryAddressCopyWith<$Res>? get deliveryAddress;
}

/// @nodoc
class _$OrderEntityCopyWithImpl<$Res, $Val extends OrderEntity>
    implements $OrderEntityCopyWith<$Res> {
  _$OrderEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderEntity
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
    Object? cancelledReason = freezed,
    Object? confirmedAt = freezed,
    Object? confirmedBy = freezed,
    Object? shippedAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userProfile = freezed,
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
            cancelledReason: freezed == cancelledReason
                ? _value.cancelledReason
                : cancelledReason // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            userProfile: freezed == userProfile
                ? _value.userProfile
                : userProfile // ignore: cast_nullable_to_non_nullable
                      as UserProfile?,
            deliveryAddress: freezed == deliveryAddress
                ? _value.deliveryAddress
                : deliveryAddress // ignore: cast_nullable_to_non_nullable
                      as DeliveryAddress?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get userProfile {
    if (_value.userProfile == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.userProfile!, (value) {
      return _then(_value.copyWith(userProfile: value) as $Val);
    });
  }

  /// Create a copy of OrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliveryAddressCopyWith<$Res>? get deliveryAddress {
    if (_value.deliveryAddress == null) {
      return null;
    }

    return $DeliveryAddressCopyWith<$Res>(_value.deliveryAddress!, (value) {
      return _then(_value.copyWith(deliveryAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderEntityImplCopyWith<$Res>
    implements $OrderEntityCopyWith<$Res> {
  factory _$$OrderEntityImplCopyWith(
    _$OrderEntityImpl value,
    $Res Function(_$OrderEntityImpl) then,
  ) = __$$OrderEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderNumber,
    String userId,
    OrderStatus status,
    ProductType productType,
    int quantity,
    int? javaraQuantity,
    int? returnTankQuantity,
    DateTime deliveryDate,
    DeliveryMethod deliveryMethod,
    String? deliveryAddressId,
    String? deliveryMemo,
    double unitPrice,
    double totalPrice,
    String? cancelledReason,
    DateTime? confirmedAt,
    String? confirmedBy,
    DateTime? shippedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime createdAt,
    DateTime updatedAt,
    UserProfile? userProfile,
    DeliveryAddress? deliveryAddress,
  });

  @override
  $UserProfileCopyWith<$Res>? get userProfile;
  @override
  $DeliveryAddressCopyWith<$Res>? get deliveryAddress;
}

/// @nodoc
class __$$OrderEntityImplCopyWithImpl<$Res>
    extends _$OrderEntityCopyWithImpl<$Res, _$OrderEntityImpl>
    implements _$$OrderEntityImplCopyWith<$Res> {
  __$$OrderEntityImplCopyWithImpl(
    _$OrderEntityImpl _value,
    $Res Function(_$OrderEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderEntity
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
    Object? cancelledReason = freezed,
    Object? confirmedAt = freezed,
    Object? confirmedBy = freezed,
    Object? shippedAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userProfile = freezed,
    Object? deliveryAddress = freezed,
  }) {
    return _then(
      _$OrderEntityImpl(
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
        cancelledReason: freezed == cancelledReason
            ? _value.cancelledReason
            : cancelledReason // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        userProfile: freezed == userProfile
            ? _value.userProfile
            : userProfile // ignore: cast_nullable_to_non_nullable
                  as UserProfile?,
        deliveryAddress: freezed == deliveryAddress
            ? _value.deliveryAddress
            : deliveryAddress // ignore: cast_nullable_to_non_nullable
                  as DeliveryAddress?,
      ),
    );
  }
}

/// @nodoc

class _$OrderEntityImpl extends _OrderEntity {
  const _$OrderEntityImpl({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.status,
    required this.productType,
    required this.quantity,
    this.javaraQuantity,
    this.returnTankQuantity,
    required this.deliveryDate,
    required this.deliveryMethod,
    this.deliveryAddressId,
    this.deliveryMemo,
    required this.unitPrice,
    required this.totalPrice,
    this.cancelledReason,
    this.confirmedAt,
    this.confirmedBy,
    this.shippedAt,
    this.completedAt,
    this.cancelledAt,
    required this.createdAt,
    required this.updatedAt,
    this.userProfile,
    this.deliveryAddress,
  }) : super._();

  @override
  final String id;
  @override
  final String orderNumber;
  @override
  final String userId;
  @override
  final OrderStatus status;
  @override
  final ProductType productType;
  @override
  final int quantity;
  @override
  final int? javaraQuantity;
  @override
  final int? returnTankQuantity;
  @override
  final DateTime deliveryDate;
  @override
  final DeliveryMethod deliveryMethod;
  @override
  final String? deliveryAddressId;
  @override
  final String? deliveryMemo;
  @override
  final double unitPrice;
  @override
  final double totalPrice;
  @override
  final String? cancelledReason;
  @override
  final DateTime? confirmedAt;
  @override
  final String? confirmedBy;
  @override
  final DateTime? shippedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? cancelledAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  // 관계 데이터
  @override
  final UserProfile? userProfile;
  @override
  final DeliveryAddress? deliveryAddress;

  @override
  String toString() {
    return 'OrderEntity(id: $id, orderNumber: $orderNumber, userId: $userId, status: $status, productType: $productType, quantity: $quantity, javaraQuantity: $javaraQuantity, returnTankQuantity: $returnTankQuantity, deliveryDate: $deliveryDate, deliveryMethod: $deliveryMethod, deliveryAddressId: $deliveryAddressId, deliveryMemo: $deliveryMemo, unitPrice: $unitPrice, totalPrice: $totalPrice, cancelledReason: $cancelledReason, confirmedAt: $confirmedAt, confirmedBy: $confirmedBy, shippedAt: $shippedAt, completedAt: $completedAt, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt, userProfile: $userProfile, deliveryAddress: $deliveryAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderEntityImpl &&
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
            (identical(other.cancelledReason, cancelledReason) ||
                other.cancelledReason == cancelledReason) &&
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
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress));
  }

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
    cancelledReason,
    confirmedAt,
    confirmedBy,
    shippedAt,
    completedAt,
    cancelledAt,
    createdAt,
    updatedAt,
    userProfile,
    deliveryAddress,
  ]);

  /// Create a copy of OrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderEntityImplCopyWith<_$OrderEntityImpl> get copyWith =>
      __$$OrderEntityImplCopyWithImpl<_$OrderEntityImpl>(this, _$identity);
}

abstract class _OrderEntity extends OrderEntity {
  const factory _OrderEntity({
    required final String id,
    required final String orderNumber,
    required final String userId,
    required final OrderStatus status,
    required final ProductType productType,
    required final int quantity,
    final int? javaraQuantity,
    final int? returnTankQuantity,
    required final DateTime deliveryDate,
    required final DeliveryMethod deliveryMethod,
    final String? deliveryAddressId,
    final String? deliveryMemo,
    required final double unitPrice,
    required final double totalPrice,
    final String? cancelledReason,
    final DateTime? confirmedAt,
    final String? confirmedBy,
    final DateTime? shippedAt,
    final DateTime? completedAt,
    final DateTime? cancelledAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final UserProfile? userProfile,
    final DeliveryAddress? deliveryAddress,
  }) = _$OrderEntityImpl;
  const _OrderEntity._() : super._();

  @override
  String get id;
  @override
  String get orderNumber;
  @override
  String get userId;
  @override
  OrderStatus get status;
  @override
  ProductType get productType;
  @override
  int get quantity;
  @override
  int? get javaraQuantity;
  @override
  int? get returnTankQuantity;
  @override
  DateTime get deliveryDate;
  @override
  DeliveryMethod get deliveryMethod;
  @override
  String? get deliveryAddressId;
  @override
  String? get deliveryMemo;
  @override
  double get unitPrice;
  @override
  double get totalPrice;
  @override
  String? get cancelledReason;
  @override
  DateTime? get confirmedAt;
  @override
  String? get confirmedBy;
  @override
  DateTime? get shippedAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get cancelledAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // 관계 데이터
  @override
  UserProfile? get userProfile;
  @override
  DeliveryAddress? get deliveryAddress;

  /// Create a copy of OrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderEntityImplCopyWith<_$OrderEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get businessNumber => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get representativeName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get grade => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
    UserProfile value,
    $Res Function(UserProfile) then,
  ) = _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call({
    String id,
    String businessNumber,
    String businessName,
    String representativeName,
    String phone,
    String? email,
    String grade,
    String status,
  });
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessNumber = null,
    Object? businessName = null,
    Object? representativeName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? grade = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            businessNumber: null == businessNumber
                ? _value.businessNumber
                : businessNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            businessName: null == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                      as String,
            representativeName: null == representativeName
                ? _value.representativeName
                : representativeName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            grade: null == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
    _$UserProfileImpl value,
    $Res Function(_$UserProfileImpl) then,
  ) = __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessNumber,
    String businessName,
    String representativeName,
    String phone,
    String? email,
    String grade,
    String status,
  });
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
    _$UserProfileImpl _value,
    $Res Function(_$UserProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessNumber = null,
    Object? businessName = null,
    Object? representativeName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? grade = null,
    Object? status = null,
  }) {
    return _then(
      _$UserProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessNumber: null == businessNumber
            ? _value.businessNumber
            : businessNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        businessName: null == businessName
            ? _value.businessName
            : businessName // ignore: cast_nullable_to_non_nullable
                  as String,
        representativeName: null == representativeName
            ? _value.representativeName
            : representativeName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        grade: null == grade
            ? _value.grade
            : grade // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl({
    required this.id,
    required this.businessNumber,
    required this.businessName,
    required this.representativeName,
    required this.phone,
    this.email,
    required this.grade,
    required this.status,
  }) : super._();

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String businessNumber;
  @override
  final String businessName;
  @override
  final String representativeName;
  @override
  final String phone;
  @override
  final String? email;
  @override
  final String grade;
  @override
  final String status;

  @override
  String toString() {
    return 'UserProfile(id: $id, businessNumber: $businessNumber, businessName: $businessName, representativeName: $representativeName, phone: $phone, email: $email, grade: $grade, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessNumber, businessNumber) ||
                other.businessNumber == businessNumber) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.representativeName, representativeName) ||
                other.representativeName == representativeName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessNumber,
    businessName,
    representativeName,
    phone,
    email,
    grade,
    status,
  );

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(this);
  }
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile({
    required final String id,
    required final String businessNumber,
    required final String businessName,
    required final String representativeName,
    required final String phone,
    final String? email,
    required final String grade,
    required final String status,
  }) = _$UserProfileImpl;
  const _UserProfile._() : super._();

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get businessNumber;
  @override
  String get businessName;
  @override
  String get representativeName;
  @override
  String get phone;
  @override
  String? get email;
  @override
  String get grade;
  @override
  String get status;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeliveryAddress _$DeliveryAddressFromJson(Map<String, dynamic> json) {
  return _DeliveryAddress.fromJson(json);
}

/// @nodoc
mixin _$DeliveryAddress {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get addressDetail => throw _privateConstructorUsedError;
  String get postalCode => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;

  /// Serializes this DeliveryAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryAddressCopyWith<DeliveryAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryAddressCopyWith<$Res> {
  factory $DeliveryAddressCopyWith(
    DeliveryAddress value,
    $Res Function(DeliveryAddress) then,
  ) = _$DeliveryAddressCopyWithImpl<$Res, DeliveryAddress>;
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    String? addressDetail,
    String postalCode,
    String phone,
  });
}

/// @nodoc
class _$DeliveryAddressCopyWithImpl<$Res, $Val extends DeliveryAddress>
    implements $DeliveryAddressCopyWith<$Res> {
  _$DeliveryAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? addressDetail = freezed,
    Object? postalCode = null,
    Object? phone = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
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
            postalCode: null == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeliveryAddressImplCopyWith<$Res>
    implements $DeliveryAddressCopyWith<$Res> {
  factory _$$DeliveryAddressImplCopyWith(
    _$DeliveryAddressImpl value,
    $Res Function(_$DeliveryAddressImpl) then,
  ) = __$$DeliveryAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    String? addressDetail,
    String postalCode,
    String phone,
  });
}

/// @nodoc
class __$$DeliveryAddressImplCopyWithImpl<$Res>
    extends _$DeliveryAddressCopyWithImpl<$Res, _$DeliveryAddressImpl>
    implements _$$DeliveryAddressImplCopyWith<$Res> {
  __$$DeliveryAddressImplCopyWithImpl(
    _$DeliveryAddressImpl _value,
    $Res Function(_$DeliveryAddressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? addressDetail = freezed,
    Object? postalCode = null,
    Object? phone = null,
  }) {
    return _then(
      _$DeliveryAddressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
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
        postalCode: null == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryAddressImpl implements _DeliveryAddress {
  const _$DeliveryAddressImpl({
    required this.id,
    required this.name,
    required this.address,
    this.addressDetail,
    required this.postalCode,
    required this.phone,
  });

  factory _$DeliveryAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryAddressImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  final String? addressDetail;
  @override
  final String postalCode;
  @override
  final String phone;

  @override
  String toString() {
    return 'DeliveryAddress(id: $id, name: $name, address: $address, addressDetail: $addressDetail, postalCode: $postalCode, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryAddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.addressDetail, addressDetail) ||
                other.addressDetail == addressDetail) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    address,
    addressDetail,
    postalCode,
    phone,
  );

  /// Create a copy of DeliveryAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryAddressImplCopyWith<_$DeliveryAddressImpl> get copyWith =>
      __$$DeliveryAddressImplCopyWithImpl<_$DeliveryAddressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryAddressImplToJson(this);
  }
}

abstract class _DeliveryAddress implements DeliveryAddress {
  const factory _DeliveryAddress({
    required final String id,
    required final String name,
    required final String address,
    final String? addressDetail,
    required final String postalCode,
    required final String phone,
  }) = _$DeliveryAddressImpl;

  factory _DeliveryAddress.fromJson(Map<String, dynamic> json) =
      _$DeliveryAddressImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  String? get addressDetail;
  @override
  String get postalCode;
  @override
  String get phone;

  /// Create a copy of DeliveryAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryAddressImplCopyWith<_$DeliveryAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ValidationResult {
  bool get isValid => throw _privateConstructorUsedError;
  Map<String, String> get errors => throw _privateConstructorUsedError;

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValidationResultCopyWith<ValidationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidationResultCopyWith<$Res> {
  factory $ValidationResultCopyWith(
    ValidationResult value,
    $Res Function(ValidationResult) then,
  ) = _$ValidationResultCopyWithImpl<$Res, ValidationResult>;
  @useResult
  $Res call({bool isValid, Map<String, String> errors});
}

/// @nodoc
class _$ValidationResultCopyWithImpl<$Res, $Val extends ValidationResult>
    implements $ValidationResultCopyWith<$Res> {
  _$ValidationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isValid = null, Object? errors = null}) {
    return _then(
      _value.copyWith(
            isValid: null == isValid
                ? _value.isValid
                : isValid // ignore: cast_nullable_to_non_nullable
                      as bool,
            errors: null == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ValidationResultImplCopyWith<$Res>
    implements $ValidationResultCopyWith<$Res> {
  factory _$$ValidationResultImplCopyWith(
    _$ValidationResultImpl value,
    $Res Function(_$ValidationResultImpl) then,
  ) = __$$ValidationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isValid, Map<String, String> errors});
}

/// @nodoc
class __$$ValidationResultImplCopyWithImpl<$Res>
    extends _$ValidationResultCopyWithImpl<$Res, _$ValidationResultImpl>
    implements _$$ValidationResultImplCopyWith<$Res> {
  __$$ValidationResultImplCopyWithImpl(
    _$ValidationResultImpl _value,
    $Res Function(_$ValidationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isValid = null, Object? errors = null}) {
    return _then(
      _$ValidationResultImpl(
        isValid: null == isValid
            ? _value.isValid
            : isValid // ignore: cast_nullable_to_non_nullable
                  as bool,
        errors: null == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc

class _$ValidationResultImpl extends _ValidationResult {
  const _$ValidationResultImpl({
    required this.isValid,
    required final Map<String, String> errors,
  }) : _errors = errors,
       super._();

  @override
  final bool isValid;
  final Map<String, String> _errors;
  @override
  Map<String, String> get errors {
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_errors);
  }

  @override
  String toString() {
    return 'ValidationResult(isValid: $isValid, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationResultImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isValid,
    const DeepCollectionEquality().hash(_errors),
  );

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationResultImplCopyWith<_$ValidationResultImpl> get copyWith =>
      __$$ValidationResultImplCopyWithImpl<_$ValidationResultImpl>(
        this,
        _$identity,
      );
}

abstract class _ValidationResult extends ValidationResult {
  const factory _ValidationResult({
    required final bool isValid,
    required final Map<String, String> errors,
  }) = _$ValidationResultImpl;
  const _ValidationResult._() : super._();

  @override
  bool get isValid;
  @override
  Map<String, String> get errors;

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationResultImplCopyWith<_$ValidationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
