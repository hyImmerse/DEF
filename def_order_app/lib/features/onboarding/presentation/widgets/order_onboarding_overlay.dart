import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../providers/onboarding_provider.dart';
import '../config/onboarding_keys.dart';
import 'onboarding_progress_bar.dart';

/// 주문 화면 3단계 온보딩 오버레이
/// 
/// 제품선택 → 수량입력 → 배송정보 순차적 가이드
/// 40-60대 사용자 최적화 (큰 글씨, 명확한 안내)
class OrderOnboardingOverlay extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback? onCompleted;
  
  const OrderOnboardingOverlay({
    super.key,
    required this.child,
    this.onCompleted,
  });

  @override
  ConsumerState<OrderOnboardingOverlay> createState() => _OrderOnboardingOverlayState();
}

class _OrderOnboardingOverlayState extends ConsumerState<OrderOnboardingOverlay> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isShowingOnboarding = false;
  
  // 현재 하이라이트할 영역
  Rect? _targetRect;
  final GlobalKey _overlayKey = GlobalKey();
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    // 온보딩 시작 확인
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStartOnboarding();
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _checkAndStartOnboarding() {
    final onboardingState = ref.read(onboardingProvider);
    
    // 주문 화면 온보딩이 필요한지 확인
    if (onboardingState.needsOnboarding && 
        !onboardingState.isScreenCompleted(OnboardingScreenType.orderCreate.id)) {
      // 온보딩 단계 설정
      final steps = OnboardingSteps.getOrderCreateSteps();
      ref.read(onboardingProvider.notifier).setCurrentScreen(
        OnboardingScreenType.orderCreate.id,
        steps,
      );
      
      // 온보딩 시작
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _isShowingOnboarding = true;
        });
        ref.read(onboardingProvider.notifier).startOnboarding();
        _animationController.forward();
        _updateTargetRect();
      });
    }
  }
  
  void _updateTargetRect() {
    final onboardingState = ref.read(onboardingProvider);
    if (!onboardingState.isShowcasing) return;
    
    final currentStep = onboardingState.currentSteps.isNotEmpty && 
                       onboardingState.currentStepIndex < onboardingState.currentSteps.length
        ? onboardingState.currentSteps[onboardingState.currentStepIndex]
        : null;
    
    if (currentStep == null) return;
    
    // 현재 단계의 타겟 위젯 찾기
    GlobalKey? targetKey;
    switch (currentStep.id) {
      case 'order_product_selection':
        targetKey = OnboardingKeys.instance.orderProductSelectionKey;
        break;
      case 'order_quantity':
        targetKey = OnboardingKeys.instance.orderQuantityInputKey;
        break;
      case 'order_delivery':
        targetKey = OnboardingKeys.instance.orderDeliveryInfoKey;
        break;
      case 'order_submit':
        targetKey = OnboardingKeys.instance.orderSubmitButtonKey;
        break;
    }
    
    if (targetKey?.currentContext != null) {
      final RenderBox renderBox = targetKey!.currentContext!.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      setState(() {
        _targetRect = Rect.fromLTWH(
          offset.dx - 10,
          offset.dy - 10,
          renderBox.size.width + 20,
          renderBox.size.height + 20,
        );
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    
    // 온보딩이 진행 중이 아니면 자식 위젯만 반환
    if (!onboardingState.isShowcasing || !_isShowingOnboarding) {
      return widget.child;
    }
    
    return FloatingOnboardingProgressBar(
      onSkip: () {
        _animationController.reverse().then((_) {
          setState(() {
            _isShowingOnboarding = false;
          });
          ref.read(onboardingProvider.notifier).skipOnboarding();
          widget.onCompleted?.call();
        });
      },
      showSkipButton: true,
      child: Stack(
        children: [
          widget.child,
          if (_isShowingOnboarding && onboardingState.isShowcasing) ...[
            // 어두운 오버레이
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value * 0.8,
                  child: Container(
                    color: Colors.black,
                    child: CustomPaint(
                      key: _overlayKey,
                      painter: _HolePainter(
                        targetRect: _targetRect,
                        borderRadius: 16.0,
                      ),
                      child: Container(),
                    ),
                  ),
                );
              },
            ),
            
            // 온보딩 콘텐츠
            if (onboardingState.currentSteps.isNotEmpty && 
                onboardingState.currentStepIndex < onboardingState.currentSteps.length)
              _buildOnboardingContent(
                onboardingState.currentSteps[onboardingState.currentStepIndex],
                onboardingState.currentStepIndex,
                onboardingState.currentSteps.length,
              ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildOnboardingContent(
    OnboardingStepEntity step,
    int currentIndex,
    int totalSteps,
  ) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 상단 여백 (진행률 바가 상단에 있으므로)
                  100.heightBox,
                  
                  // 온보딩 카드
                  GFCard(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    padding: const EdgeInsets.all(24),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 단계 아이콘
                        _buildStepIcon(step.id),
                        
                        20.heightBox,
                        
                        // 제목
                        step.title.text
                            .size(24)
                            .fontWeight(FontWeight.bold)
                            .color(Colors.black87)
                            .align(TextAlign.center)
                            .make(),
                        
                        16.heightBox,
                        
                        // 설명
                        step.description.text
                            .size(18)
                            .color(Colors.grey[700])
                            .align(TextAlign.center)
                            .lineHeight(1.5)
                            .make(),
                        
                        32.heightBox,
                        
                        // 버튼들
                        _buildActionButtons(currentIndex, totalSteps),
                      ],
                    ),
                  ),
                  
                  // 타겟 영역 화살표 (필요시)
                  if (_targetRect != null)
                    _buildTargetArrow(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildProgressIndicator(int currentIndex, int totalSteps) {
    // 상단 진행률 바로 이동했으므로 이 메서드는 빈 위젯 반환
    return const SizedBox.shrink();
  }
  
  Widget _buildStepIcon(String stepId) {
    IconData iconData;
    Color iconColor;
    
    switch (stepId) {
      case 'order_product_selection':
        iconData = Icons.inventory_2;
        iconColor = Colors.blue;
        break;
      case 'order_quantity':
        iconData = Icons.format_list_numbered;
        iconColor = Colors.green;
        break;
      case 'order_delivery':
        iconData = Icons.local_shipping;
        iconColor = Colors.orange;
        break;
      case 'order_submit':
        iconData = Icons.check_circle;
        iconColor = Colors.teal;
        break;
      default:
        iconData = Icons.info;
        iconColor = AppTheme.primaryColor;
    }
    
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 48,
        color: iconColor,
      ),
    );
  }
  
  Widget _buildActionButtons(int currentIndex, int totalSteps) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 다음/완료 버튼
        GFButton(
          onPressed: () {
            if (currentIndex < totalSteps - 1) {
              // 다음 단계로
              ref.read(onboardingProvider.notifier).nextStep();
              _updateTargetRect();
            } else {
              // 온보딩 완료
              _animationController.reverse().then((_) {
                setState(() {
                  _isShowingOnboarding = false;
                });
                ref.read(onboardingProvider.notifier).completeCurrentScreenOnboarding();
                widget.onCompleted?.call();
              });
            }
          },
          text: currentIndex < totalSteps - 1 ? '다음' : '시작하기',
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          color: AppTheme.primaryColor,
          size: GFSize.LARGE,
          shape: GFButtonShape.pills,
          icon: Icon(
            currentIndex < totalSteps - 1 ? Icons.arrow_forward : Icons.check,
            color: Colors.white,
            size: 20,
          ),
          position: GFPosition.end,
          blockButton: false,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
      ],
    );
  }
  
  Widget _buildTargetArrow() {
    if (_targetRect == null) return const SizedBox.shrink();
    
    // 타겟 영역을 가리키는 화살표 (필요시 구현)
    return Positioned(
      left: _targetRect!.center.dx - 20,
      top: _targetRect!.top - 60,
      child: Column(
        children: [
          '여기를 눌러주세요'.text
              .size(16)
              .fontWeight(FontWeight.bold)
              .color(Colors.white)
              .make(),
          Icon(
            Icons.arrow_downward,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }
}

/// 하이라이트 영역을 위한 커스텀 페인터
class _HolePainter extends CustomPainter {
  final Rect? targetRect;
  final double borderRadius;
  
  _HolePainter({
    this.targetRect,
    this.borderRadius = 16.0,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (targetRect == null) return;
    
    final paint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;
    
    // 전체 영역을 검은색으로 채우고
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.black);
    
    // 타겟 영역만 투명하게
    canvas.drawRRect(
      RRect.fromRectAndRadius(targetRect!, Radius.circular(borderRadius)),
      paint,
    );
    
    canvas.restore();
  }
  
  @override
  bool shouldRepaint(covariant _HolePainter oldDelegate) {
    return targetRect != oldDelegate.targetRect;
  }
}