import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/widget_extensions.dart';
import '../../data/models/order_model.dart';
import '../providers/order_provider.dart';
import '../widgets/order_filter_widget.dart';
import '../widgets/order_stats_widget.dart';
import 'enhanced_order_registration_screen.dart';
import 'order_detail_screen.dart';

/// 향상된 주문 내역 조회 화면
/// 
/// 40-60대 사용자를 위한 접근성 최적화:
/// - 큰 글씨와 명확한 버튼 (최소 16sp)
/// - 간단한 필터링 시스템
/// - 직관적인 상태 표시
/// - 쉬운 검색 기능
/// - GetWidget + VelocityX 활용
class EnhancedOrderListScreen extends ConsumerStatefulWidget {
  const EnhancedOrderListScreen({super.key});

  @override
  ConsumerState<EnhancedOrderListScreen> createState() => _EnhancedOrderListScreenState();
}

class _EnhancedOrderListScreenState extends ConsumerState<EnhancedOrderListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  // 현재 선택된 필터
  OrderStatus? _selectedStatus;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final orderListState = ref.read(orderListProvider);
      if (orderListState.hasMore && !orderListState.isLoading) {
        ref.read(orderListProvider.notifier).loadOrders();
      }
    }
  }

  void _onStatusFilterChanged(OrderStatus? status) {
    setState(() {
      _selectedStatus = status;
    });
    ref.read(orderListProvider.notifier).applyFilters(statusFilter: status);
  }

  void _onSearch(String query) {
    ref.read(orderListProvider.notifier).applyFilters(searchQuery: query);
  }

  @override
  Widget build(BuildContext context) {
    final orderListState = ref.watch(orderListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: '주문 내역'.text.size(22).bold.make(),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        actions: [
          // 검색 토글
          IconButton(
            icon: Icon(
              _showSearch ? Icons.search_off : Icons.search,
              size: 28,
              color: _showSearch ? AppTheme.primaryColor : Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  _onSearch('');
                }
              });
            },
          ),
          
          // 새로고침
          IconButton(
            icon: Icon(Icons.refresh, size: 28, color: Colors.grey[600]),
            onPressed: () {
              ref.read(orderListProvider.notifier).loadOrders(refresh: true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색바 (토글 가능)
          if (_showSearch) _buildSearchSection(),
          
          // 상태 필터 버튼들
          _buildStatusFilterSection(),
          
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
      floatingActionButton: GFButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EnhancedOrderRegistrationScreen(),
            ),
          );
        },
        text: '새 주문',
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        size: 60,
        color: AppTheme.primaryColor,
        shape: GFButtonShape.pills,
        icon: const Icon(Icons.add, color: Colors.white, size: 24),
        type: GFButtonType.solid,
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '주문번호로 검색...',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 24,
              color: Colors.grey[600],
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 24,
                      color: Colors.grey[600],
                    ),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: _onSearch,
        ),
      ),
    );
  }

  Widget _buildStatusFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: '주문 상태'.text.size(16).bold.make(),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatusFilterChip('전체', null),
                const SizedBox(width: 12),
                _buildStatusFilterChip('주문대기', OrderStatus.pending),
                const SizedBox(width: 12),
                _buildStatusFilterChip('주문확정', OrderStatus.confirmed),
                const SizedBox(width: 12),
                _buildStatusFilterChip('출고완료', OrderStatus.shipped),
                const SizedBox(width: 12),
                _buildStatusFilterChip('배송완료', OrderStatus.completed),
                const SizedBox(width: 12),
                _buildStatusFilterChip('주문취소', OrderStatus.cancelled),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChip(String label, OrderStatus? status) {
    final isSelected = _selectedStatus == status;
    
    return GestureDetector(
      onTap: () => _onStatusFilterChanged(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: label.text
            .size(14)
            .color(isSelected ? Colors.white : Colors.grey[700]!)
            .bold
            .make(),
      ),
    );
  }

  Widget _buildOrderList(OrderListState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              '주문 목록을 불러오는 중...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (state.error != null && state.orders.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 20),
                '데이터를 불러올 수 없습니다'.text.size(18).gray600.make(),
                const SizedBox(height: 12),
                state.error!.message.text.size(14).gray500.makeCentered(),
                const SizedBox(height: 24),
                GFButton(
                  onPressed: () {
                    ref.read(orderListProvider.notifier).loadOrders(refresh: true);
                  },
                  text: '다시 시도',
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  size: 50,
                  color: AppTheme.primaryColor,
                  shape: GFButtonShape.pills,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (state.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            '주문이 없습니다'.text.size(18).gray600.make(),
            const SizedBox(height: 12),
            '새로운 주문을 등록해보세요'.text.size(14).gray500.make(),
            const SizedBox(height: 24),
            GFButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EnhancedOrderRegistrationScreen(),
                  ),
                );
              },
              text: '주문 등록하기',
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              size: 50,
              color: AppTheme.primaryColor,
              shape: GFButtonShape.pills,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
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
          // 로딩 인디케이터
          return Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: state.isLoading
                ? Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      '더 많은 주문을 불러오는 중...'.text.size(14).gray500.make(),
                    ],
                  )
                : const SizedBox.shrink(),
          );
        }

        final order = state.orders[index];
        return _buildEnhancedOrderCard(order);
      },
    );
  }

  Widget _buildEnhancedOrderCard(OrderModel order) {
    final NumberFormat currencyFormat = NumberFormat('#,###');
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailScreen(orderId: order.id),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더: 주문번호와 상태
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          order.orderNumber.text.size(18).bold.make(),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              dateFormat.format(order.createdAt).text
                                  .size(14)
                                  .gray600
                                  .make(),
                              const SizedBox(width: 8),
                              timeFormat.format(order.createdAt).text
                                  .size(14)
                                  .gray500
                                  .make(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildLargeStatusChip(order.status),
                  ],
                ),

                const SizedBox(height: 20),

                // 제품 정보
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getProductIcon(order.productType),
                          size: 28,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _getProductTypeName(order.productType).text
                                .size(16)
                                .bold
                                .make(),
                            const SizedBox(height: 4),
                            '수량: ${currencyFormat.format(order.quantity)}개'.text
                                .size(14)
                                .gray600
                                .make(),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          '₩${currencyFormat.format(order.totalPrice)}'.text
                              .size(20)
                              .bold
                              .color(AppTheme.primaryColor)
                              .make(),
                          const SizedBox(height: 4),
                          '단가 ₩${currencyFormat.format(order.unitPrice)}'.text
                              .size(12)
                              .gray500
                              .make(),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 배송 정보
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getDeliveryIcon(order.deliveryMethod),
                        size: 20,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getDeliveryMethodName(order.deliveryMethod).text
                              .size(16)
                              .bold
                              .make(),
                          const SizedBox(height: 2),
                          '배송일: ${dateFormat.format(order.deliveryDate)}'.text
                              .size(14)
                              .gray600
                              .make(),
                        ],
                      ),
                    ),
                  ],
                ),

                // 메모 (있는 경우)
                if (order.deliveryMemo?.isNotEmpty == true) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber[200]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: 18,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.deliveryMemo!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.amber[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // 액션 버튼들
                _buildActionButtons(order),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeStatusChip(OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String statusText;
    IconData icon;

    switch (status) {
      case OrderStatus.draft:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        statusText = '임시저장';
        icon = Icons.drafts;
        break;
      case OrderStatus.pending:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        statusText = '주문대기';
        icon = Icons.schedule;
        break;
      case OrderStatus.confirmed:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[700]!;
        statusText = '주문확정';
        icon = Icons.check_circle;
        break;
      case OrderStatus.shipped:
        backgroundColor = Colors.purple[100]!;
        textColor = Colors.purple[700]!;
        statusText = '출고완료';
        icon = Icons.local_shipping;
        break;
      case OrderStatus.completed:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        statusText = '배송완료';
        icon = Icons.done_all;
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        statusText = '주문취소';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          statusText.text.size(14).color(textColor).bold.make(),
        ],
      ),
    );
  }


  Widget _buildActionButtons(OrderModel order) {
    return Row(
      children: [
        // 상태에 따른 액션 버튼
        if (order.status == OrderStatus.pending ||
            order.status == OrderStatus.draft) ...[ 
          Expanded(
            child: GFButton(
              onPressed: () => _updateOrderStatus(order.id, OrderStatus.confirmed, null),
              text: '주문 확정',
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              size: 40,
              fullWidthButton: true,
              color: Colors.blue[600]!,
              shape: GFButtonShape.pills,
              icon: const Icon(Icons.check_circle, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
        
        if (order.status == OrderStatus.confirmed) ...[
          Expanded(
            child: GFButton(
              onPressed: () => _updateOrderStatus(order.id, OrderStatus.shipped, null),
              text: '출고 완료',
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              size: 40,
              fullWidthButton: true,
              color: Colors.purple[600]!,
              shape: GFButtonShape.pills,
              icon: const Icon(Icons.local_shipping, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
        
        if (order.status == OrderStatus.shipped) ...[
          Expanded(
            child: GFButton(
              onPressed: () => _updateOrderStatus(order.id, OrderStatus.completed, null),
              text: '배송 완료',
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              size: 40,
              fullWidthButton: true,
              color: Colors.green[600]!,
              shape: GFButtonShape.pills,
              icon: const Icon(Icons.done_all, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
        
        // 취소 버튼 (완료, 취소 상태가 아닌 경우)
        if (order.status != OrderStatus.completed && 
            order.status != OrderStatus.cancelled) ...[
          Expanded(
            child: GFButton(
              onPressed: () => _showCancelDialog(order),
              text: '주문 취소',
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              size: 40,
              fullWidthButton: true,
              color: Colors.red[600]!,
              shape: GFButtonShape.pills,
              icon: const Icon(Icons.cancel, color: Colors.white, size: 16),
            ),
          ),
        ],
      ],
    );
  }

  IconData _getProductIcon(ProductType type) {
    switch (type) {
      case ProductType.box:
        return Icons.inventory_2;
      case ProductType.bulk:
        return Icons.storage;
    }
  }

  IconData _getDeliveryIcon(DeliveryMethod method) {
    switch (method) {
      case DeliveryMethod.directPickup:
        return Icons.store;
      case DeliveryMethod.delivery:
        return Icons.local_shipping;
    }
  }

  String _getProductTypeName(ProductType type) {
    switch (type) {
      case ProductType.box:
        return '박스 (20L)';
      case ProductType.bulk:
        return '벌크 (1000L)';
    }
  }

  String _getDeliveryMethodName(DeliveryMethod method) {
    switch (method) {
      case DeliveryMethod.directPickup:
        return '직접 수령';
      case DeliveryMethod.delivery:
        return '배송';
    }
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
        GFToast.showToast(
          '주문 상태가 변경되었습니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.successColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        );
      }
    } catch (e) {
      if (mounted) {
        GFToast.showToast(
          '오류가 발생했습니다: ${e.toString()}',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.errorColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        );
      }
    }
  }

  /// 주문 취소 다이얼로그
  Future<void> _showCancelDialog(OrderModel order) async {
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: '주문 취소'.text.size(20).bold.make(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            '정말로 이 주문을 취소하시겠습니까?'.text.size(16).make(),
            const SizedBox(height: 8),
            '주문번호: ${order.orderNumber}'.text.size(14).gray600.make(),
            const SizedBox(height: 20),
            '취소 사유를 입력해주세요'.text.size(16).bold.make(),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  hintText: '취소 사유를 입력하세요',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
                style: const TextStyle(fontSize: 16),
                maxLines: 3,
                maxLength: 200,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: '취소'.text.size(16).gray600.make(),
          ),
          GFButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                GFToast.showToast(
                  '취소 사유를 입력해주세요',
                  context,
                  toastPosition: GFToastPosition.BOTTOM,
                  backgroundColor: AppTheme.errorColor,
                  textStyle: const TextStyle(color: Colors.white),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            text: '주문 취소',
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            color: Colors.red[600]!,
            size: 40,
            shape: GFButtonShape.pills,
          ),
        ],
      ),
    );

    if (confirmed == true && reasonController.text.trim().isNotEmpty) {
      await _updateOrderStatus(order.id, OrderStatus.cancelled, reasonController.text.trim());
    }
  }
}