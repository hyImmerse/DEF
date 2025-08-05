import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/velocity_x_compat.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/onboarding_provider.dart';
import '../config/onboarding_keys.dart';

/// 사용자 행동 패턴 분석 데이터
class UserBehaviorPattern {
  final String screenId;
  final Map<String, int> elementInteractionCount;
  final Map<String, Duration> elementHoverTime;
  final List<String> navigationPath;
  final DateTime lastInteraction;
  final int totalInteractions;
  final Duration totalTimeSpent;
  
  const UserBehaviorPattern({
    required this.screenId,
    this.elementInteractionCount = const {},
    this.elementHoverTime = const {},
    this.navigationPath = const [],
    required this.lastInteraction,
    this.totalInteractions = 0,
    this.totalTimeSpent = Duration.zero,
  });
  
  UserBehaviorPattern copyWith({
    Map<String, int>? elementInteractionCount,
    Map<String, Duration>? elementHoverTime,
    List<String>? navigationPath,
    DateTime? lastInteraction,
    int? totalInteractions,
    Duration? totalTimeSpent,
  }) {
    return UserBehaviorPattern(
      screenId: screenId,
      elementInteractionCount: elementInteractionCount ?? this.elementInteractionCount,
      elementHoverTime: elementHoverTime ?? this.elementHoverTime,
      navigationPath: navigationPath ?? this.navigationPath,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      totalInteractions: totalInteractions ?? this.totalInteractions,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
    );
  }
}

/// 고급 컨텍스트 인식 툴팁 시스템
/// 
/// - 사용자 행동 패턴 분석
/// - 동적 도움말 생성
/// - 개인화된 가이드 제공
/// - 40-60대 최적화
class AdvancedContextTooltipSystem extends ConsumerStatefulWidget {
  final Widget child;
  final String screenId;
  final Map<GlobalKey, TooltipConfig> tooltipConfigs;
  final Duration baseWaitDuration;
  final bool enabled;
  final Function(UserBehaviorPattern)? onBehaviorAnalyzed;
  
  const AdvancedContextTooltipSystem({
    super.key,
    required this.child,
    required this.screenId,
    required this.tooltipConfigs,
    this.baseWaitDuration = const Duration(seconds: 3),
    this.enabled = true,
    this.onBehaviorAnalyzed,
  });

  @override
  ConsumerState<AdvancedContextTooltipSystem> createState() => 
      _AdvancedContextTooltipSystemState();
}

