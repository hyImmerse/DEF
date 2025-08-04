import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart'; // VelocityX 호환성 레이어
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/notice_provider.dart';

/// 40-60대 사용자를 위한 Enhanced 공지사항 상세 화면
/// 
/// 특징:
/// - 큰 글씨 (제목 24sp, 내용 18sp)
/// - 명확한 구조와 여백
/// - 큰 터치 영역
/// - 읽기 쉬운 레이아웃
/// - 공유 기능
class EnhancedNoticeDetailScreen extends ConsumerStatefulWidget {
  final String noticeId;

  const EnhancedNoticeDetailScreen({
    super.key,
    required this.noticeId,
  });

  @override
  ConsumerState<EnhancedNoticeDetailScreen> createState() => _EnhancedNoticeDetailScreenState();
}

class _EnhancedNoticeDetailScreenState extends ConsumerState<EnhancedNoticeDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // 공지사항 상세 정보 로드 및 읽음 처리
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(noticeProvider.notifier).getNoticeDetail(widget.noticeId);
      ref.read(noticeProvider.notifier).markAsRead(widget.noticeId);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _showScrollToTop = _scrollController.offset > 500;
    });
  }

  @override
  Widget build(BuildContext context) {
    final noticeDetail = ref.watch(noticeDetailProvider(widget.noticeId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: noticeDetail.when(
        data: (notice) => _buildNoticeDetail(notice),
        loading: () => _buildLoadingView(),
        error: (error, _) => _buildErrorView(error.toString()),
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  /// 공지사항 상세 내용
  Widget _buildNoticeDetail(dynamic notice) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');
    
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // 앱바
        SliverAppBar(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          expandedHeight: 120,
          pinned: true,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            title: '공지사항'.text
                .size(20)
                .fontWeight(FontWeight.bold)
                .color(Colors.white)
                .make(),
            centerTitle: false,
            titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
          ),
          actions: [
            // 공유 버튼
            GFIconButton(
              onPressed: () => _shareNotice(notice),
              icon: const Icon(
                Icons.share,
                color: Colors.white,
                size: 24,
              ),
              type: GFButtonType.transparent,
              size: GFSize.LARGE,
            ),
          ],
        ),
        
        // 메인 콘텐츠
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.heightBox,
                
                // 헤더 정보
                _buildHeader(notice, dateFormat),
                
                24.heightBox,
                Container(height: 1, color: Colors.grey[200]),
                24.heightBox,
                
                // 제목
                _buildTitle(notice),
                
                20.heightBox,
                
                // 내용
                _buildContent(notice),
                
                // 이미지 (있는 경우)
                if (notice.imageUrl != null) ...[
                  24.heightBox,
                  _buildImage(notice.imageUrl!),
                ],
                
                // 첨부파일 (있는 경우)
                if (notice.attachmentUrls?.isNotEmpty == true) ...[
                  24.heightBox,
                  _buildAttachments(notice.attachmentUrls!),
                ],
                
                // 태그 (있는 경우)
                if (notice.tags?.isNotEmpty == true) ...[
                  24.heightBox,
                  _buildTags(notice.tags!),
                ],
                
                32.heightBox,
                Container(height: 1, color: Colors.grey[200]),
                24.heightBox,
                
                // 하단 정보
                _buildFooter(notice, dateFormat),
                
                40.heightBox, // 하단 여백
              ],
            ).px(20),
          ),
        ),
      ],
    );
  }

  /// 헤더 정보 - 중요도, 카테고리, 읽음 상태
  Widget _buildHeader(dynamic notice, DateFormat dateFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상태 배지들
        Row(
          children: [
            // 중요 공지 배지
            if (notice.isImportant)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.errorColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.priority_high,
                      color: Colors.white,
                      size: 20,
                    ),
                    6.widthBox,
                    '긴급 공지'.text
                        .size(16)
                        .fontWeight(FontWeight.bold)
                        .color(Colors.white)
                        .make(),
                  ],
                ),
              ),
            
            if (notice.isImportant) 16.widthBox,
            
            // 카테고리
            if (notice.category != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: notice.category!.text
                    .size(16)
                    .color(Colors.grey[700])
                    .fontWeight(FontWeight.w600)
                    .make(),
              ),
          ],
        ),
        
        16.heightBox,
        
        // 날짜와 조회수
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 20,
              color: Colors.grey[600],
            ),
            8.widthBox,
            dateFormat.format(notice.createdAt).text
                .size(16)
                .color(Colors.grey[700])
                .fontWeight(FontWeight.w500)
                .make(),
            
            const Spacer(),
            
            Icon(
              Icons.visibility,
              size: 20,
              color: Colors.grey[600],
            ),
            8.widthBox,
            '조회 ${notice.viewCount ?? 0}회'.text
                .size(16)
                .color(Colors.grey[700])
                .make(),
          ],
        ),
      ],
    );
  }

  /// 제목
  Widget _buildTitle(dynamic notice) {
    return notice.title.text
        .size(24) // 큰 제목
        .fontWeight(FontWeight.bold)
        .color(Colors.black87)
        .lineHeight(1.4)
        .make();
  }

  /// 내용
  Widget _buildContent(dynamic notice) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: notice.content.text
          .size(18) // 읽기 쉬운 크기
          .color(Colors.black87)
          .lineHeight(1.6) // 충분한 줄 간격
          .make(),
    );
  }

  /// 이미지
  Widget _buildImage(String imageUrl) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  8.heightBox,
                  '이미지를 불러올 수 없습니다'.text
                      .size(16)
                      .color(Colors.grey[600])
                      .make(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// 첨부파일 목록
  Widget _buildAttachments(List<String> attachmentUrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.attach_file,
              size: 24,
              color: AppTheme.primaryColor,
            ),
            8.widthBox,
            '첨부파일'.text
                .size(18)
                .fontWeight(FontWeight.bold)
                .color(Colors.black87)
                .make(),
          ],
        ),
        16.heightBox,
        ...attachmentUrls.asMap().entries.map((entry) {
          final index = entry.key;
          final url = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GFListTile(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              titleText: '첨부파일 ${index + 1}',
              subTitleText: url.split('/').last,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.file_download,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              onTap: () => _launchUrl(url),
            ).card.elevation(2).rounded.make(),
          );
        }).toList(),
      ],
    );
  }

  /// 태그 목록
  Widget _buildTags(List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '태그'.text
            .size(18)
            .fontWeight(FontWeight.bold)
            .color(Colors.black87)
            .make(),
        16.heightBox,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: tags.map((tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
              ),
            ),
            child: '#$tag'.text
                .size(16)
                .color(AppTheme.primaryColor)
                .fontWeight(FontWeight.w600)
                .make(),
          )).toList(),
        ),
      ],
    );
  }

  /// 하단 정보
  Widget _buildFooter(dynamic notice, DateFormat dateFormat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              '작성일'.text
                  .size(16)
                  .color(Colors.grey[600])
                  .make(),
              const Spacer(),
              dateFormat.format(notice.createdAt).text
                  .size(16)
                  .fontWeight(FontWeight.w600)
                  .color(Colors.black87)
                  .make(),
            ],
          ),
          if (notice.updatedAt != null) ...[
            12.heightBox,
            Row(
              children: [
                '수정일'.text
                    .size(16)
                    .color(Colors.grey[600])
                    .make(),
                const Spacer(),
                dateFormat.format(notice.updatedAt!).text
                    .size(16)
                    .fontWeight(FontWeight.w600)
                    .color(Colors.black87)
                    .make(),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 로딩 뷰
  Widget _buildLoadingView() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: '공지사항'.text.size(20).color(Colors.white).make(),
      ),
      body: Column(
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
      ).centered(),
    );
  }

  /// 에러 뷰
  Widget _buildErrorView(String error) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: '공지사항'.text.size(20).color(Colors.white).make(),
      ),
      body: Column(
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
              .center
              .make(),
          16.heightBox,
          error.text
              .size(16)
              .color(Colors.grey[600])
              .center
              .make(),
          32.heightBox,
          GFButton(
            onPressed: () {
              ref.read(noticeProvider.notifier).getNoticeDetail(widget.noticeId);
            },
            text: '다시 시도',
            color: AppTheme.primaryColor,
            size: GFSize.LARGE,
            shape: GFButtonShape.pills,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ).p(32),
    );
  }

  /// 플로팅 버튼들
  Widget _buildFloatingButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 맨 위로 버튼
        if (_showScrollToTop)
          GFIconButton(
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
          ),
        
        if (_showScrollToTop) 16.heightBox,
        
        // 목록으로 돌아가기 버튼
        GFIconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.list,
            color: Colors.white,
            size: 28,
          ),
          color: AppTheme.successColor,
          shape: GFIconButtonShape.circle,
          size: GFSize.LARGE,
        ),
      ],
    );
  }

  /// 공지사항 공유
  void _shareNotice(dynamic notice) {
    final shareText = '''
${notice.title}

${notice.content}

--- 
DEF 요소수 출고 주문관리 시스템
''';
    
    Share.share(shareText, subject: notice.title);
  }

  /// URL 실행
  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: '파일을 열 수 없습니다: $url'.text.make(),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: '오류가 발생했습니다: $e'.text.make(),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}