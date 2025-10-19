import 'package:flutter/material.dart';

// TDesign 主题颜色系统
class TDesignColors {
  // 主色调
  static const Color brand = Color(0xFF0052D9);
  static const Color brandHover = Color(0xFF003EB3);
  static const Color brandActive = Color(0xFF002C8F);

  // 中性色
  static const Color textPrimary = Color(0xFF1D2129);
  static const Color textSecondary = Color(0xFF4E5969);
  static const Color textTertiary = Color(0xFF86909C);
  static const Color bgContainer = Color(0xFFFFFFFF);
  static const Color bgComponent = Color(0xFFF2F3F5);
  static const Color border = Color(0xFFE5E6EB);

  // 状态色
  static const Color success = Color(0xFF00A870);
  static const Color warning = Color(0xFFED7B2F);
  static const Color error = Color(0xFFE34D59);

  // 高亮色（处理中状态）
  static const Color highlight = Color(0xFFFFF2CC);
}

// TDesign 间距系统
class TDesignSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
}

// TDesign 圆角系统
class TDesignRadius {
  static const double xs = 2.0;
  static const double sm = 4.0;
  static const double md = 6.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
}

// TDesign 字体系统
class TDesignTypography {
  static const String fontFamily =
      '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", sans-serif';

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: TDesignColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: TDesignColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: TDesignColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: TDesignColors.textTertiary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: TDesignColors.textTertiary,
  );
}

// 应用主题配置
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: TDesignColors.brand,
        onPrimary: Colors.white,
        primaryContainer: TDesignColors.brandHover,
        onPrimaryContainer: Colors.white,
        secondary: TDesignColors.textSecondary,
        onSecondary: Colors.white,
        surface: TDesignColors.bgContainer,
        onSurface: TDesignColors.textPrimary,
        surfaceContainerHighest: TDesignColors.bgComponent,
        error: TDesignColors.error,
        onError: Colors.white,
      ),
      fontFamily: TDesignTypography.fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: TDesignColors.bgContainer,
        foregroundColor: TDesignColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: TDesignColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TDesignRadius.md),
          side: const BorderSide(color: TDesignColors.border, width: 1),
        ),
        color: TDesignColors.bgContainer,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return TDesignColors.border;
            }
            if (states.contains(WidgetState.pressed)) {
              return TDesignColors.brandActive;
            }
            if (states.contains(WidgetState.hovered)) {
              return TDesignColors.brandHover;
            }
            return TDesignColors.brand;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return TDesignColors.textTertiary;
            }
            return Colors.white;
          }),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: TDesignSpacing.lg, vertical: TDesignSpacing.sm),
          ),
          minimumSize: WidgetStateProperty.all<Size>(const Size(0, 36)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(TDesignRadius.sm)),
          ),
          elevation: WidgetStateProperty.all<double>(0),
          textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: TDesignColors.brand,
          padding: const EdgeInsets.symmetric(horizontal: TDesignSpacing.md, vertical: TDesignSpacing.xs),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: TDesignColors.brand,
          side: const BorderSide(color: TDesignColors.brand),
          padding: const EdgeInsets.symmetric(horizontal: TDesignSpacing.lg, vertical: TDesignSpacing.sm),
          minimumSize: const Size(0, 36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TDesignRadius.sm)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: TDesignColors.brand,
        linearTrackColor: TDesignColors.bgComponent,
      ),
    );
  }
}
