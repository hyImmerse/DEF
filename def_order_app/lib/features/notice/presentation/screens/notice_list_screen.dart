import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/notice_provider.dart';
import '../widgets/notice_card.dart';
import '../widgets/notice_search_bar.dart';
import '../widgets/notice_category_filter.dart';
import 'notice_detail_screen.dart';

class NoticeListScreen extends ConsumerStatefulWidget {
  const NoticeListScreen({super.key});

  @override
  ConsumerState<NoticeListScreen> createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends ConsumerState<NoticeListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(noticeProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final noticeState = ref.watch(noticeProvider);
    final unreadCount = ref.watch(unreadNoticeCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        actions: [
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: GFBadge(
                text: unreadCount.toString(),
                color: AppTheme.errorColor,
                shape: GFBadgeShape.circle,
                size: GFSize.SMALL,
                child: const Icon(Icons.notifications_active),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // 검색바
          NoticeSearchBar(
            onSearch: (query) {
              ref.read(noticeProvider.notifier).search(query);
            },
          ),
          
          // 카테고리 필터
          NoticeCategoryFilter(
            selectedCategory: noticeState.selectedCategory,
            onCategorySelected: (category) {
              ref.read(noticeProvider.notifier).setCategory(category);
            },
          ),
          
          // 공지사항 목록
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(noticeProvider.notifier).refresh();
              },
              child: _buildNoticeList(noticeState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeList(NoticeState state) {
    if (state.isLoading && state.notices.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null && state.notices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GFButton(
              onPressed: () {
                ref.read(noticeProvider.notifier).refresh();
              },
              text: '다시 시도',
              shape: GFButtonShape.pills,
            ),
          ],
        ),
      );
    }

    if (state.notices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              state.searchQuery != null
                  ? '검색 결과가 없습니다'
                  : '공지사항이 없습니다',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: state.notices.length + (state.isLoadingMore ? 1 : 0),
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        if (index >= state.notices.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final notice = state.notices[index];
        return NoticeCard(
          notice: notice,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NoticeDetailScreen(noticeId: notice.id),
              ),
            );
          },
        );
      },
    );
  }
}