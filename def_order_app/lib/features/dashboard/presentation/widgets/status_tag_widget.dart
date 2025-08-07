import 'package:flutter/material.dart';
import '../../../../core/utils/velocity_x_compat.dart';
import '../../../../core/theme/app_colors.dart';

/// 40-60대 사용자를 위한 접근성 개선된 상태별 태그 위젯
/// 
/// WCAG AA 준수:
/// - 색상 대비율 4.5:1 이상
/// - 최소 폰트 크기 16sp
/// - 명확한 색상 구분
class StatusTagWidget extends StatelessWidget {
  final String status;
  final String label;
  final IconData? icon;
  final bool isLarge;

  const StatusTagWidget({
    super.key,
    required this.status,
    required this.label,
    this.icon,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(status);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 16 : 12,
        vertical: isLarge ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: statusConfig.backgroundColor,
        borderRadius: BorderRadius.circular(isLarge ? 10 : 8),
        border: Border.all(
          color: statusConfig.borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: isLarge ? 22 : 18,
              color: statusConfig.textColor,
            ),
            (isLarge ? 8 : 6).widthBox,
          ],
          label.text
              .size(isLarge ? 18 : 16)  // 최소 16sp
              .fontWeight(FontWeight.w600)
              .color(statusConfig.textColor)
              .make(),
        ],
      ),
    );
  }

  StatusConfig _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case '대기':
        return StatusConfig(
          backgroundColor: AppColors.warning50,
          borderColor: AppColors.warning200,
          textColor: AppColors.warning900,
        );
      
      case 'confirmed':
      case '확인':
        return StatusConfig(
          backgroundColor: AppColors.primary50,
          borderColor: AppColors.primary200,
          textColor: AppColors.primary900,
        );
      
      case 'processing':
      case '처리중':
        return StatusConfig(
          backgroundColor: const Color(0xFFF3E5F5),  // Purple 50
          borderColor: const Color(0xFFCE93D8),      // Purple 200
          textColor: const Color(0xFF4A148C),        // Purple 900
        );
      
      case 'shipped':
      case '출고':
        return StatusConfig(
          backgroundColor: AppColors.info50,
          borderColor: AppColors.info200,
          textColor: AppColors.info900,
        );
      
      case 'delivered':
      case '배송완료':
        return StatusConfig(
          backgroundColor: AppColors.success50,
          borderColor: AppColors.success200,
          textColor: AppColors.success900,
        );
      
      case 'cancelled':
      case '취소':
        return StatusConfig(
          backgroundColor: AppColors.error50,
          borderColor: AppColors.error200,
          textColor: AppColors.error900,
        );
      
      case 'low':
      case '낮음':
        return StatusConfig(
          backgroundColor: AppColors.success50,
          borderColor: AppColors.success200,
          textColor: AppColors.success900,
        );
      
      case 'medium':
      case '보통':
        return StatusConfig(
          backgroundColor: AppColors.warning50,
          borderColor: AppColors.warning200,
          textColor: AppColors.warning900,
        );
      
      case 'high':
      case '높음':
        return StatusConfig(
          backgroundColor: AppColors.error50,
          borderColor: AppColors.error200,
          textColor: AppColors.error900,
        );
      
      case 'critical':
      case '위험':
        return StatusConfig(
          backgroundColor: const Color(0xFFF3E5F5),  // Purple 50
          borderColor: const Color(0xFFCE93D8),      // Purple 200
          textColor: const Color(0xFF4A148C),        // Purple 900
        );
      
      default:
        return StatusConfig(
          backgroundColor: AppColors.surfaceVariant,
          borderColor: AppColors.border,
          textColor: AppColors.textSecondary,
        );
    }
  }
}

/// 상태별 색상 설정
class StatusConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const StatusConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}

/// 상태별 태그 그룹 위젯
class StatusTagGroup extends StatelessWidget {
  final List<StatusTagItem> items;
  final bool isLarge;
  final double spacing;

  const StatusTagGroup({
    super.key,
    required this.items,
    this.isLarge = false,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: items.map((item) => StatusTagWidget(
        status: item.status,
        label: item.label,
        icon: item.icon,
        isLarge: isLarge,
      )).toList(),
    );
  }
}

/// 상태 태그 아이템
class StatusTagItem {
  final String status;
  final String label;
  final IconData? icon;

  const StatusTagItem({
    required this.status,
    required this.label,
    this.icon,
  });
}

/// 재고 상태 표시 위젯
class StockStatusIndicator extends StatelessWidget {
  final int quantity;
  final int threshold;
  final bool showQuantity;

  const StockStatusIndicator({
    super.key,
    required this.quantity,
    this.threshold = 100,
    this.showQuantity = true,
  });

  @override
  Widget build(BuildContext context) {
    final isLow = quantity < threshold;
    final isCritical = quantity < (threshold * 0.3);
    
    String status;
    String label;
    IconData icon;
    
    if (isCritical) {
      status = 'critical';
      label = '위험';
      icon = Icons.error;
    } else if (isLow) {
      status = 'medium';
      label = '부족';
      icon = Icons.warning;
    } else {
      status = 'low';
      label = '정상';
      icon = Icons.check_circle;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _getStatusConfig(status).backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getStatusConfig(status).borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: _getStatusConfig(status).textColor,
          ),
          8.widthBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label.text
                  .size(16)
                  .fontWeight(FontWeight.w600)
                  .color(_getStatusConfig(status).textColor)
                  .make(),
              if (showQuantity) ...[
                2.heightBox,
                '재고: $quantity'.text
                    .size(14)
                    .color(_getStatusConfig(status).textColor.withOpacity(0.8))
                    .make(),
              ],
            ],
          ),
        ],
      ),
    );
  }
  
  StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case 'critical':
        return StatusConfig(
          backgroundColor: AppColors.error50,
          borderColor: AppColors.error200,
          textColor: AppColors.error900,
        );
      case 'medium':
        return StatusConfig(
          backgroundColor: AppColors.warning50,
          borderColor: AppColors.warning200,
          textColor: AppColors.warning900,
        );
      default:
        return StatusConfig(
          backgroundColor: AppColors.success50,
          borderColor: AppColors.success200,
          textColor: AppColors.success900,
        );
    }
  }
}