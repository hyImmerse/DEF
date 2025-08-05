import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/onboarding_provider.dart';
import '../config/onboarding_keys.dart';

/// 스마트 툴팁 시스템
/// 
/// 3초 대기 감지, 40-60대 최적화 큰 글씨
/// 사용자가 화면에서 3초 이상 멈춰있으면 자동으로 도움말 표시
class SmartTooltipSystem extends ConsumerStatefulWidget {
  final Widget child;
  final String screenId;
  final Map<GlobalKey, String> tooltipMap;
  final Duration waitDuration;
  final bool enabled;
  
  const SmartTooltipSystem({
    super.key,
    required this.child,
    required this.screenId,
    required this.tooltipMap,
    this.waitDuration = const Duration(seconds: 3),
    this.enabled = true,
  });

  @override
  ConsumerState<SmartTooltipSystem> createState() => _SmartTooltipSystemState();
}

class _SmartTooltipSystemState extends ConsumerState<SmartTooltipSystem> 
    with SingleTickerProviderStateMixin {
  Timer? _idleTimer;
  OverlayEntry? _tooltipOverlay;
  GlobalKey? _currentTooltipKey;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  // 사용자 활동 추적
  DateTime _lastActivity = DateTime.now();
  bool _isShowingTooltip = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    if (widget.enabled) {
      _startIdleDetection();
    }
  }
  
  @override
  void dispose() {
    _idleTimer?.cancel();
    _hideTooltip();
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(SmartTooltipSystem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _startIdleDetection();
      } else {
        _stopIdleDetection();
      }
    }
  }
  
  void _startIdleDetection() {
    _idleTimer?.cancel();
    _idleTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!_isShowingTooltip && 
          DateTime.now().difference(_lastActivity) >= widget.waitDuration) {
        _showSmartTooltip();
      }
    });
  }
  
  void _stopIdleDetection() {
    _idleTimer?.cancel();
    _hideTooltip();
  }
  
  void _resetIdleTimer() {
    _lastActivity = DateTime.now();
    if (_isShowingTooltip) {
      _hideTooltip();
    }
  }
  
  void _showSmartTooltip() {
    // 온보딩이 완료되었는지 확인
    final onboardingState = ref.read(onboardingProvider);
    if (onboardingState.isScreenCompleted(widget.screenId)) {
      return; // 온보딩이 완료된 화면에서는 스마트 툴팁 표시 안함
    }
    
    // 현재 화면에서 표시할 툴팁 찾기
    final targetKey = _findVisibleTargetKey();
    if (targetKey == null || !widget.tooltipMap.containsKey(targetKey)) {
      return;
    }
    
    _currentTooltipKey = targetKey;
    _isShowingTooltip = true;
    
    final RenderBox? renderBox = targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    
    _tooltipOverlay = OverlayEntry(
      builder: (context) => _buildTooltip(
        context,
        offset,
        size,
        widget.tooltipMap[targetKey]!,
      ),
    );
    
    Overlay.of(context).insert(_tooltipOverlay!);
    _animationController.forward();
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
  
  GlobalKey? _findVisibleTargetKey() {
    // 화면에 표시되고 있는 키 중 첫 번째 것을 찾기
    for (final key in widget.tooltipMap.keys) {
      final context = key.currentContext;
      if (context != null) {
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          final offset = renderBox.localToGlobal(Offset.zero);
          final screenSize = MediaQuery.of(context).size;
          
          // 화면 안에 있는지 확인
          if (offset.dx >= 0 && 
              offset.dy >= 0 && 
              offset.dx < screenSize.width && 
              offset.dy < screenSize.height) {
            return key;
          }
        }
      }
    }
    return null;
  }
  
  Widget _buildTooltip(
    BuildContext context,
    Offset targetOffset,
    Size targetSize,
    String tooltipText,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final tooltipWidth = screenSize.width * 0.8;
    final tooltipMaxHeight = 200.0;
    
    // 툴팁 위치 계산 (타겟 위 또는 아래)
    final showAbove = targetOffset.dy > screenSize.height / 2;
    final tooltipTop = showAbove
        ? targetOffset.dy - tooltipMaxHeight - 20
        : targetOffset.dy + targetSize.height + 20;
    
    return AnimatedBuilder(
      animation: _animationController,
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
                      color: Colors.black.withOpacity(0.3 * _fadeAnimation.value),
                    ),
                  ),
                ),
                
                // 타겟 하이라이트
                Positioned(
                  left: targetOffset.dx - 10,
                  top: targetOffset.dy - 10,
                  child: Container(
                    width: targetSize.width + 20,
                    height: targetSize.height + 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.1),
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
                      child: _buildTooltipBubble(tooltipText, showAbove),
                    ),
                  ),
                ),
                
                // 화살표
                Positioned(
                  left: targetOffset.dx + targetSize.width / 2 - 15,
                  top: showAbove
                      ? targetOffset.dy - 35
                      : targetOffset.dy + targetSize.height + 5,
                  child: CustomPaint(
                    size: const Size(30, 15),
                    painter: _TrianglePainter(
                      color: Colors.white,
                      isUpward: showAbove,
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
  
  Widget _buildTooltipBubble(String text, bool showAbove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.orange,
                      size: 28,
                    ),
                    12.widthBox,
                    '도움말'.text
                        .size(20)
                        .fontWeight(FontWeight.bold)
                        .color(AppTheme.primaryColor)
                        .make(),
                  ],
                ),
              ),
              IconButton(
                onPressed: _hideTooltip,
                icon: Icon(
                  Icons.close,
                  color: Colors.grey[600],
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          
          12.heightBox,
          
          text.text
              .size(18)
              .color(Colors.black87)
              .lineHeight(1.5)
              .make(),
          
          16.heightBox,
          
          '화면을 터치하면 사라집니다'.text
              .size(14)
              .color(Colors.grey[600])
              .italic
              .make(),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetIdleTimer,
      onPanUpdate: (_) => _resetIdleTimer(),
      onPanEnd: (_) => _resetIdleTimer(),
      child: widget.child,
    );
  }
}

/// 삼각형 화살표 페인터
class _TrianglePainter extends CustomPainter {
  final Color color;
  final bool isUpward;
  
  _TrianglePainter({
    required this.color,
    required this.isUpward,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    
    if (isUpward) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    }
    
    path.close();
    canvas.drawPath(path, paint);
    
    // 그림자 효과
    canvas.drawShadow(path, Colors.black.withOpacity(0.2), 3, false);
  }
  
  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return color != oldDelegate.color || isUpward != oldDelegate.isUpward;
  }
}

/// 주문 화면용 스마트 툴팁 래퍼
class OrderSmartTooltips extends StatelessWidget {
  final Widget child;
  
  const OrderSmartTooltips({
    super.key,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return SmartTooltipSystem(
      screenId: OnboardingScreenType.orderCreate.id,
      tooltipMap: {
        OnboardingKeys.instance.orderProductSelectionKey: 
          '제품 종류를 선택하세요.\n박스는 소량 주문, 벌크는 대량 주문에 적합합니다.',
        OnboardingKeys.instance.orderQuantityInputKey: 
          '필요한 수량을 입력하세요.\n숫자만 입력 가능합니다.',
        OnboardingKeys.instance.orderDeliveryInfoKey: 
          '배송 날짜와 주소를 확인하세요.\n변경이 필요하면 수정할 수 있습니다.',
        OnboardingKeys.instance.orderSubmitButtonKey: 
          '모든 정보를 확인한 후\n이 버튼을 눌러 주문을 완료하세요.',
      },
      child: child,
    );
  }
}