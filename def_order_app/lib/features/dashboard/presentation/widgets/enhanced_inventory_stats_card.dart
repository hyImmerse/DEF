import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/velocity_x_compat.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// 접근성 개선된 재고 통계 카드
/// 
/// WCAG AA 준수:
/// - 카드 간격 24dp
/// - 둥근 모서리 12dp
/// - 그림자 효과 추가
/// - 색상 대비 개선
class EnhancedInventoryStatsCard extends StatelessWidget {
  final String title;
  final int totalQuantity;
  final int factoryQuantity;
  final int warehouseQuantity;
  final String unit;
  final Color color;
  final IconData icon;
  final bool isPrimary;

  const EnhancedInventoryStatsCard({
    super.key,
    required this.title,
    required this.totalQuantity,
    required this.factoryQuantity,
    required this.warehouseQuantity,
    required this.unit,
    required this.color,
    required this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final isLowStock = _isLowStock();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),  // 카드 간격 24dp
      child: GFCard(
        elevation: isPrimary ? 6 : 4,
        borderRadius: BorderRadius.circular(12),  // 둥근 모서리 12dp
        color: isPrimary 
            ? AppColors.primary50  // Primary Container
            : AppColors.surface,
        border: Border.all(
          color: isLowStock 
              ? AppColors.warning 
              : isPrimary 
                  ? AppColors.primary200 
                  : AppColors.border,
          width: isLowStock ? 2.5 : 1.5,
        ),
        padding: const EdgeInsets.all(24),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 섹션
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: color,
                  ),
                ),
                20.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title.text
                          .size(20)  // 18 → 20
                          .fontWeight(FontWeight.bold)
                          .color(AppColors.textPrimary)
                          .make(),
                      6.heightBox,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isLowStock 
                              ? AppColors.warning100 
                              : AppColors.success100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: (isLowStock ? '재고 부족' : '정상')
                            .text
                            .size(14)
                            .fontWeight(FontWeight.w600)
                            .color(isLowStock 
                                ? AppColors.warning900 
                                : AppColors.success900)
                            .make(),
                      ),
                    ],
                  ),
                ),
                // 총 수량 표시
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    formatter.format(totalQuantity).text
                        .size(32)  // 28 → 32
                        .fontWeight(FontWeight.bold)
                        .color(isLowStock ? AppColors.warning : color)
                        .make(),
                    unit.text
                        .size(18)  // 16 → 18
                        .color(AppColors.textSecondary)
                        .make(),
                  ],
                ),
              ],
            ),

            24.heightBox,

            // 위치별 재고 현황 - 개선된 디자인
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '위치별 재고'.text
                      .size(16)
                      .fontWeight(FontWeight.w600)
                      .color(AppColors.textSecondary)
                      .make(),
                  
                  16.heightBox,
                  
                  // 공장 재고
                  _buildLocationRow(
                    '공장',
                    factoryQuantity,
                    Icons.factory,
                    AppColors.orderProcessing,
                    formatter,
                  ),
                  
                  12.heightBox,
                  
                  // 구분선
                  Container(
                    height: 1,
                    color: AppColors.divider,
                  ),
                  
                  12.heightBox,
                  
                  // 창고 재고
                  _buildLocationRow(
                    '창고',
                    warehouseQuantity,
                    Icons.warehouse,
                    AppColors.orderShipped,
                    formatter,
                  ),
                ],
              ),
            ),

            // 재고 비율 표시
            20.heightBox,
            _buildStockRatio(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(
    String location,
    int quantity,
    IconData icon,
    Color color,
    NumberFormat formatter,
  ) {
    final percentage = totalQuantity > 0 
        ? (quantity / totalQuantity * 100).toStringAsFixed(1)
        : '0.0';

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
              location.text
                  .size(16)
                  .color(AppColors.textSecondary)
                  .make(),
              4.heightBox,
              formatter.format(quantity).text
                  .size(20)  // 18 → 20
                  .fontWeight(FontWeight.bold)
                  .color(AppColors.textPrimary)
                  .make(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: '$percentage%'.text
              .size(16)
              .fontWeight(FontWeight.w600)
              .color(color)
              .make(),
        ),
      ],
    );
  }

  Widget _buildStockRatio() {
    if (totalQuantity == 0) return const SizedBox.shrink();

    final factoryRatio = factoryQuantity / totalQuantity;
    final warehouseRatio = warehouseQuantity / totalQuantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '재고 분포'.text
            .size(16)
            .fontWeight(FontWeight.w600)
            .color(AppColors.textSecondary)
            .make(),
        
        12.heightBox,
        
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.surfaceVariant,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                if (factoryRatio > 0)
                  Expanded(
                    flex: (factoryRatio * 100).round(),
                    child: Container(
                      color: AppColors.orderProcessing,
                    ),
                  ),
                if (warehouseRatio > 0)
                  Expanded(
                    flex: (warehouseRatio * 100).round(),
                    child: Container(
                      color: AppColors.orderShipped,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _isLowStock() {
    // 임계값 설정 (예: 100개 미만)
    return totalQuantity < 100;
  }
}