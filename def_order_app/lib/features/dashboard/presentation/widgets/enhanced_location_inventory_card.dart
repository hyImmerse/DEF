import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/velocity_x_compat.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/inventory_model.dart';
import 'status_tag_widget.dart';

/// 접근성 개선된 위치별 재고 카드
/// 
/// WCAG AA 준수:
/// - 텍스트 크기 16sp 이상
/// - 색상 대비 4.5:1 이상
/// - Tertiary Container 색상 사용
class EnhancedLocationInventoryCard extends StatelessWidget {
  final String locationName;
  final String location;
  final List<InventoryModel> inventories;
  final Color color;
  final IconData icon;

  const EnhancedLocationInventoryCard({
    super.key,
    required this.locationName,
    required this.location,
    required this.inventories,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final summary = LocationInventorySummary.fromInventories(location, inventories);
    final formatter = NumberFormat('#,###');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),  // 카드 간격
      child: GFCard(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surface,
        border: Border.all(
          color: summary.hasCriticalStock 
              ? AppColors.warning 
              : AppColors.border,
          width: summary.hasCriticalStock ? 2.5 : 1.5,
        ),
        padding: const EdgeInsets.all(24),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 섹션
            Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: color,
                  ),
                ),
                20.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      locationName.text
                          .size(24)
                          .fontWeight(FontWeight.bold)
                          .color(AppColors.textPrimary)
                          .make(),
                      8.heightBox,
                      // 상태 태그
                      StatusTagWidget(
                        status: summary.hasCriticalStock ? 'high' : 'low',
                        label: summary.hasCriticalStock ? '재고 부족' : '정상 운영',
                        icon: summary.hasCriticalStock 
                            ? Icons.warning 
                            : Icons.check_circle,
                        isLarge: false,
                      ),
                    ],
                  ),
                ),
                // 총 아이템 수
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      summary.totalItems.toString().text
                          .size(24)
                          .fontWeight(FontWeight.bold)
                          .color(color)
                          .make(),
                      '품목'.text
                          .size(16)
                          .color(color)
                          .make(),
                    ],
                  ),
                ),
              ],
            ),

            24.heightBox,

            // 제품별 재고 현황 - Tertiary Container 색상
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),  // Tertiary Container
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFDDB3),  // Tertiary 200
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '제품별 재고'.text
                      .size(18)
                      .fontWeight(FontWeight.w600)
                      .color(const Color(0xFF5F4100))  // Tertiary 900
                      .make(),
                  
                  16.heightBox,
                  
                  // 박스 재고
                  _buildProductRow(
                    '박스 (20L)',
                    summary.boxQuantity,
                    '박스',
                    Icons.inventory_2,
                    AppColors.primary,
                    formatter,
                    threshold: 50,
                  ),
                  
                  12.heightBox,
                  
                  // 구분선
                  Container(
                    height: 1,
                    color: AppColors.divider,
                  ),
                  
                  12.heightBox,
                  
                  // 벌크 재고
                  _buildProductRow(
                    '벌크 (1000L)',
                    summary.bulkQuantity,
                    '탱크',
                    Icons.storage,
                    AppColors.success,
                    formatter,
                    threshold: 20,
                  ),
                  
                  if (summary.emptyTankQuantity > 0) ...[
                    12.heightBox,
                    Container(
                      height: 1,
                      color: AppColors.divider,
                    ),
                    12.heightBox,
                    
                    // 빈 탱크
                    _buildProductRow(
                      '빈 탱크',
                      summary.emptyTankQuantity,
                      '개',
                      Icons.recycling,
                      AppColors.textSecondary,
                      formatter,
                      threshold: 0,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductRow(
    String productName,
    int quantity,
    String unit,
    IconData icon,
    Color color,
    NumberFormat formatter,
    {required int threshold}
  ) {
    final isLow = threshold > 0 && quantity < threshold;
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        ),
        12.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productName.text
                  .size(16)
                  .color(AppColors.textSecondary)
                  .make(),
              4.heightBox,
              Row(
                children: [
                  formatter.format(quantity).text
                      .size(20)
                      .fontWeight(FontWeight.bold)
                      .color(isLow ? AppColors.warning : AppColors.textPrimary)
                      .make(),
                  6.widthBox,
                  unit.text
                      .size(16)
                      .color(AppColors.textSecondary)
                      .make(),
                ],
              ),
            ],
          ),
        ),
        if (isLow)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.warning100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: '부족'.text
                .size(14)
                .fontWeight(FontWeight.w600)
                .color(AppColors.warning900)
                .make(),
          ),
      ],
    );
  }
}

/// 위치별 재고 요약 정보
class LocationInventorySummary {
  final String location;
  final int totalItems;
  final int boxQuantity;
  final int bulkQuantity;
  final int emptyTankQuantity;
  final bool hasCriticalStock;

  LocationInventorySummary({
    required this.location,
    required this.totalItems,
    required this.boxQuantity,
    required this.bulkQuantity,
    required this.emptyTankQuantity,
    required this.hasCriticalStock,
  });

  factory LocationInventorySummary.fromInventories(
    String location,
    List<InventoryModel> inventories,
  ) {
    int boxTotal = 0;
    int bulkTotal = 0;
    int emptyTotal = 0;
    bool critical = false;

    for (final inv in inventories) {
      if (inv.location == location) {
        if (inv.productType == 'box') {
          boxTotal += inv.quantity;
          if (inv.quantity < 50) critical = true;
        } else if (inv.productType == 'bulk') {
          bulkTotal += inv.quantity;
          if (inv.quantity < 20) critical = true;
        } else if (inv.productType == 'empty') {
          emptyTotal += inv.quantity;
        }
      }
    }

    return LocationInventorySummary(
      location: location,
      totalItems: inventories.where((i) => i.location == location).length,
      boxQuantity: boxTotal,
      bulkQuantity: bulkTotal,
      emptyTankQuantity: emptyTotal,
      hasCriticalStock: critical,
    );
  }
}