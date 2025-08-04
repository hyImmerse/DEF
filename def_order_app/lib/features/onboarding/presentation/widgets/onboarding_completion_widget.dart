import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart'; // VelocityX 호환성 레이어
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

/// 온보딩 완료 축하 위젯
/// 
/// 40-60대 사용자를 위한 크고 명확한 완료 안내
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
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 축하 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
          ).animate()
              .scale(
                duration: 0.5.seconds,
                curve: Curves.elasticOut,
              ),
          
          20.heightBox,
          
          // 축하 메시지
          '축하합니다! 🎉'
              .text
              .size(24)
              .fontWeight(FontWeight.bold)
              .color(Colors.black87)
              .makeCentered()
              .animate()
              .fadeIn(delay: 0.3.seconds),
          
          12.heightBox,
          
          '$screenName 사용법을 마스터하셨네요!'
              .text
              .size(18)
              .color(Colors.grey[700])
              .center
              .makeCentered()
              .animate()
              .fadeIn(delay: 0.5.seconds),
          
          8.heightBox,
          
          '이제 편리하게 사용하실 수 있어요.'
              .text
              .size(16)
              .color(Colors.grey[600])
              .center
              .makeCentered()
              .animate()
              .fadeIn(delay: 0.7.seconds),
          
          32.heightBox,
          
          // 완료 버튼
          GFButton(
            onPressed: onDismiss,
            text: '확인',
            color: AppTheme.primaryColor,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            size: GFSize.LARGE,
            shape: GFButtonShape.pills,
            fullWidthButton: true,
            blockButton: true,
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 24,
            ),
            position: GFPosition.end,
          ).animate()
              .fadeIn(delay: 0.9.seconds)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 0.3.seconds,
                curve: Curves.easeOut,
              ),
          
          16.heightBox,
          
          // 도움말 안내
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.grey,
                size: 20,
              ),
              8.widthBox,
              Flexible(
                child: '도움말이 필요하시면 메뉴에서 "도움말"을 선택하세요'
                    .text
                    .size(14)
                    .color(Colors.grey[600])
                    .makeCentered(),
              ),
            ],
          ).animate()
              .fadeIn(delay: 1.1.seconds),
        ],
      ),
    );
  }
}

/// 온보딩 진행률 표시기
/// 
/// 현재 진행 단계를 시각적으로 표시
class OnboardingProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  
  const OnboardingProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 진행률 텍스트
        '단계 ${currentStep + 1} / $totalSteps'
            .text
            .size(16)
            .fontWeight(FontWeight.w600)
            .color(AppTheme.primaryColor)
            .make(),
        
        8.heightBox,
        
        // 진행률 바
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: (currentStep + 1) / totalSteps,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ).animate()
                  .slideX(
                    begin: -1,
                    end: 0,
                    duration: 0.5.seconds,
                    curve: Curves.easeOut,
                  ),
            ],
          ),
        ),
      ],
    );
  }
}