import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/index.dart';
import '../../../order/data/models/order_model.dart';

/// 주문 내역 카드 위젯
/// 40-60대 사용자를 위한 큰 폰트와 명확한 정보 표시
class OrderHistoryCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final VoidCallback? onViewStatement;
  
  const OrderHistoryCard({
    super.key,
    required this.order,
    this.onTap,
    this.onViewStatement,
  });
  
  @override
  Widget build(BuildContext context) {
    return GFCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(AppSpacing.lg),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      content: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 (주문번호, 상태)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '주문번호 ${order.orderNumber}'.text
                        .textStyle(AppTextStyles.titleMedium)
                        .make(),
                      AppSpacing.v4,
                      _formatDate(order.createdAt).text
                        .textStyle(AppTextStyles.bodyMedium)
                        .color(AppColors.textSecondary)
                        .make(),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            
            AppSpacing.v16,
            const Divider(),
            AppSpacing.v16,
            
            // 주문 정보
            Row(
              children: [
                // 제품 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.inventory_2_rounded,
                        order.productType == ProductType.box ? '박스' : '벌크',
                        AppColors.primary,
                      ),
                      AppSpacing.v8,
                      _buildInfoRow(
                        Icons.numbers_rounded,
                        '${order.quantity}개',
                        AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                // 배송 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        order.deliveryMethod == DeliveryMethod.directPickup
                          ? Icons.store_rounded
                          : Icons.local_shipping_rounded,
                        order.deliveryMethod == DeliveryMethod.directPickup
                          ? '직접수령'
                          : '배송',
                        AppColors.info,
                      ),
                      AppSpacing.v8,
                      _buildInfoRow(
                        Icons.calendar_today_rounded,
                        _formatDate(order.deliveryDate),
                        AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            AppSpacing.v16,
            
            // 금액
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  '총 금액'.text
                    .textStyle(AppTextStyles.titleSmall)
                    .color(AppColors.textSecondary)
                    .make(),
                  '${_formatPrice(order.totalPrice)}원'.text
                    .textStyle(AppTextStyles.headlineSmall)
                    .color(AppColors.primary)
                    .make(),
                ],
              ),
            ),
            
            // 액션 버튼
            if (order.status == OrderStatus.completed || 
                order.status == OrderStatus.shipped) ...[
              AppSpacing.v16,
              Row(
                children: [
                  Expanded(
                    child: GFButton(
                      onPressed: onViewStatement,
                      text: '거래명세서',
                      icon: Icon(
                        Icons.description_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      textStyle: AppTextStyles.button.copyWith(
                        color: AppColors.primary,
                      ),
                      size: GFSize.LARGE,
                      type: GFButtonType.outline,
                      color: AppColors.primary,
                      shape: GFButtonShape.pills,
                    ),
                  ),
                  AppSpacing.h12,
                  Expanded(
                    child: GFButton(
                      onPressed: () {
                        // TODO: 재주문 기능
                      },
                      text: '재주문',
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
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
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusBadge() {
    Color badgeColor;
    String statusText;
    IconData statusIcon;
    
    switch (order.status) {
      case OrderStatus.pending:
        badgeColor = AppColors.warning;
        statusText = '주문대기';
        statusIcon = Icons.schedule_rounded;
        break;
      case OrderStatus.confirmed:
        badgeColor = AppColors.info;
        statusText = '주문확정';
        statusIcon = Icons.check_circle_rounded;
        break;
      case OrderStatus.shipped:
        badgeColor = AppColors.primary;
        statusText = '출고완료';
        statusIcon = Icons.local_shipping_rounded;
        break;
      case OrderStatus.completed:
        badgeColor = AppColors.success;
        statusText = '배송완료';
        statusIcon = Icons.done_all_rounded;
        break;
      case OrderStatus.cancelled:
        badgeColor = AppColors.error;
        statusText = '주문취소';
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        badgeColor = AppColors.textSecondary;
        statusText = '';
        statusIcon = Icons.help_outline_rounded;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 20,
            color: badgeColor,
          ),
          AppSpacing.h6,
          statusText.text
            .textStyle(AppTextStyles.labelLarge)
            .color(badgeColor)
            .make(),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
        AppSpacing.h8,
        text.text
          .textStyle(AppTextStyles.bodyMedium)
          .make(),
      ],
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
  
  String _formatPrice(double price) {
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