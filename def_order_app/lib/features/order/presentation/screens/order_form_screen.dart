import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/widget_extensions.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/calculate_price_usecase.dart';
import '../../domain/usecases/check_inventory_usecase.dart';
import '../../data/models/order_model.dart';
import '../providers/order_form_provider.dart';
import '../widgets/price_breakdown_widget.dart';
import '../widgets/inventory_status_widget.dart';

/// 주문 생성/수정 폼 화면
/// 
/// 새 주문 생성 또는 기존 주문 수정을 위한 폼 화면입니다.
/// 실시간 가격 계산, 재고 확인, 유효성 검사 등을 제공합니다.
class OrderFormScreen extends ConsumerStatefulWidget {
  final OrderEntity? orderToEdit;
  final bool isEditMode;

  const OrderFormScreen({
    super.key,
    this.orderToEdit,
    this.isEditMode = false,
  });

  @override
  ConsumerState<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends ConsumerState<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _javaraQuantityController = TextEditingController();
  final _returnTankQuantityController = TextEditingController();
  final _deliveryMemoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // 수정 모드인 경우 폼 초기화
    if (widget.isEditMode && widget.orderToEdit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(orderFormProvider.notifier).initializeForEdit(widget.orderToEdit!);
        _initializeControllers();
      });
    }
  }

  /// 컨트롤러 초기화
  void _initializeControllers() {
    final state = ref.read(orderFormProvider);
    _quantityController.text = state.quantity.toString();
    _javaraQuantityController.text = state.javaraQuantity?.toString() ?? '';
    _returnTankQuantityController.text = state.returnTankQuantity?.toString() ?? '';
    _deliveryMemoController.text = state.deliveryMemo ?? '';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _javaraQuantityController.dispose();
    _returnTankQuantityController.dispose();
    _deliveryMemoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderFormProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.isEditMode ? '주문 수정' : '새 주문 생성'),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (!widget.isEditMode)
            TextButton(
              onPressed: state.isSaving ? null : () => _saveDraft(),
              child: const Text('임시저장'),
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
              // 제품 정보 섹션
              _buildProductSection(state),
              const SizedBox(height: 16),
              
              // 수량 정보 섹션
              _buildQuantitySection(state),
              const SizedBox(height: 16),
              
              // 재고 상태 섹션
              if (state.inventoryCheck != null) ...[
                _buildInventorySection(state),
                const SizedBox(height: 16),
              ],
              
              // 가격 정보 섹션
              if (state.priceCalculation != null) ...[
                _buildPriceSection(state),
                const SizedBox(height: 16),
              ],
              
              // 배송 정보 섹션
              _buildDeliverySection(state),
              const SizedBox(height: 16),
              
              // 메모 섹션
              _buildMemoSection(state),
              const SizedBox(height: 24),
              
              // 에러 메시지
              if (state.error != null) ...[
                _buildErrorMessage(state.error!),
                const SizedBox(height: 16),
              ],
              
              // 액션 버튼
              _buildActionButtons(state),
            ],
          ),
        ),
      ),
    );
  }

  /// 제품 정보 섹션
  Widget _buildProductSection(OrderFormState state) {
    return _buildSection(
      title: '제품 정보',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('제품 타입'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<ProductType>(
                  title: const Text('박스 (20L)'),
                  value: ProductType.box,
                  groupValue: state.productType,
                  onChanged: state.isLoading 
                      ? null 
                      : (value) => ref.read(orderFormProvider.notifier).setProductType(value!),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              Expanded(
                child: RadioListTile<ProductType>(
                  title: const Text('벌크 (대용량)'),
                  value: ProductType.bulk,
                  groupValue: state.productType,
                  onChanged: state.isLoading 
                      ? null 
                      : (value) => ref.read(orderFormProvider.notifier).setProductType(value!),
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

  /// 수량 정보 섹션
  Widget _buildQuantitySection(OrderFormState state) {
    return _buildSection(
      title: '수량 정보',
      child: Column(
        children: [
          // 주문 수량
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: '주문 수량',
              suffixText: '개',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: Validators.required,
            onChanged: (value) {
              final quantity = int.tryParse(value) ?? 0;
              ref.read(orderFormProvider.notifier).setQuantity(quantity);
            },
          ),
          const SizedBox(height: 16),
          
          // 자바라 수량
          TextFormField(
            controller: _javaraQuantityController,
            decoration: const InputDecoration(
              labelText: '자바라 수량 (선택사항)',
              suffixText: '개',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              final quantity = value.isEmpty ? null : int.tryParse(value);
              ref.read(orderFormProvider.notifier).setJavaraQuantity(quantity);
            },
          ),
          const SizedBox(height: 16),
          
          // 반납통 수량
          TextFormField(
            controller: _returnTankQuantityController,
            decoration: const InputDecoration(
              labelText: '반납통 수량 (선택사항)',
              suffixText: '개',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              final quantity = value.isEmpty ? null : int.tryParse(value);
              ref.read(orderFormProvider.notifier).setReturnTankQuantity(quantity);
            },
          ),
        ],
      ),
    );
  }

  /// 재고 상태 섹션
  Widget _buildInventorySection(OrderFormState state) {
    return _buildSection(
      title: '재고 상태',
      child: InventoryStatusWidget(
        inventoryCheck: state.inventoryCheck!,
        isLoading: state.isCheckingInventory,
      ),
    );
  }

  /// 가격 정보 섹션
  Widget _buildPriceSection(OrderFormState state) {
    return _buildSection(
      title: '가격 정보',
      child: PriceBreakdownWidget(
        priceCalculation: state.priceCalculation!,
        isLoading: state.isCalculatingPrice,
      ),
    );
  }

  /// 배송 정보 섹션
  Widget _buildDeliverySection(OrderFormState state) {
    return _buildSection(
      title: '배송 정보',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 배송일
          GestureDetector(
            onTap: () => _selectDeliveryDate(state),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: '배송 희망일',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: DateFormat('yyyy년 MM월 dd일').format(state.deliveryDate),
                ),
                validator: Validators.required,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // 배송 방법
          const Text('배송 방법'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<DeliveryMethod>(
                  title: const Text('배송'),
                  value: DeliveryMethod.delivery,
                  groupValue: state.deliveryMethod,
                  onChanged: state.isLoading 
                      ? null 
                      : (value) => ref.read(orderFormProvider.notifier).setDeliveryMethod(value!),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              Expanded(
                child: RadioListTile<DeliveryMethod>(
                  title: const Text('자가수거'),
                  value: DeliveryMethod.directPickup,
                  groupValue: state.deliveryMethod,
                  onChanged: state.isLoading 
                      ? null 
                      : (value) => ref.read(orderFormProvider.notifier).setDeliveryMethod(value!),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          
          // 배송 주소 (배송인 경우만)
          if (state.deliveryMethod == DeliveryMethod.delivery) ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: '배송 주소',
                border: OutlineInputBorder(),
              ),
              value: state.deliveryAddressId,
              validator: state.deliveryMethod == DeliveryMethod.delivery 
                  ? Validators.required 
                  : null,
              items: const [
                DropdownMenuItem(
                  value: 'default',
                  child: Text('기본 배송지'),
                ),
              ],
              onChanged: (value) {
                ref.read(orderFormProvider.notifier).setDeliveryAddressId(value);
              },
            ),
          ],
        ],
      ),
    );
  }

  /// 메모 섹션
  Widget _buildMemoSection(OrderFormState state) {
    return _buildSection(
      title: '배송 메모',
      child: TextFormField(
        controller: _deliveryMemoController,
        decoration: const InputDecoration(
          labelText: '배송 시 요청사항 (선택사항)',
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
        maxLines: 3,
        onChanged: (value) {
          ref.read(orderFormProvider.notifier).setDeliveryMemo(value.isEmpty ? null : value);
        },
      ),
    );
  }

  /// 에러 메시지
  Widget _buildErrorMessage(Failure error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error.message,
              style: TextStyle(color: Colors.red.shade600),
            ),
          ),
        ],
      ),
    );
  }

  /// 액션 버튼
  Widget _buildActionButtons(OrderFormState state) {
    return Column(
      children: [
        // 주문 완료 버튼
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: state.canSave ? _saveOrder : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: state.isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(widget.isEditMode ? '주문 수정' : '주문 생성'),
          ),
        ),
        
        // 취소 버튼
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: state.isSaving ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('취소'),
          ),
        ),
      ],
    );
  }

  /// 섹션 빌더
  Widget _buildSection({required String title, required Widget child}) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  /// 배송일 선택
  Future<void> _selectDeliveryDate(OrderFormState state) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final initialDate = state.deliveryDate.isBefore(tomorrow) ? tomorrow : state.deliveryDate;
    
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: tomorrow,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: '배송 희망일 선택',
      cancelText: '취소',
      confirmText: '확인',
    );

    if (date != null) {
      ref.read(orderFormProvider.notifier).setDeliveryDate(date);
    }
  }

  /// 임시저장
  Future<void> _saveDraft() async {
    // TODO: 임시저장 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('임시저장 되었습니다')),
    );
  }

  /// 주문 저장
  Future<void> _saveOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final orderForm = ref.read(orderFormProvider.notifier);
      
      final OrderEntity order;
      if (widget.isEditMode) {
        order = await orderForm.updateOrder();
      } else {
        order = await orderForm.createOrder();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isEditMode ? '주문이 수정되었습니다' : '주문이 생성되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(order);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}