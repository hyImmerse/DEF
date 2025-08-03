import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/order_model.dart';

class OrderFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const OrderFilterWidget({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<OrderFilterWidget> createState() => _OrderFilterWidgetState();
}

class _OrderFilterWidgetState extends State<OrderFilterWidget> {
  ProductType? _selectedProductType;
  DeliveryMethod? _selectedDeliveryMethod;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들바
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '필터',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    '초기화',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // 필터 옵션들
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductTypeFilter(),
                  const SizedBox(height: 24),
                  _buildDeliveryMethodFilter(),
                  const SizedBox(height: 24),
                  _buildDateRangeFilter(),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '제품 타입',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _buildFilterChip(
              label: '전체',
              isSelected: _selectedProductType == null,
              onSelected: () {
                setState(() {
                  _selectedProductType = null;
                });
              },
            ),
            _buildFilterChip(
              label: '박스 (20L)',
              isSelected: _selectedProductType == ProductType.box,
              onSelected: () {
                setState(() {
                  _selectedProductType = ProductType.box;
                });
              },
            ),
            _buildFilterChip(
              label: '벌크 (대용량)',
              isSelected: _selectedProductType == ProductType.bulk,
              onSelected: () {
                setState(() {
                  _selectedProductType = ProductType.bulk;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryMethodFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '배송 방법',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _buildFilterChip(
              label: '전체',
              isSelected: _selectedDeliveryMethod == null,
              onSelected: () {
                setState(() {
                  _selectedDeliveryMethod = null;
                });
              },
            ),
            _buildFilterChip(
              label: '직접 수령',
              isSelected: _selectedDeliveryMethod == DeliveryMethod.directPickup,
              onSelected: () {
                setState(() {
                  _selectedDeliveryMethod = DeliveryMethod.directPickup;
                });
              },
            ),
            _buildFilterChip(
              label: '배송',
              isSelected: _selectedDeliveryMethod == DeliveryMethod.delivery,
              onSelected: () {
                setState(() {
                  _selectedDeliveryMethod = DeliveryMethod.delivery;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '주문 기간',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectStartDate(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (_startDate != null 
                          ? dateFormat.format(_startDate!)
                          : '시작일').text
                          .size(14)
                          .color(_startDate != null ? Colors.black : Colors.grey[500])
                          .make(),
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              '~',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectEndDate(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (_endDate != null 
                          ? dateFormat.format(_endDate!)
                          : '종료일').text
                          .size(14)
                          .color(_endDate != null ? Colors.black : Colors.grey[500])
                          .make(),
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildQuickDateFilter('오늘', () {
              final today = DateTime.now();
              setState(() {
                _startDate = DateTime(today.year, today.month, today.day);
                _endDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
              });
            }),
            const SizedBox(width: 8),
            _buildQuickDateFilter('이번 주', () {
              final now = DateTime.now();
              final weekday = now.weekday;
              final startOfWeek = now.subtract(Duration(days: weekday - 1));
              setState(() {
                _startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
                _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
              });
            }),
            const SizedBox(width: 8),
            _buildQuickDateFilter('이번 달', () {
              final now = DateTime.now();
              setState(() {
                _startDate = DateTime(now.year, now.month, 1);
                _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickDateFilter(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
          ),
        ),
        child: label.text
            .size(14)
            .color(isSelected ? Colors.white : Colors.grey[700])
            .make(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GFButton(
          onPressed: _applyFilters,
          text: '필터 적용',
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          size: 50,
          fullWidthButton: true,
          color: AppTheme.primaryColor,
          shape: GFButtonShape.pills,
        ),
        const SizedBox(height: 12),
        GFButton(
          onPressed: () => Navigator.pop(context),
          text: '취소',
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
          size: 50,
          fullWidthButton: true,
          color: Colors.grey[200]!,
          shape: GFButtonShape.pills,
          type: GFButtonType.outline,
        ),
      ],
    );
  }

  Future<void> _selectStartDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      locale: const Locale('ko', 'KR'),
    );

    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      locale: const Locale('ko', 'KR'),
    );

    if (selectedDate != null) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedProductType = null;
      _selectedDeliveryMethod = null;
      _startDate = null;
      _endDate = null;
    });
  }

  void _applyFilters() {
    widget.onApplyFilters({
      'productType': _selectedProductType,
      'deliveryMethod': _selectedDeliveryMethod,
      'startDate': _startDate,
      'endDate': _endDate,
    });
    Navigator.pop(context);
  }
}