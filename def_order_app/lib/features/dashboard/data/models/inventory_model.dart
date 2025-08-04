import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_model.freezed.dart';
part 'inventory_model.g.dart';

/// 재고 모델
@freezed
class InventoryModel with _$InventoryModel {
  const factory InventoryModel({
    required String id,
    required String location,
    @JsonKey(name: 'product_type') required String productType,
    @JsonKey(name: 'current_quantity') required int currentQuantity,
    @JsonKey(name: 'empty_tank_quantity') required int emptyTankQuantity,
    @JsonKey(name: 'updated_by') required String updatedBy,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _InventoryModel;

  factory InventoryModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelFromJson(json);
}

/// 재고 통계
@freezed
class InventoryStats with _$InventoryStats {
  const factory InventoryStats({
    required int totalBoxQuantity,
    required int totalBulkQuantity,
    required int totalEmptyTanks,
    required int factoryBoxQuantity,
    required int factoryBulkQuantity,
    required int warehouseBoxQuantity,
    required int warehouseBulkQuantity,
    required int criticalStockCount,
    required double stockTurnoverRate,
    required DateTime lastUpdated,
  }) = _InventoryStats;

  factory InventoryStats.fromJson(Map<String, dynamic> json) =>
      _$InventoryStatsFromJson(json);

  /// 재고 목록으로부터 통계 계산
  factory InventoryStats.calculate(List<InventoryModel> inventories) {
    var totalBoxQuantity = 0;
    var totalBulkQuantity = 0;
    var totalEmptyTanks = 0;
    var factoryBoxQuantity = 0;
    var factoryBulkQuantity = 0;
    var warehouseBoxQuantity = 0;
    var warehouseBulkQuantity = 0;
    var criticalStockCount = 0;

    for (final inventory in inventories) {
      // 제품 타입별 총 재고량
      if (inventory.productType == 'box') {
        totalBoxQuantity += inventory.currentQuantity;
        
        if (inventory.location == 'factory') {
          factoryBoxQuantity += inventory.currentQuantity;
        } else if (inventory.location == 'warehouse') {
          warehouseBoxQuantity += inventory.currentQuantity;
        }
        
        // 박스 재고 임계점: 50개 이하
        if (inventory.currentQuantity <= 50) {
          criticalStockCount++;
        }
      } else if (inventory.productType == 'bulk') {
        totalBulkQuantity += inventory.currentQuantity;
        
        if (inventory.location == 'factory') {
          factoryBulkQuantity += inventory.currentQuantity;
        } else if (inventory.location == 'warehouse') {
          warehouseBulkQuantity += inventory.currentQuantity;
        }
        
        // 벌크 재고 임계점: 10개 이하
        if (inventory.currentQuantity <= 10) {
          criticalStockCount++;
        }
      }

      totalEmptyTanks += inventory.emptyTankQuantity;
    }

    // 재고 회전율 (임시 계산값)
    final stockTurnoverRate = 0.75; // 실제로는 판매량/평균재고량으로 계산

    return InventoryStats(
      totalBoxQuantity: totalBoxQuantity,
      totalBulkQuantity: totalBulkQuantity,
      totalEmptyTanks: totalEmptyTanks,
      factoryBoxQuantity: factoryBoxQuantity,
      factoryBulkQuantity: factoryBulkQuantity,
      warehouseBoxQuantity: warehouseBoxQuantity,
      warehouseBulkQuantity: warehouseBulkQuantity,
      criticalStockCount: criticalStockCount,
      stockTurnoverRate: stockTurnoverRate,
      lastUpdated: DateTime.now(),
    );
  }
}

/// 재고 변경 로그
@freezed
class InventoryLogModel with _$InventoryLogModel {
  const factory InventoryLogModel({
    required String id,
    @JsonKey(name: 'inventory_id') required String inventoryId,
    @JsonKey(name: 'change_type') required String changeType,
    @JsonKey(name: 'change_quantity') required int changeQuantity,
    @JsonKey(name: 'before_quantity') required int beforeQuantity,
    @JsonKey(name: 'after_quantity') required int afterQuantity,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'reference_type') String? referenceType,
    String? memo,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _InventoryLogModel;

  factory InventoryLogModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryLogModelFromJson(json);
}

/// 재고 위치별 요약
@freezed
class LocationInventorySummary with _$LocationInventorySummary {
  const factory LocationInventorySummary({
    required String location,
    required String locationName,
    required int boxQuantity,
    required int bulkQuantity,
    required int emptyTankQuantity,
    required int totalItems,
    required bool hasCriticalStock,
  }) = _LocationInventorySummary;

  factory LocationInventorySummary.fromInventories(
    String location,
    List<InventoryModel> inventories,
  ) {
    final locationInventories = inventories
        .where((inv) => inv.location == location)
        .toList();
    
    var boxQuantity = 0;
    var bulkQuantity = 0;
    var emptyTankQuantity = 0;
    var hasCriticalStock = false;

    for (final inventory in locationInventories) {
      if (inventory.productType == 'box') {
        boxQuantity += inventory.currentQuantity;
        if (inventory.currentQuantity <= 50) hasCriticalStock = true;
      } else if (inventory.productType == 'bulk') {
        bulkQuantity += inventory.currentQuantity;
        if (inventory.currentQuantity <= 10) hasCriticalStock = true;
      }
      emptyTankQuantity += inventory.emptyTankQuantity;
    }

    final locationName = location == 'factory' ? '공장' : '창고';

    return LocationInventorySummary(
      location: location,
      locationName: locationName,
      boxQuantity: boxQuantity,
      bulkQuantity: bulkQuantity,
      emptyTankQuantity: emptyTankQuantity,
      totalItems: locationInventories.length,
      hasCriticalStock: hasCriticalStock,
    );
  }
}