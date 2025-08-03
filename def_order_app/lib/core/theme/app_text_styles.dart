import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 앱 전반에 사용되는 타이포그래피 시스템
/// 40-60대 중년층의 가독성을 위해 충분한 크기와 명확한 계층구조 제공
class AppTextStyles {
  AppTextStyles._();

  // ========== Base Font Configuration ==========
  static const String _fontFamily = 'NotoSansKR'; // 한글 지원 폰트
  static const String _fallbackFontFamily = 'Roboto'; // 영문 폰트

  // ========== Font Weights ==========
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ========== Display Styles (대형 제목) ==========
  /// 앱 타이틀, 스플래시 화면용
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: bold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: bold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.25,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: bold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  // ========== Headline Styles (제목) ==========
  /// 페이지 제목, 섹션 제목용
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: bold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: semiBold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.15,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: semiBold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.15,
  );

  // ========== Title Styles (타이틀) ==========
  /// 카드 제목, 다이얼로그 제목용
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: medium,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.1,
  );

  // ========== Body Styles (본문) ==========
  /// 일반 텍스트, 설명문용 - 가독성을 위해 큰 크기 사용
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: regular,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.6,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.6,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    fontFamily: _fontFamily,
    color: AppColors.textSecondary,
    height: 1.6,
    letterSpacing: 0.25,
  );

  // ========== Label Styles (라벨) ==========
  /// 버튼 텍스트, 폼 라벨용
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    fontFamily: _fontFamily,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ========== Specialized Styles ==========
  /// 앱바 제목용
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: bold,
    fontFamily: _fontFamily,
    color: AppColors.textOnPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  /// 버튼 텍스트용 - 더 굵고 명확하게
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 18,
    fontWeight: bold,
    fontFamily: _fontFamily,
    color: AppColors.textOnPrimary,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 16,
    fontWeight: semiBold,
    fontFamily: _fontFamily,
    color: AppColors.textOnPrimary,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: semiBold,
    fontFamily: _fontFamily,
    color: AppColors.textOnPrimary,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  // 기본 button 스타일 (buttonMedium과 동일)
  static const TextStyle button = buttonMedium;

  /// 입력 필드용
  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.15,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    fontFamily: _fontFamily,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.15,
  );

  static const TextStyle inputHint = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    fontFamily: _fontFamily,
    color: AppColors.textTertiary,
    height: 1.4,
    letterSpacing: 0.15,
  );

  static const TextStyle inputError = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    fontFamily: _fontFamily,
    color: AppColors.error,
    height: 1.4,
    letterSpacing: 0.25,
  );

  /// 상태 표시용
  static const TextStyle statusActive = TextStyle(
    fontSize: 14,
    fontWeight: semiBold,
    fontFamily: _fontFamily,
    color: AppColors.success,
    height: 1.4,
    letterSpacing: 0.25,
  );

  static const TextStyle statusInactive = TextStyle(
    fontSize: 14,
    fontWeight: semiBold,
    fontFamily: _fontFamily,
    color: AppColors.textTertiary,
    height: 1.4,
    letterSpacing: 0.25,
  );

  static const TextStyle statusError = TextStyle(
    fontSize: 14,
    fontWeight: semiBold,
    fontFamily: _fontFamily,
    color: AppColors.error,
    height: 1.4,
    letterSpacing: 0.25,
  );

  /// 캡션/보조 텍스트용
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    fontFamily: _fontFamily,
    color: AppColors.textTertiary,
    height: 1.4,
    letterSpacing: 0.4,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: medium,
    fontFamily: _fontFamily,
    color: AppColors.textSecondary,
    height: 1.6,
    letterSpacing: 1.5,
  );

  // ========== Business Domain Styles ==========
  /// 주문 정보 표시용
  static const TextStyle orderNumber = TextStyle(
    fontSize: 18,
    fontWeight: bold,
    fontFamily: _fontFamily,
    color: AppColors.primary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle orderAmount = TextStyle(
    fontSize: 20,
    fontWeight: bold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle companyName = TextStyle(
    fontSize: 16,
    fontWeight: semiBold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.15,
  );

  /// 요소수 관련 특화 스타일
  static const TextStyle defProduct = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    fontFamily: _fontFamily,
    color: AppColors.def,
    height: 1.4,
    letterSpacing: 0.15,
  );

  static const TextStyle defQuantity = TextStyle(
    fontSize: 18,
    fontWeight: bold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  // ========== Utility Methods ==========
  /// 색상을 변경한 스타일 반환
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// 크기를 변경한 스타일 반환
  static TextStyle withSize(TextStyle style, double fontSize) {
    return style.copyWith(fontSize: fontSize);
  }

  /// 굵기를 변경한 스타일 반환
  static TextStyle withWeight(TextStyle style, FontWeight fontWeight) {
    return style.copyWith(fontWeight: fontWeight);
  }

  /// 줄 간격을 변경한 스타일 반환
  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }

  /// 투명도를 적용한 스타일 반환
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }

  /// 다크 테마용 스타일 반환
  static TextStyle forDarkTheme(TextStyle style) {
    Color? newColor;
    if (style.color == AppColors.textPrimary) {
      newColor = AppColors.darkTextPrimary;
    } else if (style.color == AppColors.textSecondary) {
      newColor = AppColors.darkTextSecondary;
    }
    return style.copyWith(color: newColor);
  }

  /// 상태별 색상 스타일 맵
  static Map<String, TextStyle> get statusStyles => {
    'success': statusActive,
    'error': statusError,
    'warning': withColor(statusActive, AppColors.warning),
    'info': withColor(statusActive, AppColors.info),
    'inactive': statusInactive,
  };

  /// 우선순위별 색상 스타일 맵
  static Map<String, TextStyle> get priorityStyles => {
    'low': withColor(labelMedium, AppColors.priorityLow),
    'medium': withColor(labelMedium, AppColors.priorityMedium),
    'high': withColor(labelMedium, AppColors.priorityHigh),
    'critical': withColor(labelMedium, AppColors.priorityCritical),
  };
}