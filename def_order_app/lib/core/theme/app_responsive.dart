import 'package:flutter/material.dart';

/// 반응형 디자인을 위한 브레이크포인트 및 유틸리티 시스템
/// 다양한 화면 크기에 대응하는 적응형 레이아웃 지원
class AppResponsive {
  AppResponsive._();

  // ========== Breakpoints ==========
  /// 화면 크기별 브레이크포인트 정의
  static const double mobileSmall = 320.0;   // 최소 모바일
  static const double mobileMedium = 375.0;  // 일반 모바일
  static const double mobileLarge = 414.0;   // 큰 모바일
  static const double tablet = 768.0;        // 태블릿
  static const double desktop = 1024.0;      // 데스크톱
  static const double desktopLarge = 1440.0; // 큰 데스크톱

  // ========== Device Type Detection ==========
  /// 현재 화면 크기를 기반으로 디바이스 타입 반환
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < mobileLarge) {
      return DeviceType.mobile;
    } else if (width < tablet) {
      return DeviceType.mobileLarge;
    } else if (width < desktop) {
      return DeviceType.tablet;
    } else if (width < desktopLarge) {
      return DeviceType.desktop;
    } else {
      return DeviceType.desktopLarge;
    }
  }

  /// 모바일 디바이스 여부 확인
  static bool isMobile(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.mobile || deviceType == DeviceType.mobileLarge;
  }

  /// 태블릿 디바이스 여부 확인
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// 데스크톱 디바이스 여부 확인
  static bool isDesktop(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.desktop || deviceType == DeviceType.desktopLarge;
  }

  /// 특정 브레이크포인트 이상 여부 확인
  static bool isAbove(BuildContext context, double breakpoint) {
    return MediaQuery.of(context).size.width >= breakpoint;
  }

  /// 특정 브레이크포인트 이하 여부 확인
  static bool isBelow(BuildContext context, double breakpoint) {
    return MediaQuery.of(context).size.width < breakpoint;
  }

  // ========== Adaptive Values ==========
  /// 디바이스 타입에 따른 적응형 값 반환
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? mobileLarge,
    T? tablet,
    T? desktop,
    T? desktopLarge,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.mobileLarge:
        return mobileLarge ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobileLarge ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobileLarge ?? mobile;
      case DeviceType.desktopLarge:
        return desktopLarge ?? desktop ?? tablet ?? mobileLarge ?? mobile;
    }
  }

  /// 화면 너비에 따른 연속적인 값 반환 (보간)
  static double interpolate(
    BuildContext context, {
    required double minValue,
    required double maxValue,
    double minBreakpoint = mobileSmall,
    double maxBreakpoint = desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width <= minBreakpoint) return minValue;
    if (width >= maxBreakpoint) return maxValue;
    
    final ratio = (width - minBreakpoint) / (maxBreakpoint - minBreakpoint);
    return minValue + (maxValue - minValue) * ratio;
  }

  // ========== Layout Utilities ==========
  /// 그리드 열 개수 계산
  static int getGridColumns(BuildContext context, {
    int mobileColumns = 1,
    int? mobileLargeColumns,
    int? tabletColumns,
    int? desktopColumns,
    int? desktopLargeColumns,
  }) {
    return value<int>(
      context,
      mobile: mobileColumns,
      mobileLarge: mobileLargeColumns,
      tablet: tabletColumns,
      desktop: desktopColumns,
      desktopLarge: desktopLargeColumns,
    );
  }

  /// 컨테이너 최대 너비 계산
  static double getMaxWidth(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
      case DeviceType.mobileLarge:
        return double.infinity; // 전체 너비 사용
      case DeviceType.tablet:
        return 600.0;
      case DeviceType.desktop:
        return 800.0;
      case DeviceType.desktopLarge:
        return 1200.0;
    }
  }

  /// 사이드바 너비 계산
  static double getSidebarWidth(BuildContext context) {
    if (isMobile(context)) return 280.0; // 모바일에서는 전체 화면 덮는 drawer
    if (isTablet(context)) return 320.0;
    return 280.0; // 데스크톱
  }

  /// 패딩 값 계산
  static EdgeInsets getPadding(BuildContext context, {
    double mobilePadding = 16.0,
    double? mobileLargePadding,
    double? tabletPadding,
    double? desktopPadding,
    double? desktopLargePadding,
  }) {
    final padding = value<double>(
      context,
      mobile: mobilePadding,
      mobileLarge: mobileLargePadding,
      tablet: tabletPadding,
      desktop: desktopPadding,
      desktopLarge: desktopLargePadding,
    );
    
    return EdgeInsets.all(padding);
  }

  /// 수평 패딩만 계산
  static EdgeInsets getHorizontalPadding(BuildContext context, {
    double mobilePadding = 16.0,
    double? mobileLargePadding,
    double? tabletPadding,
    double? desktopPadding,
    double? desktopLargePadding,
  }) {
    final padding = value<double>(
      context,
      mobile: mobilePadding,
      mobileLarge: mobileLargePadding,
      tablet: tabletPadding,
      desktop: desktopPadding,
      desktopLarge: desktopLargePadding,
    );
    
    return EdgeInsets.symmetric(horizontal: padding);
  }

  // ========== Text Scaling ==========
  /// 화면 크기에 따른 텍스트 크기 조정
  static double getTextScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < mobileLarge) {
      return 0.9; // 작은 모바일에서는 약간 작게
    } else if (width < tablet) {
      return 1.0; // 기본 크기
    } else if (width < desktop) {
      return 1.1; // 태블릿에서는 약간 크게
    } else {
      return 1.2; // 데스크톱에서는 더 크게
    }
  }

  /// 적응형 폰트 크기 계산
  static double getAdaptiveFontSize(
    BuildContext context,
    double baseFontSize, {
    double? mobileScale,
    double? tabletScale,
    double? desktopScale,
  }) {
    final deviceType = getDeviceType(context);
    double scale = 1.0;
    
    switch (deviceType) {
      case DeviceType.mobile:
      case DeviceType.mobileLarge:
        scale = mobileScale ?? 1.0;
        break;
      case DeviceType.tablet:
        scale = tabletScale ?? 1.1;
        break;
      case DeviceType.desktop:
      case DeviceType.desktopLarge:
        scale = desktopScale ?? 1.2;
        break;
    }
    
    return baseFontSize * scale;
  }

  // ========== Orientation Utilities ==========
  /// 세로 방향 여부 확인
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// 가로 방향 여부 확인
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// 방향에 따른 값 반환
  static T orientationValue<T>(
    BuildContext context, {
    required T portrait,
    required T landscape,
  }) {
    return isPortrait(context) ? portrait : landscape;
  }

  // ========== Safe Area Utilities ==========
  /// 안전 영역을 고려한 높이
  static double getSafeHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height -
           mediaQuery.padding.top -
           mediaQuery.padding.bottom;
  }

  /// 키보드를 고려한 가용 높이
  static double getAvailableHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height -
           mediaQuery.padding.top -
           mediaQuery.padding.bottom -
           mediaQuery.viewInsets.bottom;
  }

  /// 상단 안전 영역 높이
  static double getTopSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// 하단 안전 영역 높이
  static double getBottomSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  // ========== Layout Builders ==========
  /// 반응형 레이아웃 빌더
  static Widget responsive(
    BuildContext context, {
    required Widget mobile,
    Widget? mobileLarge,
    Widget? tablet,
    Widget? desktop,
    Widget? desktopLarge,
  }) {
    return value<Widget>(
      context,
      mobile: mobile,
      mobileLarge: mobileLarge,
      tablet: tablet,
      desktop: desktop,
      desktopLarge: desktopLarge,
    );
  }

  /// 조건부 위젯 빌더
  static Widget? when(
    BuildContext context, {
    Widget? mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isMobile(context) && mobile != null) return mobile;
    if (isTablet(context) && tablet != null) return tablet;
    if (isDesktop(context) && desktop != null) return desktop;
    return null;
  }

  // ========== Grid Utilities ==========
  /// 반응형 그리드 delegate 생성
  static SliverGridDelegate getGridDelegate(BuildContext context, {
    double childAspectRatio = 1.0,
    double crossAxisSpacing = 8.0,
    double mainAxisSpacing = 8.0,
  }) {
    final columns = getGridColumns(
      context,
      mobileColumns: 1,
      mobileLargeColumns: 2,
      tabletColumns: 3,
      desktopColumns: 4,
      desktopLargeColumns: 5,
    );

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
    );
  }

  /// 반응형 Wrap spacing 계산
  static double getWrapSpacing(BuildContext context) {
    return value<double>(
      context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
    );
  }
}

