import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/widget_extensions.dart';

/// 위험 재고 알림 배너 위젯
/// 
/// 40-60대 접근성을 고려한 명확한 색상과 큰 글씨
class CriticalStockAlert extends StatelessWidget {
  final int criticalCount;
  final VoidCallback onViewDetails;

  const CriticalStockAlert({
    super.key,
    required this.criticalCount,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange[100]!,
            Colors.red[50]!,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 경고 헤더
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: 32,
                  color: Colors.orange[800],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '재고 부족 경고'.text
                        .size(20)
                        .bold
                        .color(Colors.orange[800])
                        .make(),
                    const SizedBox(height: 4),
                    '즉시 확인이 필요한 재고가 있습니다'.text
                        .size(16)
                        .color(Colors.orange[700])
                        .make(),
                  ],
                ),
              ),
              // 위험 품목 수
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Column(
                  children: [
                    criticalCount.toString().text
                        .size(24)
                        .bold
                        .color(Colors.red[700])
                        .make(),
                    '품목'.text.size(14).color(Colors.red[600]).make(),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 설명 텍스트
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    '위험 기준'.text
                        .size(16)
                        .bold
                        .color(Colors.orange[700])
                        .make(),
                  ],
                ),
                const SizedBox(height: 8),
                '• 박스 재고: 50개 이하'.text
                    .size(15)
                    .color(Colors.orange[700])
                    .make(),
                const SizedBox(height: 4),
                '• 벌크 재고: 10개 이하'.text
                    .size(15)
                    .color(Colors.orange[700])
                    .make(),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 액션 버튼들
          Row(
            children: [
              // 상세 보기 버튼
              Expanded(
                flex: 2,
                child: GFButton(
                  onPressed: onViewDetails,
                  text: '위험 재고 확인',
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  size: 50,
                  fullWidthButton: true,
                  color: Colors.red[600]!,
                  shape: GFButtonShape.pills,
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 새로고침 버튼
              Expanded(
                flex: 1,
                child: GFButton(
                  onPressed: () {
                    // 새로고침 로직은 부모에서 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: '재고 정보를 새로고침했습니다'.text
                            .color(Colors.white)
                            .make(),
                        backgroundColor: Colors.green[600],
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  text: '새로고침',
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  size: 50,
                  fullWidthButton: true,
                  color: Colors.white,
                  shape: GFButtonShape.pills,
                  type: GFButtonType.outline2x,
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.orange[600],
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 위험 재고 없음 표시 위젯
class NoCriticalStockBanner extends StatelessWidget {
  const NoCriticalStockBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[50]!,
            Colors.blue[50]!,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green[200]!,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              size: 32,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                '재고 상태 양호'.text
                    .size(20)
                    .bold
                    .color(Colors.green[800])
                    .make(),
                const SizedBox(height: 4),
                '모든 재고가 안전 수준을 유지하고 있습니다'.text
                    .size(16)
                    .color(Colors.green[700])
                    .make(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: '안전'.text
                .size(16)
                .bold
                .color(Colors.green[700])
                .make(),
          ),
        ],
      ),
    );
  }
}