class _AdvancedContextTooltipSystemState 
    extends ConsumerState<AdvancedContextTooltipSystem> 
    with TickerProviderStateMixin {
  
  // 타이머 및 애니메이션
  Timer? _idleTimer;
  Timer? _behaviorAnalysisTimer;
  OverlayEntry? _tooltipOverlay;
  GlobalKey? _currentTooltipKey;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  
  // 사용자 행동 추적
  DateTime _lastActivity = DateTime.now();
  DateTime _sessionStartTime = DateTime.now();
  bool _isShowingTooltip = false;
  UserBehaviorPattern? _behaviorPattern;
  
  // 컨텍스트 상태
  int _currentStepInProcess = 0;
  Map<String, int> _elementInteractionCount = {};
  Map<String, Duration> _elementHoverTime = {};
  Map<String, DateTime> _elementHoverStart = {};
  List<String> _navigationPath = [];
  
  // 도움말 우선순위
  Map<GlobalKey, double> _tooltipPriority = {};
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserBehaviorPattern();
    
    if (widget.enabled) {
      _startIdleDetection();
      _startBehaviorAnalysis();
    }
  }
  
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }
  
  Future<void> _loadUserBehaviorPattern() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final interactionData = prefs.getString('behavior_${widget.screenId}');
      if (interactionData != null) {
        // 저장된 행동 패턴 로드 (실제 구현에서는 JSON 파싱)
        _behaviorPattern = UserBehaviorPattern(
          screenId: widget.screenId,
          lastInteraction: DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint('행동 패턴 로드 실패: $e');
    }
  }
  
  void _startBehaviorAnalysis() {
    _behaviorAnalysisTimer?.cancel();
    _behaviorAnalysisTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _analyzeUserBehavior();
    });
  }
  
  void _analyzeUserBehavior() {
    // 사용자 행동 패턴 분석
    final totalTimeSpent = DateTime.now().difference(_sessionStartTime);
    
    _behaviorPattern = UserBehaviorPattern(
      screenId: widget.screenId,
      elementInteractionCount: Map.from(_elementInteractionCount),
      elementHoverTime: Map.from(_elementHoverTime),
      navigationPath: List.from(_navigationPath),
      lastInteraction: _lastActivity,
      totalInteractions: _elementInteractionCount.values.fold(0, (a, b) => a + b),
      totalTimeSpent: totalTimeSpent,
    );
    
    // 도움말 우선순위 계산
    _calculateTooltipPriorities();
    
    // 콜백 호출
    widget.onBehaviorAnalyzed?.call(_behaviorPattern!);
    
    // 행동 패턴 저장
    _saveUserBehaviorPattern();
  }
  
  void _calculateTooltipPriorities() {
    _tooltipPriority.clear();
    
    widget.tooltipConfigs.forEach((key, config) {
      double priority = config.basePriority;
      
      // 상호작용이 적은 요소의 우선순위 증가
      final interactionCount = _elementInteractionCount[key.toString()] ?? 0;
      if (interactionCount == 0) {
        priority += 0.3;
      } else if (interactionCount < 3) {
        priority += 0.1;
      }
      
      // 현재 프로세스 단계에 해당하는 요소 우선순위 증가
      if (config.processStep == _currentStepInProcess) {
        priority += 0.5;
      }
      
      // 머뭇거린 시간이 긴 요소 우선순위 증가
      final hoverTime = _elementHoverTime[key.toString()] ?? Duration.zero;
      if (hoverTime > const Duration(seconds: 5)) {
        priority += 0.2;
      }
      
      _tooltipPriority[key] = priority;
    });
  }
  
  Future<void> _saveUserBehaviorPattern() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // 실제 구현에서는 JSON으로 변환하여 저장
      await prefs.setString('behavior_${widget.screenId}', 'pattern_data');
    } catch (e) {
      debugPrint('행동 패턴 저장 실패: $e');
    }
  }
  
  @override
  void dispose() {
    _idleTimer?.cancel();
    _behaviorAnalysisTimer?.cancel();
    _hideTooltip();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  void _startIdleDetection() {
    _idleTimer?.cancel();
    _idleTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!_isShowingTooltip) {
        final idleTime = DateTime.now().difference(_lastActivity);
        final dynamicWaitDuration = _calculateDynamicWaitDuration();
        
        if (idleTime >= dynamicWaitDuration) {
          _showSmartTooltip();
        }
      }
    });
  }
  
  Duration _calculateDynamicWaitDuration() {
    // 사용자 경험에 따라 대기 시간 조정
    Duration waitDuration = widget.baseWaitDuration;
    
    if (_behaviorPattern != null) {
      // 총 상호작용이 많으면 대기 시간 증가 (숙련자)
      if (_behaviorPattern!.totalInteractions > 20) {
        waitDuration += const Duration(seconds: 2);
      }
      
      // 처음 사용하는 요소에서는 대기 시간 감소
      final currentElement = _findCurrentHoveredElement();
      if (currentElement != null) {
        final interactionCount = _elementInteractionCount[currentElement.toString()] ?? 0;
        if (interactionCount == 0) {
          waitDuration -= const Duration(seconds: 1);
        }
      }
    }
    
    return waitDuration;
  }
  
  GlobalKey? _findCurrentHoveredElement() {
    // 현재 마우스/터치 위치에 있는 요소 찾기
    for (final entry in widget.tooltipConfigs.entries) {
      final key = entry.key;
      final context = key.currentContext;
      if (context != null) {
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          // 실제 구현에서는 마우스/터치 위치와 비교
          return key;
        }
      }
    }
    return null;
  }
  
  void _resetIdleTimer() {
    _lastActivity = DateTime.now();
    if (_isShowingTooltip) {
      _hideTooltip();
    }
  }
  
  void _trackElementInteraction(GlobalKey key) {
    final keyString = key.toString();
    _elementInteractionCount[keyString] = (_elementInteractionCount[keyString] ?? 0) + 1;
    _navigationPath.add(keyString);
    
    // 네비게이션 경로 길이 제한
    if (_navigationPath.length > 20) {
      _navigationPath.removeAt(0);
    }
  }
  
  void _trackElementHover(GlobalKey key, bool isHovering) {
    final keyString = key.toString();
    
    if (isHovering) {
      _elementHoverStart[keyString] = DateTime.now();
    } else {
      final startTime = _elementHoverStart[keyString];
      if (startTime != null) {
        final duration = DateTime.now().difference(startTime);
        _elementHoverTime[keyString] = 
            (_elementHoverTime[keyString] ?? Duration.zero) + duration;
        _elementHoverStart.remove(keyString);
      }
    }
  }
  
  void _showSmartTooltip() {
    // 온보딩 완료 확인
    final onboardingState = ref.read(onboardingProvider);
    if (onboardingState.isScreenCompleted(widget.screenId)) {
      return;
    }
    
    // 우선순위가 가장 높은 툴팁 선택
    final targetKey = _selectBestTooltip();
    if (targetKey == null || !widget.tooltipConfigs.containsKey(targetKey)) {
      return;
    }
    
    final config = widget.tooltipConfigs[targetKey]!;
    _currentTooltipKey = targetKey;
    _isShowingTooltip = true;
    
    final RenderBox? renderBox = targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    
    // 동적 툴팁 내용 생성
    final dynamicContent = _generateDynamicTooltipContent(targetKey, config);
    
    _tooltipOverlay = OverlayEntry(
      builder: (context) => _buildAdvancedTooltip(
        context,
        offset,
        size,
        dynamicContent,
        config,
      ),
    );
    
    Overlay.of(context).insert(_tooltipOverlay!);
    _animationController.forward();
  }
  
  GlobalKey? _selectBestTooltip() {
    if (_tooltipPriority.isEmpty) {
      _calculateTooltipPriorities();
    }
    
    // 화면에 보이는 요소 중 우선순위가 가장 높은 것 선택
    GlobalKey? bestKey;
    double highestPriority = -1;
    
    for (final entry in _tooltipPriority.entries) {
      final key = entry.key;
      final priority = entry.value;
      
      if (_isElementVisible(key) && priority > highestPriority) {
        highestPriority = priority;
        bestKey = key;
      }
    }
    
    return bestKey;
  }
  
  bool _isElementVisible(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return false;
    
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return false;
    
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;
    
    return offset.dx >= 0 && 
           offset.dy >= 0 && 
           offset.dx < screenSize.width && 
           offset.dy < screenSize.height;
  }
  
  String _generateDynamicTooltipContent(GlobalKey key, TooltipConfig config) {
    String content = config.baseContent;
    
    // 사용자 행동에 따른 동적 내용 추가
    final interactionCount = _elementInteractionCount[key.toString()] ?? 0;
    
    if (interactionCount == 0) {
      content = '💡 처음이신가요?\n\n$content';
    } else if (interactionCount > 5) {
      // 자주 사용하는 기능에 대한 고급 팁
      if (config.advancedTip != null) {
        content = '💡 고급 팁\n\n${config.advancedTip}';
      }
    }
    
    // 현재 단계에 맞는 추가 정보
    if (_currentStepInProcess > 0 && config.contextualHints.isNotEmpty) {
      final hint = config.contextualHints[_currentStepInProcess % config.contextualHints.length];
      content += '\n\n📌 $hint';
    }
    
    return content;
  }
  
  void _hideTooltip() {
    if (_tooltipOverlay != null) {
      _animationController.reverse().then((_) {
        _tooltipOverlay?.remove();
        _tooltipOverlay = null;
        _isShowingTooltip = false;
        _currentTooltipKey = null;
      });
    }
  }
  
  Widget _buildAdvancedTooltip(
    BuildContext context,
    Offset targetOffset,
    Size targetSize,
    String content,
    TooltipConfig config,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final tooltipWidth = screenSize.width * 0.85;
    final tooltipMaxHeight = 280.0;
    
    // 툴팁 위치 계산 (타겟 위 또는 아래)
    final showAbove = targetOffset.dy > screenSize.height / 2;
    final tooltipTop = showAbove
        ? targetOffset.dy - tooltipMaxHeight - 20
        : targetOffset.dy + targetSize.height + 20;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_animationController, _pulseController]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              children: [
                // 반투명 배경
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _hideTooltip,
                    child: Container(
                      color: Colors.black.withOpacity(0.4 * _fadeAnimation.value),
                    ),
                  ),
                ),
                
                // 타겟 하이라이트 (펄스 효과)
                Positioned(
                  left: targetOffset.dx - 15,
                  top: targetOffset.dy - 15,
                  child: Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: targetSize.width + 30,
                      height: targetSize.height + 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: config.highlightColor ?? AppTheme.primaryColor,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: (config.highlightColor ?? AppTheme.primaryColor)
                                .withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // 툴팁 말풍선
                Positioned(
                  left: (screenSize.width - tooltipWidth) / 2,
                  top: tooltipTop,
                  child: GestureDetector(
                    onTap: _hideTooltip,
                    child: Container(
                      width: tooltipWidth,
                      constraints: BoxConstraints(
                        maxHeight: tooltipMaxHeight,
                      ),
                      child: _buildAdvancedTooltipBubble(content, config, showAbove),
                    ),
                  ),
                ),
                
                // 화살표
                Positioned(
                  left: targetOffset.dx + targetSize.width / 2 - 20,
                  top: showAbove
                      ? targetOffset.dy - 40
                      : targetOffset.dy + targetSize.height + 5,
                  child: CustomPaint(
                    size: const Size(40, 20),
                    painter: _AnimatedTrianglePainter(
                      color: Colors.white,
                      isUpward: showAbove,
                      animationValue: _pulseAnimation.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildAdvancedTooltipBubble(String text, TooltipConfig config, bool showAbove) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (config.iconColor ?? Colors.orange).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        config.icon ?? Icons.lightbulb_outline,
                        color: config.iconColor ?? Colors.orange,
                        size: 32,
                      ),
                    ),
                    16.widthBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (config.title ?? '도움말').text
                              .size(22)
                              .fontWeight(FontWeight.bold)
                              .color(AppTheme.primaryColor)
                              .make(),
                          if (config.subtitle != null) ...[
                            4.heightBox,
                            config.subtitle!.text
                                .size(14)
                                .color(Colors.grey[600])
                                .make(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _hideTooltip,
                icon: Icon(
                  Icons.close,
                  color: Colors.grey[600],
                  size: 28,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          
          20.heightBox,
          
          text.text
              .size(20)
              .color(Colors.black87)
              .lineHeight(1.6)
              .make(),
          
          if (config.actions.isNotEmpty) ...[
            24.heightBox,
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: config.actions.map((action) => 
                GFButton(
                  onPressed: () {
                    action.onPressed();
                    _hideTooltip();
                  },
                  text: action.label,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: action.isPrimary ? Colors.white : AppTheme.primaryColor,
                  ),
                  color: action.isPrimary ? AppTheme.primaryColor : Colors.white,
                  size: GFSize.MEDIUM,
                  shape: GFButtonShape.pills,
                  borderShape: action.isPrimary ? null : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ).toList(),
            ),
          ],
          
          20.heightBox,
          
          Row(
            children: [
              Icon(
                Icons.touch_app,
                color: Colors.grey[500],
                size: 20,
              ),
              8.widthBox,
              '화면을 터치하면 사라집니다'.text
                  .size(14)
                  .color(Colors.grey[600])
                  .italic
                  .make(),
            ],
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _resetIdleTimer(),
      onExit: (_) => _resetIdleTimer(),
      child: GestureDetector(
        onTap: _resetIdleTimer,
        onPanUpdate: (_) => _resetIdleTimer(),
        onPanEnd: (_) => _resetIdleTimer(),
        child: widget.child,
      ),
    );
  }
}

/// 툴팁 설정
class TooltipConfig {
  final String baseContent;
  final String? advancedTip;
  final List<String> contextualHints;
  final double basePriority;
  final int processStep;
  final IconData? icon;
  final Color? iconColor;
  final String? title;
  final String? subtitle;
  final Color? highlightColor;
  final List<TooltipAction> actions;
  
  const TooltipConfig({
    required this.baseContent,
    this.advancedTip,
    this.contextualHints = const [],
    this.basePriority = 0.5,
    this.processStep = 0,
    this.icon,
    this.iconColor,
    this.title,
    this.subtitle,
    this.highlightColor,
    this.actions = const [],
  });
}

/// 툴팁 액션
class TooltipAction {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  
  const TooltipAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });
}

