import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/usecases/calculate_price_usecase.dart';

/// 가격 분석 위젯
/// 
/// 주문의 가격을 상세하게 보여주는 위젯입니다.
/// 기본 금액, 배송비, 추가 비용, 할인 등을 포함한 전체 가격 구조를 표시합니다.
class PriceBreakdownWidget extends StatelessWidget {
  final PriceCalculationResult priceCalculation;
  final bool isLoading;

  const PriceBreakdownWidget({
    super.key,
    required this.priceCalculation,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 기본 정보
        _buildBasicInfo(),
        const SizedBox(height: 16),
        
        // 가격 분석
        _buildPriceBreakdown(),
        const SizedBox(height: 16),
        
        // 추가 비용
        if (priceCalculation.additionalCosts.total > 0) ...[
          _buildAdditionalCosts(),
          const SizedBox(height: 16),
        ],
        
        // 할인 정보
        if (priceCalculation.discounts.total > 0) ...[
          _buildDiscounts(),
          const SizedBox(height: 16),
        ],
        
        // 최종 금액
        _buildFinalTotal(),
        
        // 절약 정보
        if (priceCalculation.totalSavings > 0) ...[
          const SizedBox(height: 12),
          _buildSavingsInfo(),
        ],
        
        // 특별 안내
        if (priceCalculation.isUrgentDelivery || priceCalculation.isWeekendDelivery) ...[
          const SizedBox(height: 16),
          _buildSpecialNotice(),
        ],
      ],
    );
  }

  /// 기본 정보
  Widget _buildBasicInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '사용자 등급',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                _getGradeDisplayName(priceCalculation.userGrade),
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (priceCalculation.gradeDiscountRate > 0) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '등급 할인율',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${priceCalculation.gradeDiscountRate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 가격 분석
  Widget _buildPriceBreakdown() {
    return Column(
      children: [
        _buildPriceRow(
          '단가',
          priceCalculation.unitPrice,
          subText: '${priceCalculation.quantity}개',
        ),
        _buildPriceRow(
          '소계',
          priceCalculation.subtotal,
          isSubtotal: true,
        ),
        if (priceCalculation.shippingCost > 0)
          _buildPriceRow(
            '배송비',
            priceCalculation.shippingCost,
            isAdditional: true,
          ),
      ],
    );
  }

  /// 추가 비용
  Widget _buildAdditionalCosts() {
    final costs = priceCalculation.additionalCosts;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '추가 비용',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 8),
          
          if (costs.javaraFee > 0)
            _buildPriceRow(
              '자바라 수수료',
              costs.javaraFee,
              textColor: Colors.orange.shade700,
            ),
            
          if (costs.handlingFee > 0)
            _buildPriceRow(
              '대량 처리 수수료',
              costs.handlingFee,
              textColor: Colors.orange.shade700,
            ),
            
          if (costs.urgencyFee > 0)
            _buildPriceRow(
              '긴급 처리 수수료',
              costs.urgencyFee,
              textColor: Colors.orange.shade700,
            ),
        ],
      ),
    );
  }

  /// 할인 정보
  Widget _buildDiscounts() {
    final discounts = priceCalculation.discounts;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '할인 적용',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 8),
          
          if (discounts.volumeDiscount > 0)
            _buildPriceRow(
              '대량 주문 할인',
              -discounts.volumeDiscount,
              textColor: Colors.green.shade700,
            ),
            
          if (discounts.loyaltyDiscount > 0)
            _buildPriceRow(
              '충성 고객 할인',
              -discounts.loyaltyDiscount,
              textColor: Colors.green.shade700,
            ),
            
          if (discounts.promotionDiscount > 0)
            _buildPriceRow(
              '프로모션 할인',
              -discounts.promotionDiscount,
              textColor: Colors.green.shade700,
            ),
        ],
      ),
    );
  }

  /// 최종 금액
  Widget _buildFinalTotal() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '최종 결제 금액',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            NumberFormat('#,###원').format(priceCalculation.finalTotal),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// 절약 정보
  Widget _buildSavingsInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.savings,
            color: Colors.green.shade600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '총 ${NumberFormat('#,###원').format(priceCalculation.totalSavings)} 절약',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 특별 안내
  Widget _buildSpecialNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.amber.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '특별 안내',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          if (priceCalculation.isUrgentDelivery)
            Text(
              '• 긴급 배송 (3일 이내): 추가 비용이 적용됩니다.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber.shade700,
              ),
            ),
            
          if (priceCalculation.isWeekendDelivery)
            Text(
              '• 주말 배송: 추가 배송비가 적용됩니다.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber.shade700,
              ),
            ),
        ],
      ),
    );
  }

  /// 가격 행 빌더
  Widget _buildPriceRow(
    String label,
    double amount, {
    String? subText,
    bool isSubtotal = false,
    bool isAdditional = false,
    Color? textColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isSubtotal ? 8 : 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSubtotal ? FontWeight.w600 : FontWeight.normal,
                  color: textColor,
                ),
              ),
              if (subText != null) ...[
                const SizedBox(width: 4),
                Text(
                  '($subText)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
          Text(
            NumberFormat('#,###원').format(amount.abs()),
            style: TextStyle(
              fontWeight: isSubtotal ? FontWeight.w600 : FontWeight.normal,
              color: textColor ?? (amount < 0 ? Colors.green.shade700 : null),
            ),
          ),
        ],
      ),
    );
  }

  /// 등급 표시명 변환
  String _getGradeDisplayName(String grade) {
    switch (grade) {
      case 'dealer':
      case 'agent':
        return '대리점';
      case 'regular':
      default:
        return '일반 거래처';
    }
  }
}