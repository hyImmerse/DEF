import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/order_model.dart';
import '../providers/order_provider.dart';
import '../widgets/order_filter_widget.dart';
import '../widgets/order_card_widget.dart';
import '../widgets/order_stats_widget.dart';
import 'order_detail_screen.dart';
import 'order_creation_screen.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  
  bool _showStats = false;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _scrollController.addListener(_onScroll);
    
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderListProvider.notifier).loadOrders(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final orderListState = ref.read(orderListProvider);
      if (orderListState.hasMore && !orderListState.isLoading) {
        ref.read(orderListProvider.notifier).loadOrders();
      }
    }
  }

  void _onTabChanged(int index) {
    OrderStatus? status;
    switch (index) {
      case 0:
        status = null; // 전체
        break;
      case 1:
        status = OrderStatus.draft;
        break;
      case 2:
        status = OrderStatus.pending;
        break;
      case 3:
        status = OrderStatus.confirmed;
        break;
      case 4:
        status = OrderStatus.shipped;
        break;
      case 5:
        status = OrderStatus.completed;
        break;
    }

    ref.read(orderListProvider.notifier).applyFilters(statusFilter: status);
  }

  void _onSearch(String query) {
    ref.read(orderListProvider.notifier).applyFilters(searchQuery: query);
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderFilterWidget(
        onApplyFilters: (filters) {
          ref.read(orderListProvider.notifier).applyFilters(
            productTypeFilter: filters['productType'],
            deliveryMethodFilter: filters['deliveryMethod'],
            startDate: filters['startDate'],
            endDate: filters['endDate'],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderListState = ref.watch(orderListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: '주문 관리'.text.size(20).bold.make(),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          // 통계 토글
          IconButton(
            icon: Icon(
              _showStats ? Icons.bar_chart : Icons.bar_chart_outlined,
              color: _showStats ? AppTheme.primaryColor : Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _showStats = !_showStats;
              });
            },
          ),
          
          // 필터 토글
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: orderListState.statusFilter != null ||
                      orderListState.productTypeFilter != null ||
                      orderListState.deliveryMethodFilter != null ||
                      orderListState.startDate != null ||
                      orderListState.endDate != null
                  ? AppTheme.primaryColor
                  : Colors.grey[600],
            ),
            onPressed: _showFilterDialog,
          ),
          
          // 새로고침
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey[600]),
            onPressed: () {
              ref.read(orderListProvider.notifier).loadOrders(refresh: true);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // 검색바
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '주문번호, 메모로 검색...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: _onSearch,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 상태 탭
              TabBar(
                controller: _tabController,
                isScrollable: true,
                onTap: _onTabChanged,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: '전체'),
                  Tab(text: '임시저장'),
                  Tab(text: '주문대기'),
                  Tab(text: '주문확정'),
                  Tab(text: '출고완료'),
                  Tab(text: '배송완료'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // 통계 위젯
          if (_showStats) ...[
            const OrderStatsWidget(),
            const SizedBox(height: 8),
          ],
          
          // 주문 목록
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(orderListProvider.notifier).loadOrders(refresh: true);
              },
              child: _buildOrderList(orderListState),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const OrderCreationScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: '새 주문'.text.bold.make(),
      ),
    );
  }

  Widget _buildOrderList(OrderListState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null && state.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            '데이터를 불러올 수 없습니다'.text.size(16).gray600.make(),
            const SizedBox(height: 8),
            state.error!.message.text.size(14).gray500.makeCentered(),
            const SizedBox(height: 24),
            GFButton(
              onPressed: () {
                ref.read(orderListProvider.notifier).loadOrders(refresh: true);
              },
              text: '다시 시도',
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      );
    }

    if (state.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            '주문이 없습니다'.text.size(16).gray600.make(),
            const SizedBox(height: 8),
            '새로운 주문을 생성해보세요'.text.size(14).gray500.make(),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.orders.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.orders.length) {
          return state.isLoading
              ? Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              : const SizedBox.shrink();
        }

        final order = state.orders[index];
        return OrderCardWidget(
          order: order,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailScreen(orderId: order.id),
              ),
            );
          },
          onStatusChanged: (status, reason) {
            ref.read(orderListProvider.notifier).updateOrderStatus(
              orderId: order.id,
              status: status,
              cancelledReason: reason,
            );
          },
          onDelete: () {
            _showDeleteConfirmDialog(order);
          },
        );
      },
    );
  }

  void _showDeleteConfirmDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: '주문 삭제'.text.bold.make(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            '정말로 이 주문을 삭제하시겠습니까?'.text.make(),
            const SizedBox(height: 8),
            '주문번호: ${order.orderNumber}'.text.gray600.make(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: '취소'.text.make(),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(orderListProvider.notifier).deleteOrder(order.id);
                if (mounted) {
                  GFToast.showToast(
                    '주문이 삭제되었습니다',
                    context,
                    toastPosition: GFToastPosition.BOTTOM,
                    backgroundColor: AppTheme.successColor,
                    textStyle: const TextStyle(color: Colors.white),
                  );
                }
              } catch (e) {
                if (mounted) {
                  GFToast.showToast(
                    '삭제에 실패했습니다',
                    context,
                    toastPosition: GFToastPosition.BOTTOM,
                    backgroundColor: AppTheme.errorColor,
                    textStyle: const TextStyle(color: Colors.white),
                  );
                }
              }
            },
            child: '삭제'.text.color(AppTheme.errorColor).make(),
          ),
        ],
      ),
    );
  }
}