import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// 现代化搜索栏组件 - 小米风格
class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final String? hintText;
  final bool autofocus;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.hintText,
    this.autofocus = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _hasFocus = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch() {
    final keyword = _controller.text.trim();
    if (keyword.isNotEmpty) {
      widget.onSearch(keyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.containerColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: _hasFocus ? AppTheme.primaryColor : Colors.transparent,
          width: _hasFocus ? 2 : 0,
        ),
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onSubmitted: (_) => _performSearch(),
        onTap: () {
          setState(() {
            _hasFocus = true;
          });
        },
        onEditingComplete: () {
          setState(() {
            _hasFocus = false;
          });
        },
        onTapOutside: (_) {
          setState(() {
            _hasFocus = false;
          });
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          hintText: widget.hintText ?? '搜索源码、技术、框架...',
          hintStyle: const TextStyle(
            color: AppTheme.textHintColor,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color: _hasFocus
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondaryColor,
              size: 22,
            ),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppTheme.textSecondaryColor,
                    size: 20,
                  ),
                  onPressed: () {
                    _controller.clear();
                    setState(() {});
                  },
                )
              : Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.tune_rounded,
                    color: AppTheme.textSecondaryColor,
                    size: 20,
                  ),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        onChanged: (value) {
          setState(() {}); // 更新UI状态
        },
      ),
    );
  }
}
