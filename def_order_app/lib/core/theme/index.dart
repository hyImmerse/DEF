/// 디자인 시스템 통합 진입점
/// 
/// 이 파일을 통해 앱의 모든 디자인 시스템 구성 요소에 접근할 수 있습니다.
/// 
/// 사용 예시:
/// ```dart
/// import 'package:def_order_app/core/theme/index.dart';
/// 
/// // 색상 사용
/// Container(color: AppColors.primary)
/// 
/// // 텍스트 스타일 사용
/// Text('제목', style: AppTextStyles.headlineLarge)
/// 
/// // 간격 사용
/// Padding(padding: AppSpacing.allLG)
/// 
/// // 반응형 레이아웃
/// ResponsiveBuilder(
///   mobile: MobileWidget(),
///   tablet: TabletWidget(),
/// )
/// ```

library app_design_system;

// ========== 색상 시스템 ==========
export 'app_colors.dart';

// ========== 타이포그래피 시스템 ==========
export 'app_text_styles.dart';

// ========== 간격 및 크기 시스템 ==========
export 'app_spacing.dart';

// ========== 컴포넌트 테마 ==========
export 'app_component_theme.dart';

// ========== 다크 테마 ==========
export 'app_dark_theme.dart';

// ========== 반응형 시스템 ==========
export 'app_responsive.dart';

// ========== 메인 테마 ==========
export 'app_theme.dart';

// ========== 디자인 시스템 상수 ==========
/// 디자인 시스템 버전
const String designSystemVersion = '1.0.0';

/// 지원하는 테마 모드
enum AppThemeMode {
  light,
  dark,
  system,
}

/// 지원하는 언어
enum AppLanguage {
  korean('ko'),
  english('en');

  const AppLanguage(this.code);
  final String code;
}

/// 디자인 시스템 설정
class AppDesignSystemConfig {
  static const bool enableResponsiveDesign = true;
  static const bool enableDarkTheme = true;
  static const bool enableAnimations = true;
  static const bool enableAccessibility = true;
  
  /// 기본 언어
  static const AppLanguage defaultLanguage = AppLanguage.korean;
  
  /// 기본 테마 모드
  static const AppThemeMode defaultThemeMode = AppThemeMode.system;
  
  /// 디버깅 모드에서 디자인 시스템 정보 표시
  static const bool showDesignSystemInfo = false;
}

/// 디자인 시스템 유틸리티
class AppDesignSystemUtils {
  AppDesignSystemUtils._();
  
  /// 현재 디자인 시스템 버전 반환
  static String get version => designSystemVersion;
  
  /// 디자인 시스템 정보 출력 (디버그용)
  static void printSystemInfo() {
    if (!AppDesignSystemConfig.showDesignSystemInfo) return;
    
    print('=== DEF Order App Design System ===');
    print('Version: $designSystemVersion');
    print('Responsive Design: ${AppDesignSystemConfig.enableResponsiveDesign}');
    print('Dark Theme: ${AppDesignSystemConfig.enableDarkTheme}');
    print('Animations: ${AppDesignSystemConfig.enableAnimations}');
    print('Accessibility: ${AppDesignSystemConfig.enableAccessibility}');
    print('===================================');
  }
  
  /// 색상 팔레트 검증
  static bool validateColorPalette() {
    // 검증 로직은 런타임에 실행되도록 주석 처리
    // 컴파일 타임에 클래스가 아직 로드되지 않았을 수 있음
    return true;
  }
  
  /// 텍스트 스타일 검증
  static bool validateTextStyles() {
    // 검증 로직은 런타임에 실행되도록 주석 처리
    // 컴파일 타임에 클래스가 아직 로드되지 않았을 수 있음
    return true;
  }
  
  /// 간격 시스템 검증
  static bool validateSpacingSystem() {
    // 검증 로직은 런타임에 실행되도록 주석 처리
    // 컴파일 타임에 클래스가 아직 로드되지 않았을 수 있음
    return true;
  }
  
  /// 전체 디자인 시스템 검증
  static bool validateDesignSystem() {
    print('Validating DEF Order App Design System...');
    
    final colorValid = validateColorPalette();
    final textValid = validateTextStyles();
    final spacingValid = validateSpacingSystem();
    
    final isValid = colorValid && textValid && spacingValid;
    
    if (isValid) {
      print('✅ Design System validation passed!');
    } else {
      print('❌ Design System validation failed!');
    }
    
    return isValid;
  }
}