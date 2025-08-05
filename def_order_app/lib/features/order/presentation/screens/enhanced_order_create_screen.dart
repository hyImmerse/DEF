import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart'; // VelocityX 호환성 레이어
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/order_entity.dart';
import '../../data/models/order_model.dart';
import '../providers/order_notifier.dart';
import '../../../onboarding/presentation/config/onboarding_keys.dart';
import '../../../onboarding/presentation/widgets/order_onboarding_overlay.dart';
import '../../../onboarding/presentation/widgets/smart_tooltip_system.dart';
import '../../../onboarding/presentation/widgets/order_advanced_tooltips.dart';

/// 40-60대 사용자를 위한 Enhanced 주문 등록 화면
/// 
/// 특징:
/// - 큰 글씨와 명확한 UI
/// - 단계별 주문 프로세스
/// - GetWidget + VelocityX 스타일링
class EnhancedOrderCreateScreen extends ConsumerStatefulWidget {
  const EnhancedOrderCreateScreen({super.key});

  @override
  ConsumerState<EnhancedOrderCreateScreen> createState() => _EnhancedOrderCreateScreenState();
}

class _EnhancedOrderCreateScreenState extends ConsumerState<EnhancedOrderCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // 주문 정보
  ProductType _selectedProductType = ProductType.box;
  int _quantity = 0;
  int _emptyTankReturn = 0;
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 1));
  String? _deliveryAddress;
  String? _note;
  
  // 텍스트 컨트롤러
  final _quantityController = TextEditingController();
  final _emptyTankController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  
  // 단계별 진행
  int _currentStep = 0;
  
  @override
  void dispose() {
    _quantityController.dispose();
    _emptyTankController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    
    return OrderOnboardingOverlay(
      onCompleted: () {
        // 온보딩 완료 후 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: '온보딩이 완료되었습니다! 이제 주문을 시작해보세요.'.text.make(),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: OrderAdvancedTooltips(
        onBehaviorAnalyzed: (pattern) {
          // 사용자 행동 패턴에 따른 추가 처리 가능
          debugPrint('주문 화면 사용자 행동: 총 ${pattern.totalInteractions}번 상호작용');
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: _buildAppBar(),
          body: orderState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(),
        ),
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: '새 주문 등록'
          .text
          .size(22)
          .fontWeight(FontWeight.bold)
          .make(),
      centerTitle: true,
    );
  }
  
  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 진행 단계 표시
          _buildStepIndicator(),
          
          // 단계별 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              child: _buildStepContent(),
            ),
          ),
          
          // 하단 버튼
          _buildBottomButtons(),
        ],
      ),
    );
  }
  
  Widget _buildStepIndicator() {
    final steps = ['제품 선택', '수량 입력', '배송 정보', '주문 확인'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Column(
              children: [
                // 단계 번호
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive || isCompleted
                        ? AppTheme.primaryColor
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          )
                        : '${index + 1}'
                            .text
                            .size(18)
                            .fontWeight(FontWeight.bold)
                            .color(
                              isActive || isCompleted
                                  ? Colors.white
                                  : Colors.grey[600],
                            )
                            .make(),
                  ),
                ),
                
                8.heightBox,
                
                // 단계 이름
                steps[index]
                    .text
                    .size(14)
                    .fontWeight(
                      isActive ? FontWeight.bold : FontWeight.normal,
                    )
                    .color(
                      isActive || isCompleted
                          ? AppTheme.primaryColor
                          : Colors.grey[600],
                    )
                    .make(),
              ],
            ),
          );
        }),
      ),
    );
  }
  
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildProductSelection();
      case 1:
        return _buildQuantityInput();
      case 2:
        return _buildDeliveryInfo();
      case 3:
        return _buildOrderConfirmation();
      default:
        return const SizedBox.shrink();
    }
  }
  
  Widget _buildProductSelection() {
    return Container(
      key: OnboardingKeys.instance.orderProductSelectionKey,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '제품 종류를 선택해주세요'
              .text
              .size(20)
              .fontWeight(FontWeight.bold)
              .color(Colors.black87)
              .make(),
          
          8.heightBox,
          
          '원하시는 요소수 제품 타입을 선택하세요'
              .text
              .size(16)
              .color(Colors.grey[600])
              .make(),
          
          24.heightBox,
          
          // 박스 선택
          GFCard(
            elevation: _selectedProductType == ProductType.box ? 4 : 1,
            color: _selectedProductType == ProductType.box
                ? AppTheme.primaryColor.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: _selectedProductType == ProductType.box
                ? Border.all(color: AppTheme.primaryColor, width: 2)
                : null,
            padding: const EdgeInsets.all(20),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory_2,
                        color: AppTheme.primaryColor,
                        size: 32,
                      ),
                    ),
                    16.widthBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          '박스 단위 (20L)'
                              .text
                              .size(18)
                              .fontWeight(FontWeight.bold)
                              .color(Colors.black87)
                              .make(),
                          4.heightBox,
                          '소량 주문에 적합'
                              .text
                              .size(14)
                              .color(Colors.grey[600])
                              .make(),
                        ],
                      ),
                    ),
                    GFRadio(
                      size: 30,
                      value: ProductType.box,
                      groupValue: _selectedProductType,
                      onChanged: (value) {
                        setState(() {
                          _selectedProductType = value!;
                        });
                      },
                      activeBorderColor: AppTheme.primaryColor,
                      activeIcon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).onTap(() {
            setState(() {
              _selectedProductType = ProductType.box;
            });
          }),
          
          16.heightBox,
          
          // 벌크 선택
          GFCard(
            elevation: _selectedProductType == ProductType.bulk ? 4 : 1,
            color: _selectedProductType == ProductType.bulk
                ? AppTheme.primaryColor.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: _selectedProductType == ProductType.bulk
                ? Border.all(color: AppTheme.primaryColor, width: 2)
                : null,
            padding: const EdgeInsets.all(20),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_shipping,
                        color: AppTheme.primaryColor,
                        size: 32,
                      ),
                    ),
                    16.widthBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          '벌크 단위 (대용량)'
                              .text
                              .size(18)
                              .fontWeight(FontWeight.bold)
                              .color(Colors.black87)
                              .make(),
                          4.heightBox,
                          '대량 주문에 적합'
                              .text
                              .size(14)
                              .color(Colors.grey[600])
                              .make(),
                        ],
                      ),
                    ),
                    GFRadio(
                      size: 30,
                      value: ProductType.bulk,
                      groupValue: _selectedProductType,
                      onChanged: (value) {
                        setState(() {
                          _selectedProductType = value!;
                        });
                      },
                      activeBorderColor: AppTheme.primaryColor,
                      activeIcon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).onTap(() {
            setState(() {
              _selectedProductType = ProductType.bulk;
            });
          }),
        ],
      ),
    );
  }
  
  Widget _buildQuantityInput() {
    return Container(
      key: OnboardingKeys.instance.orderQuantityInputKey,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '주문 수량을 입력해주세요'
              .text
              .size(20)
              .fontWeight(FontWeight.bold)
              .color(Colors.black87)
              .make(),
          
          8.heightBox,
          
          '필요한 수량과 빈 용기 반납 수량을 입력하세요'
              .text
              .size(16)
              .color(Colors.grey[600])
              .make(),
          
          32.heightBox,
          
          // 주문 수량
          _buildInputCard(
            title: '주문 수량',
            subtitle: _selectedProductType == ProductType.box
                ? '박스 단위 (20L)'
                : '벌크 단위',
            icon: Icons.add_shopping_cart,
            controller: _quantityController,
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
          ),
          
          20.heightBox,
          
          // 빈 용기 반납
          _buildInputCard(
            title: '빈 용기 반납',
            subtitle: '반납할 빈 용기 수량 (선택사항)',
            icon: Icons.recycling,
            controller: _emptyTankController,
            isOptional: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildInputCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool isOptional = false,
  }) {
    return GFCard(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title.text
                        .size(18)
                        .fontWeight(FontWeight.bold)
                        .color(Colors.black87)
                        .make(),
                    4.heightBox,
                    subtitle.text
                        .size(14)
                        .color(Colors.grey[600])
                        .make(),
                  ],
                ),
              ),
            ],
          ),
          
          16.heightBox,
          
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: isOptional ? '0' : '수량 입력',
              suffixText: _selectedProductType == ProductType.box ? '박스' : '벌크',
              suffixStyle: const TextStyle(fontSize: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDeliveryInfo() {
    return Container(
      key: OnboardingKeys.instance.orderDeliveryInfoKey,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '배송 정보를 확인해주세요'
              .text
              .size(20)
              .fontWeight(FontWeight.bold)
              .color(Colors.black87)
              .make(),
          
          8.heightBox,
          
          '배송 날짜와 주소를 확인하고 필요시 수정하세요'
              .text
              .size(16)
              .color(Colors.grey[600])
              .make(),
          
          32.heightBox,
          
          // 배송 날짜
          GFCard(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(20),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    12.widthBox,
                    '배송 희망일'.text
                        .size(18)
                        .fontWeight(FontWeight.bold)
                        .color(Colors.black87)
                        .make(),
                  ],
                ),
                
                16.heightBox,
                
                GFButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _deliveryDate,
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    
                    if (picked != null) {
                      setState(() {
                        _deliveryDate = picked;
                      });
                    }
                  },
                  text: '${_deliveryDate.year}년 ${_deliveryDate.month}월 ${_deliveryDate.day}일',
                  textStyle: const TextStyle(fontSize: 18),
                  color: Colors.white,
                  textColor: AppTheme.primaryColor,
                  size: GFSize.LARGE,
                  shape: GFButtonShape.pills,
                  fullWidthButton: true,
                  borderShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  icon: const Icon(
                    Icons.edit,
                    color: AppTheme.primaryColor,
                  ),
                  position: GFPosition.end,
                ),
              ],
            ),
          ),
          
          20.heightBox,
          
          // 배송 주소
          GFCard(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(20),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    12.widthBox,
                    '배송 주소'.text
                        .size(18)
                        .fontWeight(FontWeight.bold)
                        .color(Colors.black87)
                        .make(),
                  ],
                ),
                
                16.heightBox,
                
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: '배송 받으실 주소를 입력하세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '배송 주소를 입력해주세요';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          
          20.heightBox,
          
          // 요청사항
          GFCard(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(20),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.note,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    12.widthBox,
                    '요청사항 (선택)'.text
                        .size(18)
                        .fontWeight(FontWeight.bold)
                        .color(Colors.black87)
                        .make(),
                  ],
                ),
                
                16.heightBox,
                
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: '특별한 요청사항이 있으시면 입력하세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderConfirmation() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final emptyReturn = int.tryParse(_emptyTankController.text) ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '주문 내역을 확인해주세요'
              .text
              .size(20)
              .fontWeight(FontWeight.bold)
              .color(Colors.black87)
              .make(),
          
          8.heightBox,
          
          '아래 내용이 맞는지 다시 한번 확인해주세요'
              .text
              .size(16)
              .color(Colors.grey[600])
              .make(),
          
          32.heightBox,
          
          // 주문 요약 카드
          GFCard(
            elevation: 3,
            borderRadius: BorderRadius.circular(16),
            color: AppTheme.primaryColor.withOpacity(0.05),
            padding: const EdgeInsets.all(24),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                '주문 요약'.text
                    .size(18)
                    .fontWeight(FontWeight.bold)
                    .color(Colors.black87)
                    .make(),
                
                16.heightBox,
                
                _buildSummaryRow(
                  '제품 종류',
                  _selectedProductType == ProductType.box
                      ? '박스 단위 (20L)'
                      : '벌크 단위',
                  Icons.inventory_2,
                ),
                
                12.heightBox,
                
                _buildSummaryRow(
                  '주문 수량',
                  '$quantity ${_selectedProductType == ProductType.box ? '박스' : '벌크'}',
                  Icons.add_shopping_cart,
                ),
                
                if (emptyReturn > 0) ...[
                  12.heightBox,
                  _buildSummaryRow(
                    '빈 용기 반납',
                    '$emptyReturn 개',
                    Icons.recycling,
                  ),
                ],
                
                12.heightBox,
                
                _buildSummaryRow(
                  '배송 희망일',
                  '${_deliveryDate.year}년 ${_deliveryDate.month}월 ${_deliveryDate.day}일',
                  Icons.calendar_today,
                ),
                
                12.heightBox,
                
                _buildSummaryRow(
                  '배송 주소',
                  _addressController.text,
                  Icons.location_on,
                ),
                
                if (_noteController.text.isNotEmpty) ...[
                  12.heightBox,
                  _buildSummaryRow(
                    '요청사항',
                    _noteController.text,
                    Icons.note,
                  ),
                ],
              ],
            ),
          ),
          
          24.heightBox,
          
          // 안내 메시지
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 24,
                ),
                12.widthBox,
                Expanded(
                  child: '주문 확정 후 PDF 주문서가 생성됩니다'
                      .text
                      .size(16)
                      .color(Colors.blue[700])
                      .make(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
        8.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label.text
                  .size(14)
                  .color(Colors.grey[600])
                  .make(),
              2.heightBox,
              value.text
                  .size(16)
                  .fontWeight(FontWeight.w600)
                  .color(Colors.black87)
                  .make(),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildBottomButtons() {
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
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: GFButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                text: '이전',
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                color: Colors.white,
                textColor: AppTheme.primaryColor,
                size: GFSize.LARGE,
                shape: GFButtonShape.pills,
                fullWidthButton: true,
                borderShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppTheme.primaryColor,
                ),
                position: GFPosition.start,
              ),
            ),
          
          if (_currentStep > 0) 16.widthBox,
          
          Expanded(
            child: GFButton(
              key: _currentStep == 3 ? OnboardingKeys.instance.orderSubmitButtonKey : null,
              onPressed: _handleNext,
              text: _currentStep == 3 ? '주문하기' : '다음',
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              color: AppTheme.primaryColor,
              size: GFSize.LARGE,
              shape: GFButtonShape.pills,
              fullWidthButton: true,
              icon: Icon(
                _currentStep == 3 ? Icons.check : Icons.arrow_forward,
                color: Colors.white,
              ),
              position: GFPosition.end,
            ),
          ),
        ],
      ),
    );
  }
  
  void _handleNext() {
    if (_currentStep < 3) {
      // 단계별 유효성 검사
      bool canProceed = true;
      
      switch (_currentStep) {
        case 1:
          if (_quantityController.text.isEmpty) {
            canProceed = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: '주문 수량을 입력해주세요'.text.make(),
                backgroundColor: Colors.red,
              ),
            );
          }
          break;
        case 2:
          if (_addressController.text.isEmpty) {
            canProceed = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: '배송 주소를 입력해주세요'.text.make(),
                backgroundColor: Colors.red,
              ),
            );
          }
          break;
      }
      
      if (canProceed) {
        setState(() {
          _currentStep++;
        });
      }
    } else {
      // 주문 완료
      _submitOrder();
    }
  }
  
  void _submitOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      // 주문 생성
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final emptyReturn = int.tryParse(_emptyTankController.text) ?? 0;
      
      ref.read(orderProvider.notifier).createOrder(
        productType: _selectedProductType,
        quantity: quantity,
        emptyTankReturn: emptyReturn,
        deliveryDate: _deliveryDate,
        deliveryAddress: _addressController.text,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );
      
      // 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: '주문이 성공적으로 등록되었습니다'.text.make(),
          backgroundColor: Colors.green,
        ),
      );
      
      // 화면 닫기
      Navigator.of(context).pop();
    }
  }
}