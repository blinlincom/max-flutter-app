import 'package:flutter/material.dart';

/// 应用主题和颜色常量 - 小米风格现代化设计
class AppTheme {
  /// 主色调 - 小米橙色系
  static const Color primaryColor = Color(0xFFFF6900);
  static const Color primaryDarkColor = Color(0xFFE55A00);
  static const Color primaryLightColor = Color(0xFFFFB366);

  /// 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6900), Color(0xFFFF8533)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 辅助色系
  static const Color accentColor = Color(0xFF4285F4);
  static const Color secondaryColor = Color(0xFF34A853);

  /// 背景色系
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color containerColor = Color(0xFFF5F5F5);

  /// 文字颜色
  static const Color textPrimaryColor = Color(0xFF1A1A1A);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color textHintColor = Color(0xFF999999);

  /// 分割线和边框 - 优化颜色避免斑马线效果
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color borderColor = Color(0xFFE1E4E8);
  static const Color separatorColor = Color(0xFFF5F5F5); // 添加更浅的分隔色

  /// 状态色
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color warningColor = Color(0xFFFF9500);
  static const Color successColor = Color(0xFF34C759);

  /// 阴影和效果
  static const Color shadowColor = Color(0x0F000000);
  static const Color transparentColor = Colors.transparent;

  /// 常用圆角
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  /// 获取浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(primaryColor),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: textPrimaryColor, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimaryColor, fontSize: 14),
        bodySmall: TextStyle(color: textSecondaryColor, fontSize: 12),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
    );
  }

  /// 获取深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(primaryColor),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF0D1117),
      cardColor: const Color(0xFF21262D),
      dividerColor: const Color(0xFF30363D),
    );
  }

  /// 创建Material颜色
  static MaterialColor _createMaterialColor(Color color) {
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    swatch[50] = Color.fromRGBO(r, g, b, .1);
    swatch[100] = Color.fromRGBO(r, g, b, .2);
    swatch[200] = Color.fromRGBO(r, g, b, .3);
    swatch[300] = Color.fromRGBO(r, g, b, .4);
    swatch[400] = Color.fromRGBO(r, g, b, .5);
    swatch[500] = Color.fromRGBO(r, g, b, .6);
    swatch[600] = Color.fromRGBO(r, g, b, .7);
    swatch[700] = Color.fromRGBO(r, g, b, .8);
    swatch[800] = Color.fromRGBO(r, g, b, .9);
    swatch[900] = Color.fromRGBO(r, g, b, 1);

    return MaterialColor(color.value, swatch);
  }

  /// 快速样式方法
  static BoxDecoration cardDecoration({
    Color? color,
    double? radius,
    bool hasShadow = true,
  }) {
    return BoxDecoration(
      color: color ?? cardColor,
      borderRadius: BorderRadius.circular(radius ?? radiusLarge),
      boxShadow: hasShadow
          ? [
              BoxShadow(
                color: shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration gradientDecoration({
    Gradient? gradient,
    double? radius,
  }) {
    return BoxDecoration(
      gradient: gradient ?? primaryGradient,
      borderRadius: BorderRadius.circular(radius ?? radiusLarge),
    );
  }
}
