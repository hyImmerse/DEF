import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/order_model.dart';
import '../providers/order_provider.dart';
import 'order_detail_screen.dart';

class OrderCreationScreen extends ConsumerStatefulWidget {
  const OrderCreationScreen({super.key});

  @override
  ConsumerState<OrderCreationScreen> createState() => _OrderCreationScreenState();
}

class _OrderCreationScreenState extends ConsumerState<OrderCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _javaraQuantityController = TextEditingController();
  final _returnTankQuantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _deliveryMemoController = TextEditingController();
  final _deliveryDateController = TextEditingController();

  ProductType _selectedProductType = ProductType.box;
  DeliveryMethod _selectedDeliveryMethod = DeliveryMethod.delivery;
  DateTime? _selectedDeliveryDate;
  
  bool _isDraft = false;

  @override
  void initState() {
    super.initState();
    // 기본값 설정
    _unitPriceController.text = '1200'; // 기본 단가
    _selectedDeliveryDate = DateTime.now().add(const Duration(days: 1));
    _deliveryDateController.text = DateFormat('yyyy-MM-dd').format(_selectedDeliveryDate!);
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
    final orderCreationState = ref.watch(orderCreationProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: '새 주문 생성'.text.size(20).bold.make(),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: orderCreationState.isLoading ? null : () => _saveOrder(isDraft: true),
            child: '임시저장'.text.color(AppTheme.primaryColor).make(),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              _buildActionButtons(orderCreationState),
            ],
          ),
        ),
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
            onChanged: (_) => setState(() {}), // 요약 섹션 업데이트를 위해
          ),
          
          const SizedBox(height: 16),
          
          // 자바라 수량 (선택사항)
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
          
          // 반납 탱크 수량 (선택사항)
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
            onChanged: (_) => setState(() {}), // 요약 섹션 업데이트를 위해
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
          '주문 요약'.text.size(16).bold.make(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              '제품 타입'.text.size(14).gray700.make(),
              _getProductTypeName(_selectedProductType).text.size(14).make(),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              '주문 수량'.text.size(14).gray700.make(),
              '${formatter.format(quantity)}L'.text.size(14).make(),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              '단가'.text.size(14).gray700.make(),
              '₩${formatter.format(unitPrice)}'.text.size(14).make(),
            ],
          ),
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
        ],
      ),
    );
  }

  Widget _buildActionButtons(OrderCreationState state) {
    return Column(
      children: [
        // 주문하기 버튼
        GFButton(
          onPressed: state.isLoading ? null : () => _saveOrder(isDraft: false),
          text: state.isLoading ? '처리 중...' : '주문하기',
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          size: 50,
          fullWidthButton: true,
          color: AppTheme.primaryColor,
          disabledColor: Colors.grey[400]!,
          shape: GFButtonShape.pills,
        ),
        
        const SizedBox(height: 16),
        
        // 취소 버튼
        GFButton(
          onPressed: state.isLoading ? null : () => Navigator.pop(context),
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

  Future<void> _saveOrder({required bool isDraft}) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final order = await ref.read(orderCreationProvider.notifier).createOrder(
        productType: _selectedProductType,
        quantity: int.parse(_quantityController.text),
        javaraQuantity: _javaraQuantityController.text.isNotEmpty
            ? int.parse(_javaraQuantityController.text)
            : null,
        returnTankQuantity: _returnTankQuantityController.text.isNotEmpty
            ? int.parse(_returnTankQuantityController.text)
            : null,
        deliveryDate: _selectedDeliveryDate!,
        deliveryMethod: _selectedDeliveryMethod,
        deliveryMemo: _deliveryMemoController.text.trim().isNotEmpty
            ? _deliveryMemoController.text.trim()
            : null,
        unitPrice: double.parse(_unitPriceController.text),
      );

      if (mounted) {
        // 성공 메시지 표시
        GFToast.showToast(
          isDraft ? '임시저장되었습니다' : '주문이 생성되었습니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.successColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
          toastDuration: 3,
        );

        // 주문 상세 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: order.id),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        GFToast.showToast(
          isDraft ? '임시저장에 실패했습니다' : '주문 생성에 실패했습니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.errorColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
          toastDuration: 3,
        );
      }
    }
  }
}