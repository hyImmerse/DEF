import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/notice_provider.dart';
import '../widgets/enhanced_notice_card.dart';
import '../widgets/enhanced_notice_search_bar.dart';
import '../widgets/enhanced_notice_category_filter.dart';
import 'enhanced_notice_detail_screen.dart';

/// 40-60대 사용자를 위한 Enhanced 공지사항 목록 화면
/// 
/// 특징:
/// - 큰 글씨 (최소 18sp)
/// - 명확한 시각적 구분 (긴급/일반)
/// - 간단한 조작 (큰 터치 영역)
/// - 높은 대비 색상
/// - VelocityX + GetWidget 활용
class EnhancedNoticeListScreen extends ConsumerStatefulWidget {
  const EnhancedNoticeListScreen({super.key});

  @override
  ConsumerState<EnhancedNoticeListScreen> createState() => _EnhancedNoticeListScreenState();
}

class _EnhancedNoticeListScreenState extends ConsumerState<EnhancedNoticeListScreen> {
  final _scrollController = ScrollController();
  String? _selectedFilter = 'all'; // all, urgent, normal, unread

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(noticeProvider.notifier).refresh();
    });
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

  void _onFilterChanged(String? filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final noticeState = ref.watch(noticeProvider);
    final unreadCount = ref.watch(unreadNoticeCountProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: '공지사항'.text
            .size(22)
            .fontWeight(FontWeight.bold)
            .color(Colors.white)
            .make(),
        actions: [
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: GFBadge(
                text: unreadCount.toString(),
                color: AppTheme.errorColor,
                shape: GFBadgeShape.circle,
                size: GFSize.MEDIUM,
                child: const Icon(
                  Icons.notifications_active,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ).pOnly(right: 8),
        ],
      ),
      body: Column(
        children: [
          // 상단 필터 섹션 - 40-60대를 위한 큰 버튼들
          _buildFilterSection(unreadCount),
          
          // 구분선
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          
          // 공지사항 목록
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(noticeProvider.notifier).refresh();
              },
              color: AppTheme.primaryColor,
              child: _buildNoticeList(noticeState),
            ),
          ),
        ],
      ),
      // 플로팅 액션 버튼 - 맨 위로 이동
      floatingActionButton: _buildScrollToTopButton(),
    );
  }

  /// 필터 섹션 - 큰 터치 영역과 명확한 구분
  Widget _buildFilterSection(int unreadCount) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 상태 표시
          Row(
            children: [
              '전체 공지사항'.text
                  .size(18)
                  .fontWeight(FontWeight.w600)
                  .color(Colors.grey[700])
                  .make(),
              const Spacer(),
              if (unreadCount > 0)
                '읽지 않음 $unreadCount건'
                    .text
                    .size(16)
                    .color(AppTheme.errorColor)
                    .fontWeight(FontWeight.w600)
                    .make(),
            ],
          ),
          
          16.heightBox,
          
          // 필터 버튼들 - 큰 터치 영역
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterButton('all', '전체', Icons.list),
                12.widthBox,
                _buildFilterButton('urgent', '긴급 공지', Icons.priority_high),
                12.widthBox,
                _buildFilterButton('normal', '일반 공지', Icons.info_outline),
                12.widthBox,
                _buildFilterButton('unread', '읽지 않음', Icons.mark_email_unread),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    
    return GFButton(
      onPressed: () => _onFilterChanged(value),
      text: label,
      color: isSelected ? AppTheme.primaryColor : Colors.grey[200]!,
      textColor: isSelected ? Colors.white : Colors.grey[700],
      size: GFSize.LARGE,
      shape: GFButtonShape.pills,
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey[600],
        size: 20,
      ),
      position: GFPosition.start,
    ).pSymmetric(h: 4);
  }

  /// 공지사항 목록
  Widget _buildNoticeList(NoticeState state) {
    if (state.isLoading && state.notices.isEmpty) {
      return _buildLoadingView();
    }

    if (state.error != null && state.notices.isEmpty) {
      return _buildErrorView(state.error!);
    }

    final filteredNotices = _getFilteredNotices(state.notices);

    if (filteredNotices.isEmpty) {
      return _buildEmptyView();
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: filteredNotices.length + (state.isLoadingMore ? 1 : 0),
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => 12.heightBox,
      itemBuilder: (context, index) {
        if (index >= filteredNotices.length) {
          return const GFLoader(
            type: GFLoaderType.circle,
            size: GFSize.MEDIUM,
          ).centered().pSymmetric(v: 20);
        }

        final notice = filteredNotices[index];
        return EnhancedNoticeCard(
          notice: notice,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EnhancedNoticeDetailScreen(noticeId: notice.id),
              ),
            );
          },
        );
      },
    );
  }

  /// 로딩 뷰
  Widget _buildLoadingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const GFLoader(
          type: GFLoaderType.circle,
          size: GFSize.LARGE,
        ),
        24.heightBox,
        '공지사항을 불러오는 중...'
            .text
            .size(18)
            .color(Colors.grey[600])
            .make(),
      ],
    ).centered();
  }

  /// 에러 뷰
  Widget _buildErrorView(String error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 80,
          color: Colors.grey[400],
        ),
        24.heightBox,
        '공지사항을 불러올 수 없습니다'
            .text
            .size(20)
            .fontWeight(FontWeight.w600)
            .color(Colors.grey[700])
            .textAlign(TextAlign.center)
            .make(),
        12.heightBox,
        error.text
            .size(16)
            .color(Colors.grey[600])
            .textAlign(TextAlign.center)
            .make(),
        32.heightBox,
        GFButton(
          onPressed: () {
            ref.read(noticeProvider.notifier).refresh();
          },
          text: '다시 시도',
          color: AppTheme.primaryColor,
          size: GFSize.LARGE,
          shape: GFButtonShape.pills,
          icon: const Icon(Icons.refresh, color: Colors.white),
        ),
      ],
    ).p(32);
  }

  /// 빈 목록 뷰
  Widget _buildEmptyView() {
    final String message;
    final IconData icon;
    
    switch (_selectedFilter) {
      case 'urgent':
        message = '긴급 공지사항이 없습니다';
        icon = Icons.priority_high;
        break;
      case 'normal':
        message = '일반 공지사항이 없습니다';
        icon = Icons.info_outline;
        break;
      case 'unread':
        message = '읽지 않은 공지사항이 없습니다';
        icon = Icons.mark_email_read;
        break;
      default:
        message = '공지사항이 없습니다';
        icon = Icons.notifications_none;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 80,
          color: Colors.grey[400],
        ),
        24.heightBox,
        message.text
            .size(20)
            .fontWeight(FontWeight.w600)
            .color(Colors.grey[600])
            .textAlign(TextAlign.center)
            .make(),
        16.heightBox,
        '새로운 공지사항이 등록되면 알려드릴게요'
            .text
            .size(16)
            .color(Colors.grey[500])
            .textAlign(TextAlign.center)
            .make(),
      ],
    ).p(32);
  }

  /// 맨 위로 스크롤 버튼
  Widget _buildScrollToTopButton() {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, child) {
        final showButton = _scrollController.hasClients && 
                          _scrollController.offset > 500;
        
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: showButton ? 1.0 : 0.0,
          child: showButton
              ? GFIconButton(
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 28,
                  ),
                  color: AppTheme.primaryColor,
                  shape: GFIconButtonShape.circle,
                  size: GFSize.LARGE,
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  /// 필터링된 공지사항 목록 반환
  List<dynamic> _getFilteredNotices(List<dynamic> notices) {
    switch (_selectedFilter) {
      case 'urgent':
        return notices.where((notice) => notice.isImportant).toList();
      case 'normal':
        return notices.where((notice) => !notice.isImportant).toList();
      case 'unread':
        return notices.where((notice) => !notice.isRead).toList();
      default:
        return notices;
    }
  }
}