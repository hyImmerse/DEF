// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return _ProfileModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_number')
  String get businessNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_name')
  String get businessName => throw _privateConstructorUsedError;
  @JsonKey(name: 'representative_name')
  String get representativeName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  UserGrade get grade => throw _privateConstructorUsedError;
  UserStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price_box')
  double? get unitPriceBox => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price_bulk')
  double? get unitPriceBulk => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by')
  String? get approvedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejected_reason')
  String? get rejectedReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_order_at')
  DateTime? get lastOrderAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileModelCopyWith<ProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileModelCopyWith<$Res> {
  factory $ProfileModelCopyWith(
          ProfileModel value, $Res Function(ProfileModel) then) =
      _$ProfileModelCopyWithImpl<$Res, ProfileModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'business_number') String businessNumber,
      @JsonKey(name: 'business_name') String businessName,
      @JsonKey(name: 'representative_name') String representativeName,
      String phone,
      String email,
      UserGrade grade,
      UserStatus status,
      @JsonKey(name: 'unit_price_box') double? unitPriceBox,
      @JsonKey(name: 'unit_price_bulk') double? unitPriceBulk,
      @JsonKey(name: 'approved_at') DateTime? approvedAt,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'rejected_reason') String? rejectedReason,
      @JsonKey(name: 'last_order_at') DateTime? lastOrderAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ProfileModelCopyWithImpl<$Res, $Val extends ProfileModel>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessNumber = null,
    Object? businessName = null,
    Object? representativeName = null,
    Object? phone = null,
    Object? email = null,
    Object? grade = null,
    Object? status = null,
    Object? unitPriceBox = freezed,
    Object? unitPriceBulk = freezed,
    Object? approvedAt = freezed,
    Object? approvedBy = freezed,
    Object? rejectedReason = freezed,
    Object? lastOrderAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as UserGrade,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      unitPriceBox: freezed == unitPriceBox
          ? _value.unitPriceBox
          : unitPriceBox // ignore: cast_nullable_to_non_nullable
              as double?,
      unitPriceBulk: freezed == unitPriceBulk
          ? _value.unitPriceBulk
          : unitPriceBulk // ignore: cast_nullable_to_non_nullable
              as double?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedReason: freezed == rejectedReason
          ? _value.rejectedReason
          : rejectedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      lastOrderAt: freezed == lastOrderAt
          ? _value.lastOrderAt
          : lastOrderAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileModelImplCopyWith<$Res>
    implements $ProfileModelCopyWith<$Res> {
  factory _$$ProfileModelImplCopyWith(
          _$ProfileModelImpl value, $Res Function(_$ProfileModelImpl) then) =
      __$$ProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'business_number') String businessNumber,
      @JsonKey(name: 'business_name') String businessName,
      @JsonKey(name: 'representative_name') String representativeName,
      String phone,
      String email,
      UserGrade grade,
      UserStatus status,
      @JsonKey(name: 'unit_price_box') double? unitPriceBox,
      @JsonKey(name: 'unit_price_bulk') double? unitPriceBulk,
      @JsonKey(name: 'approved_at') DateTime? approvedAt,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'rejected_reason') String? rejectedReason,
      @JsonKey(name: 'last_order_at') DateTime? lastOrderAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ProfileModelImplCopyWithImpl<$Res>
    extends _$ProfileModelCopyWithImpl<$Res, _$ProfileModelImpl>
    implements _$$ProfileModelImplCopyWith<$Res> {
  __$$ProfileModelImplCopyWithImpl(
      _$ProfileModelImpl _value, $Res Function(_$ProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessNumber = null,
    Object? businessName = null,
    Object? representativeName = null,
    Object? phone = null,
    Object? email = null,
    Object? grade = null,
    Object? status = null,
    Object? unitPriceBox = freezed,
    Object? unitPriceBulk = freezed,
    Object? approvedAt = freezed,
    Object? approvedBy = freezed,
    Object? rejectedReason = freezed,
    Object? lastOrderAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProfileModelImpl(
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as UserGrade,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      unitPriceBox: freezed == unitPriceBox
          ? _value.unitPriceBox
          : unitPriceBox // ignore: cast_nullable_to_non_nullable
              as double?,
      unitPriceBulk: freezed == unitPriceBulk
          ? _value.unitPriceBulk
          : unitPriceBulk // ignore: cast_nullable_to_non_nullable
              as double?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedReason: freezed == rejectedReason
          ? _value.rejectedReason
          : rejectedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      lastOrderAt: freezed == lastOrderAt
          ? _value.lastOrderAt
          : lastOrderAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileModelImpl implements _ProfileModel {
  const _$ProfileModelImpl(
      {required this.id,
      @JsonKey(name: 'business_number') required this.businessNumber,
      @JsonKey(name: 'business_name') required this.businessName,
      @JsonKey(name: 'representative_name') required this.representativeName,
      required this.phone,
      required this.email,
      required this.grade,
      required this.status,
      @JsonKey(name: 'unit_price_box') this.unitPriceBox,
      @JsonKey(name: 'unit_price_bulk') this.unitPriceBulk,
      @JsonKey(name: 'approved_at') this.approvedAt,
      @JsonKey(name: 'approved_by') this.approvedBy,
      @JsonKey(name: 'rejected_reason') this.rejectedReason,
      @JsonKey(name: 'last_order_at') this.lastOrderAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_number')
  final String businessNumber;
  @override
  @JsonKey(name: 'business_name')
  final String businessName;
  @override
  @JsonKey(name: 'representative_name')
  final String representativeName;
  @override
  final String phone;
  @override
  final String email;
  @override
  final UserGrade grade;
  @override
  final UserStatus status;
  @override
  @JsonKey(name: 'unit_price_box')
  final double? unitPriceBox;
  @override
  @JsonKey(name: 'unit_price_bulk')
  final double? unitPriceBulk;
  @override
  @JsonKey(name: 'approved_at')
  final DateTime? approvedAt;
  @override
  @JsonKey(name: 'approved_by')
  final String? approvedBy;
  @override
  @JsonKey(name: 'rejected_reason')
  final String? rejectedReason;
  @override
  @JsonKey(name: 'last_order_at')
  final DateTime? lastOrderAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ProfileModel(id: $id, businessNumber: $businessNumber, businessName: $businessName, representativeName: $representativeName, phone: $phone, email: $email, grade: $grade, status: $status, unitPriceBox: $unitPriceBox, unitPriceBulk: $unitPriceBulk, approvedAt: $approvedAt, approvedBy: $approvedBy, rejectedReason: $rejectedReason, lastOrderAt: $lastOrderAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileModelImpl &&
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
            (identical(other.status, status) || other.status == status) &&
            (identical(other.unitPriceBox, unitPriceBox) ||
                other.unitPriceBox == unitPriceBox) &&
            (identical(other.unitPriceBulk, unitPriceBulk) ||
                other.unitPriceBulk == unitPriceBulk) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.rejectedReason, rejectedReason) ||
                other.rejectedReason == rejectedReason) &&
            (identical(other.lastOrderAt, lastOrderAt) ||
                other.lastOrderAt == lastOrderAt) &&
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
      businessNumber,
      businessName,
      representativeName,
      phone,
      email,
      grade,
      status,
      unitPriceBox,
      unitPriceBulk,
      approvedAt,
      approvedBy,
      rejectedReason,
      lastOrderAt,
      createdAt,
      updatedAt);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      __$$ProfileModelImplCopyWithImpl<_$ProfileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileModelImplToJson(
      this,
    );
  }
}

abstract class _ProfileModel implements ProfileModel {
  const factory _ProfileModel(
      {required final String id,
      @JsonKey(name: 'business_number') required final String businessNumber,
      @JsonKey(name: 'business_name') required final String businessName,
      @JsonKey(name: 'representative_name')
      required final String representativeName,
      required final String phone,
      required final String email,
      required final UserGrade grade,
      required final UserStatus status,
      @JsonKey(name: 'unit_price_box') final double? unitPriceBox,
      @JsonKey(name: 'unit_price_bulk') final double? unitPriceBulk,
      @JsonKey(name: 'approved_at') final DateTime? approvedAt,
      @JsonKey(name: 'approved_by') final String? approvedBy,
      @JsonKey(name: 'rejected_reason') final String? rejectedReason,
      @JsonKey(name: 'last_order_at') final DateTime? lastOrderAt,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$ProfileModelImpl;

  factory _ProfileModel.fromJson(Map<String, dynamic> json) =
      _$ProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_number')
  String get businessNumber;
  @override
  @JsonKey(name: 'business_name')
  String get businessName;
  @override
  @JsonKey(name: 'representative_name')
  String get representativeName;
  @override
  String get phone;
  @override
  String get email;
  @override
  UserGrade get grade;
  @override
  UserStatus get status;
  @override
  @JsonKey(name: 'unit_price_box')
  double? get unitPriceBox;
  @override
  @JsonKey(name: 'unit_price_bulk')
  double? get unitPriceBulk;
  @override
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt;
  @override
  @JsonKey(name: 'approved_by')
  String? get approvedBy;
  @override
  @JsonKey(name: 'rejected_reason')
  String? get rejectedReason;
  @override
  @JsonKey(name: 'last_order_at')
  DateTime? get lastOrderAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
