import 'package:flutter/material.dart';
import '../../../../core/utils/widget_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/order_model.dart';
import '../providers/order_provider.dart';
import '../widgets/order_status_timeline.dart';
import 'order_edit_screen.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final NumberFormat _currencyFormat = NumberFormat('#,###');
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context) {
    final orderDetailState = ref.watch(orderDetailProvider(widget.orderId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: '주문 상세'.text.size(20).bold.make(),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (orderDetailState.order != null) ...[
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _navigateToEdit(orderDetailState.order!);
                    break;
                  case 'cancel':
                    _showCancelDialog(orderDetailState.order!);
                    break;
                  case 'confirm':
                    _updateStatus(OrderStatus.confirmed);
                    break;
                  case 'ship':
                    _updateStatus(OrderStatus.shipped);
                    break;
                  case 'complete':
                    _updateStatus(OrderStatus.completed);
                    break;
                }
              },
              itemBuilder: (context) => _buildMenuItems(orderDetailState.order!),
            ),
          ],
        ],
      ),
      body: _buildBody(orderDetailState),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(OrderModel order) {
    final items = <PopupMenuEntry<String>>[];

    // 수정 (임시저장, 주문대기 상태에서만)
    if (order.status == OrderStatus.draft || order.status == OrderStatus.pending) {
      items.add(
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text('수정'),
            ],
          ),
        ),
      );
    }

    // 상태 변경 옵션
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        items.add(
          const PopupMenuItem(
            value: 'confirm',
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 20, color: Colors.green),
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
                Icon(Icons.local_shipping, size: 20, color: Colors.blue),
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
                Icon(Icons.done_all, size: 20, color: Colors.green),
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

    // 취소 (완료, 취소 상태가 아닌 경우)
    if (order.status != OrderStatus.completed && order.status != OrderStatus.cancelled) {
      if (items.isNotEmpty) {
        items.add(const PopupMenuDivider());
      }
      items.add(
        const PopupMenuItem(
          value: 'cancel',
          child: Row(
            children: [
              Icon(Icons.cancel, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('주문 취소'),
            ],
          ),
        ),
      );
    }

    return items;
  }

  Widget _buildBody(OrderDetailState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            '주문 정보를 불러올 수 없습니다'.text.size(16).gray600.make(),
            const SizedBox(height: 8),
            state.error!.message.text.size(14).gray500.makeCentered(),
            const SizedBox(height: 24),
            GFButton(
              onPressed: () {
                ref.read(orderDetailProvider(widget.orderId).notifier).loadOrder();
              },
              text: '다시 시도',
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      );
    }

    if (state.order == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            '주문을 찾을 수 없습니다'.text.size(16).gray600.make(),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildOrderHeader(state.order!),
                const SizedBox(height: 16),
                _buildOrderInfo(state.order!),
                const SizedBox(height: 16),
                _buildDeliveryInfo(state.order!),
                const SizedBox(height: 16),
                _buildPriceInfo(state.order!),
                const SizedBox(height: 16),
                _buildStatusTimeline(state.order!),
                if (state.order!.profile != null) ...[
                  const SizedBox(height: 16),
                  _buildCustomerInfo(state.order!),
                ],
                // 하단 버튼을 위한 여백
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        // 하단 고정 버튼 영역
        _buildBottomActionButtons(state.order!),
      ],
    );
  }

  Widget _buildOrderHeader(OrderModel order) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              '주문번호'.text.size(14).gray600.make(),
              _buildStatusChip(order.status),
            ],
          ),
          const SizedBox(height: 4),
          order.orderNumber.text.size(18).bold.make(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '주문일시'.text.size(12).gray500.make(),
                  _dateFormat.format(order.createdAt).text.size(14).make(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  '총 주문금액'.text.size(12).gray500.make(),
                  '₩${_currencyFormat.format(order.totalPrice)}'.text
                      .size(18)
                      .bold
                      .color(AppTheme.primaryColor)
                      .make(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo(OrderModel order) {
    return Container(
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
          '주문 정보'.text.size(16).bold.make(),
          const SizedBox(height: 16),
          _buildInfoRow('제품 타입', _getProductTypeName(order.productType)),
          _buildInfoRow('수량', '${order.quantity}L'),
          if (order.javaraQuantity != null)
            _buildInfoRow('자바라 수량', '${order.javaraQuantity}개'),
          if (order.returnTankQuantity != null)
            _buildInfoRow('반납 탱크 수량', '${order.returnTankQuantity}개'),
          _buildInfoRow('단가', '₩${_currencyFormat.format(order.unitPrice)}'),
          _buildInfoRow('희망 배송일', DateFormat('yyyy-MM-dd').format(order.deliveryDate)),
          if (order.deliveryMemo?.isNotEmpty == true)
            _buildInfoRow('배송 메모', order.deliveryMemo!),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(OrderModel order) {
    return Container(
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
          '배송 정보'.text.size(16).bold.make(),
          const SizedBox(height: 16),
          _buildInfoRow('배송 방법', _getDeliveryMethodName(order.deliveryMethod)),
          if (order.deliveryAddress != null) ...[
            _buildInfoRow('배송지명', order.deliveryAddress!.name),
            _buildInfoRow('주소', '${order.deliveryAddress!.address} ${order.deliveryAddress!.addressDetail ?? ''}'),
            if (order.deliveryAddress!.phone?.isNotEmpty == true)
              _buildInfoRow('연락처', order.deliveryAddress!.phone!),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceInfo(OrderModel order) {
    return Container(
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
          '결제 정보'.text.size(16).bold.make(),
          const SizedBox(height: 16),
          _buildPriceRow('수량', '${order.quantity}L'),
          _buildPriceRow('단가', '₩${_currencyFormat.format(order.unitPrice)}'),
          const Divider(),
          _buildPriceRow(
            '총 금액',
            '₩${_currencyFormat.format(order.totalPrice)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(OrderModel order) {
    return Container(
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
          '주문 진행 상황'.text.size(16).bold.make(),
          const SizedBox(height: 16),
          OrderStatusTimeline(order: order),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo(OrderModel order) {
    final profile = order.profile!;
    return Container(
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
          '고객 정보'.text.size(16).bold.make(),
          const SizedBox(height: 16),
          _buildInfoRow('사업체명', profile.businessName),
          _buildInfoRow('대표자명', profile.representativeName),
          _buildInfoRow('연락처', profile.phone),
          _buildInfoRow('이메일', profile.email),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: label.text.size(14).gray600.make(),
          ),
          Expanded(
            child: value.text.size(14).make(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          label.text
              .size(isTotal ? 16 : 14)
              .color(isTotal ? Colors.black : Colors.grey[600]!)
              .fontWeight(isTotal ? FontWeight.bold : FontWeight.normal)
              .make(),
          value.text
              .size(isTotal ? 18 : 14)
              .color(isTotal ? AppTheme.primaryColor : Colors.black)
              .fontWeight(isTotal ? FontWeight.bold : FontWeight.normal)
              .make(),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: statusText.text.size(12).color(textColor).bold.make(),
    );
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

  void _navigateToEdit(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderEditScreen(order: order),
      ),
    );
  }

  void _updateStatus(OrderStatus status) {
    ref.read(orderDetailProvider(widget.orderId).notifier).updateOrder();
    ref.read(orderListProvider.notifier).updateOrderStatus(
      orderId: widget.orderId,
      status: status,
    );
  }

  void _showCancelDialog(OrderModel order) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: '주문 취소'.text.bold.make(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: '취소'.text.make(),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(orderListProvider.notifier).updateOrderStatus(
                  orderId: widget.orderId,
                  status: OrderStatus.cancelled,
                  cancelledReason: reasonController.text.trim(),
                );
                
                // 상세 화면 새로고침
                ref.read(orderDetailProvider(widget.orderId).notifier).loadOrder();
                
                if (mounted) {
                  GFToast.showToast(
                    '주문이 취소되었습니다',
                    context,
                    toastPosition: GFToastPosition.BOTTOM,
                    backgroundColor: AppTheme.successColor,
                    textStyle: const TextStyle(color: Colors.white),
                  );
                }
              } catch (e) {
                if (mounted) {
                  GFToast.showToast(
                    '주문 취소에 실패했습니다',
                    context,
                    toastPosition: GFToastPosition.BOTTOM,
                    backgroundColor: AppTheme.errorColor,
                    textStyle: const TextStyle(color: Colors.white),
                  );
                }
              }
            },
            child: '확인'.text.color(AppTheme.errorColor).make(),
          ),
        ],
      ),
    );
  }

  /// 하단 고정 액션 버튼 영역
  /// 40-60대 사용자를 위한 큰 버튼으로 접근성 향상
  Widget _buildBottomActionButtons(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 주요 액션 버튼 (상태에 따라 다르게 표시)
            if (_shouldShowPrimaryActionButton(order)) ...[
              SizedBox(
                width: double.infinity,
                height: 56, // 40-60대를 위한 큰 터치 영역
                child: GFButton(
                  onPressed: () => _handlePrimaryAction(order),
                  text: _getPrimaryActionText(order),
                  color: _getPrimaryActionColor(order),
                  size: GFSize.LARGE,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  icon: _getPrimaryActionIcon(order),
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            // 보조 액션 버튼들
            Row(
              children: [
                // 뒤로가기 버튼
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: GFButton(
                      onPressed: () => Navigator.pop(context),
                      text: '목록으로',
                      type: GFButtonType.outline2x,
                      color: Colors.grey[600]!,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      icon: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                ),
                
                // 상태에 따른 추가 액션 버튼
                if (_shouldShowSecondaryActionButton(order)) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: GFButton(
                        onPressed: () => _handleSecondaryAction(order),
                        text: _getSecondaryActionText(order),
                        type: GFButtonType.outline2x,
                        color: _getSecondaryActionColor(order),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        icon: _getSecondaryActionIcon(order),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 주요 액션 버튼을 표시할지 결정
  bool _shouldShowPrimaryActionButton(OrderModel order) {
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        return true; // 주문 확정 버튼
      case OrderStatus.confirmed:
        return true; // 출고 완료 버튼
      case OrderStatus.shipped:
        return true; // 배송 완료 버튼
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return false; // 완료/취소된 주문은 주요 액션 없음
    }
  }

  /// 보조 액션 버튼을 표시할지 결정
  bool _shouldShowSecondaryActionButton(OrderModel order) {
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        return true; // 수정 버튼
      case OrderStatus.confirmed:
      case OrderStatus.shipped:
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return false;
    }
  }

  /// 주요 액션 버튼 텍스트
  String _getPrimaryActionText(OrderModel order) {
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        return '주문 확정';
      case OrderStatus.confirmed:
        return '출고 완료';
      case OrderStatus.shipped:
        return '배송 완료';
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return '';
    }
  }

  /// 보조 액션 버튼 텍스트
  String _getSecondaryActionText(OrderModel order) {
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        return '수정';
      case OrderStatus.confirmed:
      case OrderStatus.shipped:
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return '';
    }
  }

  /// 주요 액션 버튼 색상
  Color _getPrimaryActionColor(OrderModel order) {
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        return AppTheme.successColor;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.green;
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return AppTheme.primaryColor;
    }
  }

  /// 보조 액션 버튼 색상
  Color _getSecondaryActionColor(OrderModel order) {
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        return AppTheme.primaryColor;
      case OrderStatus.confirmed:
      case OrderStatus.shipped:
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return Colors.grey;
    }
  }

  /// 주요 액션 버튼 아이콘
  Icon _getPrimaryActionIcon(OrderModel order) {
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        return const Icon(Icons.check_circle, color: Colors.white);
      case OrderStatus.confirmed:
        return const Icon(Icons.local_shipping, color: Colors.white);
      case OrderStatus.shipped:
        return const Icon(Icons.check_circle_outline, color: Colors.white);
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return const Icon(Icons.info, color: Colors.white);
    }
  }

  /// 보조 액션 버튼 아이콘
  Icon _getSecondaryActionIcon(OrderModel order) {
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        return const Icon(Icons.edit, size: 20);
      case OrderStatus.confirmed:
      case OrderStatus.shipped:
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return const Icon(Icons.info, size: 20);
    }
  }

  /// 주요 액션 처리
  void _handlePrimaryAction(OrderModel order) {
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        _updateStatus(OrderStatus.confirmed);
        break;
      case OrderStatus.confirmed:
        _updateStatus(OrderStatus.shipped);
        break;
      case OrderStatus.shipped:
        _updateStatus(OrderStatus.completed);
        break;
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        break;
    }
  }

  /// 보조 액션 처리
  void _handleSecondaryAction(OrderModel order) {
    switch (order.status) {
      case OrderStatus.draft:
      case OrderStatus.pending:
        _navigateToEdit(order);
        break;
      case OrderStatus.confirmed:
      case OrderStatus.shipped:
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        break;
    }
  }
}