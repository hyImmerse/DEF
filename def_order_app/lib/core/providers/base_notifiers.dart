import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../error/failures.dart';
import '../error/exceptions.dart';
import '../utils/logger.dart';

/// 기본 AsyncNotifier 패턴들을 제공하는 추상 클래스
/// 
/// 이 클래스들은 에러 처리, 로딩 상태 관리, 로깅 등의
/// 공통 기능을 제공합니다.

/// AsyncNotifier를 위한 기본 상태 클래스
abstract class BaseAsyncState<T> {
  final T? data;
  final bool isLoading;
  final Failure? error;
  
  const BaseAsyncState({
    this.data,
    this.isLoading = false,
    this.error,
  });
  
  bool get hasData => data != null;
  bool get hasError => error != null;
  
  R when<R>({
    required R Function(T data) data,
    required R Function() loading,
    required R Function(Failure error) error,
  }) {
    if (isLoading) return loading();
    if (hasError) return error(this.error!);
    if (hasData) return data(this.data as T);
    return loading(); // 초기 상태
  }
  
  R maybeWhen<R>({
    R Function(T data)? data,
    R Function()? loading,
    R Function(Failure error)? error,
    required R Function() orElse,
  }) {
    if (isLoading && loading != null) return loading();
    if (hasError && error != null) return error(this.error!);
    if (hasData && data != null) return data(this.data as T);
    return orElse();
  }
}

/// 페이지네이션을 지원하는 상태 클래스
abstract class BasePaginatedState<T> extends BaseAsyncState<List<T>> {
  final bool hasMore;
  final int currentPage;
  final int pageSize;
  
  const BasePaginatedState({
    List<T>? data,
    bool isLoading = false,
    Failure? error,
    this.hasMore = true,
    this.currentPage = 0,
    this.pageSize = 20,
  }) : super(data: data, isLoading: isLoading, error: error);
  
  List<T> get items => data ?? [];
  bool get isEmpty => items.isEmpty;
  bool get canLoadMore => hasMore && !isLoading;
}

/// AsyncNotifier를 위한 기본 믹스인
mixin BaseAsyncNotifierMixin<T> {
  Logger get logger;
  
  /// 예외를 Failure로 변환
  Failure mapExceptionToFailure(dynamic exception) {
    logger.e('Exception occurred', exception);
    
    if (exception is AppAuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        errors: exception.errors,
      );
    } else if (exception is PostgrestException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
      );
    } else {
      return UnknownFailure(
        message: exception.toString(),
      );
    }
  }
  
  /// 안전한 비동기 작업 실행
  Future<T?> guardAsync<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e, stackTrace) {
      logger.e('Async operation failed', e, stackTrace);
      rethrow;
    }
  }
  
  /// 재시도 로직이 포함된 비동기 작업 실행
  Future<T?> guardAsyncWithRetry<T>(
    Future<T> Function() action, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    
    while (attempts < maxAttempts) {
      try {
        return await action();
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) {
          logger.e('All retry attempts failed', e);
          rethrow;
        }
        
        logger.w('Attempt $attempts failed, retrying...', e);
        await Future.delayed(delay * attempts);
      }
    }
    
    return null;
  }
}

/// 페이지네이션을 지원하는 AsyncNotifier 믹스인
mixin PaginatedAsyncNotifierMixin<T> {
  /// 다음 페이지 로드
  Future<List<T>> loadNextPage({
    required int offset,
    required int limit,
    required Future<List<T>> Function(int offset, int limit) fetcher,
  }) async {
    return await fetcher(offset, limit);
  }
  
  /// 페이지 병합
  List<T> mergePages(List<T> currentItems, List<T> newItems, {bool refresh = false}) {
    if (refresh) {
      return newItems;
    }
    return [...currentItems, ...newItems];
  }
  
  /// 중복 제거
  List<T> removeDuplicates(List<T> items, String Function(T) idExtractor) {
    final seen = <String>{};
    return items.where((item) {
      final id = idExtractor(item);
      if (seen.contains(id)) {
        return false;
      }
      seen.add(id);
      return true;
    }).toList();
  }
}

/// 캐싱을 지원하는 AsyncNotifier 믹스인
mixin CachedAsyncNotifierMixin<T> {
  Duration get cacheDuration => const Duration(minutes: 5);
  
  final Map<String, CachedData<T>> _cache = {};
  
  /// 캐시에서 데이터 가져오기
  T? getFromCache(String key) {
    final cached = _cache[key];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }
    _cache.remove(key);
    return null;
  }
  
  /// 캐시에 데이터 저장
  void saveToCache(String key, T data) {
    _cache[key] = CachedData(
      data: data,
      timestamp: DateTime.now(),
      duration: cacheDuration,
    );
  }
  
  /// 캐시 무효화
  void invalidateCache([String? key]) {
    if (key != null) {
      _cache.remove(key);
    } else {
      _cache.clear();
    }
  }
  
  /// 캐시 정리
  void cleanupCache() {
    _cache.removeWhere((_, cached) => cached.isExpired);
  }
}

/// 캐시된 데이터 클래스
class CachedData<T> {
  final T data;
  final DateTime timestamp;
  final Duration duration;
  
  CachedData({
    required this.data,
    required this.timestamp,
    required this.duration,
  });
  
  bool get isExpired => DateTime.now().difference(timestamp) > duration;
}

/// 검색을 지원하는 AsyncNotifier 믹스인
mixin SearchableAsyncNotifierMixin<T> {
  /// 디바운스된 검색
  Future<void> debouncedSearch({
    required String query,
    required Duration delay,
    required Function() onSearch,
    Timer? currentTimer,
  }) async {
    currentTimer?.cancel();
    
    if (query.isEmpty) {
      onSearch();
      return;
    }
    
    Timer(delay, onSearch);
  }
  
  /// 로컬 필터링
  List<T> filterItems(
    List<T> items,
    String query,
    List<String> Function(T) searchableFields,
  ) {
    if (query.isEmpty) return items;
    
    final lowerQuery = query.toLowerCase();
    return items.where((item) {
      final fields = searchableFields(item);
      return fields.any((field) => field.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}