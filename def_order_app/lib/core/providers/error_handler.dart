import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../error/failures.dart';
import '../utils/logger.dart';

/// 전역 에러 핸들러
/// 
/// 이 클래스는 앱 전체의 에러를 중앙에서 관리하고
/// 일관된 에러 처리를 제공합니다.

/// 에러 이벤트
class ErrorEvent {
  final Object error;
  final StackTrace? stackTrace;
  final String? source;
  final DateTime timestamp;
  
  ErrorEvent({
    required this.error,
    this.stackTrace,
    this.source,
  }) : timestamp = DateTime.now();
  
  Failure get failure {
    if (error is Failure) {
      return error as Failure;
    }
    return UnknownFailure(message: error.toString());
  }
}

/// 에러 핸들러 Notifier
class ErrorHandlerNotifier extends StateNotifier<List<ErrorEvent>> {
  final Logger _logger;
  
  ErrorHandlerNotifier(this._logger) : super([]);
  
  /// 에러 추가
  void addError(Object error, {StackTrace? stackTrace, String? source}) {
    final event = ErrorEvent(
      error: error,
      stackTrace: stackTrace,
      source: source,
    );
    
    state = [...state, event];
    
    // 로그 기록
    _logger.e(
      'Error from ${source ?? 'Unknown'}',
      error,
      stackTrace,
    );
    
    // 개발 모드에서는 콘솔에도 출력
    if (kDebugMode) {
      debugPrint('🔴 Error: ${event.failure.userMessage}');
      if (stackTrace != null) {
        debugPrintStack(stackTrace: stackTrace);
      }
    }
    
    // 오래된 에러 제거 (최대 50개 유지)
    if (state.length > 50) {
      state = state.sublist(state.length - 50);
    }
  }
  
  /// 특정 소스의 에러 제거
  void clearErrorsFromSource(String source) {
    state = state.where((event) => event.source != source).toList();
  }
  
  /// 모든 에러 제거
  void clearAllErrors() {
    state = [];
  }
  
  /// 최근 에러 가져오기
  ErrorEvent? get lastError => state.isEmpty ? null : state.last;
  
  /// 특정 소스의 최근 에러 가져오기
  ErrorEvent? getLastErrorFromSource(String source) {
    return state.lastWhereOrNull((event) => event.source == source);
  }
}

/// 에러 핸들러 Provider
final errorHandlerProvider = StateNotifierProvider<ErrorHandlerNotifier, List<ErrorEvent>>((ref) {
  final logger = ref.watch(loggerProvider);
  return ErrorHandlerNotifier(logger);
});

/// 에러 처리 믹스인
mixin ErrorHandlerMixin {
  void handleError(
    WidgetRef ref,
    Object error, {
    StackTrace? stackTrace,
    String? source,
  }) {
    ref.read(errorHandlerProvider.notifier).addError(
      error,
      stackTrace: stackTrace,
      source: source,
    );
  }
}

/// 에러 처리 래퍼 함수들
class ErrorHandler {
  /// Future를 에러 처리와 함께 실행
  static Future<T?> guardFuture<T>(
    WidgetRef ref,
    Future<T> Function() action, {
    String? source,
    T? fallback,
    void Function(Failure)? onError,
  }) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      ref.read(errorHandlerProvider.notifier).addError(
        error,
        stackTrace: stackTrace,
        source: source,
      );
      
      final failure = error is Failure 
          ? error 
          : UnknownFailure(message: error.toString());
          
      onError?.call(failure);
      return fallback;
    }
  }
  
  /// 동기 함수를 에러 처리와 함께 실행
  static T? guard<T>(
    WidgetRef ref,
    T Function() action, {
    String? source,
    T? fallback,
    void Function(Failure)? onError,
  }) {
    try {
      return action();
    } catch (error, stackTrace) {
      ref.read(errorHandlerProvider.notifier).addError(
        error,
        stackTrace: stackTrace,
        source: source,
      );
      
      final failure = error is Failure 
          ? error 
          : UnknownFailure(message: error.toString());
          
      onError?.call(failure);
      return fallback;
    }
  }
  
  /// Stream을 에러 처리와 함께 변환
  static Stream<T> guardStream<T>(
    WidgetRef ref,
    Stream<T> stream, {
    String? source,
    void Function(Failure)? onError,
  }) {
    return stream.handleError((error, stackTrace) {
      ref.read(errorHandlerProvider.notifier).addError(
        error,
        stackTrace: stackTrace,
        source: source,
      );
      
      final failure = error is Failure 
          ? error 
          : UnknownFailure(message: error.toString());
          
      onError?.call(failure);
    });
  }
}

/// 에러 복구 전략
abstract class ErrorRecoveryStrategy {
  Future<void> recover(ErrorEvent error);
}

/// 재시도 복구 전략
class RetryRecoveryStrategy implements ErrorRecoveryStrategy {
  final Future<void> Function() retryAction;
  final int maxAttempts;
  final Duration delay;
  
  RetryRecoveryStrategy({
    required this.retryAction,
    this.maxAttempts = 3,
    this.delay = const Duration(seconds: 1),
  });
  
  @override
  Future<void> recover(ErrorEvent error) async {
    for (int i = 0; i < maxAttempts; i++) {
      try {
        await Future.delayed(delay * (i + 1));
        await retryAction();
        break;
      } catch (_) {
        if (i == maxAttempts - 1) rethrow;
      }
    }
  }
}

/// 폴백 복구 전략
class FallbackRecoveryStrategy implements ErrorRecoveryStrategy {
  final Future<void> Function() fallbackAction;
  
  FallbackRecoveryStrategy({required this.fallbackAction});
  
  @override
  Future<void> recover(ErrorEvent error) async {
    await fallbackAction();
  }
}

/// 복합 복구 전략
class CompositeRecoveryStrategy implements ErrorRecoveryStrategy {
  final List<ErrorRecoveryStrategy> strategies;
  
  CompositeRecoveryStrategy({required this.strategies});
  
  @override
  Future<void> recover(ErrorEvent error) async {
    for (final strategy in strategies) {
      try {
        await strategy.recover(error);
        break;
      } catch (_) {
        // 다음 전략 시도
      }
    }
  }
}

/// List extension for null-safe operations
extension ListX<T> on List<T> {
  T? lastWhereOrNull(bool Function(T) test) {
    try {
      return lastWhere(test);
    } catch (_) {
      return null;
    }
  }
}

/// Failure extension for user messages
extension FailureUserMessage on Failure {
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
}