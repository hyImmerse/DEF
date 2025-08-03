import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'app_component_theme.dart';
import 'app_dark_theme.dart';
import 'app_responsive.dart';

/// 통합 앱 테마 관리 클래스
/// 라이트/다크 테마, 반응형 디자인, 컴포넌트 테마를 통합 관리
class AppTheme {
  AppTheme._();

  // ========== Legacy Color Constants (하위 호환성) ==========
  @Deprecated('Use AppColors.primary instead')
  static const Color primaryColor = AppColors.primary;
  
  @Deprecated('Use AppColors.secondary instead')
  static const Color secondaryColor = AppColors.secondary;
  
  @Deprecated('Use AppColors.error instead')
  static const Color errorColor = AppColors.error;
  
  @Deprecated('Use AppColors.success instead')
  static const Color successColor = AppColors.success;
  
  @Deprecated('Use AppColors.warning instead')
  static const Color warningColor = AppColors.warning;

  // ========== Light Theme ==========
  /// 라이트 테마 정의
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // 색상 스키마
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    
    // 시각적 밀도
    visualDensity: VisualDensity.comfortable,
    
    // 타이포그래피
    textTheme: _buildTextTheme(Brightness.light),
    primaryTextTheme: _buildTextTheme(Brightness.light),
    
    // 컴포넌트 테마들
    appBarTheme: AppComponentTheme.appBarTheme,
    elevatedButtonTheme: AppComponentTheme.elevatedButtonTheme,
    outlinedButtonTheme: AppComponentTheme.outlinedButtonTheme,
    textButtonTheme: AppComponentTheme.textButtonTheme,
    inputDecorationTheme: AppComponentTheme.inputDecorationTheme,
    cardTheme: AppComponentTheme.cardTheme,
    listTileTheme: AppComponentTheme.listTileTheme,
    chipTheme: AppComponentTheme.chipTheme,
    bottomNavigationBarTheme: AppComponentTheme.bottomNavigationBarTheme,
    bottomSheetTheme: AppComponentTheme.bottomSheetTheme,
    dialogTheme: AppComponentTheme.dialogTheme,
    floatingActionButtonTheme: AppComponentTheme.floatingActionButtonTheme,
    snackBarTheme: AppComponentTheme.snackBarTheme,
    tabBarTheme: AppComponentTheme.tabBarTheme,
    switchTheme: AppComponentTheme.switchTheme,
    checkboxTheme: AppComponentTheme.checkboxTheme,
    radioTheme: AppComponentTheme.radioTheme,
    progressIndicatorTheme: AppComponentTheme.progressIndicatorTheme,
    dividerTheme: AppComponentTheme.dividerTheme,
    
    // 배경 색상
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.surface,
    cardColor: AppColors.surface,
    dialogBackgroundColor: AppColors.surface,
    
