import 'package:flutter/material.dart';

/// 分类图标管理工具类
class CategoryIconManager {
  /// 根据分类名称获取对应的图标
  static IconData getIconByName(String categoryName) {
    final nameIconMap = {
      // 移动开发
      'android': Icons.phone_android,
      'ios': Icons.phone_iphone,
      'flutter': Icons.apps,
      'mobile': Icons.smartphone,
      '移动开发': Icons.smartphone,

      // Web开发
      'web': Icons.web,
      'html': Icons.code,
      'javascript': Icons.integration_instructions,
      'react': Icons.web,
      'vue': Icons.web_asset,
      '前端': Icons.web,

      // 后端开发
      'backend': Icons.dns,
      'server': Icons.cloud,
      'api': Icons.api,
      'database': Icons.storage,
      'java': Icons.coffee_outlined,
      'python': Icons.code,
      '后端': Icons.dns,

      // 游戏开发
      'game': Icons.games,
      'unity': Icons.sports_esports,
      '游戏': Icons.games,

      // 工具类
      'tool': Icons.build,
      'utility': Icons.extension,
      '工具': Icons.build,

      // 其他
      'other': Icons.more_horiz,
      'default': Icons.apps,
      '其他': Icons.more_horiz,
    };

    final lowerCaseName = categoryName.toLowerCase();

    // 精确匹配
    if (nameIconMap.containsKey(lowerCaseName)) {
      return nameIconMap[lowerCaseName]!;
    }

    // 模糊匹配
    for (final entry in nameIconMap.entries) {
      if (lowerCaseName.contains(entry.key) ||
          entry.key.contains(lowerCaseName)) {
        return entry.value;
      }
    }

    return Icons.apps;
  }

  /// 根据分类ID获取颜色
  static Color getColorById(int categoryId) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrange,
      Colors.deepPurple,
    ];

    return colors[categoryId % colors.length];
  }

  /// 根据分类名称和索引获取最佳匹配的图标
  static IconData getBestMatchIcon(String? categoryName, int fallbackIndex) {
    if (categoryName != null && categoryName.isNotEmpty) {
      return getIconByName(categoryName);
    }

    final defaultIcons = [
      Icons.apps,
      Icons.phone_android,
      Icons.web,
      Icons.desktop_windows,
      Icons.cloud,
      Icons.extension,
      Icons.code,
      Icons.storage,
      Icons.games,
      Icons.music_note,
      Icons.video_library,
      Icons.photo,
    ];

    return defaultIcons[fallbackIndex % defaultIcons.length];
  }
}
