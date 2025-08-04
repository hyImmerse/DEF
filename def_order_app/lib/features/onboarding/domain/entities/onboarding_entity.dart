import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_entity.freezed.dart';

/// 온보딩 단계 엔티티
@freezed
class OnboardingStepEntity with _$OnboardingStepEntity {
  const factory OnboardingStepEntity({
    required String id,
    required String title,
    required String description,
    required String targetKey,
    required OnboardingStepType type,
    @Default(0) int order,
    String? customWidget,
    String? actionText,
    bool? isSkippable,
    Duration? displayDuration,
  }) = _OnboardingStepEntity;
}

/// 온보딩 진행 상태 엔티티
@freezed
class OnboardingProgressEntity with _$OnboardingProgressEntity {
  const factory OnboardingProgressEntity({
    required String screenId,
    required bool isCompleted,
    required DateTime lastCompletedAt,
    @Default([]) List<String> completedSteps,
    @Default(0) int currentStep,
    @Default(0) int totalSteps,
  }) = _OnboardingProgressEntity;

  const OnboardingProgressEntity._();

  /// 진행률 계산
  double get progressPercent {
    if (totalSteps == 0) return 0.0;
    return currentStep / totalSteps;
  }

  /// 완료 여부
  bool get isFullyCompleted => currentStep >= totalSteps && isCompleted;
}

/// 온보딩 단계 타입
enum OnboardingStepType {
  /// 기본 툴팁
  basic,
  /// 커스텀 위젯
  custom,
  /// 강조 표시
  highlight,
  /// 스와이프 제스처
  swipe,
  /// 탭 제스처
  tap,
  /// 텍스트 입력
  input,
}

/// 온보딩 화면 타입
enum OnboardingScreenType {
  /// 홈 화면
  home('home', '홈 화면'),
  /// 주문 등록
  orderCreate('order_create', '주문 등록'),
  /// 주문 내역
  orderHistory('order_history', '주문 내역'),
  /// 공지사항
  notice('notice', '공지사항'),
  /// 설정
  settings('settings', '설정');

  const OnboardingScreenType(this.id, this.displayName);
  
  final String id;
  final String displayName;
}