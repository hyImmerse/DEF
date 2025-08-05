import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/onboarding_entity.dart';

part 'onboarding_provider.freezed.dart';

/// 온보딩 상태
@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default({}) Map<String, OnboardingProgressEntity> screenProgress,
    @Default(false) bool isOnboardingEnabled,
    @Default(false) bool isFirstLaunch,
    @Default([]) List<OnboardingStepEntity> currentSteps,
    String? currentScreenId,
    @Default(0) int currentStepIndex,
    @Default(false) bool isShowcasing,
    String? error,
  }) = _OnboardingState;

  const OnboardingState._();

  /// 현재 화면의 진행 상태
  OnboardingProgressEntity? get currentProgress {
    if (currentScreenId == null) return null;
    return screenProgress[currentScreenId!];
  }

  /// 전체 완료율
  double get overallProgress {
    if (screenProgress.isEmpty) return 0.0;
    
    final completedScreens = screenProgress.values
        .where((progress) => progress.isCompleted)
        .length;
    
    return completedScreens / screenProgress.length;
  }

  /// 온보딩 필요 여부
  bool get needsOnboarding {
    return isFirstLaunch || 
           (isOnboardingEnabled && overallProgress < 1.0);
  }

  /// 특정 화면의 온보딩 완료 여부
  bool isScreenCompleted(String screenId) {
    final progress = screenProgress[screenId];
    return progress?.isCompleted ?? false;
  }
}

