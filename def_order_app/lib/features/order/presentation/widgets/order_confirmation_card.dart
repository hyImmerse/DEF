import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/order_entity.dart';

/// 40-60대 사용자를 위한 접근성 개선된 주문 확인 카드
/// 
/// WCAG AA 준수:
/// - 색상 대비율 4.5:1 이상
/// - 폰트 크기 16sp 이상
/// - 명확한 정보 계층 구조
class OrderConfirmationCard extends StatelessWidget {
  final ProductType productType;
  final int quantity;
  final int emptyReturn;
  final DateTime deliveryDate;
  final String address;
  final String? note;

  const OrderConfirmationCard({
    super.key,
    required this.productType,
    required this.quantity,
    required this.emptyReturn,
    required this.deliveryDate,
    required this.address,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return GFCard(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      color: AppColors.surface,  // 흰색 배경
      border: Border.all(
        color: AppColors.primary200,
        width: 1.5,
      ),
      padding: const EdgeInsets.all(24),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카드 헤더
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shopping_cart_checkout,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                16.widthBox,
                '주문 요약'.text
                    .size(22)
                    .fontWeight(FontWeight.bold)
                    .color(AppColors.primary900)
                    .make(),
              ],
            ),
          ),
          
          20.heightBox,
          
          // 주요 정보 섹션 (강조)
          _buildPrimarySection(),
          
          // 구분선
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: 1,
            color: AppColors.divider,
          ),
          
          // 배송 정보 섹션
          _buildDeliverySection(),
          
          // 추가 정보 섹션 (있는 경우)
          if (emptyReturn > 0 || note != null) ...[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 1,
              color: AppColors.divider,
            ),
            _buildAdditionalSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildPrimarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: '주문 내역'.text
              .size(16)
              .fontWeight(FontWeight.w600)
              .color(AppColors.primary)
              .make(),
        ),
        
        16.heightBox,
        
        // 제품 종류
        _buildInfoRow(
          icon: Icons.inventory_2,
          label: '제품 종류',
          value: productType == ProductType.box 
              ? '박스 단위 (20L)' 
              : '벌크 단위',
          isPrimary: true,
        ),
        
        12.heightBox,
        
        // 주문 수량
        _buildInfoRow(
          icon: Icons.add_shopping_cart,
          label: '주문 수량',
          value: '$quantity ${productType == ProductType.box ? '박스' : '벌크'}',
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildDeliverySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.info50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: '배송 정보'.text
              .size(16)
              .fontWeight(FontWeight.w600)
              .color(AppColors.info800)
              .make(),
        ),
        
        16.heightBox,
        
        // 배송 희망일
        _buildInfoRow(
          icon: Icons.calendar_today,
          label: '배송 희망일',
          value: '${deliveryDate.year}년 ${deliveryDate.month}월 ${deliveryDate.day}일',
          isPrimary: false,
        ),
        
        12.heightBox,
        
        // 배송 주소
        _buildInfoRow(
          icon: Icons.location_on,
          label: '배송 주소',
          value: address,
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildAdditionalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: '추가 정보'.text
              .size(16)
              .fontWeight(FontWeight.w600)
              .color(AppColors.textSecondary)
              .make(),
        ),
        
        16.heightBox,
        
        // 빈 용기 반납
        if (emptyReturn > 0) ...[
          _buildInfoRow(
            icon: Icons.recycling,
            label: '빈 용기 반납',
            value: '$emptyReturn 개',
            isPrimary: false,
          ),
          if (note != null) 12.heightBox,
        ],
        
        // 요청사항
        if (note != null)
          _buildInfoRow(
            icon: Icons.note,
            label: '요청사항',
            value: note!,
            isPrimary: false,
          ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isPrimary 
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isPrimary ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
          ),
          
          16.widthBox,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label.text
                    .size(16)
                    .color(AppColors.textSecondary)
                    .make(),
                
                4.heightBox,
                
                value.text
                    .size(isPrimary ? 20 : 18)
                    .fontWeight(isPrimary ? FontWeight.bold : FontWeight.w600)
                    .color(isPrimary ? AppColors.primary900 : AppColors.textPrimary)
                    .lineHeight(1.4)
                    .make(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// PDF 알림 메시지 위젯
class PDFNotificationMessage extends StatelessWidget {
  const PDFNotificationMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.info50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info200,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.info100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              color: AppColors.info,
              size: 28,
            ),
          ),
          
          16.widthBox,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                '안내'.text
                    .size(16)
                    .fontWeight(FontWeight.bold)
                    .color(AppColors.info900)
                    .make(),
                
                4.heightBox,
                
                '주문 확정 후 PDF 주문서가 생성됩니다'
                    .text
                    .size(18)  // 16sp → 18sp
                    .color(AppColors.info800)
                    .lineHeight(1.4)
                    .make(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}