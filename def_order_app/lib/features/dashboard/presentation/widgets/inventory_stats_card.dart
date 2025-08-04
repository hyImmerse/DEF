import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/widget_extensions.dart';

/// 재고 통계 카드 위젯
/// 
/// 40-60대 접근성을 고려한 큰 글씨와 명확한 색상 구분
class InventoryStatsCard extends StatelessWidget {
  final String title;
  final int totalQuantity;
  final int factoryQuantity;
  final int warehouseQuantity;
  final String unit;
  final Color color;
  final IconData icon;

  const InventoryStatsCard({
    super.key,
    required this.title,
    required this.totalQuantity,
    required this.factoryQuantity,
    required this.warehouseQuantity,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final isLowStock = _isLowStock();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isLowStock ? Border.all(color: Colors.orange[300]!, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 섹션
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title.text.size(18).bold.make(),
                    const SizedBox(height: 4),
                    if (isLowStock)
                      '재고 부족 주의'.text
                          .size(14)
                          .color(Colors.orange[700])
                          .make()
                    else
                      '정상'.text.size(14).color(Colors.green[600]).make(),
                  ],
                ),
              ),
              // 총 수량 표시
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  formatter.format(totalQuantity).text
                      .size(28)
                      .bold
                      .color(isLowStock ? Colors.orange[700] : color)
                      .make(),
                  unit.text.size(16).gray500.make(),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 위치별 재고 현황
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // 공장 재고
                _buildLocationRow(
                  '공장',
                  factoryQuantity,
                  Icons.factory,
                  Colors.orange,
                  formatter,
                ),
                
                const SizedBox(height: 12),
                
                // 구분선
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                
                const SizedBox(height: 12),
                
                // 창고 재고
                _buildLocationRow(
                  '창고',
                  warehouseQuantity,
                  Icons.warehouse,
                  Colors.teal,
                  formatter,
                ),
              ],
            ),
          ),

          // 재고 비율 표시
          const SizedBox(height: 16),
          _buildStockRatio(),
        ],
      ),
    );
  }

  /// 위치별 재고 행
  Widget _buildLocationRow(
    String locationName,
    int quantity,
    IconData icon,
    Color iconColor,
    NumberFormat formatter,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: locationName.text.size(16).bold.make(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            formatter.format(quantity).text
                .size(18)
                .bold
                .make(),
            unit.text.size(12).gray500.make(),
          ],
        ),
      ],
    );
  }

  /// 재고 비율 표시 (진행률 바)
  Widget _buildStockRatio() {
    final factoryRatio = totalQuantity > 0 ? factoryQuantity / totalQuantity : 0.0;
    final warehouseRatio = totalQuantity > 0 ? warehouseQuantity / totalQuantity : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            '재고 분포'.text.size(14).bold.gray700.make(),
            '${(factoryRatio * 100).toInt()}% : ${(warehouseRatio * 100).toInt()}%'
                .text.size(14).gray600.make(),
          ],
        ),
        const SizedBox(height: 8),
        
        // 재고 분포 바
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          child: Row(
            children: [
              if (factoryRatio > 0)
                Expanded(
                  flex: (factoryRatio * 100).round(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              if (warehouseRatio > 0)
                Expanded(
                  flex: (warehouseRatio * 100).round(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 범례
        Row(
          children: [
            _buildLegendItem('공장', Colors.orange),
            const SizedBox(width: 16),
            _buildLegendItem('창고', Colors.teal),
          ],
        ),
      ],
    );
  }

  /// 범례 아이템
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        label.text.size(12).gray600.make(),
      ],
    );
  }

  /// 재고 부족 여부 판단
  bool _isLowStock() {
    if (unit == '박스') {
      return totalQuantity <= 100; // 박스 100개 이하
    } else if (unit == '탱크') {
      return totalQuantity <= 20;  // 벌크 20개 이하
    }
    return false;
  }
}