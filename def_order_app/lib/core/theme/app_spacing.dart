import 'package:flutter/material.dart';

/// 앱 전반에 사용되는 간격(Spacing) 시스템
/// 일관된 간격과 여백을 통해 시각적 리듬감 제공
class AppSpacing {
  AppSpacing._();

  // ========== Base Spacing Unit ==========
  /// 기본 간격 단위 (4dp)
  static const double baseUnit = 4.0;

  // ========== Spacing Scale ==========
  /// 매우 작은 간격 (2dp)
  static const double xxs = baseUnit * 0.5;
  
  /// 작은 간격 (4dp)
  static const double xs = baseUnit * 1;
  
  /// 중간-작은 간격 (8dp)
  static const double sm = baseUnit * 2;
  
  /// 중간 간격 (12dp)
  static const double md = baseUnit * 3;
  
  /// 중간-큰 간격 (16dp)
  static const double lg = baseUnit * 4;
  
  /// 큰 간격 (20dp)
  static const double xl = baseUnit * 5;
  
  /// 매우 큰 간격 (24dp)
  static const double xxl = baseUnit * 6;
  
  /// 특별히 큰 간격 (32dp)
  static const double xxxl = baseUnit * 8;
  
  /// 거대한 간격 (40dp)
  static const double huge = baseUnit * 10;

  // ========== Common Spacing Values ==========
  /// 기본 여백 (16dp)
  static const double defaultPadding = lg;
  
  /// 화면 여백 (20dp)
  static const double screenPadding = xl;
  
  /// 카드 여백 (16dp)
  static const double cardPadding = lg;
  
  /// 섹션 간격 (24dp)
  static const double sectionSpacing = xxl;
  
  /// 컴포넌트 간격 (12dp)
  static const double componentSpacing = md;
  
  /// 요소 간격 (8dp)
  static const double elementSpacing = sm;
  
  /// 최소 터치 영역 (48dp) - 접근성 고려
  static const double minTouchTarget = 48.0;

  // ========== EdgeInsets Presets ==========
  /// 자주 사용되는 EdgeInsets 미리 정의
  
  // 모든 방향 동일
  static const EdgeInsets allXS = EdgeInsets.all(xs);
  static const EdgeInsets allSM = EdgeInsets.all(sm);
  static const EdgeInsets allMD = EdgeInsets.all(md);
  static const EdgeInsets allLG = EdgeInsets.all(lg);
  static const EdgeInsets allXL = EdgeInsets.all(xl);
  static const EdgeInsets allXXL = EdgeInsets.all(xxl);
  
  // 수평/수직
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets horizontalXXL = EdgeInsets.symmetric(horizontal: xxl);
  
  static const EdgeInsets verticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets verticalXXL = EdgeInsets.symmetric(vertical: xxl);
  
  // 화면 및 컨테이너 전용
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenVertical = EdgeInsets.symmetric(vertical: screenPadding);
  static const EdgeInsets screenAll = EdgeInsets.all(screenPadding);
  
  // 카드 전용
  static const EdgeInsets cardHorizontal = EdgeInsets.symmetric(horizontal: cardPadding);
  static const EdgeInsets cardVertical = EdgeInsets.symmetric(vertical: cardPadding);
  static const EdgeInsets cardAll = EdgeInsets.all(cardPadding);
  
  // 버튼 전용 (40-60대를 위한 넓은 터치 영역)
  static const EdgeInsets buttonHorizontal = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets buttonVertical = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets buttonAll = EdgeInsets.symmetric(horizontal: xl, vertical: lg);
  
  // 입력 필드 전용
  static const EdgeInsets inputHorizontal = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets inputVertical = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets inputAll = EdgeInsets.symmetric(horizontal: lg, vertical: xl);

  // ========== SizedBox Presets ==========
  /// 자주 사용되는 SizedBox 미리 정의
  
  // 수직 간격
  static const Widget verticalSpaceXS = SizedBox(height: xs);
  static const Widget verticalSpaceSM = SizedBox(height: sm);
  static const Widget verticalSpaceMD = SizedBox(height: md);
  static const Widget verticalSpaceLG = SizedBox(height: lg);
  static const Widget verticalSpaceXL = SizedBox(height: xl);
  static const Widget verticalSpaceXXL = SizedBox(height: xxl);
  static const Widget verticalSpaceXXXL = SizedBox(height: xxxl);
  
  // 더 짧은 이름의 수직 간격 (velocity_x 대체)
  static const double h4 = xs;
  static const double h6 = 6.0;
  static const double h8 = sm;
  static const double h12 = md;
  static const double h16 = lg;
  static const double h20 = xl;
  static const double h24 = xxl;
  static const double h32 = xxxl;
  
  static const double v4 = xs;
  static const double v8 = sm;
  static const double v12 = md;
  static const double v16 = lg;
  static const double v20 = xl;
  static const double v24 = xxl;
  static const double v32 = xxxl;
  static const double v40 = huge;
  static const double v48 = 48.0;
  
  // radius values
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  
  // 수평 간격
  static const Widget horizontalSpaceXS = SizedBox(width: xs);
  static const Widget horizontalSpaceSM = SizedBox(width: sm);
  static const Widget horizontalSpaceMD = SizedBox(width: md);
  static const Widget horizontalSpaceLG = SizedBox(width: lg);
  static const Widget horizontalSpaceXL = SizedBox(width: xl);
  static const Widget horizontalSpaceXXL = SizedBox(width: xxl);
  static const Widget horizontalSpaceXXXL = SizedBox(width: xxxl);

