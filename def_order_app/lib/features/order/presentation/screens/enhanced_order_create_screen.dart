import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart'; // VelocityX 호환성 레이어
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../../data/models/order_model.dart';
import '../providers/order_notifier.dart';
import '../../../onboarding/presentation/config/onboarding_keys.dart';
import '../../../onboarding/presentation/widgets/order_onboarding_overlay.dart';
import '../../../onboarding/presentation/widgets/smart_tooltip_system.dart';
import '../../../onboarding/presentation/widgets/order_advanced_tooltips.dart';
import '../widgets/pdf_notification_widget.dart';

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
    
    // TODO: 데모를 위해 온보딩 시스템 임시 비활성화 - 나중에 활성화 필요
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: orderState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
    
    /*
    // 원래 온보딩 코드 (데모 후 복구 예정)
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
          // TODO: 데모를 위해 로깅 임시 비활성화
          // debugPrint('주문 화면 사용자 행동: 총 ${pattern.totalInteractions}번 상호작용');
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
    */
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
          
          // 박스 선택 - 접근성 개선
          GFCard(
            elevation: _selectedProductType == ProductType.box ? 6 : 2,
            color: _selectedProductType == ProductType.box
                ? AppColors.primary50  // Material 3 Primary Container
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _selectedProductType == ProductType.box
                  ? AppColors.primary
                  : AppColors.border,
              width: _selectedProductType == ProductType.box ? 2.5 : 1.5,
            ),
            padding: const EdgeInsets.all(24),  // 터치 영역 확대
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
                              .size(20)  // 18sp → 20sp
                              .fontWeight(FontWeight.bold)
                              .color(_selectedProductType == ProductType.box
                                  ? AppColors.primary900  // 선택 시 진한 색상
                                  : AppColors.textPrimary)
                              .make(),
                          6.heightBox,
                          '소량 주문에 적합'
                              .text
                              .size(16)  // 14sp → 16sp
                              .color(_selectedProductType == ProductType.box
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary)
                              .make(),
                        ],
                      ),
                    ),
                    GFRadio(
                      size: 36,  // 30 → 36 (터치 영역 확대)
                      value: ProductType.box,
                      groupValue: _selectedProductType,
                      onChanged: (value) {
                        setState(() {
                          _selectedProductType = value!;
                        });
                      },
                      activeBorderColor: AppColors.primary,
                      activeIcon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 22,  // 18 → 22
                      ),
                      inactiveBorderColor: AppColors.border,
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
          
          // 벌크 선택 - 접근성 개선
          GFCard(
            elevation: _selectedProductType == ProductType.bulk ? 6 : 2,
            color: _selectedProductType == ProductType.bulk
                ? AppColors.primary50  // Material 3 Primary Container
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _selectedProductType == ProductType.bulk
                  ? AppColors.primary
                  : AppColors.border,
              width: _selectedProductType == ProductType.bulk ? 2.5 : 1.5,
            ),
            padding: const EdgeInsets.all(24),  // 터치 영역 확대
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
                              .size(20)  // 18sp → 20sp
                              .fontWeight(FontWeight.bold)
                              .color(_selectedProductType == ProductType.bulk
                                  ? AppColors.primary900  // 선택 시 진한 색상
                                  : AppColors.textPrimary)
                              .make(),
                          6.heightBox,
                          '대량 주문에 적합'
                              .text
                              .size(16)  // 14sp → 16sp
                              .color(_selectedProductType == ProductType.bulk
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary)
                              .make(),
                        ],
                      ),
                    ),
                    GFRadio(
                      size: 36,  // 30 → 36 (터치 영역 확대)
                      value: ProductType.bulk,
                      groupValue: _selectedProductType,
                      onChanged: (value) {
                        setState(() {
                          _selectedProductType = value!;
                        });
                      },
                      activeBorderColor: AppColors.primary,
                      activeIcon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 22,  // 18 → 22
                      ),
                      inactiveBorderColor: AppColors.border,
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
          
          // 주문 요약 카드 - 접근성 개선
          GFCard(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            color: AppColors.primary50,  // Material 3 Primary Container
            border: Border.all(
              color: AppColors.primary200,
              width: 1.5,
            ),
            padding: const EdgeInsets.all(24),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                '주문 요약'.text
                    .size(20)  // 18sp → 20sp
                    .fontWeight(FontWeight.bold)
                    .color(AppColors.primary900)  // 진한 Primary 색상
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
          
          // PDF 안내 메시지 - 접근성 개선된 위젯 사용
          PdfNotificationWidget(
            recipientEmail: _getUserEmail(),  // 사용자 이메일 가져오기
            showEmailInfo: true,
            onResendEmail: null,  // 주문 확정 전에는 재발송 불가
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, IconData icon) {
    // 중요 정보 강조를 위한 판단
    final isImportant = label.contains('제품') || label.contains('수량') || label.contains('배송 희망일');
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isImportant ? AppColors.primary : AppColors.primary600,
            size: 24,  // 20 → 24
          ),
          12.widthBox,  // 8 → 12
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label.text
                    .size(16)  // 14sp → 16sp
                    .color(AppColors.textSecondary)  // 개선된 대비율
                    .make(),
                4.heightBox,  // 2 → 4
                value.text
                    .size(isImportant ? 20 : 18)  // 중요 정보는 20sp
                    .fontWeight(isImportant ? FontWeight.bold : FontWeight.w600)
                    .color(isImportant ? AppColors.primary900 : AppColors.textPrimary)
                    .make(),
              ],
            ),
          ),
        ],
      ),
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
      
      // 성공 메시지 및 PDF 안내 다이얼로그
      _showOrderSuccessDialog();
    }
  }
  
  // 사용자 이메일 가져오기
  String? _getUserEmail() {
    // TODO: 실제 사용자 프로필에서 이메일 가져오기
    // 예시: ref.read(userProfileProvider).value?.email
    return 'user@example.com';  // 임시 값
  }
  
  // 주문 성공 다이얼로그 - 접근성 개선
  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 성공 헤더
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.success50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.success100,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 40,
                    ),
                  ),
                  20.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        '주문 성공!'.text
                            .size(24)
                            .fontWeight(FontWeight.bold)
                            .color(AppColors.success900)
                            .make(),
                        8.heightBox,
                        '주문이 성공적으로 등록되었습니다'
                            .text
                            .size(16)
                            .color(AppColors.success800)
                            .make(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // PDF 안내
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // PDF 생성 안내
                  PdfStatusIndicator(
                    isGenerated: false,
                    isEmailSent: false,
                  ),
                  
                  20.heightBox,
                  
                  // 이메일 발송 정보
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.info50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.info200,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: AppColors.info,
                          size: 28,  // 24dp 이상
                        ),
                        12.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              'PDF 주문서 발송 예정'.text
                                  .size(16)
                                  .fontWeight(FontWeight.w600)
                                  .color(AppColors.info900)
                                  .make(),
                              4.heightBox,
                              (_getUserEmail() ?? '등록된 이메일 주소').text
                                  .size(20)  // 18sp → 20sp
                                  .fontWeight(FontWeight.bold)
                                  .color(AppColors.primary)  // Primary 색상으로 강조
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  16.heightBox,
                  
                  // 추가 안내
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.info600,
                        size: 20,
                      ),
                      8.widthBox,
                      Expanded(
                        child: 'PDF 파일은 주문 내역에서도 다운로드 가능합니다'
                            .text
                            .size(16)
                            .color(AppColors.info700)
                            .lineHeight(1.4)
                            .make(),
                      ),
                    ],
                  ),
                  
                  24.heightBox,
                  
                  // 확인 버튼
                  GFButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    text: '확인',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    color: AppColors.primary,
                    size: 56,  // 48dp 이상 터치 영역
                    shape: GFButtonShape.pills,
                    fullWidthButton: true,
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}