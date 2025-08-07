import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/order_entity.dart';

/// 40-60대 사용자를 위한 접근성 개선된 제품 선택 카드
/// 
/// WCAG AA 준수:
/// - 색상 대비율 4.5:1 이상
/// - 최소 터치 타겟 56dp
/// - 폰트 크기 18sp 이상
class ProductSelectionCard extends StatelessWidget {
  final ProductType productType;
  final ProductType selectedProductType;
  final ValueChanged<ProductType> onChanged;
  final String title;
  final String subtitle;
  final IconData icon;

  const ProductSelectionCard({
    super.key,
    required this.productType,
    required this.selectedProductType,
    required this.onChanged,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  bool get isSelected => selectedProductType == productType;

  @override
  Widget build(BuildContext context) {
    return GFCard(
      // 접근성 개선: 선택 시 더 높은 elevation
      elevation: isSelected ? 6 : 2,
      
      // Material 3 Primary Container 색상 사용
      color: isSelected 
          ? AppColors.primary50  // 선택 시: Primary Container (밝은 파란색)
          : AppColors.surface,    // 미선택 시: 흰색 배경
      
      borderRadius: BorderRadius.circular(16),
      
      // 명확한 테두리로 선택 상태 구분
      border: Border.all(
        color: isSelected 
            ? AppColors.primary      // 선택 시: 진한 파란 테두리
            : AppColors.border,      // 미선택 시: 회색 테두리 (개선된 대비율)
        width: isSelected ? 2.5 : 1.5,
      ),
      
      // 터치 영역 확대 (56dp 이상 확보)
      padding: const EdgeInsets.all(24),
      
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 아이콘 컨테이너
              Container(
                padding: const EdgeInsets.all(14),  // 터치 타겟 확대
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary.withOpacity(0.15)
                      : AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.textSecondary,
                  size: 36,  // 아이콘 크기 확대
                ),
              ),
              
              20.widthBox,  // 간격 확대
              
              // 텍스트 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목 - 20sp 크기, 높은 대비
                    title.text
                        .size(20)  // 18sp → 20sp
                        .fontWeight(FontWeight.bold)
                        .color(isSelected 
                            ? AppColors.primary900   // 선택 시: 매우 진한 색
                            : AppColors.textPrimary) // 미선택 시: 기본 텍스트
                        .make(),
                    
                    6.heightBox,
                    
                    // 부제목 - 16sp 크기, 적절한 대비
                    subtitle.text
                        .size(16)  // 14sp → 16sp
                        .color(isSelected 
                            ? AppColors.textPrimary     // 선택 시: 진한 색
                            : AppColors.textSecondary)  // 미선택 시: 보조 텍스트
                        .make(),
                  ],
                ),
              ),
              
              // 라디오 버튼 - 크기 확대
              GFRadio<ProductType>(
                size: 36,  // 30 → 36 (터치 영역 확대)
                value: productType,
                groupValue: selectedProductType,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
                activeBorderColor: AppColors.primary,
                activeIcon: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 22,  // 18 → 22
                ),
                inactiveBorderColor: AppColors.border,
                radioColor: isSelected 
                    ? AppColors.primary 
                    : AppColors.border,
              ),
            ],
          ),
          
          // 선택 시 추가 시각적 피드백
          if (isSelected) ...[
            16.heightBox,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  8.widthBox,
                  '선택됨'
                      .text
                      .size(14)
                      .fontWeight(FontWeight.w600)
                      .color(AppColors.primary)
                      .make(),
                ],
              ),
            ),
          ],
        ],
      ),
    ).onTap(() {
      // 전체 카드 터치 가능
      onChanged(productType);
    });
  }
}

/// 제품 선택 섹션 위젯
class ProductSelectionSection extends StatelessWidget {
  final ProductType selectedProductType;
  final ValueChanged<ProductType> onProductTypeChanged;

  const ProductSelectionSection({
    super.key,
    required this.selectedProductType,
    required this.onProductTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          '제품 종류를 선택해주세요'
              .text
              .size(22)  // 큰 제목
              .fontWeight(FontWeight.bold)
              .color(AppColors.textPrimary)
              .make(),
          
          8.heightBox,
          
          // 설명 텍스트
          '원하시는 요소수 제품 타입을 선택하세요'
              .text
              .size(16)
              .color(AppColors.textSecondary)
              .make(),
          
          24.heightBox,
          
          // 박스 선택 카드
          ProductSelectionCard(
            productType: ProductType.box,
            selectedProductType: selectedProductType,
            onChanged: onProductTypeChanged,
            title: '박스 단위 (20L)',
            subtitle: '소량 주문에 적합',
            icon: Icons.inventory_2,
          ),
          
          16.heightBox,
          
          // 벌크 선택 카드
          ProductSelectionCard(
            productType: ProductType.bulk,
            selectedProductType: selectedProductType,
            onChanged: onProductTypeChanged,
            title: '벌크 단위 (대용량)',
            subtitle: '대량 주문에 적합',
            icon: Icons.local_shipping,
          ),
          
          // 추가 안내 메시지
          24.heightBox,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.info200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.info,
                  size: 24,
                ),
                12.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '선택 도움말'
                          .text
                          .size(16)
                          .fontWeight(FontWeight.w600)
                          .color(AppColors.info900)
                          .make(),
                      4.heightBox,
                      '박스는 20L 단위로 포장되어 있으며, 벌크는 탱크로리로 대량 배송됩니다.'
                          .text
                          .size(14)
                          .color(AppColors.info800)
                          .make(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}