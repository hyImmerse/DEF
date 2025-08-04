import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart'; // VelocityX 호환성 레이어
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../config/onboarding_keys.dart';

/// 40-60대 사용자를 위한 Senior-Friendly Showcase 위젯
/// 
/// 특징:
/// - 큰 글씨 (제목 22sp, 내용 18sp)
/// - 높은 대비 색상
/// - 명확한 액션 버튼
/// - 간단한 조작 방법 안내
class SeniorFriendlyShowcase extends StatelessWidget {
  final GlobalKey showcaseKey;
  final OnboardingStepEntity step;
  final Widget child;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final VoidCallback? onPrevious;
  final bool showSkip;
  final bool showPrevious;

  const SeniorFriendlyShowcase({
    super.key,
    required this.showcaseKey,
    required this.step,
    required this.child,
    this.onNext,
    this.onSkip,
    this.onPrevious,
    this.showSkip = true,
    this.showPrevious = false,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: showcaseKey,
      height: _getHeightForType(step.type),
      width: _getWidthForType(step.type),
      targetShapeBorder: _getShapeForType(step.type),
      targetBorderRadius: BorderRadius.circular(16),
      targetPadding: const EdgeInsets.all(8),
      overlayColor: OnboardingColors.overlayColor,
      overlayOpacity: 0.7,
      container: _buildCustomContainer(context),
      child: child,
    );
  }

  /// 단계 타입별 높이
  double _getHeightForType(OnboardingStepType type) {
    switch (type) {
      case OnboardingStepType.basic:
        return 200;
      case OnboardingStepType.custom:
        return 250;
      case OnboardingStepType.highlight:
        return 180;
      case OnboardingStepType.swipe:
        return 220;
      case OnboardingStepType.tap:
        return 200;
      case OnboardingStepType.input:
        return 240;
    }
  }

  /// 단계 타입별 너비
  double _getWidthForType(OnboardingStepType type) {
    switch (type) {
      case OnboardingStepType.basic:
        return 300;
      case OnboardingStepType.custom:
        return 320;
      case OnboardingStepType.highlight:
        return 280;
      case OnboardingStepType.swipe:
        return 300;
      case OnboardingStepType.tap:
        return 300;
      case OnboardingStepType.input:
        return 320;
    }
  }

