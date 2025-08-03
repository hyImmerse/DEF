import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/usecases/check_inventory_usecase.dart';

/// 재고 상태 위젯
/// 
/// 주문하려는 제품의 재고 상황을 표시하는 위젯입니다.
/// 재고 수준, 주문 가능 여부, 대안 옵션 등을 시각적으로 보여줍니다.
class InventoryStatusWidget extends StatelessWidget {
  final InventoryCheckResult inventoryCheck;
  final bool isLoading;

  const InventoryStatusWidget({
    super.key,
    required this.inventoryCheck,
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
        // 재고 상태 헤더
        _buildStatusHeader(),
        const SizedBox(height: 16),
        
        // 재고 세부 정보
        _buildInventoryDetails(),
        const SizedBox(height: 16),
        
        // 추천 사항
        if (inventoryCheck.recommendations.isNotEmpty) ...[
          _buildRecommendations(),
          const SizedBox(height: 16),
        ],
        
        // 대안 옵션
        if (inventoryCheck.alternativeOptions.isNotEmpty) ...[
          _buildAlternativeOptions(),
          const SizedBox(height: 16),
        ],
        
        // 재입고 예상일
        if (inventoryCheck.estimatedRestockDate != null) ...[
          _buildRestockInfo(),
        ],
      ],
    );
  }

  /// 상태 헤더
  Widget _buildStatusHeader() {
    final color = _getStatusColor();
    final icon = _getStatusIcon();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inventoryCheck.stockLevel.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  inventoryCheck.stockLevel.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: inventoryCheck.isAvailable ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              inventoryCheck.isAvailable ? '주문 가능' : '주문 불가',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 재고 세부 정보
  Widget _buildInventoryDetails() {
    return Column(
      children: [
        _buildInventoryRow(
          '요청 수량',
          '${inventoryCheck.requestedQuantity}개',
          null,
        ),
        _buildInventoryRow(
          '현재 재고',
          '${inventoryCheck.currentStock}개',
          null,
        ),
        if (inventoryCheck.reservedStock > 0)
          _buildInventoryRow(
            '예약된 재고',
            '${inventoryCheck.reservedStock}개',
            Colors.orange,
          ),
        _buildInventoryRow(
          '주문 가능 재고',
          '${inventoryCheck.availableStock}개',
          inventoryCheck.isAvailable ? Colors.green : Colors.red,
        ),
        
        // 충족률 표시
        const SizedBox(height: 12),
        _buildFulfillmentRate(),
      ],
    );
  }

  /// 충족률 표시
  Widget _buildFulfillmentRate() {
    final rate = inventoryCheck.fulfillmentRate;
    final color = rate >= 1.0 ? Colors.green : 
                  rate >= 0.5 ? Colors.orange : Colors.red;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '충족률',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '${(rate * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: rate,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  /// 추천 사항
  Widget _buildRecommendations() {
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
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '추천 사항',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...inventoryCheck.recommendations.map(
            (recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $recommendation',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 대안 옵션
  Widget _buildAlternativeOptions() {
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
          Row(
            children: [
              Icon(
                Icons.alt_route,
                color: Colors.green.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '대안 옵션',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...inventoryCheck.alternativeOptions.map(
            (option) => _buildAlternativeOption(option),
          ),
        ],
      ),
    );
  }

  /// 대안 옵션 항목
  Widget _buildAlternativeOption(AlternativeOption option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            option.description,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '가능 수량: ${option.availableQuantity}개',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              if (option.unitPrice > 0)
                Text(
                  NumberFormat('#,###원').format(option.unitPrice),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// 재입고 정보
  Widget _buildRestockInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: Colors.amber.shade700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '재입고 예정일',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('yyyy년 MM월 dd일').format(inventoryCheck.estimatedRestockDate!),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 재고 행 빌더
  Widget _buildInventoryRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 상태별 색상
  Color _getStatusColor() {
    switch (inventoryCheck.stockLevel) {
      case StockLevel.outOfStock:
        return Colors.red;
      case StockLevel.critical:
        return Colors.red.shade400;
      case StockLevel.low:
        return Colors.orange;
      case StockLevel.medium:
        return Colors.blue;
      case StockLevel.high:
        return Colors.green;
    }
  }

  /// 상태별 아이콘
  IconData _getStatusIcon() {
    switch (inventoryCheck.stockLevel) {
      case StockLevel.outOfStock:
        return Icons.remove_circle_outline;
      case StockLevel.critical:
        return Icons.warning_amber_outlined;
      case StockLevel.low:
        return Icons.error_outline;
      case StockLevel.medium:
        return Icons.info_outline;
      case StockLevel.high:
        return Icons.check_circle_outline;
    }
  }
}