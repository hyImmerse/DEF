import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/inventory_model.dart';

part 'inventory_service.g.dart';

/// 재고 서비스
@riverpod
InventoryService inventoryService(InventoryServiceRef ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return InventoryService(supabase.client);
}

class InventoryService {
  final SupabaseClient _supabase;

  InventoryService(this._supabase);

  /// 모든 재고 정보 조회
  Future<List<InventoryModel>> getAllInventories() async {
    try {
      final response = await _supabase
          .from('inventory')
          .select('*')
          .order('location')
          .order('product_type');

      return (response as List<dynamic>)
          .map((json) => InventoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('재고 정보 조회에 실패했습니다: $e');
    }
  }

  /// 특정 위치의 재고 정보 조회
  Future<List<InventoryModel>> getInventoriesByLocation(String location) async {
    try {
      final response = await _supabase
          .from('inventory')
          .select('*')
          .eq('location', location)
          .order('product_type');

      return (response as List<dynamic>)
          .map((json) => InventoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('위치별 재고 조회에 실패했습니다: $e');
    }
  }

  /// 특정 제품 타입의 재고 정보 조회
  Future<List<InventoryModel>> getInventoriesByProductType(String productType) async {
    try {
      final response = await _supabase
          .from('inventory')
          .select('*')
          .eq('product_type', productType)
          .order('location');

      return (response as List<dynamic>)
          .map((json) => InventoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('제품별 재고 조회에 실패했습니다: $e');
    }
  }

  /// 재고 통계 조회
  Future<InventoryStats> getInventoryStats() async {
    try {
      final inventories = await getAllInventories();
      return InventoryStats.calculate(inventories);
    } catch (e) {
      throw Exception('재고 통계 조회에 실패했습니다: $e');
    }
  }

  /// 위험 수준 재고 조회
  Future<List<InventoryModel>> getCriticalInventories() async {
    try {
      final response = await _supabase
          .from('inventory')
          .select('*')
          .or('and(product_type.eq.box,current_quantity.lte.50),and(product_type.eq.bulk,current_quantity.lte.10)')
          .order('current_quantity');

      return (response as List<dynamic>)
          .map((json) => InventoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('위험 재고 조회에 실패했습니다: $e');
    }
  }

  /// 재고 변경 로그 조회
  Future<List<InventoryLogModel>> getInventoryLogs({
    String? inventoryId,
    int limit = 50,
  }) async {
    try {
      var query = _supabase
          .from('inventory_logs')
          .select('*')
          .order('created_at', ascending: false)
          .limit(limit);

      if (inventoryId != null) {
        query = query.eq('inventory_id', inventoryId);
      }

      final response = await query;

      return (response as List<dynamic>)
          .map((json) => InventoryLogModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('재고 로그 조회에 실패했습니다: $e');
    }
  }

  /// 위치별 재고 요약 정보
  Future<List<LocationInventorySummary>> getLocationSummaries() async {
    try {
      final inventories = await getAllInventories();
      final locations = inventories.map((inv) => inv.location).toSet().toList();
      
      return locations.map((location) {
        return LocationInventorySummary.fromInventories(location, inventories);
      }).toList();
    } catch (e) {
      throw Exception('위치별 요약 조회에 실패했습니다: $e');
    }
  }

  /// 재고 수량 업데이트 (관리자 전용)
  Future<void> updateInventoryQuantity({
    required String inventoryId,
    required int newQuantity,
    required String changeType,
    String? memo,
    String? referenceId,
    String? referenceType,
  }) async {
    try {
      // 현재 재고 정보 조회
      final currentInventory = await _supabase
          .from('inventory')
          .select('current_quantity')
          .eq('id', inventoryId)
          .single();

      final beforeQuantity = currentInventory['current_quantity'] as int;
      final changeQuantity = newQuantity - beforeQuantity;

      // 재고 수량 업데이트
      await _supabase
          .from('inventory')
          .update({
            'current_quantity': newQuantity,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', inventoryId);

      // 재고 변경 로그 추가
      await _supabase
          .from('inventory_logs')
          .insert({
            'inventory_id': inventoryId,
            'change_type': changeType,
            'change_quantity': changeQuantity,
            'before_quantity': beforeQuantity,
            'after_quantity': newQuantity,
            'reference_id': referenceId,
            'reference_type': referenceType,
            'memo': memo,
            'created_by': _supabase.auth.currentUser?.id,
          });
    } catch (e) {
      throw Exception('재고 수량 업데이트에 실패했습니다: $e');
    }
  }

  /// 빈 탱크 수량 업데이트
  Future<void> updateEmptyTankQuantity({
    required String inventoryId,
    required int newEmptyTankQuantity,
    String? memo,
  }) async {
    try {
      await _supabase
          .from('inventory')
          .update({
            'empty_tank_quantity': newEmptyTankQuantity,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', inventoryId);

      // 빈 탱크 변경 로그 추가
      await _supabase
          .from('inventory_logs')
          .insert({
            'inventory_id': inventoryId,
            'change_type': 'empty_tank_update',
            'change_quantity': newEmptyTankQuantity,
            'before_quantity': 0, // 빈 탱크는 이전 수량 추적하지 않음
            'after_quantity': newEmptyTankQuantity,
            'memo': memo ?? '빈 탱크 수량 업데이트',
            'created_by': _supabase.auth.currentUser?.id,
          });
    } catch (e) {
      throw Exception('빈 탱크 수량 업데이트에 실패했습니다: $e');
    }
  }
}