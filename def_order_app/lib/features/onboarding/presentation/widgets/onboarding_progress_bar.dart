import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/onboarding_provider.dart';
import '../../domain/entities/onboarding_entity.dart';

/// 온보딩 진행률 바
/// 
/// 상단 고정, 현재/전체 단계 표시, 건너뛰기 옵션
/// 40-60대 사용자를 위한 큰 글씨와 명확한 UI
class OnboardingProgressBar extends ConsumerStatefulWidget {
  final VoidCallback? onSkip;
  final bool showSkipButton;
  final Color? backgroundColor;
  final Color? progressColor;
  final double height;
  
  const OnboardingProgressBar({
    super.key,
    this.onSkip,
    this.showSkipButton = true,
    this.backgroundColor,
    this.progressColor,
    this.height = 80,
  });

  @override
  ConsumerState<OnboardingProgressBar> createState() => _OnboardingProgressBarState();
}

class _OnboardingProgressBarState extends ConsumerState<OnboardingProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _previousProgress = 0;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    
    // 온보딩이 진행 중이 아니면 표시하지 않음
    if (!onboardingState.isShowcasing || onboardingState.currentSteps.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final currentStep = onboardingState.currentStepIndex + 1;
    final totalSteps = onboardingState.currentSteps.length;
    final progress = currentStep / totalSteps;
    
    // 진행률 애니메이션 업데이트
    if (progress != _previousProgress) {
      _progressAnimation = Tween<double>(
        begin: _previousProgress,
        end: progress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.forward(from: 0);
      _previousProgress = progress;
    }
    
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // 진행률 정보 및 바
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 단계 정보
                    Row(
                      children: [
                        _buildStepIndicator(currentStep, totalSteps),
                        16.widthBox,
                        Expanded(
                          child: _buildStepTitle(onboardingState),
                        ),
                      ],
                    ),
                    
                    8.heightBox,
                    
                    // 진행률 바
                    _buildProgressBar(progress),
                  ],
                ),
              ),
              
              // 건너뛰기 버튼
              if (widget.showSkipButton) ...[
                16.widthBox,
                _buildSkipButton(onboardingState),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStepIndicator(int current, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          '$current'.text
              .size(20)
              .fontWeight(FontWeight.bold)
              .color(AppTheme.primaryColor)
              .make(),
          ' / '.text
              .size(16)
              .color(Colors.grey[600])
              .make(),
          '$total'.text
              .size(18)
              .color(Colors.grey[700])
              .make(),
        ],
      ),
    );
  }
  
  Widget _buildStepTitle(OnboardingState state) {
    final currentStepData = state.currentSteps[state.currentStepIndex];
    
    return currentStepData.title.text
        .size(16)
        .fontWeight(FontWeight.w600)
        .color(Colors.black87)
        .maxLines(1)
        .overflow(TextOverflow.ellipsis)
        .make();
  }
  
  Widget _buildProgressBar(double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 10,
        child: AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.progressColor ?? AppTheme.primaryColor,
              ),
              minHeight: 10,
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildSkipButton(OnboardingState state) {
    return GFButton(
      onPressed: () {
        if (widget.onSkip != null) {
          widget.onSkip!();
        } else {
          ref.read(onboardingProvider.notifier).skipOnboarding();
        }
      },
      text: '건너뛰기',
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      color: Colors.transparent,
      textColor: Colors.grey[600],
      type: GFButtonType.transparent,
      shape: GFButtonShape.pills,
      size: GFSize.MEDIUM,
      icon: Icon(
        Icons.skip_next,
        color: Colors.grey[600],
        size: 20,
      ),
    );
  }
}

/// 플로팅 온보딩 진행률 바
/// 
/// 화면 상단에 오버레이로 표시되는 진행률 바
class FloatingOnboardingProgressBar extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback? onSkip;
  final bool showSkipButton;
  final double top;
  
  const FloatingOnboardingProgressBar({
    super.key,
    required this.child,
    this.onSkip,
    this.showSkipButton = true,
    this.top = 0,
  });

  @override
  ConsumerState<FloatingOnboardingProgressBar> createState() => 
      _FloatingOnboardingProgressBarState();
}

class _FloatingOnboardingProgressBarState 
    extends ConsumerState<FloatingOnboardingProgressBar> 
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }
  
  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    
    // 온보딩 상태에 따라 애니메이션
    if (onboardingState.isShowcasing && onboardingState.currentSteps.isNotEmpty) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
    
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: widget.top,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _slideAnimation,
            child: OnboardingProgressBar(
              onSkip: widget.onSkip,
              showSkipButton: widget.showSkipButton,
            ),
          ),
        ),
      ],
    );
  }
}

/// 미니 온보딩 진행률 인디케이터
/// 
/// 작은 공간에 표시할 수 있는 미니 버전
class MiniOnboardingProgressIndicator extends ConsumerWidget {
  final double size;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool showText;
  
  const MiniOnboardingProgressIndicator({
    super.key,
    this.size = 60,
    this.progressColor,
    this.backgroundColor,
    this.showText = true,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    
    if (!onboardingState.isShowcasing || onboardingState.currentSteps.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final currentStep = onboardingState.currentStepIndex + 1;
    final totalSteps = onboardingState.currentSteps.length;
    final progress = currentStep / totalSteps;
    
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 원형 진행률
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4,
              backgroundColor: backgroundColor ?? Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? AppTheme.primaryColor,
              ),
            ),
          ),
          
          // 텍스트
          if (showText)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                '$currentStep'.text
                    .size(16)
                    .fontWeight(FontWeight.bold)
                    .color(AppTheme.primaryColor)
                    .make(),
                Container(
                  height: 1,
                  width: 20,
                  color: Colors.grey[400],
                  margin: const EdgeInsets.symmetric(vertical: 2),
                ),
                '$totalSteps'.text
                    .size(14)
                    .color(Colors.grey[600])
                    .make(),
              ],
            ),
        ],
      ),
    );
  }
}

/// 온보딩 진행률 도트 인디케이터
/// 
/// 점으로 표시되는 진행률 인디케이터
class OnboardingDotsIndicator extends ConsumerWidget {
  final double dotSize;
  final double spacing;
  final Color? activeColor;
  final Color? inactiveColor;
  final MainAxisAlignment alignment;
  
  const OnboardingDotsIndicator({
    super.key,
    this.dotSize = 10,
    this.spacing = 8,
    this.activeColor,
    this.inactiveColor,
    this.alignment = MainAxisAlignment.center,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    
    if (!onboardingState.isShowcasing || onboardingState.currentSteps.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final currentIndex = onboardingState.currentStepIndex;
    final totalSteps = onboardingState.currentSteps.length;
    
    return Row(
      mainAxisAlignment: alignment,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentIndex;
        final isCompleted = index < currentIndex;
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? dotSize * 2.5 : dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: isActive 
                  ? (activeColor ?? AppTheme.primaryColor)
                  : isCompleted
                      ? (activeColor ?? AppTheme.primaryColor).withOpacity(0.5)
                      : (inactiveColor ?? Colors.grey[300]),
              borderRadius: BorderRadius.circular(dotSize / 2),
            ),
          ),
        );
      }),
    );
  }
}