    // 아이콘 테마
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: AppSizes.iconLG,
    ),
    primaryIconTheme: const IconThemeData(
      color: AppColors.textOnPrimary,
      size: AppSizes.iconLG,
    ),
    
    // 텍스트 선택 테마
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withOpacity(0.4),
      selectionHandleColor: AppColors.primary,
    ),
    
    // 스플래시 및 하이라이트
    splashColor: AppColors.primary.withOpacity(0.12),
    highlightColor: AppColors.primary.withOpacity(0.08),
    hoverColor: AppColors.primary.withOpacity(0.04),
    focusColor: AppColors.primary.withOpacity(0.12),
    
    // 비활성화 색상
    disabledColor: AppColors.textDisabled,
    
    // 그림자 색상
    shadowColor: AppColors.shadow,
    
    // Material 터치 타겟 크기
    materialTapTargetSize: MaterialTapTargetSize.padded,
  );

  // ========== Dark Theme ==========
  /// 다크 테마 정의
  static ThemeData get darkTheme => AppDarkTheme.themeData;

  // ========== Theme Mode Management ==========
  /// 시스템 테마 모드에 따른 테마 반환
  static ThemeData getTheme(ThemeMode themeMode, Brightness platformBrightness) {
    switch (themeMode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.system:
        return platformBrightness == Brightness.dark ? darkTheme : lightTheme;
    }
  }

  /// 현재 테마가 다크 모드인지 확인
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// 테마에 적응하는 색상 반환
  static Color adaptiveColor(
    BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) {
    return isDarkMode(context) ? darkColor : lightColor;
  }

  // ========== Text Theme Builder ==========
  /// 밝기에 따른 텍스트 테마 구성
  static TextTheme _buildTextTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    
    return TextTheme(
      // Display styles
      displayLarge: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.displayLarge)
          : AppTextStyles.displayLarge,
      displayMedium: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.displayMedium)
          : AppTextStyles.displayMedium,
      displaySmall: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.displaySmall)
          : AppTextStyles.displaySmall,
      
      // Headline styles
      headlineLarge: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.headlineLarge)
          : AppTextStyles.headlineLarge,
      headlineMedium: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.headlineMedium)
          : AppTextStyles.headlineMedium,
      headlineSmall: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.headlineSmall)
          : AppTextStyles.headlineSmall,
      
      // Title styles
      titleLarge: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.titleLarge)
          : AppTextStyles.titleLarge,
      titleMedium: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.titleMedium)
          : AppTextStyles.titleMedium,
      titleSmall: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.titleSmall)
          : AppTextStyles.titleSmall,
      
      // Body styles
      bodyLarge: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.bodyLarge)
          : AppTextStyles.bodyLarge,
      bodyMedium: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.bodyMedium)
          : AppTextStyles.bodyMedium,
      bodySmall: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.bodySmall)
          : AppTextStyles.bodySmall,
      
      // Label styles
      labelLarge: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.labelLarge)
          : AppTextStyles.labelLarge,
      labelMedium: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.labelMedium)
          : AppTextStyles.labelMedium,
      labelSmall: isDark 
          ? AppTextStyles.forDarkTheme(AppTextStyles.labelSmall)
          : AppTextStyles.labelSmall,
    );
  }

  // ========== GetWidget Theme (Legacy Support) ==========
  /// GetWidget 테마 설정 (하위 호환성을 위해 유지)
  static GFTheme get gfTheme => GFTheme(
    data: lightTheme.copyWith(
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
    ),
    child: const SizedBox.shrink(),
  );

  // ========== Utility Methods ==========
  /// 반응형 텍스트 스타일 생성
  static TextStyle responsiveTextStyle(
    BuildContext context,
    TextStyle baseStyle, {
    double? mobileScale,
    double? tabletScale,
    double? desktopScale,
  }) {
    final adaptiveFontSize = AppResponsive.getAdaptiveFontSize(
      context,
      baseStyle.fontSize ?? 16.0,
      mobileScale: mobileScale,
      tabletScale: tabletScale,
      desktopScale: desktopScale,
    );
    
    return baseStyle.copyWith(fontSize: adaptiveFontSize);
  }

  /// 테마별 색상 가져오기
  static Color getColor(BuildContext context, String colorKey) {
    final colorScheme = Theme.of(context).colorScheme;
    
    switch (colorKey) {
      case 'primary':
        return colorScheme.primary;
      case 'secondary':
        return colorScheme.secondary;
      case 'error':
        return colorScheme.error;
      case 'surface':
        return colorScheme.surface;
      case 'background':
        return colorScheme.background;
      case 'onPrimary':
        return colorScheme.onPrimary;
      case 'onSecondary':
        return colorScheme.onSecondary;
      case 'onError':
        return colorScheme.onError;
      case 'onSurface':
        return colorScheme.onSurface;
      case 'onBackground':
        return colorScheme.onBackground;
      default:
        return colorScheme.primary;
    }
  }

  /// 텍스트 스타일 가져오기
  static TextStyle getTextStyle(BuildContext context, String styleKey) {
    final textTheme = Theme.of(context).textTheme;
    
    switch (styleKey) {
      case 'displayLarge':
        return textTheme.displayLarge ?? AppTextStyles.displayLarge;
      case 'displayMedium':
        return textTheme.displayMedium ?? AppTextStyles.displayMedium;
      case 'displaySmall':
        return textTheme.displaySmall ?? AppTextStyles.displaySmall;
      case 'headlineLarge':
        return textTheme.headlineLarge ?? AppTextStyles.headlineLarge;
      case 'headlineMedium':
        return textTheme.headlineMedium ?? AppTextStyles.headlineMedium;
      case 'headlineSmall':
        return textTheme.headlineSmall ?? AppTextStyles.headlineSmall;
      case 'titleLarge':
        return textTheme.titleLarge ?? AppTextStyles.titleLarge;
      case 'titleMedium':
        return textTheme.titleMedium ?? AppTextStyles.titleMedium;
      case 'titleSmall':
        return textTheme.titleSmall ?? AppTextStyles.titleSmall;
      case 'bodyLarge':
        return textTheme.bodyLarge ?? AppTextStyles.bodyLarge;
      case 'bodyMedium':
        return textTheme.bodyMedium ?? AppTextStyles.bodyMedium;
      case 'bodySmall':
        return textTheme.bodySmall ?? AppTextStyles.bodySmall;
      case 'labelLarge':
        return textTheme.labelLarge ?? AppTextStyles.labelLarge;
      case 'labelMedium':
        return textTheme.labelMedium ?? AppTextStyles.labelMedium;
      case 'labelSmall':
        return textTheme.labelSmall ?? AppTextStyles.labelSmall;
      default:
        return textTheme.bodyMedium ?? AppTextStyles.bodyMedium;
    }
  }

  /// 상태별 색상 가져오기
  static Color getStatusColor(String status) {
    return AppColors.statusColors[status] ?? AppColors.textSecondary;
  }

  /// 우선순위별 색상 가져오기
  static Color getPriorityColor(String priority) {
    return AppColors.priorityColors[priority] ?? AppColors.textSecondary;
  }
}