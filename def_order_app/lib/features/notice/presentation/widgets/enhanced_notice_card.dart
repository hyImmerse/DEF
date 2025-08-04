import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart'; // VelocityX 호환성 레이어
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/notice_entity.dart';

/// 40-60대 사용자를 위한 Enhanced 공지사항 카드
/// 
/// 특징:
/// - 큰 글씨 크기 (제목 20sp, 내용 16sp)
/// - 명확한 시각적 구분 (긴급은 빨간 테두리)
/// - 큰 터치 영역 (최소 48dp)
/// - 높은 대비 색상
/// - 읽음/읽지 않음 명확한 표시
class EnhancedNoticeCard extends StatelessWidget {
  final NoticeEntity notice;
  final VoidCallback onTap;

  const EnhancedNoticeCard({
    super.key,
    required this.notice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy.MM.dd HH:mm');
    final isNew = notice.createdAt.isAfter(
      DateTime.now().subtract(const Duration(days: 3))
    );

    return Container(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20), // 더 큰 패딩
          decoration: BoxDecoration(
            color: notice.isRead ? Colors.white : Colors.blue[25],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notice.isImportant 
                  ? AppTheme.errorColor 
                  : notice.isRead 
                      ? Colors.grey[300]! 
                      : AppTheme.primaryColor.withOpacity(0.5),
              width: notice.isImportant ? 3 : 2, // 더 두꺼운 테두리
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 정보 - 더 명확하고 큰 표시
              _buildHeader(isNew),
              16.heightBox,
              // 제목 - 큰 글씨
              _buildTitle(),
              12.heightBox,
              // 내용 미리보기 - 명확한 글씨
              _buildContentPreview(),
              16.heightBox,
              // 하단 정보 - 날짜와 읽음 상태
              _buildFooter(dateFormat),
            ],
          ),
        ),
      ),
    );
  }

  /// 상단 헤더 - 중요도와 NEW 배지
  Widget _buildHeader(bool isNew) {
    return Row(
      children: [
        // 중요 공지 표시 - 더 크고 명확하게
        if (notice.isImportant)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.errorColor,
              borderRadius: BorderRadius.circular(20),
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
                  size: 18,
                ),
                4.widthBox,
                '긴급'.text
                    .size(14)
                    .fontWeight(FontWeight.bold)
                    .color(Colors.white)
                    .make(),
              ],
            ),
          ),
        
        if (notice.isImportant) 12.widthBox,
        
        // NEW 배지 - 더 눈에 띄게
        if (isNew && !notice.isRead)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.successColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: 'NEW'.text
                .size(12)
                .fontWeight(FontWeight.bold)
                .color(Colors.white)
                .make(),
          ),
        
        if (isNew && !notice.isRead) 12.widthBox,
        
        // 카테고리 - 더 명확하게
        if (notice.category != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: notice.category!.text
                .size(14)
                .color(Colors.grey[700])
                .fontWeight(FontWeight.w500)
                .make(),
          ),
        
        const Spacer(),
        
        // 읽음 상태 표시 - 명확한 아이콘
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: notice.isRead 
                ? Colors.grey[100] 
                : AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            notice.isRead ? Icons.check_circle : Icons.radio_button_unchecked,
            color: notice.isRead ? Colors.grey[600] : AppTheme.primaryColor,
            size: 20,
          ),
        ),
      ],
    );
  }

  /// 제목 섹션 - 큰 글씨와 첨부파일 표시
  Widget _buildTitle() {
    return Row(
      children: [
        // 이미지/첨부파일 아이콘
        if (notice.imageUrl != null || notice.attachmentUrls?.isNotEmpty == true)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              notice.imageUrl != null ? Icons.image : Icons.attach_file,
              size: 20,
              color: AppTheme.primaryColor,
            ),
          ),
        
        if (notice.imageUrl != null || notice.attachmentUrls?.isNotEmpty == true) 
          12.widthBox,
        
        // 제목 - 큰 글씨
        Expanded(
          child: notice.title.text
              .size(20) // 큰 글씨
              .fontWeight(notice.isRead ? FontWeight.w600 : FontWeight.bold)
              .color(notice.isRead ? Colors.grey[700] : Colors.black87)
              .lineHeight(1.3)
              .maxLines(2)
              .ellipsis
              .make(),
        ),
      ],
    );
  }

  /// 내용 미리보기
  Widget _buildContentPreview() {
    return notice.content.text
        .size(16) // 읽기 쉬운 크기
        .color(Colors.grey[700])
        .lineHeight(1.5)
        .maxLines(3)
        .ellipsis
        .make();
  }

  /// 하단 정보
  Widget _buildFooter(DateFormat dateFormat) {
    return Row(
      children: [
        // 날짜 - 명확한 표시
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: Colors.grey[600],
              ),
              6.widthBox,
              dateFormat.format(notice.createdAt).text
                  .size(14)
                  .color(Colors.grey[700])
                  .fontWeight(FontWeight.w500)
                  .make(),
            ],
          ),
        ),
        
        const Spacer(),
        
        // 조회수
        if (notice.viewCount != null && notice.viewCount! > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.visibility,
                size: 16,
                color: Colors.grey[500],
              ),
              4.widthBox,
              '${notice.viewCount}'.text
                  .size(14)
                  .color(Colors.grey[600])
                  .make(),
            ],
          ),
        
        // 첨부파일 개수
        if (notice.attachmentUrls?.isNotEmpty == true) ...[
          12.widthBox,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.attach_file,
                size: 16,
                color: Colors.grey[500],
              ),
              4.widthBox,
              '${notice.attachmentUrls!.length}'.text
                  .size(14)
                  .color(Colors.grey[600])
                  .make(),
            ],
          ),
        ],
      ],
    );
  }
}