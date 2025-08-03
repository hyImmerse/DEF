import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/theme/app_theme.dart';

class NoticeSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const NoticeSearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  State<NoticeSearchBar> createState() => _NoticeSearchBarState();
}

class _NoticeSearchBarState extends State<NoticeSearchBar> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      widget.onSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: '공지사항 검색',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: const Icon(Icons.search, size: 24),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearch('');
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// Debouncer 클래스
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}