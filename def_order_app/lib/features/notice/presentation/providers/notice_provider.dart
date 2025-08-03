import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notice_entity.dart';
import '../../data/repositories/notice_repository_impl.dart';

part 'notice_provider.freezed.dart';

// 공지사항 상태
@freezed
class NoticeState with _$NoticeState {
  const factory NoticeState({
    @Default([]) List<NoticeEntity> notices,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? error,
    String? selectedCategory,
    String? searchQuery,
    @Default(0) int offset,
    @Default(20) int limit,
  }) = _NoticeState;
}

// 공지사항 상태 관리
class NoticeNotifier extends StateNotifier<NoticeState> {
  final Ref ref;
  
  NoticeNotifier(this.ref) : super(const NoticeState()) {
    loadNotices();
  }

  // 공지사항 목록 로드
  Future<void> loadNotices({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      offset: refresh ? 0 : state.offset,
    );

    final repository = ref.read(noticeRepositoryProvider);
    final result = await repository.getNotices(
      limit: state.limit,
      offset: refresh ? 0 : state.offset,
      category: state.selectedCategory,
      isImportant: null,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (notices) {
        state = state.copyWith(
          notices: refresh ? notices : [...state.notices, ...notices],
          isLoading: false,
          hasMore: notices.length >= state.limit,
          offset: refresh ? state.limit : state.offset + notices.length,
        );
      },
    );
  }

  // 더 많은 공지사항 로드
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    final repository = ref.read(noticeRepositoryProvider);
    final result = await repository.getNotices(
      limit: state.limit,
      offset: state.offset,
      category: state.selectedCategory,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingMore: false,
          error: failure.message,
        );
      },
      (notices) {
        state = state.copyWith(
          notices: [...state.notices, ...notices],
          isLoadingMore: false,
          hasMore: notices.length >= state.limit,
          offset: state.offset + notices.length,
        );
      },
    );
  }

  // 카테고리 필터 설정
  void setCategory(String? category) {
    if (state.selectedCategory != category) {
      state = state.copyWith(
        selectedCategory: category,
        searchQuery: null,
      );
      loadNotices(refresh: true);
    }
  }

  // 검색
  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchQuery: null);
      loadNotices(refresh: true);
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
      searchQuery: query,
    );

    final repository = ref.read(noticeRepositoryProvider);
    final result = await repository.searchNotices(query);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (notices) {
        state = state.copyWith(
          notices: notices,
          isLoading: false,
          hasMore: false,
        );
      },
    );
  }

  // 읽음 처리
  Future<void> markAsRead(String noticeId) async {
    final repository = ref.read(noticeRepositoryProvider);
    await repository.markAsRead(noticeId);
    
    // 상태 업데이트
    state = state.copyWith(
      notices: state.notices.map((notice) {
        if (notice.id == noticeId) {
          return notice.copyWith(isRead: true);
        }
        return notice;
      }).toList(),
    );
  }

  // 새로고침
  Future<void> refresh() async {
    await loadNotices(refresh: true);
  }
}

// Provider
final noticeProvider = StateNotifierProvider<NoticeNotifier, NoticeState>((ref) {
  return NoticeNotifier(ref);
});

// 공지사항 상세 Provider
final noticeDetailProvider = FutureProvider.family<NoticeEntity, String>((ref, id) async {
  final repository = ref.read(noticeRepositoryProvider);
  
  // 조회수 증가
  await repository.incrementViewCount(id);
  
  // 공지사항 조회
  final result = await repository.getNoticeById(id);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (notice) {
      // 읽음 처리
      ref.read(noticeProvider.notifier).markAsRead(id);
      return notice;
    },
  );
});

// 카테고리 목록 Provider
final noticeCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(noticeRepositoryProvider);
  final result = await repository.getCategories();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (categories) => categories,
  );
});

// 읽지 않은 공지사항 수 Provider
final unreadNoticeCountProvider = Provider<int>((ref) {
  final notices = ref.watch(noticeProvider).notices;
  return notices.where((notice) => !notice.isRead && notice.isImportant).length;
});