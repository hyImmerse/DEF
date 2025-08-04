// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryModelImpl _$$InventoryModelImplFromJson(Map<String, dynamic> json) =>
    _$InventoryModelImpl(
      id: json['id'] as String,
      location: json['location'] as String,
      productType: json['product_type'] as String,
      currentQuantity: (json['current_quantity'] as num).toInt(),
      emptyTankQuantity: (json['empty_tank_quantity'] as num).toInt(),
      updatedBy: json['updated_by'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$InventoryModelImplToJson(
        _$InventoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'product_type': instance.productType,
      'current_quantity': instance.currentQuantity,
      'empty_tank_quantity': instance.emptyTankQuantity,
      'updated_by': instance.updatedBy,
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

_$InventoryStatsImpl _$$InventoryStatsImplFromJson(Map<String, dynamic> json) =>
    _$InventoryStatsImpl(
      totalBoxQuantity: (json['totalBoxQuantity'] as num).toInt(),
      totalBulkQuantity: (json['totalBulkQuantity'] as num).toInt(),
      totalEmptyTanks: (json['totalEmptyTanks'] as num).toInt(),
      factoryBoxQuantity: (json['factoryBoxQuantity'] as num).toInt(),
      factoryBulkQuantity: (json['factoryBulkQuantity'] as num).toInt(),
      warehouseBoxQuantity: (json['warehouseBoxQuantity'] as num).toInt(),
      warehouseBulkQuantity: (json['warehouseBulkQuantity'] as num).toInt(),
      criticalStockCount: (json['criticalStockCount'] as num).toInt(),
      stockTurnoverRate: (json['stockTurnoverRate'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$InventoryStatsImplToJson(
        _$InventoryStatsImpl instance) =>
    <String, dynamic>{
      'totalBoxQuantity': instance.totalBoxQuantity,
      'totalBulkQuantity': instance.totalBulkQuantity,
      'totalEmptyTanks': instance.totalEmptyTanks,
      'factoryBoxQuantity': instance.factoryBoxQuantity,
      'factoryBulkQuantity': instance.factoryBulkQuantity,
      'warehouseBoxQuantity': instance.warehouseBoxQuantity,
      'warehouseBulkQuantity': instance.warehouseBulkQuantity,
      'criticalStockCount': instance.criticalStockCount,
      'stockTurnoverRate': instance.stockTurnoverRate,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

_$InventoryLogModelImpl _$$InventoryLogModelImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryLogModelImpl(
      id: json['id'] as String,
      inventoryId: json['inventory_id'] as String,
      changeType: json['change_type'] as String,
      changeQuantity: (json['change_quantity'] as num).toInt(),
      beforeQuantity: (json['before_quantity'] as num).toInt(),
      afterQuantity: (json['after_quantity'] as num).toInt(),
      referenceId: json['reference_id'] as String?,
      referenceType: json['reference_type'] as String?,
      memo: json['memo'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$InventoryLogModelImplToJson(
        _$InventoryLogModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inventory_id': instance.inventoryId,
      'change_type': instance.changeType,
      'change_quantity': instance.changeQuantity,
      'before_quantity': instance.beforeQuantity,
      'after_quantity': instance.afterQuantity,
      'reference_id': instance.referenceId,
      'reference_type': instance.referenceType,
      'memo': instance.memo,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
    };
