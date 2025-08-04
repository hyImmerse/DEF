import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/widget_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/realtime_inventory_provider.dart';
import '../widgets/inventory_stats_card.dart';
import '../widgets/location_inventory_card.dart';
import '../widgets/critical_stock_alert.dart';
import '../widgets/realtime_connection_indicator.dart';

/// 실시간 재고 현황 대시보드
/// 
/// 40-60대 사용자를 위한 접근성 최적화:
/// - 큰 글씨와 명확한 아이콘
/// - 높은 대비 색상
/// - 단순하고 직관적인 레이아웃
/// - Supabase Realtime으로 실시간 업데이트
class RealtimeInventoryDashboard extends ConsumerStatefulWidget {
  const RealtimeInventoryDashboard({super.key});

  @override
  ConsumerState<RealtimeInventoryDashboard> createState() => 
      _RealtimeInventoryDashboardState();
}

class _RealtimeInventoryDashboardState 
    extends ConsumerState<RealtimeInventoryDashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(realtimeInventoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          children: [
            '실시간 재고 현황'.text.size(22).bold.make(),
            if (inventoryState.lastUpdated != null)
              '마지막 업데이트: ${DateFormat('MM-dd HH:mm').format(inventoryState.lastUpdated!)}'
                  .text.size(12).gray600.make(),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        actions: [
          // 실시간 연결 상태
          RealtimeConnectionIndicator(
            isConnected: inventoryState.isConnected,
            onReconnect: () {
              ref.read(realtimeInventoryProvider.notifier).reconnect();
            },
          ),
          
          // 새로고침 버튼
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: GFButton(
              onPressed: inventoryState.isLoading ? null : () {
                ref.read(realtimeInventoryProvider.notifier).refresh();
              },
              text: '',
              icon: Icon(
                Icons.refresh,
                color: inventoryState.isLoading ? Colors.grey : Colors.white,
                size: 20,
              ),
              size: 40,
              color: inventoryState.isLoading ? Colors.grey[300]! : AppTheme.primaryColor,
              shape: GFButtonShape.circle,
              type: GFButtonType.solid,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: AppTheme.primaryColor,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          tabs: const [
            Tab(text: '전체 재고'),
            Tab(text: '위치별'),
            Tab(text: '위험 재고'),
          ],
        ),
      ),
      body: inventoryState.isLoading && inventoryState.inventories.isEmpty
          ? _buildInitialLoadingView()
          : inventoryState.error != null && inventoryState.inventories.isEmpty
              ? _buildErrorView(inventoryState.error!)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(inventoryState),
                    _buildLocationTab(inventoryState),
                    _buildCriticalTab(inventoryState),
                  ],
                ),
    );
  }

  /// 초기 로딩 화면
  Widget _buildInitialLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2,
              size: 40,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          '재고 현황을 불러오는 중...'.text
              .size(18)
              .bold
              .gray700
              .makeCentered(),
          const SizedBox(height: 12),
          '잠시만 기다려주세요'.text
              .size(16)
              .gray500
              .makeCentered(),
          const SizedBox(height: 24),
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  /// 에러 화면
  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 32),
          '데이터를 불러올 수 없습니다'.text
              .size(24)
              .bold
              .color(Colors.red[700])
              .make(),
          const SizedBox(height: 12),
          error.text
              .size(16)
              .gray600
              .align(TextAlign.center)
              .make(),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: GFButton(
              onPressed: () {
                ref.read(realtimeInventoryProvider.notifier).refresh();
              },
              text: '다시 시도',
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              size: 56,
              fullWidthButton: true,
              color: Colors.red[600]!,
              shape: GFButtonShape.pills,
              icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  /// 전체 재고 탭
  Widget _buildOverviewTab(RealtimeInventoryState state) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(realtimeInventoryProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 위험 재고 알림 (있는 경우)
            if (state.stats?.criticalStockCount != null && 
                state.stats!.criticalStockCount > 0) ...[
              CriticalStockAlert(
                criticalCount: state.stats!.criticalStockCount,
                onViewDetails: () {
                  _tabController.animateTo(2); // 위험 재고 탭으로 이동
                },
              ),
              const SizedBox(height: 20),
            ],

            // 전체 통계 카드들
            '재고 현황 요약'.text.size(20).bold.make(),
            const SizedBox(height: 16),
            
            if (state.stats != null) ...[
              // 박스 재고 통계
              InventoryStatsCard(
                title: '박스 재고 (20L)',
                totalQuantity: state.stats!.totalBoxQuantity,
                factoryQuantity: state.stats!.factoryBoxQuantity,
                warehouseQuantity: state.stats!.warehouseBoxQuantity,
                unit: '박스',
                color: Colors.blue,
                icon: Icons.inventory_2,
              ),
              
              const SizedBox(height: 16),
              
              // 벌크 재고 통계
              InventoryStatsCard(
                title: '벌크 재고 (1000L)',
                totalQuantity: state.stats!.totalBulkQuantity,
                factoryQuantity: state.stats!.factoryBulkQuantity,
                warehouseQuantity: state.stats!.warehouseBulkQuantity,
                unit: '탱크',
                color: Colors.green,
                icon: Icons.storage,
              ),
              
              const SizedBox(height: 16),
              
              // 빈 탱크 통계
              _buildEmptyTankCard(state.stats!.totalEmptyTanks),
            ],
            
            const SizedBox(height: 32),
            
            // 최근 업데이트 시간
            if (state.lastUpdated != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.update, color: Colors.blue[700], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          '마지막 업데이트'.text
                              .size(16)
                              .bold
                              .color(Colors.blue[700])
                              .make(),
                          const SizedBox(height: 4),
                          DateFormat('yyyy년 MM월 dd일 HH:mm:ss')
                              .format(state.lastUpdated!)
                              .text
                              .size(14)
                              .color(Colors.blue[600])
                              .make(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 위치별 재고 탭
  Widget _buildLocationTab(RealtimeInventoryState state) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(realtimeInventoryProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            '위치별 재고 현황'.text.size(20).bold.make(),
            const SizedBox(height: 16),
            
            // 공장 재고
            LocationInventoryCard(
              locationName: '공장',
              location: 'factory',
              inventories: ref.read(realtimeInventoryProvider.notifier)
                  .getInventoriesByLocation('factory'),
              color: Colors.orange,
              icon: Icons.factory,
            ),
            
            const SizedBox(height: 16),
            
            // 창고 재고
            LocationInventoryCard(
              locationName: '창고',
              location: 'warehouse',
              inventories: ref.read(realtimeInventoryProvider.notifier)
                  .getInventoriesByLocation('warehouse'),
              color: Colors.teal,
              icon: Icons.warehouse,
            ),
          ],
        ),
      ),
    );
  }

  /// 위험 재고 탭
  Widget _buildCriticalTab(RealtimeInventoryState state) {
    final criticalInventories = ref.read(realtimeInventoryProvider.notifier)
        .getCriticalInventories();

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(realtimeInventoryProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            '위험 수준 재고'.text.size(20).bold.make(),
            const SizedBox(height: 16),
            
            if (criticalInventories.isEmpty)
              _buildNoCriticalStockView()
            else
              ...criticalInventories.map((inventory) => 
                _buildCriticalInventoryCard(inventory)),
          ],
        ),
      ),
    );
  }

  /// 빈 탱크 카드
  Widget _buildEmptyTankCard(int totalEmptyTanks) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.propane_tank,
              size: 32,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                '빈 탱크'.text.size(18).bold.make(),
                const SizedBox(height: 4),
                '회수 대기 중인 빈 탱크'.text.size(14).gray600.make(),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              NumberFormat('#,###').format(totalEmptyTanks).text
                  .size(24)
                  .bold
                  .color(Colors.grey[700])
                  .make(),
              '개'.text.size(16).gray500.make(),
            ],
          ),
        ],
      ),
    );
  }

  /// 위험 재고 없음 화면
  Widget _buildNoCriticalStockView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 40,
              color: Colors.green[600],
            ),
          ),
          const SizedBox(height: 20),
          '모든 재고가 안전 수준입니다'.text
              .size(20)
              .bold
              .color(Colors.green[700])
              .makeCentered(),
          const SizedBox(height: 8),
          '위험 수준의 재고가 없습니다'.text
              .size(16)
              .color(Colors.green[600])
              .makeCentered(),
        ],
      ),
    );
  }

  /// 위험 재고 카드
  Widget _buildCriticalInventoryCard(inventory) {
    final locationName = inventory.location == 'factory' ? '공장' : '창고';
    final productName = inventory.productType == 'box' ? '박스 (20L)' : '벌크 (1000L)';
    final threshold = inventory.productType == 'box' ? 50 : 10;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[300]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.warning,
                  size: 28,
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '$locationName - $productName'.text.size(16).bold.make(),
                    const SizedBox(height: 4),
                    '임계 수준 이하 (${threshold}개 미만)'.text
                        .size(14)
                        .color(Colors.red[600])
                        .make(),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  NumberFormat('#,###').format(inventory.currentQuantity).text
                      .size(20)
                      .bold
                      .color(Colors.red[700])
                      .make(),
                  '개'.text.size(14).gray500.make(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}