/// 디바이스 타입 열거형
enum DeviceType {
  mobile,        // < 414dp
  mobileLarge,   // 414dp ~ 767dp
  tablet,        // 768dp ~ 1023dp
  desktop,       // 1024dp ~ 1439dp
  desktopLarge,  // >= 1440dp
}

/// 반응형 빌더 위젯
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    Key? key,
    required this.mobile,
    this.mobileLarge,
    this.tablet,
    this.desktop,
    this.desktopLarge,
  }) : super(key: key);

  final Widget mobile;
  final Widget? mobileLarge;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? desktopLarge;

  @override
  Widget build(BuildContext context) {
    return AppResponsive.responsive(
      context,
      mobile: mobile,
      mobileLarge: mobileLarge,
      tablet: tablet,
      desktop: desktop,
      desktopLarge: desktopLarge,
    );
  }
}

/// 반응형 제약 조건 위젯
class ResponsiveConstraints extends StatelessWidget {
  const ResponsiveConstraints({
    Key? key,
    required this.child,
    this.maxWidth,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final adaptiveMaxWidth = maxWidth ?? AppResponsive.getMaxWidth(context);
    final adaptivePadding = padding ?? AppResponsive.getHorizontalPadding(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: adaptiveMaxWidth),
        child: Padding(
          padding: adaptivePadding,
          child: child,
        ),
      ),
    );
  }
}

/// 반응형 그리드 뷰 위젯
class ResponsiveGridView extends StatelessWidget {
  const ResponsiveGridView({
    Key? key,
    required this.children,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);

  final List<Widget> children;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: AppResponsive.getGridDelegate(
        context,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: children,
    );
  }
}

/// 반응형 Wrap 위젯
class ResponsiveWrap extends StatelessWidget {
  const ResponsiveWrap({
    Key? key,
    required this.children,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.direction = Axis.horizontal,
    this.runAlignment = WrapAlignment.start,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  final List<Widget> children;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;
  final Axis direction;
  final WrapAlignment runAlignment;
  final VerticalDirection verticalDirection;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final spacing = AppResponsive.getWrapSpacing(context);

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      direction: direction,
      runAlignment: runAlignment,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}