import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/notice_provider.dart';

class NoticeCategoryFilter extends ConsumerWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const NoticeCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(noticeCategoriesProvider);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: categoriesAsync.when(
        data: (categories) => _buildCategoryList(categories),
        loading: () => const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildCategoryList(List<String> categories) {
    final allCategories = ['전체', ...categories];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: allCategories.length,
      itemBuilder: (context, index) {
        final category = allCategories[index];
        final isAll = category == '전체';
        final isSelected = isAll 
            ? selectedCategory == null 
            : selectedCategory == category;

        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: GFButton(
            onPressed: () {
              onCategorySelected(isAll ? null : category);
            },
            text: category,
            shape: GFButtonShape.pills,
            size: GFSize.SMALL,
            color: isSelected ? AppTheme.primaryColor : Colors.white,
            textColor: isSelected ? Colors.white : Colors.grey[700],
            borderSide: BorderSide(
              color: isSelected 
                  ? AppTheme.primaryColor 
                  : Colors.grey[300]!,
            ),
            hoverColor: AppTheme.primaryColor.withOpacity(0.1),
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }
}