  /// 단계 타입별 모양
  ShapeBorder _getShapeForType(OnboardingStepType type) {
    switch (type) {
      case OnboardingStepType.basic:
      case OnboardingStepType.custom:
      case OnboardingStepType.highlight:
      case OnboardingStepType.input:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        );
      case OnboardingStepType.swipe:
      case OnboardingStepType.tap:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        );
    }
  }

  /// 커스텀 컨테이너 빌드
  Widget _buildCustomContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 단계 타입 아이콘
          _buildStepTypeIcon(),
          
          const SizedBox(height: 12),
          
          // 제목 - 큰 글씨
          Text(
            step.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 설명 - 읽기 쉬운 글씨
          Text(
            step.description,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          
          // 제스처 안내 (타입별)
          if (step.type == OnboardingStepType.swipe ||
              step.type == OnboardingStepType.tap ||
              step.type == OnboardingStepType.input) ...[
            const SizedBox(height: 16),
            _buildGestureGuide(),
          ],
          
          const SizedBox(height: 24),
          
          // 액션 버튼들
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// 단계 타입 아이콘
  Widget _buildStepTypeIcon() {
    IconData icon;
    Color color;
    
    switch (step.type) {
      case OnboardingStepType.basic:
        icon = Icons.info_outline;
        color = OnboardingColors.primaryColor;
        break;
      case OnboardingStepType.custom:
        icon = Icons.auto_awesome;
        color = OnboardingColors.accentColor;
        break;
      case OnboardingStepType.highlight:
        icon = Icons.highlight;
        color = OnboardingColors.warningColor;
        break;
      case OnboardingStepType.swipe:
        icon = Icons.swipe;
        color = OnboardingColors.accentColor;
        break;
      case OnboardingStepType.tap:
        icon = Icons.touch_app;
        color = OnboardingColors.primaryColor;
        break;
      case OnboardingStepType.input:
        icon = Icons.edit;
        color = OnboardingColors.accentColor;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  /// 제스처 안내
  Widget _buildGestureGuide() {
    Widget gestureWidget;
    
    switch (step.type) {
      case OnboardingStepType.swipe:
        gestureWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back,
              color: OnboardingColors.accentColor,
              size: 20,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward,
              color: OnboardingColors.accentColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '좌우로 밀어서 이동',
              style: TextStyle(
                fontSize: 16,
                color: OnboardingColors.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
        break;
      case OnboardingStepType.tap:
        gestureWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.touch_app,
              color: OnboardingColors.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '터치해보세요',
              style: TextStyle(
                fontSize: 16,
                color: OnboardingColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
        break;
      case OnboardingStepType.input:
        gestureWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.keyboard,
              color: OnboardingColors.accentColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '입력해보세요',
              style: TextStyle(
                fontSize: 16,
                color: OnboardingColors.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: gestureWidget,
    );
  }

  /// 액션 버튼들
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 이전 버튼
        if (showPrevious && onPrevious != null)
          GFButton(
            onPressed: onPrevious,
            text: '이전',
            color: Colors.grey[300]!,
            textColor: Colors.grey[700],
            size: GFSize.LARGE,
            shape: GFButtonShape.pills,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey[700],
              size: 20,
            ),
            position: GFPosition.start,
          ),

        if (showPrevious && onPrevious != null) const SizedBox(width: 12),

        // 건너뛰기 버튼
        if (showSkip && step.isSkippable != false && onSkip != null)
          GFButton(
            onPressed: onSkip,
            text: '건너뛰기',
            type: GFButtonType.outline,
            color: Colors.grey[400]!,
            textColor: Colors.grey[600],
            size: GFSize.LARGE,
            shape: GFButtonShape.pills,
          ),

        if (showSkip && step.isSkippable != false && onSkip != null) const SizedBox(width: 12),

        // 다음/완료 버튼
        GFButton(
          onPressed: onNext,
          text: step.actionText ?? '다음',
          color: OnboardingColors.getColorForType(step.type),
          textColor: Colors.white,
          size: GFSize.LARGE,
          shape: GFButtonShape.pills,
          icon: Icon(
            step.actionText != null ? Icons.check : Icons.arrow_forward,
            color: Colors.white,
            size: 20,
          ),
          position: GFPosition.end,
        ),
      ],
    );
  }
}

/// 온보딩 진행률 표시 위젯
class OnboardingProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeColor;
  final Color? inactiveColor;

  const OnboardingProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 진행률 바
          Container(
            width: 150,
            height: 8,
            decoration: BoxDecoration(
              color: inactiveColor ?? Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: totalSteps > 0 ? (currentStep + 1) / totalSteps : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: activeColor ?? OnboardingColors.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 단계 표시
          Text(
            '${currentStep + 1}/$totalSteps',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

/// 온보딩 완료 축하 위젯
class OnboardingCompletionWidget extends StatelessWidget {
  final String screenName;
  final VoidCallback onDismiss;

  const OnboardingCompletionWidget({
    super.key,
    required this.screenName,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 축하 아이콘
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OnboardingColors.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.celebration,
              color: OnboardingColors.accentColor,
              size: 48,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 축하 메시지
          Text(
            '축하합니다! 🎉',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          Text(
            '$screenName 사용법을 모두 익히셨어요!\n이제 자유롭게 사용해보세요.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 28),
          
          // 완료 버튼
          GFButton(
            onPressed: onDismiss,
            text: '시작하기',
            color: OnboardingColors.accentColor,
            textColor: Colors.white,
            size: GFSize.LARGE,
            shape: GFButtonShape.pills,
            fullWidthButton: true,
            icon: const Icon(
              Icons.rocket_launch,
              color: Colors.white,
              size: 20,
            ),
            position: GFPosition.start,
          ),
        ],
      ),
    );
  }
}