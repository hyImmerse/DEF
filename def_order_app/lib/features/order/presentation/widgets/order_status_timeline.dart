import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/order_model.dart';

class OrderStatusTimeline extends StatelessWidget {
  final OrderModel order;

  const OrderStatusTimeline({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final steps = _buildTimelineSteps();
    
    return Column(
      children: [
        for (int i = 0; i < steps.length; i++)
          _buildTimelineItem(
            step: steps[i],
            isLast: i == steps.length - 1,
          ),
      ],
    );
  }

  List<TimelineStep> _buildTimelineSteps() {
    final steps = <TimelineStep>[];
    final DateFormat dateFormat = DateFormat('MM-dd HH:mm');

    // 1. 주문 생성
    steps.add(TimelineStep(
      title: '주문 생성',
      description: order.status == OrderStatus.draft ? '임시저장됨' : '주문 요청',
      time: dateFormat.format(order.createdAt),
      isCompleted: true,
      isActive: order.status == OrderStatus.draft,
      icon: Icons.create_outlined,
    ));

    // 2. 주문 대기 (pending 상태인 경우)
    if (order.status != OrderStatus.draft) {
      steps.add(TimelineStep(
        title: '주문 대기',
        description: '주문 검토 중',
        time: order.status.index >= OrderStatus.pending.index 
            ? dateFormat.format(order.createdAt)
            : null,
        isCompleted: order.status.index >= OrderStatus.pending.index,
        isActive: order.status == OrderStatus.pending,
        icon: Icons.hourglass_empty,
      ));
    }

    // 3. 주문 확정
    steps.add(TimelineStep(
      title: '주문 확정',
      description: '주문이 승인됨',
      time: order.confirmedAt != null 
          ? dateFormat.format(order.confirmedAt!)
          : null,
      isCompleted: order.status.index >= OrderStatus.confirmed.index,
      isActive: order.status == OrderStatus.confirmed,
      icon: Icons.check_circle_outline,
    ));

    // 4. 출고 완료
    steps.add(TimelineStep(
      title: '출고 완료',
      description: order.deliveryMethod == DeliveryMethod.directPickup 
          ? '수령 대기 중'
          : '배송 시작',
      time: order.shippedAt != null 
          ? dateFormat.format(order.shippedAt!)
          : null,
      isCompleted: order.status.index >= OrderStatus.shipped.index,
      isActive: order.status == OrderStatus.shipped,
      icon: Icons.local_shipping_outlined,
    ));

    // 5. 배송 완료
    steps.add(TimelineStep(
      title: order.deliveryMethod == DeliveryMethod.directPickup 
          ? '수령 완료'
          : '배송 완료',
      description: '주문 처리 완료',
      time: order.completedAt != null 
          ? dateFormat.format(order.completedAt!)
          : null,
      isCompleted: order.status == OrderStatus.completed,
      isActive: order.status == OrderStatus.completed,
      icon: Icons.done_all,
    ));

    // 취소된 경우 취소 단계 추가
    if (order.status == OrderStatus.cancelled) {
      steps.add(TimelineStep(
        title: '주문 취소',
        description: order.cancelledReason ?? '주문이 취소됨',
        time: order.cancelledAt != null 
            ? dateFormat.format(order.cancelledAt!)
            : null,
        isCompleted: true,
        isActive: false,
        icon: Icons.cancel_outlined,
        isError: true,
      ));
    }

    return steps;
  }

  Widget _buildTimelineItem({
    required TimelineStep step,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 타임라인 점과 선
        Column(
          children: [
            _buildTimelineIcon(step),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: step.isCompleted 
                    ? (step.isError ? AppTheme.errorColor : AppTheme.primaryColor)
                    : Colors.grey[300],
              ),
          ],
        ),
        
        const SizedBox(width: 16),
        
        // 내용
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: step.isCompleted 
                            ? (step.isError ? AppTheme.errorColor : Colors.black)
                            : Colors.grey[600],
                      ),
                    ),
                    if (step.time != null)
                      Text(
                        step.time!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: step.isCompleted 
                        ? (step.isError ? AppTheme.errorColor : Colors.grey[700])
                        : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineIcon(TimelineStep step) {
    Color iconColor;
    Color backgroundColor;

    if (step.isError) {
      iconColor = Colors.white;
      backgroundColor = AppTheme.errorColor;
    } else if (step.isCompleted) {
      iconColor = Colors.white;
      backgroundColor = AppTheme.primaryColor;
    } else if (step.isActive) {
      iconColor = AppTheme.primaryColor;
      backgroundColor = AppTheme.primaryColor.withOpacity(0.2);
    } else {
      iconColor = Colors.grey[400]!;
      backgroundColor = Colors.grey[200]!;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: step.isActive && !step.isCompleted
            ? Border.all(color: AppTheme.primaryColor, width: 2)
            : null,
      ),
      child: Icon(
        step.icon,
        size: 16,
        color: iconColor,
      ),
    );
  }
}

class TimelineStep {
  final String title;
  final String description;
  final String? time;
  final bool isCompleted;
  final bool isActive;
  final IconData icon;
  final bool isError;

  TimelineStep({
    required this.title,
    required this.description,
    this.time,
    required this.isCompleted,
    required this.isActive,
    required this.icon,
    this.isError = false,
  });
}