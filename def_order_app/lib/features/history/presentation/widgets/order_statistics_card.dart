import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/index.dart';
import '../../../order/data/models/order_model.dart';
import '../../data/services/order_history_service.dart';

/// 주문 통계 카드 위젯
/// 선택된 기간의 주문 통계를 시각적으로 표시
class OrderStatisticsCard extends StatelessWidget {
  final OrderStatistics statistics;
  
  const OrderStatisticsCard({
    super.key,
    required this.statistics,
  });
  
  @override
  Widget build(BuildContext context) {
    return GFCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(AppSpacing.lg),
      elevation: 3,
      color: AppColors.primary.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        side: BorderSide(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                size: 28,
                color: AppColors.primary,
              ),
              AppSpacing.h12,
              '주문 통계'.text
                .textStyle(AppTextStyles.titleLarge)
                .color(AppColors.primary)
                .make(),
            ],
          ),
          
          AppSpacing.v20,
          
          // 주요 통계
          Row(
            children: [
              // 총 주문
              Expanded(
                child: _buildStatItem(
                  '총 주문',
                  '${statistics.totalOrders}건',
                  Icons.receipt_long_rounded,
                  AppColors.info,
                ),
              ),
              AppSpacing.h12,
              // 총 금액
              Expanded(
                child: _buildStatItem(
                  '총 금액',
                  '${_formatPrice(statistics.totalAmount)}원',
                  Icons.payments_rounded,
                  AppColors.success,
                ),
              ),
            ],
          ),
          
          AppSpacing.v12,
          
          Row(
            children: [
              // 총 수량
              Expanded(
                child: _buildStatItem(
                  '총 수량',
                  '${statistics.totalQuantity}개',
                  Icons.inventory_2_rounded,
                  AppColors.warning,
                ),
              ),
              AppSpacing.h12,
              // 평균 주문액
              Expanded(
                child: _buildStatItem(
                  '평균 주문액',
                  '${_formatPrice(statistics.averageOrderValue)}원',
                  Icons.trending_up_rounded,
                  AppColors.primary,
                ),
              ),
            ],
          ),
          
          if (statistics.statusCount.isNotEmpty) ...[
            AppSpacing.v20,
            const Divider(),
            AppSpacing.v20,
            
            // 상태별 분포
            '상태별 현황'.text
              .textStyle(AppTextStyles.titleMedium)
              .color(AppColors.textSecondary)
              .make(),
            AppSpacing.v12,
            _buildStatusDistribution(),
          ],
          
          if (statistics.productTypeCount.isNotEmpty) ...[
            AppSpacing.v20,
            
            // 제품별 분포
            '제품별 현황'.text
              .textStyle(AppTextStyles.titleMedium)
              .color(AppColors.textSecondary)
              .make(),
            AppSpacing.v12,
            Row(
              children: [
                if (statistics.productTypeCount.containsKey(ProductType.box))
                  Expanded(
                    child: _buildProductTypeItem(
                      '박스',
                      statistics.productTypeCount[ProductType.box] ?? 0,
                      AppColors.primary,
                    ),
                  ),
                if (statistics.productTypeCount.containsKey(ProductType.box) &&
                    statistics.productTypeCount.containsKey(ProductType.bulk))
                  AppSpacing.h12,
                if (statistics.productTypeCount.containsKey(ProductType.bulk))
                  Expanded(
                    child: _buildProductTypeItem(
                      '벌크',
                      statistics.productTypeCount[ProductType.bulk] ?? 0,
                      AppColors.secondary,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              AppSpacing.h8,
              Expanded(
                child: label.text
                  .textStyle(AppTextStyles.bodySmall)
                  .color(AppColors.textSecondary)
                  .make(),
              ),
            ],
          ),
          AppSpacing.v8,
          value.text
            .textStyle(AppTextStyles.titleLarge)
            .color(AppColors.textPrimary)
            .make(),
        ],
      ),
    );
  }
  
  Widget _buildStatusDistribution() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: statistics.statusCount.entries.map((entry) {
        final status = entry.key;
        final count = entry.value;
        final percentage = (count / statistics.totalOrders * 100).toStringAsFixed(1);
        
        Color statusColor;
        String statusText;
        
        switch (status) {
          case OrderStatus.pending:
            statusColor = AppColors.warning;
            statusText = '주문대기';
            break;
          case OrderStatus.confirmed:
            statusColor = AppColors.info;
            statusText = '주문확정';
            break;
          case OrderStatus.shipped:
            statusColor = AppColors.primary;
            statusText = '출고완료';
            break;
          case OrderStatus.completed:
            statusColor = AppColors.success;
            statusText = '배송완료';
            break;
          case OrderStatus.cancelled:
            statusColor = AppColors.error;
            statusText = '주문취소';
            break;
          default:
            statusColor = AppColors.textSecondary;
            statusText = '';
        }
        
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              AppSpacing.h8,
              '$statusText $count건 ($percentage%)'.text
                .textStyle(AppTextStyles.labelMedium)
                .color(statusColor)
                .make(),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildProductTypeItem(String label, int count, Color color) {
    final percentage = (count / statistics.totalOrders * 100).toStringAsFixed(1);
    
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            label == '박스' ? Icons.inventory_2_rounded : Icons.water_drop_rounded,
            size: 32,
            color: color,
          ),
          AppSpacing.v8,
          label.text
            .textStyle(AppTextStyles.titleMedium)
            .color(color)
            .make(),
          AppSpacing.v4,
          '$count건 ($percentage%)'.text
            .textStyle(AppTextStyles.bodyMedium)
            .color(color.withOpacity(0.8))
            .make(),
        ],
      ),
    );
  }
  
  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}백만';
    } else if (price >= 10000) {
      return '${(price / 10000).toStringAsFixed(1)}만';
    } else {
      final formatter = price.toStringAsFixed(0);
      final buffer = StringBuffer();
      int digitCount = 0;
      
      for (int i = formatter.length - 1; i >= 0; i--) {
        if (digitCount == 3) {
          buffer.write(',');
          digitCount = 0;
        }
        buffer.write(formatter[i]);
        digitCount++;
      }
      
      return buffer.toString().split('').reversed.join();
    }
  }
}