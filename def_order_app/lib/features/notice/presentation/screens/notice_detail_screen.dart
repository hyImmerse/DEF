import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/notice_entity.dart';
import '../providers/notice_provider.dart';

class NoticeDetailScreen extends ConsumerWidget {
  final String noticeId;

  const NoticeDetailScreen({
    super.key,
    required this.noticeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeAsync = ref.watch(noticeDetailProvider(noticeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        actions: [
          noticeAsync.when(
            data: (notice) => _buildShareButton(context, notice),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: noticeAsync.when(
        data: (notice) => _buildNoticeContent(context, notice),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorWidget(context, error.toString()),
      ),
    );
  }

  Widget _buildShareButton(BuildContext context, NoticeEntity notice) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () {
        // TODO: 공유 기능 구현
        GFToast.showToast(
          '공유 기능은 준비 중입니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
        );
      },
    );
  }

  Widget _buildNoticeContent(BuildContext context, NoticeEntity notice) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 중요 공지 배지
          if (notice.isImportant)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.errorColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '중요 공지',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          if (notice.isImportant) const SizedBox(height: 12),

          // 제목
          Text(
            notice.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 메타 정보
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                dateFormat.format(notice.createdAt),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(width: 16),
              Icon(Icons.remove_red_eye, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '조회 ${notice.viewCount ?? 0}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          
          // 카테고리 및 태그
          if (notice.category != null || notice.tags?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (notice.category != null)
                  GFBadge(
                    text: notice.category!,
                    color: AppTheme.primaryColor,
                    shape: GFBadgeShape.pills,
                  ),
                if (notice.tags != null)
                  ...notice.tags!.map((tag) => GFBadge(
                    text: tag,
                    color: Colors.grey[600]!,
                    shape: GFBadgeShape.pills,
                  )),
              ],
            ),
          ],
          
          const Divider(height: 32),
          
          // 이미지
          if (notice.imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: notice.imageUrl!,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.error, size: 48, color: Colors.grey),
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
          ],
          
          // 내용
          Text(
            notice.content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
          
          // 첨부파일
          if (notice.attachmentUrls?.isNotEmpty == true) ...[
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              '첨부파일',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...notice.attachmentUrls!.map((url) => _buildAttachmentItem(url)),
          ],
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(String url) {
    final fileName = url.split('/').last;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.attach_file,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fileName,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.download,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
              error,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GFButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: '뒤로 가기',
              shape: GFButtonShape.pills,
            ),
          ],
        ),
      ),
    );
  }
}