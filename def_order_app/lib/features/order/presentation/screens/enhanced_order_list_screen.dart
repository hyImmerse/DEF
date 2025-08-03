import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/widget_extensions.dart';
import '../../domain/entities/order_entity.dart';
import '../../data/models/order_model.dart';
import '../providers/order_list_provider.dart';
import '../widgets/order_card_widget.dart';
import '../widgets/order_filter_widget.dart';
import '../widgets/order_stats_widget.dart';
import 'order_form_screen.dart';
import 'order_detail_screen.dart';

/// 향상된 주문 목록 화면
/// 
/// Clean Architecture 패턴과 UseCase를 활용한 주문 목록 화면입니다.
/// 필터링, 검색, 무한 스크롤, 상태별 탭 등을 제공합니다.
class EnhancedOrderListScreen extends ConsumerStatefulWidget {
  const EnhancedOrderListScreen({super.key});

  @override
  ConsumerState<EnhancedOrderListScreen> createState() => _EnhancedOrderListScreenState();
}

class _EnhancedOrderListScreenState extends ConsumerState<EnhancedOrderListScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  
  bool _showStats = false;
  bool _showFilters = false;

  // 탭별 필터 상태
  final List<OrderStatus?> _tabFilters = [
    null, // 전체
    OrderStatus.pending, // 대기중
    OrderStatus.confirmed, // 확정
    OrderStatus.shipped, // 배송중
    OrderStatus.completed, // 완료
    OrderStatus.cancelled, // 취소
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabFilters.length, vsync: this);
    _scrollController.addListener(_onScroll);
    
    // 탭 변경 리스너
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// 스크롤 이벤트 처리 (무한 스크롤)
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(orderListProvider.notifier).loadNextPage();
    }
  }

  /// 탭 변경 이벤트 처리
  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    
    final selectedStatus = _tabFilters[_tabController.index];
    ref.read(orderListProvider.notifier).applyFilters(
      statusFilter: selectedStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderListState = ref.watch(orderListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 통계 섹션
          if (_showStats) _buildStatsSection(orderListState),
          
          // 필터 섹션  
          if (_showFilters) _buildFiltersSection(),
          
          // 탭 섹션
          _buildTabSection(orderListState),
          
          // 주문 목록
          Expanded(
            child: _buildOrderList(orderListState),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// 앱바 빌드
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('주문 관리'),
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      actions: [
        // 통계 토글
        IconButton(
          icon: Icon(_showStats ? Icons.bar_chart : Icons.bar_chart_outlined),
          onPressed: () => setState(() => _showStats = !_showStats),
        ),
        
        // 필터 토글
        IconButton(
          icon: Icon(_showFilters ? Icons.filter_list : Icons.filter_list_outlined),
          onPressed: () => setState(() => _showFilters = !_showFilters),
        ),
        
        // 검색
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _showSearchDialog,
        ),
        
        // 새로고침
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.read(orderListProvider.notifier).refresh(),
        ),
      ],
    );
  }

  /// 통계 섹션
  Widget _buildStatsSection(OrderListState state) {
    return Container(
      color: Colors.white,
      child: OrderStatsWidget(
        totalOrders: state.totalCount,
        totalAmount: state.totalAmount,
        totalQuantity: state.totalQuantity,
        urgentOrders: state.urgentOrdersCount,
        overdueOrders: state.overdueOrdersCount,
        statusCounts: state.statusCounts,
      ),
    );
  }

  /// 필터 섹션
  Widget _buildFiltersSection() {
    return Container(
      color: Colors.white,
      child: OrderFilterWidget(
        onFiltersChanged: (filters) {
          ref.read(orderListProvider.notifier).applyFilters(
            statusFilter: filters['status'],
            productTypeFilter: filters['productType'],
            deliveryMethodFilter: filters['deliveryMethod'],
            startDate: filters['startDate'],
            endDate: filters['endDate'],
          );
        },
        onFiltersCleared: () {
          ref.read(orderListProvider.notifier).clearFilters();
        },
      ),
    );
  }

  /// 탭 섹션
  Widget _buildTabSection(OrderListState state) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: AppTheme.primaryColor,
            tabs: [
              _buildTab('전체', state.totalCount),
              _buildTab('대기중', state.getStatusCount(OrderStatus.pending)),
              _buildTab('확정', state.getStatusCount(OrderStatus.confirmed)),
              _buildTab('배송중', state.getStatusCount(OrderStatus.shipped)),
              _buildTab('완료', state.getStatusCount(OrderStatus.completed)),
              _buildTab('취소', state.getStatusCount(OrderStatus.cancelled)),
            ],
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  /// 탭 빌드
  Widget _buildTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 주문 목록
  Widget _buildOrderList(OrderListState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.orders.isEmpty) {
      return _buildErrorWidget(state.error!);
    }

    if (state.orders.isEmpty) {
      return _buildEmptyWidget();
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(orderListProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.orders.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.orders.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final order = state.orders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OrderCardWidget(
              order: order,
              onTap: () => _navigateToOrderDetail(order),
              onStatusChanged: (status, reason) => _updateOrderStatus(
                order.id,
                status,
                reason,
              ),
              onEdit: order.canEdit ? () => _navigateToOrderEdit(order) : null,
              onCancel: order.canCancel ? () => _cancelOrder(order) : null,
            ),
          );
        },
      ),
    );
  }

  /// 에러 위젯
  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '오류가 발생했습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.read(orderListProvider.notifier).refresh(),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  /// 빈 목록 위젯
  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '주문 내역이 없습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 번째 주문을 생성해보세요',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToOrderCreate,
            icon: const Icon(Icons.add),
            label: const Text('새 주문 생성'),
          ),
        ],
      ),
    );
  }

  /// 플로팅 액션 버튼
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _navigateToOrderCreate,
      backgroundColor: AppTheme.primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  /// 검색 다이얼로그
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('주문 검색'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '주문번호, 메모 등을 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              Navigator.of(context).pop();
              ref.read(orderListProvider.notifier).search('');
            },
            child: const Text('초기화'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(orderListProvider.notifier).search(_searchController.text);
            },
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }

  /// 주문 상세로 이동
  void _navigateToOrderDetail(OrderEntity order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(orderId: order.id),
      ),
    );
  }

  /// 주문 생성으로 이동
  void _navigateToOrderCreate() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OrderFormScreen(),
      ),
    );
  }

  /// 주문 수정으로 이동
  void _navigateToOrderEdit(OrderEntity order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderFormScreen(
          orderToEdit: order,
          isEditMode: true,
        ),
      ),
    );
  }

  /// 주문 상태 업데이트
  Future<void> _updateOrderStatus(
    String orderId,
    OrderStatus status,
    String? reason,
  ) async {
    try {
      await ref.read(orderListProvider.notifier).updateOrderStatus(
        orderId: orderId,
        status: status,
        cancelledReason: reason,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('주문 상태가 변경되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 주문 취소
  Future<void> _cancelOrder(OrderEntity order) async {
    final reason = await _showCancelReasonDialog();
    if (reason == null || reason.isEmpty) return;

    try {
      await _updateOrderStatus(order.id, OrderStatus.cancelled, reason);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('주문 취소 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 취소 사유 입력 다이얼로그
  Future<String?> _showCancelReasonDialog() async {
    final controller = TextEditingController();
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('주문 취소'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('취소 사유를 입력해주세요'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '취소 사유',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}