import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/widget_extensions.dart';
import '../../data/models/inventory_model.dart';

/// 위치별 재고 카드 위젯
/// 
/// 40-60대 접근성을 고려한 큰 글씨와 명확한 색상 구분
class LocationInventoryCard extends StatelessWidget {
  final String locationName;
  final String location;
  final List<InventoryModel> inventories;
  final Color color;
  final IconData icon;

  const LocationInventoryCard({
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: summary.hasCriticalStock 
            ? Border.all(color: Colors.orange[300]!, width: 2) 
            : null,
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
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    locationName.text.size(24).bold.make(),
                    const SizedBox(height: 8),
                    if (summary.hasCriticalStock)
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange[700], size: 18),
                          const SizedBox(width: 6),
                          '재고 부족 주의'.text
                              .size(16)
                              .color(Colors.orange[700])
                              .make(),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[600], size: 18),
                          const SizedBox(width: 6),
                          '정상 운영'.text.size(16).color(Colors.green[600]).make(),
                        ],
                      ),
                  ],
                ),
              ),
              // 총 아이템 수
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    summary.totalItems.toString().text
                        .size(20)
                        .bold
                        .color(color)
                        .make(),
                    '품목'.text.size(14).color(color).make(),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 제품별 재고 현황
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // 박스 재고 (20L)
                _buildProductRow(
                  '박스 재고 (20L)',
                  summary.boxQuantity,
                  '박스',
                  Icons.inventory_2,
                  Colors.blue,
                  formatter,
                  threshold: 50,
                ),
                
                const SizedBox(height: 16),
                
                // 구분선
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                
                const SizedBox(height: 16),
                
                // 벌크 재고 (1000L)
                _buildProductRow(
                  '벌크 재고 (1000L)',
                  summary.bulkQuantity,
                  '탱크',
                  Icons.storage,
                  Colors.green,
                  formatter,
                  threshold: 10,
                ),
                
                const SizedBox(height: 16),
                
                // 구분선
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                
                const SizedBox(height: 16),
                
                // 빈 탱크
                _buildProductRow(
                  '빈 탱크',
                  summary.emptyTankQuantity,
                  '개',
                  Icons.propane_tank,
                  Colors.grey[600]!,
                  formatter,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 상세 정보 버튼
          SizedBox(
            width: double.infinity,
            child: GFButton(
              onPressed: () {
                _showDetailDialog(context, summary);
              },
              text: '상세 정보 보기',
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              size: 50,
              fullWidthButton: true,
              color: color,
              shape: GFButtonShape.pills,
              icon: Icon(Icons.info_outline, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  /// 제품별 재고 행
  Widget _buildProductRow(
    String productName,
    int quantity,
    String unit,
    IconData icon,
    Color iconColor,
    NumberFormat formatter, {
    int? threshold,
  }) {
    final isLowStock = threshold != null && quantity <= threshold;
    
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productName.text.size(18).bold.make(),
              const SizedBox(height: 4),
              if (isLowStock)
                '재고 부족 (${threshold}${unit} 이하)'.text
                    .size(14)
                    .color(Colors.orange[700])
                    .make()
              else
                '정상 재고'.text.size(14).color(Colors.green[600]).make(),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            formatter.format(quantity).text
                .size(22)
                .bold
                .color(isLowStock ? Colors.orange[700] : iconColor)
                .make(),
            unit.text.size(14).gray500.make(),
          ],
        ),
      ],
    );
  }

  /// 상세 정보 다이얼로그
  void _showDetailDialog(BuildContext context, LocationInventorySummary summary) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        '$locationName 상세 정보'.text.size(20).bold.make(),
                        '총 ${summary.totalItems}개 품목'.text
                            .size(16)
                            .gray600
                            .make(),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 개별 재고 목록
              '개별 재고 현황'.text.size(18).bold.make(),
              const SizedBox(height: 16),

              ...inventories.map((inventory) => _buildInventoryDetailTile(inventory)),

              const SizedBox(height: 20),

              // 닫기 버튼
              SizedBox(
                width: double.infinity,
                child: GFButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: '닫기',
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  size: 48,
                  fullWidthButton: true,
                  color: color,
                  shape: GFButtonShape.pills,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 재고 상세 타일
  Widget _buildInventoryDetailTile(InventoryModel inventory) {
    final productName = inventory.productType == 'box' ? '박스 (20L)' : '벌크 (1000L)';
    final unit = inventory.productType == 'box' ? '박스' : '탱크';
    final threshold = inventory.productType == 'box' ? 50 : 10;
    final isLowStock = inventory.currentQuantity <= threshold;
    final formatter = NumberFormat('#,###');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLowStock ? Colors.orange[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: isLowStock ? Border.all(color: Colors.orange[300]!) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isLowStock 
                  ? Colors.orange.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              inventory.productType == 'box' ? Icons.inventory_2 : Icons.storage,
              color: isLowStock ? Colors.orange[700] : Colors.grey[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productName.text.size(16).bold.make(),
                const SizedBox(height: 4),
                Row(
                  children: [
                    '현재: ${formatter.format(inventory.currentQuantity)}$unit'.text
                        .size(14)
                        .color(isLowStock ? Colors.orange[700] : Colors.grey[700])
                        .make(),
                    if (inventory.emptyTankQuantity > 0) ...[
                      ' • '.text.gray500.make(),
                      '빈탱크: ${inventory.emptyTankQuantity}개'.text
                          .size(14)
                          .gray600
                          .make(),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isLowStock)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: '부족'.text.size(12).color(Colors.orange[700]).make(),
            ),
        ],
      ),
    );
  }
}