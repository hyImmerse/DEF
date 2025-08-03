import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/index.dart';
import '../../../../core/utils/widget_extensions.dart';
import '../../../order/data/models/order_model.dart';
import '../providers/order_history_provider.dart';
import '../widgets/order_history_card.dart';
import '../widgets/order_history_filter.dart' as widget;
import '../widgets/order_statistics_card.dart';
import 'transaction_statement_viewer.dart';

/// 주문 내역 화면
/// 40-60대 사용자를 위한 큰 UI와 직관적인 필터링
class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showStatistics = true;
  
  @override
  void initState() {
    super.initState();
    
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderHistoryProvider.notifier).loadOrderHistory();
    });
    
    // 무한 스크롤 설정
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(orderHistoryProvider.notifier).loadMore();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderHistoryProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: '주문 내역'.text
          .textStyle(AppTextStyles.headlineSmall)
          .make(),
        centerTitle: true,
        actions: [
          // 통계 표시/숨기기 토글
          IconButton(
            icon: Icon(
              _showStatistics 
                ? Icons.analytics_rounded 
                : Icons.analytics_outlined,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _showStatistics = !_showStatistics;
              });
            },
            tooltip: '통계 ${_showStatistics ? '숨기기' : '보기'}',
          ),
          // Excel 다운로드
          IconButton(
            icon: Icon(
              Icons.download_rounded,
              size: 28,
              color: AppColors.primary,
            ),
            onPressed: _downloadExcel,
            tooltip: 'Excel 다운로드',
          ),
          const SizedBox(width: AppSpacing.h8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(orderHistoryProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 필터 섹션
            SliverToBoxAdapter(
              child: widget.OrderHistoryFilter(
                filter: state.filter,
                onFilterChanged: (filter) {
                  ref.read(orderHistoryProvider.notifier).updateFilter(filter);
                },
              ),
            ),
            
            // 통계 카드
            if (_showStatistics && state.statistics != null)
              SliverToBoxAdapter(
                child: OrderStatisticsCard(
                  statistics: state.statistics!,
                ).px(AppSpacing.md).pOnly(bottom: AppSpacing.md),
              ),
            
            // 로딩 상태
            if (state.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            // 빈 상태
            else if (state.orders.isEmpty)
              SliverFillRemaining(
                child: _buildEmptyState(),
              )
            // 주문 목록
            else ...[
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final order = state.orders[index];
                      return OrderHistoryCard(
                        order: order,
                        onTap: () => _viewOrderDetail(order),
                        onViewStatement: () => _viewTransactionStatement(order),
                      ).pOnly(bottom: AppSpacing.sm);
                    },
                    childCount: state.orders.length,
                  ),
                ),
              ),
              
              // 추가 로딩 인디케이터
              if (state.isLoadingMore)
                SliverToBoxAdapter(
                  child: const CircularProgressIndicator()
                    .centered
                    .p(AppSpacing.lg),
                ),
              
              // 하단 여백
              SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
            ],
            
            // 에러 상태
            if (state.error != null)
              SliverToBoxAdapter(
                child: _buildErrorState(state.error!),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.receipt_long_outlined,
            size: 60,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: AppSpacing.v24),
        '주문 내역이 없습니다'.text
          .textStyle(AppTextStyles.titleLarge)
          .color(AppColors.textSecondary)
          .make(),
        const SizedBox(height: AppSpacing.v8),
        '새로운 주문을 생성해보세요'.text
          .textStyle(AppTextStyles.bodyLarge)
          .color(AppColors.textTertiary)
          .make(),
        const SizedBox(height: AppSpacing.v32),
        GFButton(
          onPressed: () {
            Navigator.pushNamed(context, '/order/create');
          },
          text: '주문하기',
          icon: const Icon(Icons.add, color: Colors.white, size: 24),
          textStyle: AppTextStyles.button.copyWith(color: Colors.white),
          size: GFSize.LARGE,
          color: AppColors.primary,
          shape: GFButtonShape.pills,
        ),
      ],
    ).px(AppSpacing.xl);
  }
  
  Widget _buildErrorState(String error) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.v16),
          '오류가 발생했습니다'.text
            .textStyle(AppTextStyles.titleMedium)
            .color(AppColors.error)
            .make(),
          const SizedBox(height: AppSpacing.v8),
          error.text
            .textStyle(AppTextStyles.bodyMedium)
            .color(AppColors.errorText)
            .align(TextAlign.center)
            .make(),
          const SizedBox(height: AppSpacing.v16),
          GFButton(
            onPressed: () {
              ref.read(orderHistoryProvider.notifier).refresh();
            },
            text: '다시 시도',
            size: GFSize.MEDIUM,
            color: AppColors.error,
            shape: GFButtonShape.pills,
          ),
        ],
      ),
    );
  }
  
  void _viewOrderDetail(OrderModel order) {
    Navigator.pushNamed(
      context,
      '/order/detail',
      arguments: order.id,
    );
  }
  
  void _viewTransactionStatement(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionStatementViewer(
          orderId: order.id,
          orderNumber: order.orderNumber,
        ),
      ),
    );
  }
  
  Future<void> _downloadExcel() async {
    final filter = ref.read(orderHistoryProvider).filter;
    
    // 다운로드 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: '주문 내역 다운로드'.text
          .textStyle(AppTextStyles.headlineSmall)
          .make(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            '현재 필터 조건으로 주문 내역을\nExcel 파일로 다운로드합니다.'.text
              .textStyle(AppTextStyles.bodyLarge)
              .make(),
            const SizedBox(height: AppSpacing.v16),
            if (filter.startDate != null || filter.endDate != null)
              _buildFilterInfo('기간', _formatDateRange(filter.startDate, filter.endDate)),
            if (filter.status != null)
              _buildFilterInfo('상태', _getStatusLabel(filter.status!)),
            if (filter.productType != null)
              _buildFilterInfo('제품', filter.productType == ProductType.box ? '박스' : '벌크'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: '취소'.text
              .textStyle(AppTextStyles.button)
              .color(AppColors.textSecondary)
              .make(),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: '다운로드'.text
              .textStyle(AppTextStyles.button)
              .color(AppColors.primary)
              .make(),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await ref.read(excelDownloadProvider.notifier).generateExcel(
        startDate: filter.startDate,
        endDate: filter.endDate,
      );
      
      ref.listen(excelDownloadProvider, (previous, next) {
        next.when(
          data: (url) {
            if (url != null) {
              // TODO: URL을 사용해 다운로드 처리
              GFToast.showToast(
                'Excel 파일이 생성되었습니다',
                context,
                toastPosition: GFToastPosition.BOTTOM,
                backgroundColor: AppColors.success,
              );
            }
          },
          loading: () {},
          error: (error, _) {
            GFToast.showToast(
              'Excel 생성에 실패했습니다',
              context,
              toastPosition: GFToastPosition.BOTTOM,
              backgroundColor: AppColors.error,
            );
          },
        );
      });
    }
  }
  
  Widget _buildFilterInfo(String label, String value) {
    return Row(
      children: [
        '$label: '.text
          .textStyle(AppTextStyles.bodyMedium)
          .color(AppColors.textSecondary)
          .make(),
        value.text
          .textStyle(AppTextStyles.bodyMedium)
          .color(AppColors.textPrimary)
          .make(),
      ],
    ).pOnly(bottom: AppSpacing.xs);
  }
  
  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null && end == null) return '전체';
    if (start != null && end != null) {
      return '${_formatDate(start)} ~ ${_formatDate(end)}';
    }
    if (start != null) return '${_formatDate(start)} 이후';
    return '${_formatDate(end!)} 이전';
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
  
  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return '주문대기';
      case OrderStatus.confirmed:
        return '주문확정';
      case OrderStatus.shipped:
        return '출고완료';
      case OrderStatus.completed:
        return '배송완료';
      case OrderStatus.cancelled:
        return '주문취소';
      default:
        return '';
    }
  }
}