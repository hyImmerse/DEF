import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/widget_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/order_model.dart';
import '../providers/order_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'order_detail_screen.dart';

/// 요소수 주문 등록 화면
/// 
/// 40-60대 사용자를 위한 접근성 최적화:
/// - 큰 글씨 (최소 16sp)
/// - 명확한 터치 타겟 (최소 48dp)
/// - 단순한 네비게이션 (3탭 이내 완료)
/// - 높은 대비 색상
class EnhancedOrderRegistrationScreen extends ConsumerStatefulWidget {
  const EnhancedOrderRegistrationScreen({super.key});

  @override
  ConsumerState<EnhancedOrderRegistrationScreen> createState() => 
      _EnhancedOrderRegistrationScreenState();
}

class _EnhancedOrderRegistrationScreenState 
    extends ConsumerState<EnhancedOrderRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _javaraQuantityController = TextEditingController();
  final _returnTankQuantityController = TextEditingController();
  final _deliveryMemoController = TextEditingController();
  final _deliveryDateController = TextEditingController();

  ProductType _selectedProductType = ProductType.box;
  DeliveryMethod _selectedDeliveryMethod = DeliveryMethod.delivery;
  DateTime? _selectedDeliveryDate;
  
  // 현재 단계 (1: 제품선택, 2: 수량입력, 3: 배송정보)
  int _currentStep = 1;
  
  @override
  void initState() {
    super.initState();
    // 기본 배송일: 내일
    _selectedDeliveryDate = DateTime.now().add(const Duration(days: 1));
    _deliveryDateController.text = DateFormat('yyyy-MM-dd').format(_selectedDeliveryDate!);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _javaraQuantityController.dispose();
    _returnTankQuantityController.dispose();
    _deliveryMemoController.dispose();
    _deliveryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderCreationState = ref.watch(orderCreationProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: '요소수 주문하기'.text.size(22).bold.make(),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 진행률 표시
          _buildProgressIndicator(),
          
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(),
              ),
            ),
          ),
          
          // 하단 버튼 영역
          _buildBottomButtons(orderCreationState),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          _buildStepIndicator(1, '제품 선택', _currentStep >= 1),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep >= 2 ? AppTheme.primaryColor : Colors.grey[300],
            ),
          ),
          _buildStepIndicator(2, '수량 입력', _currentStep >= 2),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep >= 3 ? AppTheme.primaryColor : Colors.grey[300],
            ),
          ),
          _buildStepIndicator(3, '배송 정보', _currentStep >= 3),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.primaryColor : Colors.grey[300],
          ),
          child: Center(
            child: step.toString().text
                .size(16)
                .bold
                .color(isActive ? Colors.white : Colors.grey[600]!)
                .make(),
          ),
        ),
        const SizedBox(height: 4),
        label.text
            .size(12)
            .color(isActive ? AppTheme.primaryColor : Colors.grey[600]!)
            .make(),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildProductSelectionStep();
      case 2:
        return _buildQuantityInputStep();
      case 3:
        return _buildDeliveryInfoStep();
      default:
        return Container();
    }
  }

  Widget _buildProductSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '제품을 선택해주세요'.text.size(24).bold.make(),
        const SizedBox(height: 8),
        '원하시는 요소수 제품 타입을 선택하세요'.text.size(16).gray600.make(),
        const SizedBox(height: 32),
        
        // 박스 제품 선택
        _buildProductCard(
          productType: ProductType.box,
          title: '박스 (10L)',
          description: '소량 주문에 적합\n배송비 별도',
          icon: Icons.inventory_2,
          price: '8,500원/box (대리점)\n9,500원/box (일반)',
          isSelected: _selectedProductType == ProductType.box,
        ),
        
        const SizedBox(height: 20),
        
        // 벌크 제품 선택
        _buildProductCard(
          productType: ProductType.bulk,
          title: '벌크 (1000L)',
          description: '대량 주문에 적합\n탱크 배송',
          icon: Icons.local_shipping,
          price: '750,000원/tank (대리점)\n850,000원/tank (일반)',
          isSelected: _selectedProductType == ProductType.bulk,
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required ProductType productType,
    required String title,
    required String description,
    required IconData icon,
    required String price,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProductType = productType;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected ? AppTheme.primaryColor : Colors.grey[600]!,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title.text.size(20).bold.make(),
                  const SizedBox(height: 4),
                  description.text.size(14).gray600.make(),
                  const SizedBox(height: 8),
                  price.text.size(16).bold.color(AppTheme.primaryColor).make(),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityInputStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '수량을 입력해주세요'.text.size(24).bold.make(),
        const SizedBox(height: 8),
        '필요한 요소수 수량을 정확히 입력하세요'.text.size(16).gray600.make(),
        const SizedBox(height: 32),
        
        // 주문 수량
        _buildQuantityInput(
          controller: _quantityController,
          label: '주문 수량',
          hint: _selectedProductType == ProductType.box ? '박스 개수' : '탱크 개수',
          suffix: _selectedProductType == ProductType.box ? '박스' : '탱크',
          isRequired: true,
        ),
        
        const SizedBox(height: 24),
        
        // 자바라 수량 (선택사항)
        _buildQuantityInput(
          controller: _javaraQuantityController,
          label: '자바라 수량 (선택사항)',
          hint: '자바라 개수',
          suffix: '개',
          isRequired: false,
        ),
        
        const SizedBox(height: 24),
        
        // 반납 탱크 수량 (선택사항)
        _buildQuantityInput(
          controller: _returnTankQuantityController,
          label: '반납 탱크 수량 (선택사항)',
          hint: '반납할 빈 탱크 개수',
          suffix: '개',
          isRequired: false,
        ),
        
        const SizedBox(height: 32),
        
        // 예상 금액 표시
        _buildPricePreview(),
      ],
    );
  }

  Widget _buildQuantityInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffix,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            label.text.size(18).bold.make(),
            if (isRequired) ...[
              const SizedBox(width: 4),
              '*'.text.size(18).color(Colors.red).make(),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
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
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              suffixText: suffix,
              suffixStyle: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: isRequired
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return '$label을(를) 입력해주세요';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return '올바른 수량을 입력해주세요';
                    }
                    return null;
                  }
                : null,
            onChanged: (_) => setState(() {}), // 가격 미리보기 업데이트
          ),
        ),
      ],
    );
  }

  Widget _buildPricePreview() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity == 0) return Container();

    // 사용자 등급에 따른 단가 계산 (실제로는 서버에서 가져와야 함)
    double unitPrice = 0;
    if (_selectedProductType == ProductType.box) {
      unitPrice = 9500; // 일반 거래처 기본 단가
    } else {
      unitPrice = 850000; // 일반 거래처 기본 단가
    }
    
    final totalPrice = quantity * unitPrice;
    final formatter = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '예상 주문 금액'.text.size(18).bold.make(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              '수량'.text.size(16).gray700.make(),
              '${formatter.format(quantity)}${_selectedProductType == ProductType.box ? '박스' : '탱크'}'
                  .text.size(16).make(),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              '단가'.text.size(16).gray700.make(),
              '₩${formatter.format(unitPrice)}'.text.size(16).make(),
            ],
          ),
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              '총 금액'.text.size(20).bold.make(),
              '₩${formatter.format(totalPrice)}'.text
                  .size(24)
                  .bold
                  .color(AppTheme.primaryColor)
                  .make(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '배송 정보를 입력해주세요'.text.size(24).bold.make(),
        const SizedBox(height: 8),
        '요소수를 받으실 방법과 날짜를 선택하세요'.text.size(16).gray600.make(),
        const SizedBox(height: 32),
        
        // 배송 방법 선택
        '배송 방법'.text.size(18).bold.make(),
        const SizedBox(height: 12),
        
        _buildDeliveryMethodCard(
          method: DeliveryMethod.delivery,
          title: '배송 받기',
          description: '지정한 주소로 배송\n배송비 별도',
          icon: Icons.local_shipping,
          isSelected: _selectedDeliveryMethod == DeliveryMethod.delivery,
        ),
        
        const SizedBox(height: 16),
        
        _buildDeliveryMethodCard(
          method: DeliveryMethod.directPickup,
          title: '직접 수령',
          description: '공장에서 직접 수령\n배송비 없음',
          icon: Icons.store,
          isSelected: _selectedDeliveryMethod == DeliveryMethod.directPickup,
        ),
        
        const SizedBox(height: 32),
        
        // 희망 배송일
        '희망 배송일'.text.size(18).bold.make(),
        const SizedBox(width: 4),
        '*'.text.size(18).color(Colors.red).make(),
        const SizedBox(height: 12),
        
        Container(
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
          child: TextFormField(
            controller: _deliveryDateController,
            decoration: InputDecoration(
              hintText: '날짜를 선택해주세요',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              suffixIcon: const Icon(
                Icons.calendar_today,
                size: 24,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: const TextStyle(fontSize: 18),
            readOnly: true,
            onTap: _selectDeliveryDate,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '희망 배송일을 선택해주세요';
              }
              return null;
            },
          ),
        ),
        
        const SizedBox(height: 32),
        
        // 배송 메모
        '요청사항 (선택사항)'.text.size(18).bold.make(),
        const SizedBox(height: 12),
        
        Container(
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
          child: TextFormField(
            controller: _deliveryMemoController,
            decoration: InputDecoration(
              hintText: '특별한 요청사항이 있으시면 입력해주세요',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: const TextStyle(fontSize: 16),
            maxLines: 4,
            maxLength: 200,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryMethodCard({
    required DeliveryMethod method,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDeliveryMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isSelected ? AppTheme.primaryColor : Colors.grey[600]!,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title.text.size(18).bold.make(),
                  const SizedBox(height: 4),
                  description.text.size(14).gray600.make(),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(OrderCreationState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 1) ...[
              Expanded(
                flex: 1,
                child: GFButton(
                  onPressed: state.isLoading ? null : () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                  text: '이전',
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                  size: 56,
                  fullWidthButton: true,
                  color: Colors.grey[200]!,
                  shape: GFButtonShape.pills,
                  type: GFButtonType.outline,
                ),
              ),
              const SizedBox(width: 12),
            ],
            
            Expanded(
              flex: 2,
              child: GFButton(
                onPressed: state.isLoading ? null : _handleNextStep,
                text: state.isLoading 
                    ? '처리 중...' 
                    : _currentStep == 3 
                        ? '주문하기' 
                        : '다음',
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                size: 56,
                fullWidthButton: true,
                color: AppTheme.primaryColor,
                disabledColor: Colors.grey[400]!,
                shape: GFButtonShape.pills,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNextStep() {
    if (_currentStep < 3) {
      // 현재 단계 검증
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
      }
    } else {
      // 주문 생성
      _createOrder();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 1:
        // 제품 선택은 기본값이 있으므로 항상 통과
        return true;
      case 2:
        // 수량 입력 검증
        if (_quantityController.text.isEmpty) {
          _showErrorMessage('주문 수량을 입력해주세요');
          return false;
        }
        final quantity = int.tryParse(_quantityController.text);
        if (quantity == null || quantity <= 0) {
          _showErrorMessage('올바른 수량을 입력해주세요');
          return false;
        }
        return true;
      case 3:
        // 배송 정보 검증은 주문 생성 시 처리
        return true;
      default:
        return false;
    }
  }

  Future<void> _selectDeliveryDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeliveryDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ko', 'KR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDeliveryDate = selectedDate;
        _deliveryDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> _createOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // 실제 단가는 서버에서 사용자 등급에 따라 계산됨
      double unitPrice = 0;
      if (_selectedProductType == ProductType.box) {
        unitPrice = 9500; // 기본 단가, 실제로는 서버에서 계산
      } else {
        unitPrice = 850000; // 기본 단가, 실제로는 서버에서 계산
      }

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
        unitPrice: unitPrice,
      );

      if (mounted) {
        // 성공 메시지 표시
        GFToast.showToast(
          '주문이 성공적으로 등록되었습니다!',
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
        _showErrorMessage('주문 등록에 실패했습니다. 다시 시도해주세요.');
      }
    }
  }

  void _showErrorMessage(String message) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      backgroundColor: AppTheme.errorColor,
      textStyle: const TextStyle(color: Colors.white, fontSize: 16),
      toastDuration: 3,
    );
  }
}