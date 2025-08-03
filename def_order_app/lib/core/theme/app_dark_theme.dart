import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'app_component_theme.dart';

/// 다크 테마 정의
/// 40-60대 사용자를 위한 가독성과 눈의 피로 감소를 고려한 다크 테마
class AppDarkTheme {
  AppDarkTheme._();

  // ========== Dark Theme Colors ==========
  /// 다크 테마 전용 색상 팔레트
  static const _darkPrimary = AppColors.primary200; // 밝은 파란색
  static const _darkSecondary = AppColors.secondary200;
  static const _darkSurface = Color(0xFF1E1E1E);
  static const _darkBackground = Color(0xFF121212);
  static const _darkError = AppColors.error300;
  static const _darkOnPrimary = Color(0xFF003258);
  static const _darkOnSecondary = Color(0xFF102027);
  static const _darkOnSurface = Color(0xFFE1E2E1);
  static const _darkOnBackground = Color(0xFFE1E2E1);
  static const _darkOnError = Color(0xFF690005);

  // ========== ColorScheme ==========
  static ColorScheme get colorScheme => const ColorScheme.dark(
    // Primary colors
    primary: _darkPrimary,
    onPrimary: _darkOnPrimary,
    primaryContainer: AppColors.primary700,
    onPrimaryContainer: AppColors.primary50,
    
    // Secondary colors
    secondary: _darkSecondary,
    onSecondary: _darkOnSecondary,
    secondaryContainer: AppColors.secondary700,
    onSecondaryContainer: AppColors.secondary50,
    
    // Tertiary colors
    tertiary: AppColors.info200,
    onTertiary: AppColors.info900,
    tertiaryContainer: AppColors.info700,
    onTertiaryContainer: AppColors.info50,
    
    // Error colors
    error: _darkError,
    onError: _darkOnError,
    errorContainer: AppColors.error700,
    onErrorContainer: AppColors.error50,
    
    // Surface colors
    background: _darkBackground,
    onBackground: _darkOnBackground,
    surface: _darkSurface,
    onSurface: _darkOnSurface,
    surfaceVariant: Color(0xFF2C2C2C),
    onSurfaceVariant: Color(0xFFC4C7C5),
    
    // Outline colors
    outline: Color(0xFF8E918F),
    outlineVariant: Color(0xFF424940),
    
    // Other colors
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE1E2E1),
    onInverseSurface: Color(0xFF2E312E),
    inversePrimary: AppColors.primary600,
    surfaceTint: _darkPrimary,
  );

  // ========== ThemeData ==========
  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    
    // Visual density
    visualDensity: VisualDensity.comfortable,
    
    // Typography
    textTheme: _darkTextTheme,
    primaryTextTheme: _darkTextTheme,
    
    // AppBar
    appBarTheme: _darkAppBarTheme,
    
    // Buttons
    elevatedButtonTheme: _darkElevatedButtonTheme,
    outlinedButtonTheme: _darkOutlinedButtonTheme,
    textButtonTheme: _darkTextButtonTheme,
    
    // Input
    inputDecorationTheme: _darkInputDecorationTheme,
    
    // Cards and surfaces
    cardTheme: _darkCardTheme,
    
    // Lists
    listTileTheme: _darkListTileTheme,
    
    // Chips
    chipTheme: _darkChipTheme,
    
    // Navigation
    bottomNavigationBarTheme: _darkBottomNavigationBarTheme,
    
    // Dialogs
    dialogTheme: _darkDialogTheme,
    bottomSheetTheme: _darkBottomSheetTheme,
    
    // FAB
    floatingActionButtonTheme: _darkFloatingActionButtonTheme,
    
    // SnackBar
    snackBarTheme: _darkSnackBarTheme,
    
    // TabBar
    tabBarTheme: _darkTabBarTheme,
    
    // Form controls
    switchTheme: _darkSwitchTheme,
    checkboxTheme: _darkCheckboxTheme,
    radioTheme: _darkRadioTheme,
    
    // Progress indicators
    progressIndicatorTheme: _darkProgressIndicatorTheme,
    
    // Dividers
    dividerTheme: _darkDividerTheme,
    
    // Scaffold
    scaffoldBackgroundColor: _darkBackground,
    canvasColor: _darkSurface,
    cardColor: _darkSurface,
    dialogBackgroundColor: _darkSurface,
    
    // Icons
    iconTheme: const IconThemeData(
      color: _darkOnSurface,
      size: AppSizes.iconLG,
    ),
    primaryIconTheme: const IconThemeData(
      color: _darkOnPrimary,
      size: AppSizes.iconLG,
    ),
    
    // Selection
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: _darkPrimary,
      selectionColor: _darkPrimary.withOpacity(0.4),
      selectionHandleColor: _darkPrimary,
    ),
    
    // Splash and highlight
    splashColor: _darkPrimary.withOpacity(0.12),
    highlightColor: _darkPrimary.withOpacity(0.08),
    hoverColor: _darkPrimary.withOpacity(0.04),
    focusColor: _darkPrimary.withOpacity(0.12),
    
    // Disabled
    disabledColor: AppColors.darkTextSecondary,
    
    // Shadows
    shadowColor: const Color(0xFF000000),
    
    // Material state
    materialTapTargetSize: MaterialTapTargetSize.padded,
  );

  // ========== Text Theme ==========
  static TextTheme get _darkTextTheme => TextTheme(
    // Display styles
    displayLarge: AppTextStyles.displayLarge.copyWith(
      color: _darkOnBackground,
    ),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: _darkOnBackground,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(
      color: _darkOnBackground,
    ),
    
    // Headline styles
    headlineLarge: AppTextStyles.headlineLarge.copyWith(
      color: _darkOnBackground,
    ),
    headlineMedium: AppTextStyles.headlineMedium.copyWith(
      color: _darkOnBackground,
    ),
    headlineSmall: AppTextStyles.headlineSmall.copyWith(
      color: _darkOnBackground,
    ),
    
    // Title styles
    titleLarge: AppTextStyles.titleLarge.copyWith(
      color: _darkOnSurface,
    ),
    titleMedium: AppTextStyles.titleMedium.copyWith(
      color: _darkOnSurface,
    ),
    titleSmall: AppTextStyles.titleSmall.copyWith(
      color: _darkOnSurface,
    ),
    
    // Body styles
    bodyLarge: AppTextStyles.bodyLarge.copyWith(
      color: _darkOnSurface,
    ),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: _darkOnSurface,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: AppColors.darkTextSecondary,
    ),
    
    // Label styles
    labelLarge: AppTextStyles.labelLarge.copyWith(
      color: _darkOnSurface,
    ),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: _darkOnSurface,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: AppColors.darkTextSecondary,
    ),
  );

  // ========== Component Themes for Dark Mode ==========
  
  static AppBarTheme get _darkAppBarTheme => AppComponentTheme.appBarTheme.copyWith(
    backgroundColor: _darkSurface,
    foregroundColor: _darkOnSurface,
    titleTextStyle: AppTextStyles.appBarTitle.copyWith(
      color: _darkOnSurface,
    ),
    iconTheme: const IconThemeData(
      color: _darkOnSurface,
      size: AppSizes.iconLG,
    ),
    actionsIconTheme: const IconThemeData(
      color: _darkOnSurface,
      size: AppSizes.iconLG,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
    elevation: 0,
    scrolledUnderElevation: 2,
    shadowColor: const Color(0xFF000000),
    surfaceTintColor: _darkSurface,
  );

  static ElevatedButtonThemeData get _darkElevatedButtonTheme => ElevatedButtonThemeData(
    style: AppComponentTheme.elevatedButtonTheme.style?.copyWith(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.darkTextSecondary.withOpacity(0.12);
        }
        return _darkPrimary;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.darkTextSecondary.withOpacity(0.38);
        }
        return _darkOnPrimary;
      }),
      elevation: MaterialStateProperty.resolveWith<double>((states) {
        if (states.contains(MaterialState.disabled)) return 0;
        if (states.contains(MaterialState.hovered)) return 4;
        if (states.contains(MaterialState.focused)) return 4;
        if (states.contains(MaterialState.pressed)) return 8;
        return 2;
      }),
    ),
  );

  static OutlinedButtonThemeData get _darkOutlinedButtonTheme => OutlinedButtonThemeData(
    style: AppComponentTheme.outlinedButtonTheme.style?.copyWith(
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.darkTextSecondary.withOpacity(0.38);
        }
        return _darkPrimary;
      }),
      side: MaterialStateProperty.resolveWith<BorderSide>((states) {
        if (states.contains(MaterialState.disabled)) {
          return BorderSide(
            color: AppColors.darkTextSecondary.withOpacity(0.12),
            width: AppSizes.borderThin,
          );
        }
        return const BorderSide(
          color: _darkPrimary,
          width: AppSizes.borderNormal,
        );
      }),
    ),
  );

  static TextButtonThemeData get _darkTextButtonTheme => TextButtonThemeData(
    style: AppComponentTheme.textButtonTheme.style?.copyWith(
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.darkTextSecondary.withOpacity(0.38);
        }
        return _darkPrimary;
      }),
    ),
  );

  static InputDecorationTheme get _darkInputDecorationTheme => AppComponentTheme.inputDecorationTheme.copyWith(
    fillColor: const Color(0xFF2C2C2C),
    
    // 기본 테두리
    border: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: BorderSide(
        color: AppColors.darkBorder,
        width: AppSizes.borderThin,
      ),
    ),
    
    // 활성화된 테두리
    enabledBorder: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: BorderSide(
        color: AppColors.darkBorder,
        width: AppSizes.borderThin,
      ),
    ),
    
    // 포커스된 테두리
    focusedBorder: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: const BorderSide(
        color: _darkPrimary,
        width: AppSizes.borderFocus,
      ),
    ),
    
    // 에러 테두리
    errorBorder: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: const BorderSide(
        color: _darkError,
        width: AppSizes.borderFocus,
      ),
    ),
    
    // 포커스된 에러 테두리
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: const BorderSide(
        color: _darkError,
        width: AppSizes.borderFocus,
      ),
    ),
    
    // 비활성화된 테두리
    disabledBorder: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: BorderSide(
        color: AppColors.darkTextSecondary.withOpacity(0.38),
        width: AppSizes.borderThin,
      ),
    ),
    
    // 텍스트 스타일
    labelStyle: AppTextStyles.inputLabel.copyWith(
      color: AppColors.darkTextSecondary,
    ),
    hintStyle: AppTextStyles.inputHint.copyWith(
      color: AppColors.darkTextSecondary.withOpacity(0.6),
    ),
    errorStyle: AppTextStyles.inputError.copyWith(
      color: _darkError,
    ),
    helperStyle: AppTextStyles.caption.copyWith(
      color: AppColors.darkTextSecondary,
    ),
    
    // 플로팅 라벨 스타일
    floatingLabelStyle: AppTextStyles.inputLabel.copyWith(
      color: _darkPrimary,
    ),
    
    // 아이콘 색상
    iconColor: AppColors.darkTextSecondary,
    prefixIconColor: AppColors.darkTextSecondary,
    suffixIconColor: AppColors.darkTextSecondary,
  );

  static CardThemeData get _darkCardTheme => AppComponentTheme.cardTheme.copyWith(
    color: _darkSurface,
    shadowColor: const Color(0xFF000000),
    surfaceTintColor: _darkSurface,
  );

  static ListTileThemeData get _darkListTileTheme => AppComponentTheme.listTileTheme.copyWith(
    iconColor: AppColors.darkTextSecondary,
    textColor: _darkOnSurface,
    titleTextStyle: AppTextStyles.titleMedium.copyWith(
      color: _darkOnSurface,
    ),
    subtitleTextStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.darkTextSecondary,
    ),
    selectedTileColor: _darkPrimary.withOpacity(0.12),
    selectedColor: _darkPrimary,
    tileColor: _darkSurface,
  );

  static ChipThemeData get _darkChipTheme => AppComponentTheme.chipTheme.copyWith(
    backgroundColor: const Color(0xFF2C2C2C),
    deleteIconColor: AppColors.darkTextSecondary,
    disabledColor: AppColors.darkTextSecondary.withOpacity(0.12),
    selectedColor: _darkPrimary.withOpacity(0.12),
    secondarySelectedColor: _darkSecondary.withOpacity(0.12),
    checkmarkColor: _darkPrimary,
    labelStyle: AppTextStyles.labelMedium.copyWith(
      color: _darkOnSurface,
    ),
    secondaryLabelStyle: AppTextStyles.labelSmall.copyWith(
      color: AppColors.darkTextSecondary,
    ),
    side: BorderSide(
      color: AppColors.darkBorder,
      width: AppSizes.borderThin,
    ),
    brightness: Brightness.dark,
  );

  static BottomNavigationBarThemeData get _darkBottomNavigationBarTheme => AppComponentTheme.bottomNavigationBarTheme.copyWith(
    backgroundColor: _darkSurface,
    selectedItemColor: _darkPrimary,
    unselectedItemColor: AppColors.darkTextSecondary,
    selectedIconTheme: const IconThemeData(
      color: _darkPrimary,
      size: AppSizes.iconLG,
    ),
    unselectedIconTheme: const IconThemeData(
      color: AppColors.darkTextSecondary,
      size: AppSizes.iconLG,
    ),
    selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
      color: _darkPrimary,
      fontWeight: AppTextStyles.semiBold,
    ),
    unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
      color: AppColors.darkTextSecondary,
    ),
  );

  static DialogThemeData get _darkDialogTheme => AppComponentTheme.dialogTheme.copyWith(
    backgroundColor: _darkSurface,
    surfaceTintColor: _darkSurface,
    shadowColor: const Color(0xFF000000),
    titleTextStyle: AppTextStyles.headlineSmall.copyWith(
      color: _darkOnSurface,
    ),
    contentTextStyle: AppTextStyles.bodyMedium.copyWith(
      color: _darkOnSurface,
    ),
  );

  static BottomSheetThemeData get _darkBottomSheetTheme => AppComponentTheme.bottomSheetTheme.copyWith(
    backgroundColor: _darkSurface,
    surfaceTintColor: _darkSurface,
    dragHandleColor: AppColors.darkTextSecondary,
  );

  static FloatingActionButtonThemeData get _darkFloatingActionButtonTheme => AppComponentTheme.floatingActionButtonTheme.copyWith(
    backgroundColor: _darkPrimary,
    foregroundColor: _darkOnPrimary,
    focusColor: _darkPrimary.withOpacity(0.12),
    hoverColor: _darkPrimary.withOpacity(0.08),
    splashColor: _darkPrimary.withOpacity(0.12),
  );

  static SnackBarThemeData get _darkSnackBarTheme => AppComponentTheme.snackBarTheme.copyWith(
    backgroundColor: const Color(0xFF2C2C2C),
    contentTextStyle: AppTextStyles.bodyMedium.copyWith(
      color: _darkOnSurface,
    ),
    actionTextColor: _darkPrimary,
    closeIconColor: _darkOnSurface,
  );

  static TabBarThemeData get _darkTabBarTheme => AppComponentTheme.tabBarTheme.copyWith(
    labelColor: _darkPrimary,
    unselectedLabelColor: AppColors.darkTextSecondary,
    indicator: UnderlineTabIndicator(
      borderSide: const BorderSide(
        color: _darkPrimary,
        width: AppSizes.borderThick,
      ),
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusSM),
      ),
    ),
    indicatorColor: _darkPrimary,
  );

  static SwitchThemeData get _darkSwitchTheme => SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.darkTextSecondary.withOpacity(0.38);
      }
      if (states.contains(MaterialState.selected)) {
        return _darkPrimary;
      }
      return const Color(0xFF2C2C2C);
    }),
    trackColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.darkTextSecondary.withOpacity(0.12);
      }
      if (states.contains(MaterialState.selected)) {
        return _darkPrimary.withOpacity(0.54);
      }
      return AppColors.darkTextSecondary.withOpacity(0.38);
    }),
  );

  static CheckboxThemeData get _darkCheckboxTheme => CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.darkTextSecondary.withOpacity(0.38);
      }
      if (states.contains(MaterialState.selected)) {
        return _darkPrimary;
      }
      return _darkSurface;
    }),
    checkColor: MaterialStateProperty.all(_darkOnPrimary),
    side: BorderSide(
      color: AppColors.darkBorder,
      width: AppSizes.borderNormal,
    ),
  );

  static RadioThemeData get _darkRadioTheme => RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.darkTextSecondary.withOpacity(0.38);
      }
      if (states.contains(MaterialState.selected)) {
        return _darkPrimary;
      }
      return AppColors.darkTextSecondary;
    }),
  );

  static ProgressIndicatorThemeData get _darkProgressIndicatorTheme => const ProgressIndicatorThemeData(
    color: _darkPrimary,
    linearTrackColor: Color(0xFF2C2C2C),
    circularTrackColor: Color(0xFF2C2C2C),
    refreshBackgroundColor: _darkSurface,
  );

  static DividerThemeData get _darkDividerTheme => DividerThemeData(
    color: AppColors.darkBorder,
    thickness: AppSizes.dividerNormal,
    space: AppSpacing.lg,
  );
}