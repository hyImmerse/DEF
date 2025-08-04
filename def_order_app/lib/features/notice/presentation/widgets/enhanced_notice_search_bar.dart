import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart'; // VelocityX 호환성 레이어
import '../../../../core/theme/app_theme.dart';

/// 40-60대 사용자를 위한 Enhanced 공지사항 검색 바
class EnhancedNoticeSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String? hintText;
  
  const EnhancedNoticeSearchBar({
    super.key,
    this.onChanged,
    this.onClear,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText ?? '공지사항 검색...',
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.grey[500],
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600],
            size: 28,
          ),
          suffixIcon: onClear != null
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}