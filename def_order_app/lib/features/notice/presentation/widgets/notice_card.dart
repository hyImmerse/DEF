import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/notice_entity.dart';

class NoticeCard extends StatelessWidget {
  final NoticeEntity notice;
  final VoidCallback onTap;

  const NoticeCard({
    super.key,
    required this.notice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM/dd');
    final isNew = notice.createdAt.isAfter(
      DateTime.now().subtract(const Duration(days: 3))
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notice.isRead ? Colors.white : Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notice.isImportant 
                  ? AppTheme.errorColor 
                  : notice.isRead 
                      ? Colors.grey[300]! 
                      : AppTheme.primaryColor.withOpacity(0.3),
              width: notice.isImportant ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 정보
              Row(
                children: [
                  // 중요 공지 표시
                  if (notice.isImportant)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, 
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '중요',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  
                  if (notice.isImportant) const SizedBox(width: 8),
                  
                  // NEW 배지
                  if (isNew && !notice.isRead)
                    GFBadge(
                      text: 'NEW',
                      color: AppTheme.successColor,
                      shape: GFBadgeShape.pills,
                      size: GFSize.SMALL,
                    ),
                  
                  if (isNew && !notice.isRead) const SizedBox(width: 8),
                  
                  // 카테고리
                  if (notice.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        notice.category!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  
                  const Spacer(),
                  
                  // 날짜
                  Text(
                    dateFormat.format(notice.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 제목
              Row(
                children: [
                  if (notice.imageUrl != null)
                    Icon(
                      Icons.image,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  if (notice.imageUrl != null) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notice.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: notice.isRead 
                            ? FontWeight.normal 
                            : FontWeight.bold,
                        color: notice.isRead 
                            ? Colors.grey[700] 
                            : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // 내용 미리보기
              Text(
                notice.content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              // 태그
              if (notice.tags?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: notice.tags!.take(3).map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  )).toList(),
                ),
              ],
              
              // 하단 정보
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.remove_red_eye,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${notice.viewCount ?? 0}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  if (notice.attachmentUrls?.isNotEmpty == true)
                    Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${notice.attachmentUrls!.length}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}