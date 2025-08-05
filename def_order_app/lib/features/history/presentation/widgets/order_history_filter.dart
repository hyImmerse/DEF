import 'package:flutter/material.dart';
import '../../../../core/utils/widget_extensions.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/index.dart';
import '../../../order/data/models/order_model.dart';
import '../providers/order_history_provider.dart';

/// 주문 내역 필터 위젯
/// 40-60대 사용자를 위한 큰 버튼과 명확한 UI
class OrderHistoryFilter extends StatefulWidget {
  final OrderHistoryFilterModel filter;
  final Function(OrderHistoryFilterModel) onFilterChanged;
  
  const OrderHistoryFilter({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  State<OrderHistoryFilter> createState() => _OrderHistoryFilterState();
}

class _OrderHistoryFilterState extends State<OrderHistoryFilter> {
  bool _isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // 헤더
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLG),
              bottom: _isExpanded ? Radius.zero : Radius.circular(AppSpacing.radiusLG),
            ),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_rounded,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.h12),
                  '필터'.text
                    .textStyle(AppTextStyles.titleMedium)
                    .make(),
                  const Spacer(),
                  if (_hasActiveFilters())
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                      ),
                      child: _getActiveFilterCount().toString().text
                        .textStyle(AppTextStyles.labelMedium)
                        .color(Colors.white)
                        .make(),
                    ),
                  const SizedBox(width: AppSpacing.h8),
                  Icon(
                    _isExpanded 
                      ? Icons.keyboard_arrow_up 
                      : Icons.keyboard_arrow_down,
                    size: 32,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          
          // 확장된 필터
          if (_isExpanded) ...[
            const Divider(height: 1),
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 기간 필터
                  _buildDateRangeFilter(),
                  const SizedBox(height: AppSpacing.v20),
                  
                  // 상태 필터
                  _buildStatusFilter(),
                  const SizedBox(height: AppSpacing.v20),
                  
                  // 제품 타입 필터
                  _buildProductTypeFilter(),
                  const SizedBox(height: AppSpacing.v20),
                  
                  // 배송 방법 필터
                  _buildDeliveryMethodFilter(),
                  const SizedBox(height: AppSpacing.v24),
                  
                  // 액션 버튼
                  Row(
                    children: [
                      Expanded(
                        child: GFButton(
                          onPressed: _resetFilter,
                          text: '초기화',
                          textStyle: AppTextStyles.button,
                          size: GFSize.LARGE,
                          type: GFButtonType.outline,
                          color: AppColors.textSecondary,
                          shape: GFButtonShape.pills,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.h12),
                      Expanded(
                        child: GFButton(
                          onPressed: _applyFilter,
                          text: '적용',
                          textStyle: AppTextStyles.button.copyWith(
                            color: Colors.white,
                          ),
                          size: GFSize.LARGE,
                          color: AppColors.primary,
                          shape: GFButtonShape.pills,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '기간'.text
          .textStyle(AppTextStyles.titleSmall)
          .color(AppColors.textSecondary)
          .make(),
        const SizedBox(height: AppSpacing.v8),
        Row(
          children: [
            // 시작일
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(true),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.h8),
                      Expanded(
                        child: (widget.filter.startDate != null
                          ? _formatDate(widget.filter.startDate!)
                          : '시작일').text
                          .textStyle(AppTextStyles.bodyMedium)
                          .color(widget.filter.startDate != null 
                            ? AppColors.textPrimary 
                            : AppColors.textTertiary)
                          .make(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.h8),
            '~'.text
              .textStyle(AppTextStyles.bodyLarge)
              .color(AppColors.textSecondary)
              .make(),
            const SizedBox(width: AppSpacing.h8),
            // 종료일
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(false),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.h8),
                      Expanded(
                        child: (widget.filter.endDate != null
                          ? _formatDate(widget.filter.endDate!)
                          : '종료일').text
                          .textStyle(AppTextStyles.bodyMedium)
                          .color(widget.filter.endDate != null 
                            ? AppColors.textPrimary 
                            : AppColors.textTertiary)
                          .make(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.v8),
        // 빠른 선택
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            _buildQuickDateChip('오늘', () {
              final today = DateTime.now();
              final newFilter = widget.filter.copyWith(
                startDate: DateTime(today.year, today.month, today.day),
                endDate: DateTime(today.year, today.month, today.day),
              );
              widget.onFilterChanged(newFilter);
            }),
            _buildQuickDateChip('이번 주', () {
              final now = DateTime.now();
              final weekday = now.weekday;
              final monday = now.subtract(Duration(days: weekday - 1));
              final sunday = monday.add(const Duration(days: 6));
              final newFilter = widget.filter.copyWith(
                startDate: DateTime(monday.year, monday.month, monday.day),
                endDate: DateTime(sunday.year, sunday.month, sunday.day),
              );
              widget.onFilterChanged(newFilter);
            }),
            _buildQuickDateChip('이번 달', () {
              final now = DateTime.now();
              final newFilter = widget.filter.copyWith(
                startDate: DateTime(now.year, now.month, 1),
                endDate: DateTime(now.year, now.month + 1, 0),
              );
              widget.onFilterChanged(newFilter);
            }),
            _buildQuickDateChip('최근 3개월', () {
              final now = DateTime.now();
              final newFilter = widget.filter.copyWith(
                startDate: DateTime(now.year, now.month - 3, now.day),
                endDate: now,
              );
              widget.onFilterChanged(newFilter);
            }),
          ],
        ),
      ],
    );
  }
  
  Widget _buildQuickDateChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: label.text
        .textStyle(AppTextStyles.labelMedium)
        .make(),
      onPressed: onTap,
      backgroundColor: AppColors.backgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        side: BorderSide(color: AppColors.border),
      ),
    );
  }
  
  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '주문 상태'.text
          .textStyle(AppTextStyles.titleSmall)
          .color(AppColors.textSecondary)
          .make(),
        const SizedBox(height: AppSpacing.v8),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _buildFilterChip('전체', null, widget.filter.status),
            _buildFilterChip('주문대기', OrderStatus.pending, widget.filter.status),
            _buildFilterChip('주문확정', OrderStatus.confirmed, widget.filter.status),
            _buildFilterChip('출고완료', OrderStatus.shipped, widget.filter.status),
            _buildFilterChip('배송완료', OrderStatus.completed, widget.filter.status),
            _buildFilterChip('주문취소', OrderStatus.cancelled, widget.filter.status),
          ],
        ),
      ],
    );
  }
  
  Widget _buildProductTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '제품 타입'.text
          .textStyle(AppTextStyles.titleSmall)
          .color(AppColors.textSecondary)
          .make(),
        const SizedBox(height: AppSpacing.v8),
        Row(
          children: [
            _buildFilterChip('전체', null, widget.filter.productType),
            const SizedBox(width: AppSpacing.h8),
            _buildFilterChip('박스', ProductType.box, widget.filter.productType),
            const SizedBox(width: AppSpacing.h8),
            _buildFilterChip('벌크', ProductType.bulk, widget.filter.productType),
          ],
        ),
      ],
    );
  }
  
  Widget _buildDeliveryMethodFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '배송 방법'.text
          .textStyle(AppTextStyles.titleSmall)
          .color(AppColors.textSecondary)
          .make(),
        const SizedBox(height: AppSpacing.v8),
        Row(
          children: [
            _buildFilterChip('전체', null, widget.filter.deliveryMethod),
            const SizedBox(width: AppSpacing.h8),
            _buildFilterChip('직접수령', DeliveryMethod.directPickup, widget.filter.deliveryMethod),
            const SizedBox(width: AppSpacing.h8),
            _buildFilterChip('배송', DeliveryMethod.delivery, widget.filter.deliveryMethod),
          ],
        ),
      ],
    );
  }
  
  Widget _buildFilterChip<T>(String label, T? value, T? selectedValue) {
    final isSelected = value == selectedValue;
    
    return GFButton(
      onPressed: () {
        // 새로운 필터 생성
        OrderHistoryFilterModel newFilter;
        
        if (T == OrderStatus) {
          newFilter = widget.filter.copyWith(
            status: value as OrderStatus?,
            clearStatus: value == null,
          );
          print('🎯 OrderStatus 필터 클릭: ${value?.toString() ?? 'null'} → ${newFilter.status?.toString() ?? 'null'}');
        } else if (T == ProductType) {
          newFilter = widget.filter.copyWith(
            productType: value as ProductType?,
            clearProductType: value == null,
          );
          print('🎯 ProductType 필터 클릭: ${value?.toString() ?? 'null'} → ${newFilter.productType?.toString() ?? 'null'}');
        } else if (T == DeliveryMethod) {
          newFilter = widget.filter.copyWith(
            deliveryMethod: value as DeliveryMethod?,
            clearDeliveryMethod: value == null,
          );
          print('🎯 DeliveryMethod 필터 클릭: ${value?.toString() ?? 'null'} → ${newFilter.deliveryMethod?.toString() ?? 'null'}');
        } else {
          newFilter = widget.filter;
        }
        
        // 필터 변경 콜백 호출
        print('🔄 필터 변경 콜백 호출: onFilterChanged');
        widget.onFilterChanged(newFilter);
        
        // 시각적 피드백을 위한 상태 업데이트
        setState(() {});
      },
      text: label,
      textStyle: AppTextStyles.button.copyWith(
        color: isSelected ? Colors.white : AppColors.textPrimary,
      ),
      size: GFSize.MEDIUM,
      type: isSelected ? GFButtonType.solid : GFButtonType.outline,
      color: isSelected ? AppColors.primary : AppColors.textSecondary,
      shape: GFButtonShape.pills,
    );
  }
  
  Future<void> _selectDate(bool isStartDate) async {
    final initialDate = isStartDate 
      ? widget.filter.startDate 
      : widget.filter.endDate;
    
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.2,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (selectedDate != null) {
      final newFilter = isStartDate
        ? widget.filter.copyWith(startDate: selectedDate)
        : widget.filter.copyWith(endDate: selectedDate);
      
      widget.onFilterChanged(newFilter);
      setState(() {});
    }
  }
  
  bool _hasActiveFilters() {
    return widget.filter.startDate != null ||
      widget.filter.endDate != null ||
      widget.filter.status != null ||
      widget.filter.productType != null ||
      widget.filter.deliveryMethod != null;
  }
  
  int _getActiveFilterCount() {
    int count = 0;
    if (widget.filter.startDate != null || widget.filter.endDate != null) count++;
    if (widget.filter.status != null) count++;
    if (widget.filter.productType != null) count++;
    if (widget.filter.deliveryMethod != null) count++;
    return count;
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
  
  void _resetFilter() {
    widget.onFilterChanged(const OrderHistoryFilterModel());
    setState(() => _isExpanded = false);
  }
  
  void _applyFilter() {
    widget.onFilterChanged(widget.filter);
    setState(() => _isExpanded = false);
  }
}