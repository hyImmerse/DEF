import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../data/models/inventory_model.dart';
import '../../data/services/inventory_service.dart';

part 'realtime_inventory_provider.g.dart';

/// 실시간 재고 현황 상태
class RealtimeInventoryState {
  final bool isLoading;
  final bool isConnected;
  final List<InventoryModel> inventories;
  final InventoryStats? stats;
  final String? error;
  final DateTime? lastUpdated;

  const RealtimeInventoryState({
    this.isLoading = false,
    this.isConnected = false,
    this.inventories = const [],
    this.stats,
    this.error,
    this.lastUpdated,
  });

  RealtimeInventoryState copyWith({
    bool? isLoading,
    bool? isConnected,
    List<InventoryModel>? inventories,
    InventoryStats? stats,
    String? error,
    DateTime? lastUpdated,
  }) {
    return RealtimeInventoryState(
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      inventories: inventories ?? this.inventories,
      stats: stats ?? this.stats,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// 실시간 재고 현황 Provider
@riverpod
class RealtimeInventory extends _$RealtimeInventory {
  late final InventoryService _service;
  late final SupabaseClient _supabase;
  RealtimeChannel? _channel;

  @override
  RealtimeInventoryState build() {
    _service = ref.watch(inventoryServiceProvider);
    _supabase = ref.watch(supabaseServiceProvider).client;
    
    // Provider가 dispose될 때 채널 정리
    ref.onDispose(_disposeRealtimeChannel);
    
    // 초기 데이터 로드 및 실시간 구독 시작
    _loadInitialData();
    _subscribeToRealtimeUpdates();
    
    return const RealtimeInventoryState();
  }

  /// 초기 데이터 로드
  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final inventories = await _service.getAllInventories();
      final stats = await _service.getInventoryStats();
      
      state = state.copyWith(
        isLoading: false,
        inventories: inventories,
        stats: stats,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Supabase Realtime 구독 시작
  void _subscribeToRealtimeUpdates() {
    try {
      _channel = _supabase
          .channel('inventory_changes')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'inventory',
            callback: _handleInventoryChange,
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public', 
            table: 'inventory_logs',
            callback: _handleInventoryLogChange,
          )
          .subscribe((status) {
        if (status == RealtimeSubscribeStatus.subscribed) {
          state = state.copyWith(isConnected: true);
        } else {
          state = state.copyWith(isConnected: false);
        }
      });
    } catch (e) {
      state = state.copyWith(
        error: '실시간 연결에 실패했습니다: ${e.toString()}',
        isConnected: false,
      );
    }
  }

  /// 재고 변경 이벤트 처리
  void _handleInventoryChange(PostgresChangePayload payload) {
    try {
      final eventType = payload.eventType;
      final newRecord = payload.newRecord;
      final oldRecord = payload.oldRecord;

      switch (eventType) {
        case PostgresChangeEvent.insert:
          if (newRecord != null) {
            final newInventory = InventoryModel.fromJson(newRecord);
            final updatedList = [...state.inventories, newInventory];
            _updateStateWithNewInventories(updatedList);
          }
          break;
          
        case PostgresChangeEvent.update:
          if (newRecord != null) {
            final updatedInventory = InventoryModel.fromJson(newRecord);
            final updatedList = state.inventories.map((inventory) {
              return inventory.id == updatedInventory.id ? updatedInventory : inventory;
            }).toList();
            _updateStateWithNewInventories(updatedList);
          }
          break;
          
        case PostgresChangeEvent.delete:
          if (oldRecord != null) {
            final deletedId = oldRecord['id'] as String;
            final updatedList = state.inventories
                .where((inventory) => inventory.id != deletedId)
                .toList();
            _updateStateWithNewInventories(updatedList);
          }
          break;
          
        default:
          break;
      }
    } catch (e) {
      // 로그만 출력하고 상태는 유지
      print('재고 변경 처리 오류: $e');
    }
  }

  /// 재고 로그 변경 이벤트 처리 (통계 업데이트용)
  void _handleInventoryLogChange(PostgresChangePayload payload) {
    // 재고 로그가 추가될 때마다 통계 재계산
    _refreshStats();
  }

  /// 새로운 재고 목록으로 상태 업데이트
  void _updateStateWithNewInventories(List<InventoryModel> inventories) async {
    try {
      // 통계도 함께 업데이트
      final stats = InventoryStats.calculate(inventories);
      
      state = state.copyWith(
        inventories: inventories,
        stats: stats,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('재고 상태 업데이트 오류: $e');
    }
  }

  /// 통계 새로고침
  Future<void> _refreshStats() async {
    try {
      final stats = await _service.getInventoryStats();
      state = state.copyWith(
        stats: stats,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('통계 새로고침 오류: $e');
    }
  }

  /// 수동 새로고침
  Future<void> refresh() async {
    await _loadInitialData();
  }

  /// 실시간 연결 재시작
  void reconnect() {
    _disposeRealtimeChannel();
    _subscribeToRealtimeUpdates();
  }

  /// 실시간 채널 정리
  void _disposeRealtimeChannel() {
    _channel?.unsubscribe();
    _channel = null;
    state = state.copyWith(isConnected: false);
  }

  /// 특정 위치의 재고 조회
  List<InventoryModel> getInventoriesByLocation(String location) {
    return state.inventories
        .where((inventory) => inventory.location == location)
        .toList();
  }

  /// 특정 제품 타입의 재고 조회
  List<InventoryModel> getInventoriesByProductType(String productType) {
    return state.inventories
        .where((inventory) => inventory.productType == productType)
        .toList();
  }

  /// 위험 수준의 재고 조회 (재고량이 임계값 이하)
  List<InventoryModel> getCriticalInventories() {
    return state.inventories.where((inventory) {
      final threshold = inventory.productType == 'box' ? 50 : 10;
      return inventory.currentQuantity <= threshold;
    }).toList();
  }
}