  // ========== Utility Methods ==========
  /// 커스텀 EdgeInsets 생성
  static EdgeInsets custom({
    double top = 0,
    double right = 0,
    double bottom = 0,
    double left = 0,
  }) {
    return EdgeInsets.only(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );
  }
  
  /// 커스텀 수직 SizedBox 생성
  static Widget verticalSpace(double height) => SizedBox(height: height);
  
  /// 커스텀 수평 SizedBox 생성
  static Widget horizontalSpace(double width) => SizedBox(width: width);
  
  /// 기본 단위의 배수로 간격 생성
  static double multiply(double multiplier) => baseUnit * multiplier;
  
  /// 최소 터치 영역을 보장하는 패딩 생성
  static EdgeInsets touchTarget({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ?? lg,
      vertical: vertical ?? ((minTouchTarget - 24) / 2), // 24는 기본 텍스트 높이 추정
    );
  }
}

/// 앱 전반에 사용되는 크기(Size) 시스템
/// 컴포넌트의 일관된 크기 정의
class AppSizes {
  AppSizes._();

  // ========== Icon Sizes ==========
  /// 아이콘 크기 (40-60대 사용자를 위해 큰 크기 사용)
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 28.0;
  static const double iconXL = 32.0;
  static const double iconXXL = 40.0;
  static const double iconHuge = 48.0;

  // ========== Avatar Sizes ==========
  /// 아바타/프로필 이미지 크기
  static const double avatarXS = 24.0;
  static const double avatarSM = 32.0;
  static const double avatarMD = 40.0;
  static const double avatarLG = 56.0;
  static const double avatarXL = 72.0;
  static const double avatarXXL = 96.0;

  // ========== Button Sizes ==========
  /// 버튼 높이 (접근성을 위해 최소 48dp 보장)
  static const double buttonHeightSM = 40.0;
  static const double buttonHeightMD = 48.0; // 기본 크기
  static const double buttonHeightLG = 56.0; // 중년층을 위한 큰 버튼
  static const double buttonHeightXL = 64.0;
  
  /// 버튼 너비
  static const double buttonWidthSM = 80.0;
  static const double buttonWidthMD = 120.0;
  static const double buttonWidthLG = 160.0;
  static const double buttonWidthXL = 200.0;
  static const double buttonWidthFull = double.infinity;

  // ========== Input Field Sizes ==========
  /// 입력 필드 높이
  static const double inputHeightSM = 40.0;
  static const double inputHeightMD = 48.0;
  static const double inputHeightLG = 56.0; // 기본 크기 (가독성)
  static const double inputHeightXL = 64.0;

  // ========== Card & Container Sizes ==========
  /// 카드 크기
  static const double cardElevation = 2.0;
  static const double cardElevationHover = 4.0;
  static const double cardElevationPressed = 8.0;
  
  /// 컨테이너 최소/최대 크기
  static const double containerMinHeight = 48.0;
  static const double containerMaxWidth = 400.0; // 모바일 최적화

  // ========== Border Radius ==========
  /// 모서리 둥글기 (Material 3 스타일)
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusCircular = 999.0; // 완전 원형
  
  /// 자주 사용되는 BorderRadius 미리 정의
  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderRadiusSM = BorderRadius.all(Radius.circular(radiusSM));
  static const BorderRadius borderRadiusMD = BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderRadiusLG = BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderRadiusXXL = BorderRadius.all(Radius.circular(radiusXXL));
  static const BorderRadius borderRadiusCircular = BorderRadius.all(Radius.circular(radiusCircular));

  // ========== Divider & Border Sizes ==========
  /// 구분선 두께
  static const double dividerThin = 0.5;
  static const double dividerNormal = 1.0;
  static const double dividerThick = 2.0;
  
  /// 테두리 두께
  static const double borderThin = 1.0;
  static const double borderNormal = 2.0;
  static const double borderThick = 3.0;
  static const double borderFocus = 2.0; // 포커스 상태

  // ========== Business Domain Sizes ==========
  /// 주문 관련 특화 크기
  static const double orderCardHeight = 120.0;
  static const double orderListItemHeight = 80.0;
  static const double productImageSize = 60.0;
  static const double companyLogoSize = 40.0;
  
  /// 요소수 관련 특화 크기
  static const double defContainerIcon = 32.0;
  static const double defQuantityDisplay = 48.0;

  // ========== Screen Breakpoints ==========
  /// 반응형 디자인을 위한 화면 크기 기준점
  static const double mobileBreakpoint = 480.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;
  static const double largeDesktopBreakpoint = 1440.0;

  // ========== Utility Methods ==========
  /// 화면 너비에 따른 적응형 크기 계산
  static double adaptive(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopBreakpoint) {
      return desktop ?? tablet ?? mobile;
    } else if (width >= tabletBreakpoint) {
      return tablet ?? mobile;
    }
    return mobile;
  }
  
  /// 화면 높이의 비율로 크기 계산
  static double screenHeightFraction(BuildContext context, double fraction) {
    return MediaQuery.of(context).size.height * fraction;
  }
  
  /// 화면 너비의 비율로 크기 계산
  static double screenWidthFraction(BuildContext context, double fraction) {
    return MediaQuery.of(context).size.width * fraction;
  }
  
  /// 안전 영역을 고려한 높이 계산
  static double safeAreaHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - 
           mediaQuery.padding.top - 
           mediaQuery.padding.bottom;
  }
  
  /// 키보드를 고려한 높이 계산
  static double availableHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - 
           mediaQuery.padding.top - 
           mediaQuery.padding.bottom - 
           mediaQuery.viewInsets.bottom;
  }
}