import 'package:flutter/material.dart';
import '../../../../core/utils/widget_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/order_model.dart';
import '../providers/order_provider.dart';

class OrderEditScreen extends ConsumerStatefulWidget {
  final OrderModel order;

  const OrderEditScreen({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<OrderEditScreen> createState() => _OrderEditScreenState();
}

class _OrderEditScreenState extends ConsumerState<OrderEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _javaraQuantityController = TextEditingController();
  final _returnTankQuantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _deliveryMemoController = TextEditingController();
  final _deliveryDateController = TextEditingController();

  ProductType? _selectedProductType;
  DeliveryMethod? _selectedDeliveryMethod;
  DateTime? _selectedDeliveryDate;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final order = widget.order;
    
    _quantityController.text = order.quantity.toString();
    _javaraQuantityController.text = order.javaraQuantity?.toString() ?? '';
    _returnTankQuantityController.text = order.returnTankQuantity?.toString() ?? '';
    _unitPriceController.text = order.unitPrice.toString();
    _deliveryMemoController.text = order.deliveryMemo ?? '';
    
    _selectedProductType = order.productType;
    _selectedDeliveryMethod = order.deliveryMethod;
    _selectedDeliveryDate = order.deliveryDate;
    _deliveryDateController.text = DateFormat('yyyy-MM-dd').format(order.deliveryDate);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _javaraQuantityController.dispose();
    _returnTankQuantityController.dispose();
    _unitPriceController.dispose();
    _deliveryMemoController.dispose();
    _deliveryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: '주문 수정'.text.size(20).bold.make(),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildOrderInfoCard(),
              const SizedBox(height: 16),
              _buildProductSection(),
              const SizedBox(height: 16),
              _buildQuantitySection(),
              const SizedBox(height: 16),
              _buildPriceSection(),
              const SizedBox(height: 16),
              _buildDeliverySection(),
              const SizedBox(height: 24),
              _buildSummarySection(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                '주문 정보'.text.size(14).bold.color(Colors.blue[700]!).make(),
                const SizedBox(height: 4),
                '주문번호: ${widget.order.orderNumber}'.text
                    .size(12)
                    .color(Colors.blue[700]!)
                    .make(),
                '주문일시: ${DateFormat('yyyy-MM-dd HH:mm').format(widget.order.createdAt)}'.text
                    .size(12)
                    .color(Colors.blue[700]!)
                    .make(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
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
          '제품 정보'.text.size(16).bold.make(),
          const SizedBox(height: 16),
          
          // 제품 타입 선택
          '제품 타입'.text.size(14).gray700.make(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<ProductType>(
                  title: '박스 (20L)'.text.size(14).make(),
                  value: ProductType.box,
                  groupValue: _selectedProductType,
                  onChanged: (value) {
                    setState(() {
                      _selectedProductType = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              Expanded(
                child: RadioListTile<ProductType>(
                  title: '벌크 (대용량)'.text.size(14).make(),
                  value: ProductType.bulk,
                  groupValue: _selectedProductType,
                  onChanged: (value) {
                    setState(() {
                      _selectedProductType = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySection() {
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
          '수량 정보'.text.size(16).bold.make(),
          const SizedBox(height: 16),
          
          // 주문 수량
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: '주문 수량 (L)',
              hintText: '예: 1000',
              suffixText: 'L',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '주문 수량을 입력해주세요';
              }
              final quantity = int.tryParse(value);
              if (quantity == null || quantity <= 0) {
                return '올바른 수량을 입력해주세요';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          
          const SizedBox(height: 16),
          
          // 자바라 수량
          TextFormField(
            controller: _javaraQuantityController,
            decoration: const InputDecoration(
              labelText: '자바라 수량 (선택사항)',
              hintText: '예: 5',
              suffixText: '개',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          
          const SizedBox(height: 16),
          
          // 반납 탱크 수량
          TextFormField(
            controller: _returnTankQuantityController,
            decoration: const InputDecoration(
              labelText: '반납 탱크 수량 (선택사항)',
              hintText: '예: 2',
              suffixText: '개',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
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
          '가격 정보'.text.size(16).bold.make(),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _unitPriceController,
            decoration: const InputDecoration(
              labelText: '단가 (원/L)',
              hintText: '예: 1200',
              suffixText: '원',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '단가를 입력해주세요';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return '올바른 단가를 입력해주세요';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection() {
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
          
          // 배송 방법
          '배송 방법'.text.size(14).gray700.make(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<DeliveryMethod>(
                  title: '직접 수령'.text.size(14).make(),
                  value: DeliveryMethod.directPickup,
                  groupValue: _selectedDeliveryMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedDeliveryMethod = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              Expanded(
                child: RadioListTile<DeliveryMethod>(
                  title: '배송'.text.size(14).make(),
                  value: DeliveryMethod.delivery,
                  groupValue: _selectedDeliveryMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedDeliveryMethod = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 희망 배송일
          TextFormField(
            controller: _deliveryDateController,
            decoration: const InputDecoration(
              labelText: '희망 배송일',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: _selectDeliveryDate,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '희망 배송일을 선택해주세요';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // 배송 메모
          TextFormField(
            controller: _deliveryMemoController,
            decoration: const InputDecoration(
              labelText: '배송 메모 (선택사항)',
              hintText: '특별한 요청사항이 있으시면 입력해주세요',
            ),
            maxLines: 3,
            maxLength: 500,
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;
    final totalPrice = quantity * unitPrice;
    final formatter = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '수정 요약'.text.size(16).bold.make(),
          const SizedBox(height: 16),
          
          _buildSummaryRow('제품 타입', _getProductTypeName(_selectedProductType!)),
          _buildSummaryRow('주문 수량', '${formatter.format(quantity)}L'),
          _buildSummaryRow('단가', '₩${formatter.format(unitPrice)}'),
          
          const Divider(),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              '총 금액'.text.size(16).bold.make(),
              '₩${formatter.format(totalPrice)}'.text
                  .size(18)
                  .bold
                  .color(AppTheme.primaryColor)
                  .make(),
            ],
          ),
          
          // 변경사항 표시
          if (_hasChanges()) ...[
            const Divider(),
            '변경사항'.text.size(14).bold.color(Colors.orange[700]!).make(),
            const SizedBox(height: 4),
            ..._getChanges().map((change) => 
              '• $change'.text.size(12).color(Colors.orange[700]!).make()
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          label.text.size(14).gray700.make(),
          value.text.size(14).make(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GFButton(
          onPressed: _saveChanges,
          text: '수정 저장',
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          size: 50,
          fullWidthButton: true,
          color: AppTheme.primaryColor,
          shape: GFButtonShape.pills,
        ),
        
        const SizedBox(height: 16),
        
        GFButton(
          onPressed: () => Navigator.pop(context),
          text: '취소',
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
          size: 50,
          fullWidthButton: true,
          color: Colors.grey[200]!,
          shape: GFButtonShape.pills,
          type: GFButtonType.outline,
        ),
      ],
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

  bool _hasChanges() {
    final order = widget.order;
    
    return _selectedProductType != order.productType ||
           int.parse(_quantityController.text) != order.quantity ||
           (_javaraQuantityController.text.isNotEmpty 
               ? int.parse(_javaraQuantityController.text) 
               : null) != order.javaraQuantity ||
           (_returnTankQuantityController.text.isNotEmpty 
               ? int.parse(_returnTankQuantityController.text) 
               : null) != order.returnTankQuantity ||
           double.parse(_unitPriceController.text) != order.unitPrice ||
           _selectedDeliveryMethod != order.deliveryMethod ||
           _selectedDeliveryDate != order.deliveryDate ||
           _deliveryMemoController.text.trim() != (order.deliveryMemo ?? '');
  }

  List<String> _getChanges() {
    final order = widget.order;
    final changes = <String>[];
    
    if (_selectedProductType != order.productType) {
      changes.add('제품 타입: ${_getProductTypeName(order.productType)} → ${_getProductTypeName(_selectedProductType!)}');
    }
    
    if (int.parse(_quantityController.text) != order.quantity) {
      changes.add('수량: ${order.quantity}L → ${_quantityController.text}L');
    }
    
    if (double.parse(_unitPriceController.text) != order.unitPrice) {
      final formatter = NumberFormat('#,###');
      changes.add('단가: ₩${formatter.format(order.unitPrice)} → ₩${formatter.format(double.parse(_unitPriceController.text))}');
    }
    
    return changes;
  }

  Future<void> _selectDeliveryDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeliveryDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ko', 'KR'),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDeliveryDate = selectedDate;
        _deliveryDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_hasChanges()) {
      GFToast.showToast(
        '변경된 내용이 없습니다',
        context,
        toastPosition: GFToastPosition.BOTTOM,
        backgroundColor: Colors.orange,
        textStyle: const TextStyle(color: Colors.white),
      );
      return;
    }

    try {
      await ref.read(orderDetailProvider(widget.order.id).notifier).updateOrder(
        productType: _selectedProductType,
        quantity: int.parse(_quantityController.text),
        javaraQuantity: _javaraQuantityController.text.isNotEmpty
            ? int.parse(_javaraQuantityController.text)
            : null,
        returnTankQuantity: _returnTankQuantityController.text.isNotEmpty
            ? int.parse(_returnTankQuantityController.text)
            : null,
        deliveryDate: _selectedDeliveryDate,
        deliveryMethod: _selectedDeliveryMethod,
        deliveryMemo: _deliveryMemoController.text.trim().isNotEmpty
            ? _deliveryMemoController.text.trim()
            : null,
        unitPrice: double.parse(_unitPriceController.text),
      );

      // 주문 목록도 새로고침
      ref.invalidate(orderListProvider);

      if (mounted) {
        GFToast.showToast(
          '주문이 수정되었습니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.successColor,
          textStyle: const TextStyle(color: Colors.white),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        GFToast.showToast(
          '주문 수정에 실패했습니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.errorColor,
          textStyle: const TextStyle(color: Colors.white),
        );
      }
    }
  }
}