/// 애니메이션 삼각형 페인터
class _AnimatedTrianglePainter extends CustomPainter {
  final Color color;
  final bool isUpward;
  final double animationValue;
  
  _AnimatedTrianglePainter({
    required this.color,
    required this.isUpward,
    required this.animationValue,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    final scale = 0.9 + (animationValue - 1.0) * 0.5;
    final scaledSize = Size(size.width * scale, size.height * scale);
    final offset = Offset((size.width - scaledSize.width) / 2, 0);
    
    if (isUpward) {
      path.moveTo(size.width / 2, offset.dy);
      path.lineTo(offset.dx, scaledSize.height);
      path.lineTo(offset.dx + scaledSize.width, scaledSize.height);
    } else {
      path.moveTo(offset.dx, 0);
      path.lineTo(offset.dx + scaledSize.width, 0);
      path.lineTo(size.width / 2, scaledSize.height);
    }
    
    path.close();
    canvas.drawPath(path, paint);
    
    // 그림자 효과
    canvas.drawShadow(path, Colors.black.withOpacity(0.2), 5, false);
  }
  
  @override
  bool shouldRepaint(covariant _AnimatedTrianglePainter oldDelegate) {
    return color != oldDelegate.color || 
           isUpward != oldDelegate.isUpward ||
           animationValue != oldDelegate.animationValue;
  }
}