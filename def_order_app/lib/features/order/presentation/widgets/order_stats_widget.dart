import 'package:flutter/material.dart';
import '../../../../core/utils/widget_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/order_provider.dart';

class OrderStatsWidget extends ConsumerWidget {
  const OrderStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(orderStatsProvider());
    final NumberFormat currencyFormat = NumberFormat('#,###');

    if (statsState.isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (statsState.error != null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.grey[400], size: 32),
            const SizedBox(height: 8),
            const Text(
              '통계를 불러올 수 없습니다',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final stats = statsState.stats;
    if (stats == null) {
      return const SizedBox.shrink();
    }

    final totalOrders = stats['total_orders'] as int? ?? 0;
    final totalAmount = stats['total_amount'] as double? ?? 0;
    final totalQuantity = stats['total_quantity'] as int? ?? 0;
    final statusCount = stats['status_count'] as Map<String, dynamic>? ?? {};

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Text(
            '주문 통계',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // 주요 지표
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: '총 주문',
                  value: totalOrders.toString(),
                  suffix: '건',
                  color: AppTheme.primaryColor,
                  icon: Icons.receipt_long_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: '총 금액',
                  value: currencyFormat.format(totalAmount),
                  suffix: '원',
                  color: Colors.green,
                  icon: Icons.attach_money,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: '총 수량',
                  value: currencyFormat.format(totalQuantity),
                  suffix: 'L',
                  color: Colors.blue,
                  icon: Icons.local_drink_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: '평균 단가',
                  value: totalQuantity > 0 
                      ? currencyFormat.format((totalAmount / totalQuantity).round())
                      : '0',
                  suffix: '원/L',
                  color: Colors.orange,
                  icon: Icons.trending_up,
                ),
              ),
            ],
          ),
          
          if (statusCount.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              '상태별 현황',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatusGrid(statusCount),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String suffix,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                suffix,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusGrid(Map<String, dynamic> statusCount) {
    final statusList = [
      {'key': 'draft', 'name': '임시저장', 'color': Colors.grey},
      {'key': 'pending', 'name': '주문대기', 'color': Colors.orange},
      {'key': 'confirmed', 'name': '주문확정', 'color': Colors.blue},
      {'key': 'shipped', 'name': '출고완료', 'color': Colors.purple},
      {'key': 'completed', 'name': '배송완료', 'color': Colors.green},
      {'key': 'cancelled', 'name': '주문취소', 'color': Colors.red},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: statusList.map((status) {
        final count = statusCount[status['key']] as int? ?? 0;
        if (count == 0) return const SizedBox.shrink();
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (status['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (status['color'] as Color).withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: status['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${status['name']} $count건',
                style: TextStyle(
                  fontSize: 10,
                  color: status['color'] as Color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}