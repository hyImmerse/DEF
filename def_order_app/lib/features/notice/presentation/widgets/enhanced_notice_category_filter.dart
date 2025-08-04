import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart'; // VelocityX 호환성 레이어
import '../../../../core/theme/app_theme.dart';

/// 공지사항 카테고리 필터
enum NoticeCategory {
  all('전체'),
  urgent('긴급'),
  normal('일반'),
  unread('읽지 않음');

  final String label;
  const NoticeCategory(this.label);
}

/// 40-60대 사용자를 위한 Enhanced 공지사항 카테고리 필터
class EnhancedNoticeCategoryFilter extends StatelessWidget {
  final NoticeCategory selectedCategory;
  final ValueChanged<NoticeCategory> onCategoryChanged;
  
  const EnhancedNoticeCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: NoticeCategory.values.length,
        itemBuilder: (context, index) {
          final category = NoticeCategory.values[index];
          final isSelected = category == selectedCategory;
          
          return Container(
            margin: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: index == NoticeCategory.values.length - 1 ? 16 : 0,
            ),
            child: GFButton(
              onPressed: () => onCategoryChanged(category),
              text: category.label,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
              ),
              color: isSelected ? AppTheme.primaryColor : Colors.white,
              shape: GFButtonShape.pills,
              size: GFSize.MEDIUM,
              borderSide: BorderSide(
                color: AppTheme.primaryColor,
                width: 2,
              ),
              icon: category == NoticeCategory.urgent
                  ? Icon(
                      Icons.priority_high,
                      color: isSelected ? Colors.white : Colors.red,
                      size: 20,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}