/// 온보딩 상태 관리 Provider
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final LocalStorageService _localStorage;
  
  static const String _onboardingEnabledKey = 'onboarding_enabled';
  static const String _firstLaunchKey = 'is_first_launch';
  static const String _progressKeyPrefix = 'onboarding_progress_';

  OnboardingNotifier(this._localStorage) : super(const OnboardingState()) {
    _loadOnboardingSettings();
  }

  /// 온보딩 설정 로드
  Future<void> _loadOnboardingSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final isEnabled = prefs.getBool(_onboardingEnabledKey) ?? true;
      final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;
      
      // 화면별 진행 상태 로드
      final Map<String, OnboardingProgressEntity> progressMap = {};
      
      for (final screenType in OnboardingScreenType.values) {
        final progressJson = prefs.getString('${_progressKeyPrefix}${screenType.id}');
        if (progressJson != null) {
          // JSON에서 OnboardingProgressEntity 복원
          // 실제 구현에서는 fromJson 메소드 사용
          progressMap[screenType.id] = OnboardingProgressEntity(
            screenId: screenType.id,
            isCompleted: false,
            lastCompletedAt: DateTime.now(),
          );
        }
      }

      state = state.copyWith(
        isOnboardingEnabled: isEnabled,
        isFirstLaunch: isFirstLaunch,
        screenProgress: progressMap,
      );
    } catch (e) {
      state = state.copyWith(error: '온보딩 설정을 불러올 수 없습니다: $e');
    }
  }

  /// 온보딩 활성화/비활성화
  Future<void> setOnboardingEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingEnabledKey, enabled);
      
      state = state.copyWith(isOnboardingEnabled: enabled);
    } catch (e) {
      state = state.copyWith(error: '온보딩 설정을 저장할 수 없습니다: $e');
    }
  }

  /// 첫 실행 상태 업데이트
  Future<void> setFirstLaunchCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstLaunchKey, false);
      
      state = state.copyWith(isFirstLaunch: false);
    } catch (e) {
      state = state.copyWith(error: '첫 실행 상태를 저장할 수 없습니다: $e');
    }
  }

  /// 화면별 온보딩 단계 설정
  void setCurrentScreen(String screenId, List<OnboardingStepEntity> steps) {
    state = state.copyWith(
      currentScreenId: screenId,
      currentSteps: steps,
      currentStepIndex: 0,
      isShowcasing: false,
    );
  }

  /// 온보딩 시작
  void startOnboarding() {
    if (state.currentSteps.isEmpty) return;
    
    state = state.copyWith(
      isShowcasing: true,
      currentStepIndex: 0,
    );
  }

  /// 다음 단계로 이동
  void nextStep() {
    final nextIndex = state.currentStepIndex + 1;
    
    if (nextIndex >= state.currentSteps.length) {
      // 온보딩 완료
      completeCurrentScreenOnboarding();
    } else {
      state = state.copyWith(currentStepIndex: nextIndex);
    }
  }

  /// 이전 단계로 이동
  void previousStep() {
    if (state.currentStepIndex > 0) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex - 1,
      );
    }
  }

  /// 온보딩 건너뛰기
  void skipOnboarding() {
    completeCurrentScreenOnboarding();
  }

  /// 현재 화면 온보딩 완료
  Future<void> completeCurrentScreenOnboarding() async {
    if (state.currentScreenId == null) return;

    try {
      final currentScreenId = state.currentScreenId!;
      final completedProgress = OnboardingProgressEntity(
        screenId: currentScreenId,
        isCompleted: true,
        lastCompletedAt: DateTime.now(),
        completedSteps: state.currentSteps.map((step) => step.id).toList(),
        currentStep: state.currentSteps.length,
        totalSteps: state.currentSteps.length,
      );

      // SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      // 실제 구현에서는 toJson 메소드 사용
      await prefs.setString(
        '${_progressKeyPrefix}$currentScreenId',
        'completed', // JSON 문자열로 저장
      );

      // 상태 업데이트
      final updatedProgress = Map<String, OnboardingProgressEntity>.from(
        state.screenProgress,
      );
      updatedProgress[currentScreenId] = completedProgress;

      state = state.copyWith(
        screenProgress: updatedProgress,
        isShowcasing: false,
        currentStepIndex: 0,
      );

      // 첫 실행이면 완료 처리
      if (state.isFirstLaunch) {
        await setFirstLaunchCompleted();
      }
    } catch (e) {
      state = state.copyWith(error: '온보딩 완료 상태를 저장할 수 없습니다: $e');
    }
  }

  /// 온보딩 리셋 (개발/테스트용)
  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 모든 온보딩 관련 데이터 삭제
      for (final screenType in OnboardingScreenType.values) {
        await prefs.remove('${_progressKeyPrefix}${screenType.id}');
      }
      await prefs.setBool(_firstLaunchKey, true);

      state = const OnboardingState(
        isOnboardingEnabled: true,
        isFirstLaunch: true,
      );
    } catch (e) {
      state = state.copyWith(error: '온보딩 리셋 중 오류 발생: $e');
    }
  }

  /// 특정 화면 온보딩 완료 여부 확인
  bool isScreenCompleted(String screenId) {
    final progress = state.screenProgress[screenId];
    return progress?.isCompleted ?? false;
  }

  /// 온보딩 진행률 가져오기
  double getScreenProgress(String screenId) {
    final progress = state.screenProgress[screenId];
    return progress?.progressPercent ?? 0.0;
  }
}

/// 온보딩 Provider
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final localStorage = ref.read(localStorageServiceProvider);
  return OnboardingNotifier(localStorage);
});

/// 특정 화면의 온보딩 완료 여부 Provider
final screenOnboardingCompletedProvider = Provider.family<bool, String>((ref, screenId) {
  final onboardingState = ref.watch(onboardingProvider);
  return onboardingState.screenProgress[screenId]?.isCompleted ?? false;
});

/// 온보딩 필요 여부 Provider
final needsOnboardingProvider = Provider<bool>((ref) {
  final onboardingState = ref.watch(onboardingProvider);
  return onboardingState.needsOnboarding;
});

/// 전체 온보딩 진행률 Provider
final overallOnboardingProgressProvider = Provider<double>((ref) {
  final onboardingState = ref.watch(onboardingProvider);
  return onboardingState.overallProgress;
});