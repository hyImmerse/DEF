import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../error/failures.dart';
import '../theme/app_colors.dart';
import '../utils/toast_utils.dart';

/// Provider 관련 유틸리티 함수들
/// 
/// 이 파일은 Provider 사용 시 반복되는 패턴들을
/// 간소화하는 유틸리티 함수들을 제공합니다.

/// Provider 에러 처리를 위한 extension
extension AsyncValueX<T> on AsyncValue<T> {
  /// 에러를 토스트로 표시
  void showErrorToast(BuildContext context) {
    whenOrNull(
      error: (error, _) {
        final message = error is Failure
            ? error.message
            : '오류가 발생했습니다';
        ToastUtils.showError(context, message);
      },
    );
  }
  
  /// 로딩 상태에 따른 위젯 빌드
  Widget whenWidget({
    required Widget Function(T data) data,
    Widget Function()? loading,
    Widget Function(Object error, StackTrace stackTrace)? error,
  }) {
    return when(
      data: data,
      loading: () => loading ?? const _DefaultLoadingWidget(),
      error: (err, stack) => error?.call(err, stack) ?? _DefaultErrorWidget(error: err),
    );
  }
  
  /// 데이터가 있을 때만 위젯 빌드
  Widget? whenDataWidget(Widget Function(T data) builder) {
    return whenOrNull(data: builder);
  }
}

/// Failure extension for UI
extension FailureX on Failure {
  /// Failure를 사용자 친화적인 메시지로 변환
  String get userMessage {
    if (this is NetworkFailure) {
      return '네트워크 연결을 확인해주세요';
    } else if (this is AuthFailure) {
      final authFailure = this as AuthFailure;
      switch (authFailure.code) {
        case 'INVALID_CREDENTIALS':
          return '아이디 또는 비밀번호가 올바르지 않습니다';
        case 'USER_NOT_FOUND':
          return '등록되지 않은 사용자입니다';
        case 'BUSINESS_NUMBER_NOT_FOUND':
          return '등록되지 않은 사업자번호입니다';
        case 'PENDING_APPROVAL':
          return '관리자 승인 대기 중입니다';
        case 'ACCOUNT_INACTIVE':
          return '비활성화된 계정입니다';
        default:
          return authFailure.message;
      }
    } else if (this is ServerFailure) {
      return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요';
    } else if (this is CacheFailure) {
      return '로컬 저장소 오류가 발생했습니다';
    } else if (this is ValidationFailure) {
      final validationFailure = this as ValidationFailure;
      if (validationFailure.errors.isNotEmpty) {
        return validationFailure.errors.values.first.first;
      }
      return validationFailure.message;
    }
    return message;
  }
  
  /// Failure 타입에 따른 아이콘
  IconData get icon {
    if (this is NetworkFailure) {
      return Icons.wifi_off;
    } else if (this is AuthFailure) {
      return Icons.lock_outline;
    } else if (this is ServerFailure) {
      return Icons.cloud_off;
    } else if (this is ValidationFailure) {
      return Icons.error_outline;
    }
    return Icons.error;
  }
  
  /// Failure 타입에 따른 색상
  Color get color {
    if (this is NetworkFailure) {
      return Colors.orange;
    } else if (this is AuthFailure) {
      return AppColors.error;
    } else if (this is ServerFailure) {
      return AppColors.error;
    } else if (this is ValidationFailure) {
      return Colors.amber;
    }
    return AppColors.error;
  }
}

/// 기본 로딩 위젯
class _DefaultLoadingWidget extends StatelessWidget {
  const _DefaultLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// 기본 에러 위젯
class _DefaultErrorWidget extends StatelessWidget {
  final Object error;
  
  const _DefaultErrorWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    final failure = error is Failure ? error : UnknownFailure(message: error.toString());
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              failure.icon,
              size: 64,
              color: failure.color,
            ),
            const SizedBox(height: 16),
            Text(
              failure.userMessage,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider를 안전하게 읽는 extension
extension WidgetRefX on WidgetRef {
  /// Provider를 안전하게 watch하고 에러 처리
  T? watchSafe<T>(ProviderListenable<T> provider, {T? defaultValue}) {
    try {
      return watch(provider);
    } catch (e) {
      return defaultValue;
    }
  }
  
  /// Provider를 안전하게 read하고 에러 처리
  T? readSafe<T>(ProviderListenable<T> provider, {T? defaultValue}) {
    try {
      return read(provider);
    } catch (e) {
      return defaultValue;
    }
  }
}

/// Provider 새로고침 유틸리티
class ProviderRefreshUtils {
  /// 여러 Provider를 동시에 새로고침
  static Future<void> refreshMultiple(
    WidgetRef ref,
    List<ProviderOrFamily> providers,
  ) async {
    await Future.wait(
      providers.map((provider) => ref.refresh(provider.future)),
    );
  }
  
  /// 조건부 Provider 새로고침
  static Future<void> refreshIf(
    WidgetRef ref,
    ProviderOrFamily provider,
    bool Function() condition,
  ) async {
    if (condition()) {
      await ref.refresh(provider.future);
    }
  }
  
  /// 지연된 Provider 새로고침
  static Future<void> refreshDelayed(
    WidgetRef ref,
    ProviderOrFamily provider,
    Duration delay,
  ) async {
    await Future.delayed(delay);
    await ref.refresh(provider.future);
  }
}

/// Provider 의존성 관리
class ProviderDependencies {
  /// Provider 의존성 체인 무효화
  static void invalidateChain(
    WidgetRef ref,
    List<ProviderOrFamily> providers,
  ) {
    for (final provider in providers) {
      ref.invalidate(provider);
    }
  }
  
  /// 조건부 의존성 무효화
  static void invalidateIf(
    WidgetRef ref,
    Map<ProviderOrFamily, bool Function()> providerConditions,
  ) {
    providerConditions.forEach((provider, condition) {
      if (condition()) {
        ref.invalidate(provider);
      }
    });
  }
}

/// Provider 상태 저장 및 복원
class ProviderStateManager {
  static final Map<String, dynamic> _savedStates = {};
  
  /// 상태 저장
  static void saveState<T>(String key, T state) {
    _savedStates[key] = state;
  }
  
  /// 상태 복원
  static T? restoreState<T>(String key) {
    return _savedStates[key] as T?;
  }
  
  /// 저장된 상태 삭제
  static void clearState(String key) {
    _savedStates.remove(key);
  }
  
  /// 모든 저장된 상태 삭제
  static void clearAllStates() {
    _savedStates.clear();
  }
}

/// Toast 유틸리티 임시 구현 (실제 구현은 별도 파일에)
class ToastUtils {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
  
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }
  
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.info,
      ),
    );
  }
}