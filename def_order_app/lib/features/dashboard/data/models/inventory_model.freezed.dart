// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InventoryModel _$InventoryModelFromJson(Map<String, dynamic> json) {
  return _InventoryModel.fromJson(json);
}

/// @nodoc
mixin _$InventoryModel {
  String get id => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_type')
  String get productType => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_quantity')
  int get currentQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'empty_tank_quantity')
  int get emptyTankQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_by')
  String get updatedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InventoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryModelCopyWith<InventoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryModelCopyWith<$Res> {
  factory $InventoryModelCopyWith(
    InventoryModel value,
    $Res Function(InventoryModel) then,
  ) = _$InventoryModelCopyWithImpl<$Res, InventoryModel>;
  @useResult
  $Res call({
    String id,
    String location,
    @JsonKey(name: 'product_type') String productType,
    @JsonKey(name: 'current_quantity') int currentQuantity,
    @JsonKey(name: 'empty_tank_quantity') int emptyTankQuantity,
    @JsonKey(name: 'updated_by') String updatedBy,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$InventoryModelCopyWithImpl<$Res, $Val extends InventoryModel>
    implements $InventoryModelCopyWith<$Res> {
  _$InventoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? location = null,
    Object? productType = null,
    Object? currentQuantity = null,
    Object? emptyTankQuantity = null,
    Object? updatedBy = null,
    Object? updatedAt = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            productType: null == productType
                ? _value.productType
                : productType // ignore: cast_nullable_to_non_nullable
                      as String,
            currentQuantity: null == currentQuantity
                ? _value.currentQuantity
                : currentQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            emptyTankQuantity: null == emptyTankQuantity
                ? _value.emptyTankQuantity
                : emptyTankQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            updatedBy: null == updatedBy
                ? _value.updatedBy
                : updatedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryModelImplCopyWith<$Res>
    implements $InventoryModelCopyWith<$Res> {
  factory _$$InventoryModelImplCopyWith(
    _$InventoryModelImpl value,
    $Res Function(_$InventoryModelImpl) then,
  ) = __$$InventoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String location,
    @JsonKey(name: 'product_type') String productType,
    @JsonKey(name: 'current_quantity') int currentQuantity,
    @JsonKey(name: 'empty_tank_quantity') int emptyTankQuantity,
    @JsonKey(name: 'updated_by') String updatedBy,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$InventoryModelImplCopyWithImpl<$Res>
    extends _$InventoryModelCopyWithImpl<$Res, _$InventoryModelImpl>
    implements _$$InventoryModelImplCopyWith<$Res> {
  __$$InventoryModelImplCopyWithImpl(
    _$InventoryModelImpl _value,
    $Res Function(_$InventoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? location = null,
    Object? productType = null,
    Object? currentQuantity = null,
    Object? emptyTankQuantity = null,
    Object? updatedBy = null,
    Object? updatedAt = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$InventoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        productType: null == productType
            ? _value.productType
            : productType // ignore: cast_nullable_to_non_nullable
                  as String,
        currentQuantity: null == currentQuantity
            ? _value.currentQuantity
            : currentQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        emptyTankQuantity: null == emptyTankQuantity
            ? _value.emptyTankQuantity
            : emptyTankQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        updatedBy: null == updatedBy
            ? _value.updatedBy
            : updatedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryModelImpl implements _InventoryModel {
  const _$InventoryModelImpl({
    required this.id,
    required this.location,
    @JsonKey(name: 'product_type') required this.productType,
    @JsonKey(name: 'current_quantity') required this.currentQuantity,
    @JsonKey(name: 'empty_tank_quantity') required this.emptyTankQuantity,
    @JsonKey(name: 'updated_by') required this.updatedBy,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$InventoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String location;
  @override
  @JsonKey(name: 'product_type')
  final String productType;
  @override
  @JsonKey(name: 'current_quantity')
  final int currentQuantity;
  @override
  @JsonKey(name: 'empty_tank_quantity')
  final int emptyTankQuantity;
  @override
  @JsonKey(name: 'updated_by')
  final String updatedBy;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'InventoryModel(id: $id, location: $location, productType: $productType, currentQuantity: $currentQuantity, emptyTankQuantity: $emptyTankQuantity, updatedBy: $updatedBy, updatedAt: $updatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.currentQuantity, currentQuantity) ||
                other.currentQuantity == currentQuantity) &&
            (identical(other.emptyTankQuantity, emptyTankQuantity) ||
                other.emptyTankQuantity == emptyTankQuantity) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    location,
    productType,
    currentQuantity,
    emptyTankQuantity,
    updatedBy,
    updatedAt,
    createdAt,
  );

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryModelImplCopyWith<_$InventoryModelImpl> get copyWith =>
      __$$InventoryModelImplCopyWithImpl<_$InventoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryModelImplToJson(this);
  }
}

abstract class _InventoryModel implements InventoryModel {
  const factory _InventoryModel({
    required final String id,
    required final String location,
    @JsonKey(name: 'product_type') required final String productType,
    @JsonKey(name: 'current_quantity') required final int currentQuantity,
    @JsonKey(name: 'empty_tank_quantity') required final int emptyTankQuantity,
    @JsonKey(name: 'updated_by') required final String updatedBy,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$InventoryModelImpl;

  factory _InventoryModel.fromJson(Map<String, dynamic> json) =
      _$InventoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get location;
  @override
  @JsonKey(name: 'product_type')
  String get productType;
  @override
  @JsonKey(name: 'current_quantity')
  int get currentQuantity;
  @override
  @JsonKey(name: 'empty_tank_quantity')
  int get emptyTankQuantity;
  @override
  @JsonKey(name: 'updated_by')
  String get updatedBy;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryModelImplCopyWith<_$InventoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryStats _$InventoryStatsFromJson(Map<String, dynamic> json) {
  return _InventoryStats.fromJson(json);
}

/// @nodoc
mixin _$InventoryStats {
  int get totalBoxQuantity => throw _privateConstructorUsedError;
  int get totalBulkQuantity => throw _privateConstructorUsedError;
  int get totalEmptyTanks => throw _privateConstructorUsedError;
  int get factoryBoxQuantity => throw _privateConstructorUsedError;
  int get factoryBulkQuantity => throw _privateConstructorUsedError;
  int get warehouseBoxQuantity => throw _privateConstructorUsedError;
  int get warehouseBulkQuantity => throw _privateConstructorUsedError;
  int get criticalStockCount => throw _privateConstructorUsedError;
  double get stockTurnoverRate => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this InventoryStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryStatsCopyWith<InventoryStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryStatsCopyWith<$Res> {
  factory $InventoryStatsCopyWith(
    InventoryStats value,
    $Res Function(InventoryStats) then,
  ) = _$InventoryStatsCopyWithImpl<$Res, InventoryStats>;
  @useResult
  $Res call({
    int totalBoxQuantity,
    int totalBulkQuantity,
    int totalEmptyTanks,
    int factoryBoxQuantity,
    int factoryBulkQuantity,
    int warehouseBoxQuantity,
    int warehouseBulkQuantity,
    int criticalStockCount,
    double stockTurnoverRate,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$InventoryStatsCopyWithImpl<$Res, $Val extends InventoryStats>
    implements $InventoryStatsCopyWith<$Res> {
  _$InventoryStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBoxQuantity = null,
    Object? totalBulkQuantity = null,
    Object? totalEmptyTanks = null,
    Object? factoryBoxQuantity = null,
    Object? factoryBulkQuantity = null,
    Object? warehouseBoxQuantity = null,
    Object? warehouseBulkQuantity = null,
    Object? criticalStockCount = null,
    Object? stockTurnoverRate = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            totalBoxQuantity: null == totalBoxQuantity
                ? _value.totalBoxQuantity
                : totalBoxQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            totalBulkQuantity: null == totalBulkQuantity
                ? _value.totalBulkQuantity
                : totalBulkQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            totalEmptyTanks: null == totalEmptyTanks
                ? _value.totalEmptyTanks
                : totalEmptyTanks // ignore: cast_nullable_to_non_nullable
                      as int,
            factoryBoxQuantity: null == factoryBoxQuantity
                ? _value.factoryBoxQuantity
                : factoryBoxQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            factoryBulkQuantity: null == factoryBulkQuantity
                ? _value.factoryBulkQuantity
                : factoryBulkQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            warehouseBoxQuantity: null == warehouseBoxQuantity
                ? _value.warehouseBoxQuantity
                : warehouseBoxQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            warehouseBulkQuantity: null == warehouseBulkQuantity
                ? _value.warehouseBulkQuantity
                : warehouseBulkQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            criticalStockCount: null == criticalStockCount
                ? _value.criticalStockCount
                : criticalStockCount // ignore: cast_nullable_to_non_nullable
                      as int,
            stockTurnoverRate: null == stockTurnoverRate
                ? _value.stockTurnoverRate
                : stockTurnoverRate // ignore: cast_nullable_to_non_nullable
                      as double,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryStatsImplCopyWith<$Res>
    implements $InventoryStatsCopyWith<$Res> {
  factory _$$InventoryStatsImplCopyWith(
    _$InventoryStatsImpl value,
    $Res Function(_$InventoryStatsImpl) then,
  ) = __$$InventoryStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalBoxQuantity,
    int totalBulkQuantity,
    int totalEmptyTanks,
    int factoryBoxQuantity,
    int factoryBulkQuantity,
    int warehouseBoxQuantity,
    int warehouseBulkQuantity,
    int criticalStockCount,
    double stockTurnoverRate,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$InventoryStatsImplCopyWithImpl<$Res>
    extends _$InventoryStatsCopyWithImpl<$Res, _$InventoryStatsImpl>
    implements _$$InventoryStatsImplCopyWith<$Res> {
  __$$InventoryStatsImplCopyWithImpl(
    _$InventoryStatsImpl _value,
    $Res Function(_$InventoryStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBoxQuantity = null,
    Object? totalBulkQuantity = null,
    Object? totalEmptyTanks = null,
    Object? factoryBoxQuantity = null,
    Object? factoryBulkQuantity = null,
    Object? warehouseBoxQuantity = null,
    Object? warehouseBulkQuantity = null,
    Object? criticalStockCount = null,
    Object? stockTurnoverRate = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$InventoryStatsImpl(
        totalBoxQuantity: null == totalBoxQuantity
            ? _value.totalBoxQuantity
            : totalBoxQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        totalBulkQuantity: null == totalBulkQuantity
            ? _value.totalBulkQuantity
            : totalBulkQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        totalEmptyTanks: null == totalEmptyTanks
            ? _value.totalEmptyTanks
            : totalEmptyTanks // ignore: cast_nullable_to_non_nullable
                  as int,
        factoryBoxQuantity: null == factoryBoxQuantity
            ? _value.factoryBoxQuantity
            : factoryBoxQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        factoryBulkQuantity: null == factoryBulkQuantity
            ? _value.factoryBulkQuantity
            : factoryBulkQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        warehouseBoxQuantity: null == warehouseBoxQuantity
            ? _value.warehouseBoxQuantity
            : warehouseBoxQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        warehouseBulkQuantity: null == warehouseBulkQuantity
            ? _value.warehouseBulkQuantity
            : warehouseBulkQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        criticalStockCount: null == criticalStockCount
            ? _value.criticalStockCount
            : criticalStockCount // ignore: cast_nullable_to_non_nullable
                  as int,
        stockTurnoverRate: null == stockTurnoverRate
            ? _value.stockTurnoverRate
            : stockTurnoverRate // ignore: cast_nullable_to_non_nullable
                  as double,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryStatsImpl implements _InventoryStats {
  const _$InventoryStatsImpl({
    required this.totalBoxQuantity,
    required this.totalBulkQuantity,
    required this.totalEmptyTanks,
    required this.factoryBoxQuantity,
    required this.factoryBulkQuantity,
    required this.warehouseBoxQuantity,
    required this.warehouseBulkQuantity,
    required this.criticalStockCount,
    required this.stockTurnoverRate,
    required this.lastUpdated,
  });

  factory _$InventoryStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryStatsImplFromJson(json);

  @override
  final int totalBoxQuantity;
  @override
  final int totalBulkQuantity;
  @override
  final int totalEmptyTanks;
  @override
  final int factoryBoxQuantity;
  @override
  final int factoryBulkQuantity;
  @override
  final int warehouseBoxQuantity;
  @override
  final int warehouseBulkQuantity;
  @override
  final int criticalStockCount;
  @override
  final double stockTurnoverRate;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'InventoryStats(totalBoxQuantity: $totalBoxQuantity, totalBulkQuantity: $totalBulkQuantity, totalEmptyTanks: $totalEmptyTanks, factoryBoxQuantity: $factoryBoxQuantity, factoryBulkQuantity: $factoryBulkQuantity, warehouseBoxQuantity: $warehouseBoxQuantity, warehouseBulkQuantity: $warehouseBulkQuantity, criticalStockCount: $criticalStockCount, stockTurnoverRate: $stockTurnoverRate, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryStatsImpl &&
            (identical(other.totalBoxQuantity, totalBoxQuantity) ||
                other.totalBoxQuantity == totalBoxQuantity) &&
            (identical(other.totalBulkQuantity, totalBulkQuantity) ||
                other.totalBulkQuantity == totalBulkQuantity) &&
            (identical(other.totalEmptyTanks, totalEmptyTanks) ||
                other.totalEmptyTanks == totalEmptyTanks) &&
            (identical(other.factoryBoxQuantity, factoryBoxQuantity) ||
                other.factoryBoxQuantity == factoryBoxQuantity) &&
            (identical(other.factoryBulkQuantity, factoryBulkQuantity) ||
                other.factoryBulkQuantity == factoryBulkQuantity) &&
            (identical(other.warehouseBoxQuantity, warehouseBoxQuantity) ||
                other.warehouseBoxQuantity == warehouseBoxQuantity) &&
            (identical(other.warehouseBulkQuantity, warehouseBulkQuantity) ||
                other.warehouseBulkQuantity == warehouseBulkQuantity) &&
            (identical(other.criticalStockCount, criticalStockCount) ||
                other.criticalStockCount == criticalStockCount) &&
            (identical(other.stockTurnoverRate, stockTurnoverRate) ||
                other.stockTurnoverRate == stockTurnoverRate) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalBoxQuantity,
    totalBulkQuantity,
    totalEmptyTanks,
    factoryBoxQuantity,
    factoryBulkQuantity,
    warehouseBoxQuantity,
    warehouseBulkQuantity,
    criticalStockCount,
    stockTurnoverRate,
    lastUpdated,
  );

  /// Create a copy of InventoryStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryStatsImplCopyWith<_$InventoryStatsImpl> get copyWith =>
      __$$InventoryStatsImplCopyWithImpl<_$InventoryStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryStatsImplToJson(this);
  }
}

abstract class _InventoryStats implements InventoryStats {
  const factory _InventoryStats({
    required final int totalBoxQuantity,
    required final int totalBulkQuantity,
    required final int totalEmptyTanks,
    required final int factoryBoxQuantity,
    required final int factoryBulkQuantity,
    required final int warehouseBoxQuantity,
    required final int warehouseBulkQuantity,
    required final int criticalStockCount,
    required final double stockTurnoverRate,
    required final DateTime lastUpdated,
  }) = _$InventoryStatsImpl;

  factory _InventoryStats.fromJson(Map<String, dynamic> json) =
      _$InventoryStatsImpl.fromJson;

  @override
  int get totalBoxQuantity;
  @override
  int get totalBulkQuantity;
  @override
  int get totalEmptyTanks;
  @override
  int get factoryBoxQuantity;
  @override
  int get factoryBulkQuantity;
  @override
  int get warehouseBoxQuantity;
  @override
  int get warehouseBulkQuantity;
  @override
  int get criticalStockCount;
  @override
  double get stockTurnoverRate;
  @override
  DateTime get lastUpdated;

  /// Create a copy of InventoryStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryStatsImplCopyWith<_$InventoryStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryLogModel _$InventoryLogModelFromJson(Map<String, dynamic> json) {
  return _InventoryLogModel.fromJson(json);
}

/// @nodoc
mixin _$InventoryLogModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_id')
  String get inventoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'change_type')
  String get changeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'change_quantity')
  int get changeQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'before_quantity')
  int get beforeQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'after_quantity')
  int get afterQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_id')
  String? get referenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_type')
  String? get referenceType => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InventoryLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryLogModelCopyWith<InventoryLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryLogModelCopyWith<$Res> {
  factory $InventoryLogModelCopyWith(
    InventoryLogModel value,
    $Res Function(InventoryLogModel) then,
  ) = _$InventoryLogModelCopyWithImpl<$Res, InventoryLogModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'inventory_id') String inventoryId,
    @JsonKey(name: 'change_type') String changeType,
    @JsonKey(name: 'change_quantity') int changeQuantity,
    @JsonKey(name: 'before_quantity') int beforeQuantity,
    @JsonKey(name: 'after_quantity') int afterQuantity,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'reference_type') String? referenceType,
    String? memo,
    @JsonKey(name: 'created_by') String createdBy,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$InventoryLogModelCopyWithImpl<$Res, $Val extends InventoryLogModel>
    implements $InventoryLogModelCopyWith<$Res> {
  _$InventoryLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryId = null,
    Object? changeType = null,
    Object? changeQuantity = null,
    Object? beforeQuantity = null,
    Object? afterQuantity = null,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
    Object? memo = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            inventoryId: null == inventoryId
                ? _value.inventoryId
                : inventoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            changeType: null == changeType
                ? _value.changeType
                : changeType // ignore: cast_nullable_to_non_nullable
                      as String,
            changeQuantity: null == changeQuantity
                ? _value.changeQuantity
                : changeQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            beforeQuantity: null == beforeQuantity
                ? _value.beforeQuantity
                : beforeQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            afterQuantity: null == afterQuantity
                ? _value.afterQuantity
                : afterQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            referenceId: freezed == referenceId
                ? _value.referenceId
                : referenceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceType: freezed == referenceType
                ? _value.referenceType
                : referenceType // ignore: cast_nullable_to_non_nullable
                      as String?,
            memo: freezed == memo
                ? _value.memo
                : memo // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryLogModelImplCopyWith<$Res>
    implements $InventoryLogModelCopyWith<$Res> {
  factory _$$InventoryLogModelImplCopyWith(
    _$InventoryLogModelImpl value,
    $Res Function(_$InventoryLogModelImpl) then,
  ) = __$$InventoryLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'inventory_id') String inventoryId,
    @JsonKey(name: 'change_type') String changeType,
    @JsonKey(name: 'change_quantity') int changeQuantity,
    @JsonKey(name: 'before_quantity') int beforeQuantity,
    @JsonKey(name: 'after_quantity') int afterQuantity,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'reference_type') String? referenceType,
    String? memo,
    @JsonKey(name: 'created_by') String createdBy,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$InventoryLogModelImplCopyWithImpl<$Res>
    extends _$InventoryLogModelCopyWithImpl<$Res, _$InventoryLogModelImpl>
    implements _$$InventoryLogModelImplCopyWith<$Res> {
  __$$InventoryLogModelImplCopyWithImpl(
    _$InventoryLogModelImpl _value,
    $Res Function(_$InventoryLogModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryId = null,
    Object? changeType = null,
    Object? changeQuantity = null,
    Object? beforeQuantity = null,
    Object? afterQuantity = null,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
    Object? memo = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$InventoryLogModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        inventoryId: null == inventoryId
            ? _value.inventoryId
            : inventoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        changeType: null == changeType
            ? _value.changeType
            : changeType // ignore: cast_nullable_to_non_nullable
                  as String,
        changeQuantity: null == changeQuantity
            ? _value.changeQuantity
            : changeQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        beforeQuantity: null == beforeQuantity
            ? _value.beforeQuantity
            : beforeQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        afterQuantity: null == afterQuantity
            ? _value.afterQuantity
            : afterQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        referenceId: freezed == referenceId
            ? _value.referenceId
            : referenceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceType: freezed == referenceType
            ? _value.referenceType
            : referenceType // ignore: cast_nullable_to_non_nullable
                  as String?,
        memo: freezed == memo
            ? _value.memo
            : memo // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryLogModelImpl implements _InventoryLogModel {
  const _$InventoryLogModelImpl({
    required this.id,
    @JsonKey(name: 'inventory_id') required this.inventoryId,
    @JsonKey(name: 'change_type') required this.changeType,
    @JsonKey(name: 'change_quantity') required this.changeQuantity,
    @JsonKey(name: 'before_quantity') required this.beforeQuantity,
    @JsonKey(name: 'after_quantity') required this.afterQuantity,
    @JsonKey(name: 'reference_id') this.referenceId,
    @JsonKey(name: 'reference_type') this.referenceType,
    this.memo,
    @JsonKey(name: 'created_by') required this.createdBy,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$InventoryLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryLogModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'inventory_id')
  final String inventoryId;
  @override
  @JsonKey(name: 'change_type')
  final String changeType;
  @override
  @JsonKey(name: 'change_quantity')
  final int changeQuantity;
  @override
  @JsonKey(name: 'before_quantity')
  final int beforeQuantity;
  @override
  @JsonKey(name: 'after_quantity')
  final int afterQuantity;
  @override
  @JsonKey(name: 'reference_id')
  final String? referenceId;
  @override
  @JsonKey(name: 'reference_type')
  final String? referenceType;
  @override
  final String? memo;
  @override
  @JsonKey(name: 'created_by')
  final String createdBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'InventoryLogModel(id: $id, inventoryId: $inventoryId, changeType: $changeType, changeQuantity: $changeQuantity, beforeQuantity: $beforeQuantity, afterQuantity: $afterQuantity, referenceId: $referenceId, referenceType: $referenceType, memo: $memo, createdBy: $createdBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.changeType, changeType) ||
                other.changeType == changeType) &&
            (identical(other.changeQuantity, changeQuantity) ||
                other.changeQuantity == changeQuantity) &&
            (identical(other.beforeQuantity, beforeQuantity) ||
                other.beforeQuantity == beforeQuantity) &&
            (identical(other.afterQuantity, afterQuantity) ||
                other.afterQuantity == afterQuantity) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    inventoryId,
    changeType,
    changeQuantity,
    beforeQuantity,
    afterQuantity,
    referenceId,
    referenceType,
    memo,
    createdBy,
    createdAt,
  );

  /// Create a copy of InventoryLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryLogModelImplCopyWith<_$InventoryLogModelImpl> get copyWith =>
      __$$InventoryLogModelImplCopyWithImpl<_$InventoryLogModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryLogModelImplToJson(this);
  }
}

abstract class _InventoryLogModel implements InventoryLogModel {
  const factory _InventoryLogModel({
    required final String id,
    @JsonKey(name: 'inventory_id') required final String inventoryId,
    @JsonKey(name: 'change_type') required final String changeType,
    @JsonKey(name: 'change_quantity') required final int changeQuantity,
    @JsonKey(name: 'before_quantity') required final int beforeQuantity,
    @JsonKey(name: 'after_quantity') required final int afterQuantity,
    @JsonKey(name: 'reference_id') final String? referenceId,
    @JsonKey(name: 'reference_type') final String? referenceType,
    final String? memo,
    @JsonKey(name: 'created_by') required final String createdBy,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$InventoryLogModelImpl;

  factory _InventoryLogModel.fromJson(Map<String, dynamic> json) =
      _$InventoryLogModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'inventory_id')
  String get inventoryId;
  @override
  @JsonKey(name: 'change_type')
  String get changeType;
  @override
  @JsonKey(name: 'change_quantity')
  int get changeQuantity;
  @override
  @JsonKey(name: 'before_quantity')
  int get beforeQuantity;
  @override
  @JsonKey(name: 'after_quantity')
  int get afterQuantity;
  @override
  @JsonKey(name: 'reference_id')
  String? get referenceId;
  @override
  @JsonKey(name: 'reference_type')
  String? get referenceType;
  @override
  String? get memo;
  @override
  @JsonKey(name: 'created_by')
  String get createdBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of InventoryLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryLogModelImplCopyWith<_$InventoryLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LocationInventorySummary {
  String get location => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  int get boxQuantity => throw _privateConstructorUsedError;
  int get bulkQuantity => throw _privateConstructorUsedError;
  int get emptyTankQuantity => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  bool get hasCriticalStock => throw _privateConstructorUsedError;

  /// Create a copy of LocationInventorySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationInventorySummaryCopyWith<LocationInventorySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationInventorySummaryCopyWith<$Res> {
  factory $LocationInventorySummaryCopyWith(
    LocationInventorySummary value,
    $Res Function(LocationInventorySummary) then,
  ) = _$LocationInventorySummaryCopyWithImpl<$Res, LocationInventorySummary>;
  @useResult
  $Res call({
    String location,
    String locationName,
    int boxQuantity,
    int bulkQuantity,
    int emptyTankQuantity,
    int totalItems,
    bool hasCriticalStock,
  });
}

/// @nodoc
class _$LocationInventorySummaryCopyWithImpl<
  $Res,
  $Val extends LocationInventorySummary
>
    implements $LocationInventorySummaryCopyWith<$Res> {
  _$LocationInventorySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationInventorySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? locationName = null,
    Object? boxQuantity = null,
    Object? bulkQuantity = null,
    Object? emptyTankQuantity = null,
    Object? totalItems = null,
    Object? hasCriticalStock = null,
  }) {
    return _then(
      _value.copyWith(
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            locationName: null == locationName
                ? _value.locationName
                : locationName // ignore: cast_nullable_to_non_nullable
                      as String,
            boxQuantity: null == boxQuantity
                ? _value.boxQuantity
                : boxQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            bulkQuantity: null == bulkQuantity
                ? _value.bulkQuantity
                : bulkQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            emptyTankQuantity: null == emptyTankQuantity
                ? _value.emptyTankQuantity
                : emptyTankQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            totalItems: null == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                      as int,
            hasCriticalStock: null == hasCriticalStock
                ? _value.hasCriticalStock
                : hasCriticalStock // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationInventorySummaryImplCopyWith<$Res>
    implements $LocationInventorySummaryCopyWith<$Res> {
  factory _$$LocationInventorySummaryImplCopyWith(
    _$LocationInventorySummaryImpl value,
    $Res Function(_$LocationInventorySummaryImpl) then,
  ) = __$$LocationInventorySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String location,
    String locationName,
    int boxQuantity,
    int bulkQuantity,
    int emptyTankQuantity,
    int totalItems,
    bool hasCriticalStock,
  });
}

/// @nodoc
class __$$LocationInventorySummaryImplCopyWithImpl<$Res>
    extends
        _$LocationInventorySummaryCopyWithImpl<
          $Res,
          _$LocationInventorySummaryImpl
        >
    implements _$$LocationInventorySummaryImplCopyWith<$Res> {
  __$$LocationInventorySummaryImplCopyWithImpl(
    _$LocationInventorySummaryImpl _value,
    $Res Function(_$LocationInventorySummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationInventorySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? locationName = null,
    Object? boxQuantity = null,
    Object? bulkQuantity = null,
    Object? emptyTankQuantity = null,
    Object? totalItems = null,
    Object? hasCriticalStock = null,
  }) {
    return _then(
      _$LocationInventorySummaryImpl(
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        locationName: null == locationName
            ? _value.locationName
            : locationName // ignore: cast_nullable_to_non_nullable
                  as String,
        boxQuantity: null == boxQuantity
            ? _value.boxQuantity
            : boxQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        bulkQuantity: null == bulkQuantity
            ? _value.bulkQuantity
            : bulkQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        emptyTankQuantity: null == emptyTankQuantity
            ? _value.emptyTankQuantity
            : emptyTankQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        totalItems: null == totalItems
            ? _value.totalItems
            : totalItems // ignore: cast_nullable_to_non_nullable
                  as int,
        hasCriticalStock: null == hasCriticalStock
            ? _value.hasCriticalStock
            : hasCriticalStock // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$LocationInventorySummaryImpl implements _LocationInventorySummary {
  const _$LocationInventorySummaryImpl({
    required this.location,
    required this.locationName,
    required this.boxQuantity,
    required this.bulkQuantity,
    required this.emptyTankQuantity,
    required this.totalItems,
    required this.hasCriticalStock,
  });

  @override
  final String location;
  @override
  final String locationName;
  @override
  final int boxQuantity;
  @override
  final int bulkQuantity;
  @override
  final int emptyTankQuantity;
  @override
  final int totalItems;
  @override
  final bool hasCriticalStock;

  @override
  String toString() {
    return 'LocationInventorySummary(location: $location, locationName: $locationName, boxQuantity: $boxQuantity, bulkQuantity: $bulkQuantity, emptyTankQuantity: $emptyTankQuantity, totalItems: $totalItems, hasCriticalStock: $hasCriticalStock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationInventorySummaryImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.boxQuantity, boxQuantity) ||
                other.boxQuantity == boxQuantity) &&
            (identical(other.bulkQuantity, bulkQuantity) ||
                other.bulkQuantity == bulkQuantity) &&
            (identical(other.emptyTankQuantity, emptyTankQuantity) ||
                other.emptyTankQuantity == emptyTankQuantity) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.hasCriticalStock, hasCriticalStock) ||
                other.hasCriticalStock == hasCriticalStock));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    location,
    locationName,
    boxQuantity,
    bulkQuantity,
    emptyTankQuantity,
    totalItems,
    hasCriticalStock,
  );

  /// Create a copy of LocationInventorySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationInventorySummaryImplCopyWith<_$LocationInventorySummaryImpl>
  get copyWith =>
      __$$LocationInventorySummaryImplCopyWithImpl<
        _$LocationInventorySummaryImpl
      >(this, _$identity);
}

abstract class _LocationInventorySummary implements LocationInventorySummary {
  const factory _LocationInventorySummary({
    required final String location,
    required final String locationName,
    required final int boxQuantity,
    required final int bulkQuantity,
    required final int emptyTankQuantity,
    required final int totalItems,
    required final bool hasCriticalStock,
  }) = _$LocationInventorySummaryImpl;

  @override
  String get location;
  @override
  String get locationName;
  @override
  int get boxQuantity;
  @override
  int get bulkQuantity;
  @override
  int get emptyTankQuantity;
  @override
  int get totalItems;
  @override
  bool get hasCriticalStock;

  /// Create a copy of LocationInventorySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationInventorySummaryImplCopyWith<_$LocationInventorySummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
