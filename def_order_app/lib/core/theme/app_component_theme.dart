import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

/// 앱 전반에 사용되는 컴포넌트별 테마 설정
/// 각 Material 컴포넌트의 일관된 스타일링을 위한 테마 정의
class AppComponentTheme {
  AppComponentTheme._();

  // ========== AppBar Theme ==========
  static AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: AppTextStyles.appBarTitle,
    iconTheme: const IconThemeData(
      color: AppColors.textOnPrimary,
      size: AppSizes.iconLG,
    ),
    actionsIconTheme: const IconThemeData(
      color: AppColors.textOnPrimary,
      size: AppSizes.iconLG,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
    toolbarHeight: 56,
    scrolledUnderElevation: 4,
    shadowColor: AppColors.shadow,
    surfaceTintColor: AppColors.primary,
  );

  // ========== ElevatedButton Theme ==========
  static ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      disabledBackgroundColor: AppColors.textDisabled,
      disabledForegroundColor: AppColors.textOnSurface,
      elevation: AppSizes.cardElevation,
      padding: AppSpacing.buttonAll,
      minimumSize: const Size.fromHeight(AppSizes.buttonHeightLG),
      maximumSize: const Size(double.infinity, AppSizes.buttonHeightLG),
      textStyle: AppTextStyles.buttonLarge,
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.borderRadiusSM,
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
    ),
  );

  // ========== OutlinedButton Theme ==========
  static OutlinedButtonThemeData get outlinedButtonTheme => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.textDisabled,
      padding: AppSpacing.buttonAll,
      minimumSize: const Size.fromHeight(AppSizes.buttonHeightLG),
      maximumSize: const Size(double.infinity, AppSizes.buttonHeightLG),
      textStyle: AppTextStyles.buttonLarge.copyWith(color: AppColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.borderRadiusSM,
      ),
      side: const BorderSide(
        color: AppColors.primary,
        width: AppSizes.borderNormal,
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
    ),
  );

  // ========== TextButton Theme ==========
  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.textDisabled,
      padding: AppSpacing.buttonAll,
      minimumSize: const Size(0, AppSizes.buttonHeightMD),
      textStyle: AppTextStyles.buttonMedium.copyWith(color: AppColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.borderRadiusSM,
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
    ),
  );

  // ========== InputDecoration Theme ==========
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceVariant,
    contentPadding: AppSpacing.inputAll,
    
    // 기본 테두리
    border: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: const BorderSide(
        color: AppColors.border,
        width: AppSizes.borderThin,
      ),
    ),
    
    // 활성화된 테두리
    enabledBorder: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: const BorderSide(
        color: AppColors.border,
        width: AppSizes.borderThin,
      ),
    ),
    
    // 포커스된 테두리
    focusedBorder: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: AppSizes.borderFocus,
      ),
    ),
    
    // 에러 테두리
    errorBorder: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: const BorderSide(
        color: AppColors.error,
        width: AppSizes.borderFocus,
      ),
    ),
    
    // 포커스된 에러 테두리
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: const BorderSide(
        color: AppColors.error,
        width: AppSizes.borderFocus,
      ),
    ),
    
    // 비활성화된 테두리
    disabledBorder: OutlineInputBorder(
      borderRadius: AppSizes.borderRadiusSM,
      borderSide: const BorderSide(
        color: AppColors.textDisabled,
        width: AppSizes.borderThin,
      ),
    ),
    
    // 텍스트 스타일
    labelStyle: AppTextStyles.inputLabel,
    hintStyle: AppTextStyles.inputHint,
    errorStyle: AppTextStyles.inputError,
    helperStyle: AppTextStyles.caption,
    
    // 플로팅 라벨 스타일
    floatingLabelStyle: AppTextStyles.inputLabel.copyWith(
      color: AppColors.primary,
    ),
    
    // 아이콘 테마
    iconColor: AppColors.textSecondary,
    prefixIconColor: AppColors.textSecondary,
    suffixIconColor: AppColors.textSecondary,
  );

  // ========== Card Theme ==========
  static CardThemeData get cardTheme => const CardThemeData(
    color: AppColors.surface,
    shadowColor: AppColors.shadow,
    surfaceTintColor: AppColors.surface,
    elevation: AppSizes.cardElevation,
    margin: AppSpacing.allSM,
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.borderRadiusLG,
    ),
    clipBehavior: Clip.antiAlias,
  );

  // ========== ListTile Theme ==========
  static ListTileThemeData get listTileTheme => ListTileThemeData(
    contentPadding: AppSpacing.cardAll,
    minVerticalPadding: AppSpacing.sm,
    horizontalTitleGap: AppSpacing.md,
    minLeadingWidth: AppSizes.iconXL,
    iconColor: AppColors.textSecondary,
    textColor: AppColors.textPrimary,
    titleTextStyle: AppTextStyles.titleMedium,
    subtitleTextStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textSecondary,
    ),
    leadingAndTrailingTextStyle: AppTextStyles.labelMedium,
    dense: false,
    visualDensity: VisualDensity.comfortable,
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.borderRadiusSM,
    ),
    selectedTileColor: AppColors.primary50,
    selectedColor: AppColors.primary,
    tileColor: AppColors.surface,
  );

  // ========== Chip Theme ==========
  static ChipThemeData get chipTheme => ChipThemeData(
    backgroundColor: AppColors.surfaceVariant,
    deleteIconColor: AppColors.textSecondary,
    disabledColor: AppColors.textDisabled,
    selectedColor: AppColors.primary100,
    secondarySelectedColor: AppColors.secondary100,
    shadowColor: AppColors.shadow,
    selectedShadowColor: AppColors.shadow,
    showCheckmark: true,
    checkmarkColor: AppColors.primary,
    labelPadding: AppSpacing.horizontalSM,
    padding: AppSpacing.allSM,
    side: const BorderSide(
      color: AppColors.border,
      width: AppSizes.borderThin,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.borderRadiusCircular,
    ),
    labelStyle: AppTextStyles.labelMedium,
    secondaryLabelStyle: AppTextStyles.labelSmall,
    brightness: Brightness.light,
    elevation: 0,
    pressElevation: AppSizes.cardElevationHover,
  );

  // ========== BottomNavigationBar Theme ==========
  static BottomNavigationBarThemeData get bottomNavigationBarTheme => BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    selectedIconTheme: const IconThemeData(
      color: AppColors.primary,
      size: AppSizes.iconLG,
    ),
    unselectedIconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: AppSizes.iconLG,
    ),
    selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
      color: AppColors.primary,
      fontWeight: AppTextStyles.semiBold,
    ),
    unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
      color: AppColors.textSecondary,
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    enableFeedback: true,
  );

  // ========== BottomSheet Theme ==========
  static BottomSheetThemeData get bottomSheetTheme => BottomSheetThemeData(
    backgroundColor: AppColors.surface,
    surfaceTintColor: AppColors.surface,
    elevation: 8,
    modalElevation: 16,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusXL),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    constraints: const BoxConstraints(
      maxWidth: AppSizes.containerMaxWidth,
    ),
    showDragHandle: true,
    dragHandleColor: AppColors.textTertiary,
    dragHandleSize: const Size(40, 4),
  );

  // ========== Dialog Theme ==========
  static DialogThemeData get dialogTheme => const DialogThemeData(
    backgroundColor: AppColors.surface,
    surfaceTintColor: AppColors.surface,
    elevation: 16,
    shadowColor: AppColors.shadowDark,
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.borderRadiusXL,
    ),
    alignment: Alignment.center,
    titleTextStyle: AppTextStyles.headlineSmall,
    contentTextStyle: AppTextStyles.bodyMedium,
    actionsPadding: AppSpacing.allLG,
    // buttonPadding은 Flutter 3.16+에서 제거됨
    insetPadding: AppSpacing.allXL,
  );

  // ========== FloatingActionButton Theme ==========
  static FloatingActionButtonThemeData get floatingActionButtonTheme => FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
    focusColor: AppColors.primary700,
    hoverColor: AppColors.primary600,
    splashColor: AppColors.primary800,
    elevation: 6,
    focusElevation: 8,
    hoverElevation: 8,
    highlightElevation: 12,
    disabledElevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.borderRadiusLG,
    ),
    enableFeedback: true,
    iconSize: AppSizes.iconLG,
    sizeConstraints: const BoxConstraints.tightFor(
      width: 56,
      height: 56,
    ),
    smallSizeConstraints: const BoxConstraints.tightFor(
      width: 40,
      height: 40,
    ),
    largeSizeConstraints: const BoxConstraints.tightFor(
      width: 96,
      height: 96,
    ),
    extendedSizeConstraints: const BoxConstraints.tightFor(
      height: 48,
    ),
    extendedIconLabelSpacing: AppSpacing.sm,
    extendedPadding: AppSpacing.horizontalLG,
    extendedTextStyle: AppTextStyles.labelLarge,
  );

  // ========== SnackBar Theme ==========
  static SnackBarThemeData get snackBarTheme => SnackBarThemeData(
    backgroundColor: AppColors.textPrimary,
    contentTextStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textOnPrimary,
    ),
    actionTextColor: AppColors.primary200,
    disabledActionTextColor: AppColors.textDisabled,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.borderRadiusSM,
    ),
    behavior: SnackBarBehavior.floating,
    // margin은 SnackBarThemeData에서 제거됨
    insetPadding: AppSpacing.allLG,
    showCloseIcon: true,
    closeIconColor: AppColors.textOnPrimary,
    actionOverflowThreshold: 0.25,
    actionBackgroundColor: AppColors.primary,
  );

  // ========== TabBar Theme ==========
  static TabBarThemeData get tabBarTheme => TabBarThemeData(
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(
        color: AppColors.primary,
        width: AppSizes.borderThick,
      ),
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusSM),
      ),
    ),
    indicatorColor: AppColors.primary,
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.textSecondary,
    labelStyle: AppTextStyles.labelLarge.copyWith(
      fontWeight: AppTextStyles.semiBold,
    ),
    unselectedLabelStyle: AppTextStyles.labelLarge,
    labelPadding: AppSpacing.horizontalMD,
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return AppColors.primary.withOpacity(0.04);
        }
        if (states.contains(MaterialState.focused)) {
          return AppColors.primary.withOpacity(0.12);
        }
        if (states.contains(MaterialState.pressed)) {
          return AppColors.primary.withOpacity(0.12);
        }
        return null;
      },
    ),
    splashFactory: InkRipple.splashFactory,
    mouseCursor: MaterialStateProperty.resolveWith<MouseCursor?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return SystemMouseCursors.forbidden;
        }
        return SystemMouseCursors.click;
      },
    ),
  );

  // ========== Switch Theme ==========
  static SwitchThemeData get switchTheme => SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.textDisabled;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.surfaceContainer;
      },
    ),
    trackColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.textDisabled.withOpacity(0.12);
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary.withOpacity(0.54);
        }
        return AppColors.textTertiary.withOpacity(0.38);
      },
    ),
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.primary.withOpacity(0.12);
        }
        if (states.contains(MaterialState.hovered)) {
          return AppColors.primary.withOpacity(0.04);
        }
        if (states.contains(MaterialState.focused)) {
          return AppColors.primary.withOpacity(0.12);
        }
        return null;
      },
    ),
    splashRadius: 20,
  );

  // ========== CheckBox Theme ==========
  static CheckboxThemeData get checkboxTheme => CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.textDisabled;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.surface;
      },
    ),
    checkColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        return AppColors.textOnPrimary;
      },
    ),
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.primary.withOpacity(0.12);
        }
        if (states.contains(MaterialState.hovered)) {
          return AppColors.primary.withOpacity(0.04);
        }
        if (states.contains(MaterialState.focused)) {
          return AppColors.primary.withOpacity(0.12);
        }
        return null;
      },
    ),
    splashRadius: 20,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.comfortable,
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.borderRadiusXS,
    ),
    side: const BorderSide(
      color: AppColors.border,
      width: AppSizes.borderNormal,
    ),
  );

  // ========== RadioButton Theme ==========
  static RadioThemeData get radioTheme => RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.textDisabled;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.textSecondary;
      },
    ),
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.primary.withOpacity(0.12);
        }
        if (states.contains(MaterialState.hovered)) {
          return AppColors.primary.withOpacity(0.04);
        }
        if (states.contains(MaterialState.focused)) {
          return AppColors.primary.withOpacity(0.12);
        }
        return null;
      },
    ),
    splashRadius: 20,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.comfortable,
  );

  // ========== ProgressIndicator Theme ==========
  static ProgressIndicatorThemeData get progressIndicatorTheme => const ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.surfaceVariant,
    circularTrackColor: AppColors.surfaceVariant,
    refreshBackgroundColor: AppColors.surface,
    linearMinHeight: 6,
  );

  // ========== Divider Theme ==========
  static DividerThemeData get dividerTheme => const DividerThemeData(
    color: AppColors.divider,
    thickness: AppSizes.dividerNormal,
    space: AppSpacing.lg,
    indent: 0,
    endIndent: 0,
  );
}