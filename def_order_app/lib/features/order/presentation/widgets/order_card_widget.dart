import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/order_model.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final Function(OrderStatus status, String? reason)? onStatusChanged;
  final VoidCallback? onDelete;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.onTap,
    this.onStatusChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat('#,###');
    final DateFormat dateFormat = DateFormat('MM-dd HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더: 주문번호, 상태, 메뉴
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          order.orderNumber.text.size(16).bold.make(),
                          const SizedBox(height: 4),
                          dateFormat.format(order.createdAt).text
                              .size(12)
                              .gray500
                              .make(),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _buildStatusChip(order.status),
                        const SizedBox(width: 8),
                        _buildPopupMenu(context),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 주문 정보
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getProductIcon(order.productType),
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              _getProductTypeName(order.productType).text
                                  .size(14)
                                  .gray700
                                  .make(),
                            ],
                          ),
                          const SizedBox(height: 4),
                          '${currencyFormat.format(order.quantity)}L'.text
                              .size(14)
                              .gray600
                              .make(),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        '₩${currencyFormat.format(order.totalPrice)}'.text
                            .size(16)
                            .bold
                            .color(AppTheme.primaryColor)
                            .make(),
                        const SizedBox(height: 4),
                        '단가 ₩${currencyFormat.format(order.unitPrice)}'.text
                            .size(12)
                            .gray500
                            .make(),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 배송 정보
                Row(
                  children: [
                    Icon(
                      _getDeliveryIcon(order.deliveryMethod),
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getDeliveryMethodName(order.deliveryMethod).text
                              .size(14)
                              .gray700
                              .make(),
                          if (order.deliveryAddress != null)
                            order.deliveryAddress!.name.text
                                .size(12)
                                .gray500
                                .make(),
                        ],
                      ),
                    ),
                    DateFormat('MM-dd').format(order.deliveryDate).text
                        .size(12)
                        .gray500
                        .make(),
                  ],
                ),

                // 메모가 있는 경우 표시
                if (order.deliveryMemo?.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: order.deliveryMemo!.text
                              .size(12)
                              .gray600
                              .maxLines(2)
                              .ellipsis
                              .make(),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status) {
      case OrderStatus.draft:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        statusText = '임시저장';
        break;
      case OrderStatus.pending:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        statusText = '주문대기';
        break;
      case OrderStatus.confirmed:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[700]!;
        statusText = '주문확정';
        break;
      case OrderStatus.shipped:
        backgroundColor = Colors.purple[100]!;
        textColor = Colors.purple[700]!;
        statusText = '출고완료';
        break;
      case OrderStatus.completed:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        statusText = '배송완료';
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        statusText = '주문취소';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: statusText.text.size(10).color(textColor).bold.make(),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, size: 20, color: Colors.grey[600]),
      onSelected: (value) {
        switch (value) {
          case 'confirm':
            onStatusChanged?.call(OrderStatus.confirmed, null);
            break;
          case 'ship':
            onStatusChanged?.call(OrderStatus.shipped, null);
            break;
          case 'complete':
            onStatusChanged?.call(OrderStatus.completed, null);
            break;
          case 'cancel':
            _showCancelDialog(context);
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) {
        final items = <PopupMenuEntry<String>>[];

        // 상태별 액션 추가
        switch (order.status) {
          case OrderStatus.draft:
          case OrderStatus.pending:
            items.add(
              const PopupMenuItem(
                value: 'confirm',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Colors.green),
                    SizedBox(width: 8),
                    Text('주문 확정'),
                  ],
                ),
              ),
            );
            break;
          case OrderStatus.confirmed:
            items.add(
              const PopupMenuItem(
                value: 'ship',
                child: Row(
                  children: [
                    Icon(Icons.local_shipping, size: 16, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('출고 완료'),
                  ],
                ),
              ),
            );
            break;
          case OrderStatus.shipped:
            items.add(
              const PopupMenuItem(
                value: 'complete',
                child: Row(
                  children: [
                    Icon(Icons.done_all, size: 16, color: Colors.green),
                    SizedBox(width: 8),
                    Text('배송 완료'),
                  ],
                ),
              ),
            );
            break;
          default:
            break;
        }

        // 취소 옵션 (완료, 취소 상태가 아닌 경우)
        if (order.status != OrderStatus.completed && 
            order.status != OrderStatus.cancelled) {
          if (items.isNotEmpty) {
            items.add(const PopupMenuDivider());
          }
          items.add(
            const PopupMenuItem(
              value: 'cancel',
              child: Row(
                children: [
                  Icon(Icons.cancel, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('주문 취소'),
                ],
              ),
            ),
          );
        }

        // 삭제 옵션 (임시저장 상태에서만)
        if (order.status == OrderStatus.draft) {
          if (items.isNotEmpty) {
            items.add(const PopupMenuDivider());
          }
          items.add(
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('삭제'),
                ],
              ),
            ),
          );
        }

        return items;
      },
    );
  }

  void _showCancelDialog(BuildContext context) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: '주문 취소'.text.bold.make(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            '주문을 취소하시겠습니까?'.text.make(),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: '취소 사유',
                hintText: '취소 사유를 입력해주세요',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: '취소'.text.make(),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onStatusChanged?.call(
                OrderStatus.cancelled,
                reasonController.text.trim(),
              );
            },
            child: '확인'.text.color(AppTheme.errorColor).make(),
          ),
        ],
      ),
    );
  }

  IconData _getProductIcon(ProductType type) {
    switch (type) {
      case ProductType.box:
        return Icons.inventory_2_outlined;
      case ProductType.bulk:
        return Icons.storage_outlined;
    }
  }

  IconData _getDeliveryIcon(DeliveryMethod method) {
    switch (method) {
      case DeliveryMethod.directPickup:
        return Icons.store_outlined;
      case DeliveryMethod.delivery:
        return Icons.local_shipping_outlined;
    }
  }

  String _getProductTypeName(ProductType type) {
    switch (type) {
      case ProductType.box:
        return '박스 (20L)';
      case ProductType.bulk:
        return '벌크 (대용량)';
    }
  }

  String _getDeliveryMethodName(DeliveryMethod method) {
    switch (method) {
      case DeliveryMethod.directPickup:
        return '직접 수령';
      case DeliveryMethod.delivery:
        return '배송';
    }
  }
}