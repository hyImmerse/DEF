import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/widget_extensions.dart';

/// 실시간 연결 상태 표시 위젯
/// 
/// WebSocket 연결 상태를 시각적으로 표시하고 재연결 기능 제공
class RealtimeConnectionIndicator extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onReconnect;

  const RealtimeConnectionIndicator({
    super.key,
    required this.isConnected,
    required this.onReconnect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isConnected ? null : _showConnectionDialog,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isConnected 
              ? Colors.green[50] 
              : Colors.red[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isConnected 
                ? Colors.green[200]! 
                : Colors.red[200]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 연결 상태 아이콘
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isConnected 
                    ? Colors.green[600] 
                    : Colors.red[600],
                shape: BoxShape.circle,
              ),
              child: isConnected
                  ? Container() // 연결된 경우 단순 원
                  : Icon(
                      Icons.close,
                      size: 8,
                      color: Colors.white,
                    ),
            ),
            const SizedBox(width: 6),
            // 연결 상태 텍스트
            (isConnected ? '실시간' : '연결끊김').text
                .size(12)
                .bold
                .color(isConnected 
                    ? Colors.green[700] 
                    : Colors.red[700])
                .make(),
            // 재연결이 필요한 경우 아이콘 표시
            if (!isConnected) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.refresh,
                size: 14,
                color: Colors.red[600],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 연결 상태 다이얼로그 표시
  void _showConnectionDialog() {
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) => RealtimeConnectionDialog(
        isConnected: isConnected,
        onReconnect: onReconnect,
      ),
    );
  }
}

/// 실시간 연결 상태 다이얼로그
class RealtimeConnectionDialog extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onReconnect;

  const RealtimeConnectionDialog({
    super.key,
    required this.isConnected,
    required this.onReconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상태 아이콘
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isConnected 
                    ? Colors.green[100] 
                    : Colors.red[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isConnected 
                    ? Icons.wifi 
                    : Icons.wifi_off,
                size: 40,
                color: isConnected 
                    ? Colors.green[600] 
                    : Colors.red[600],
              ),
            ),

            const SizedBox(height: 20),

            // 연결 상태 제목
            (isConnected ? '실시간 연결 활성' : '실시간 연결 끊김').text
                .size(20)
                .bold
                .color(isConnected 
                    ? Colors.green[700] 
                    : Colors.red[700])
                .makeCentered(),

            const SizedBox(height: 12),

            // 상태 설명
            (isConnected 
                ? '재고 변경사항이 실시간으로 업데이트됩니다.'
                : '네트워크 연결을 확인하고 다시 연결해주세요.').text
                .size(16)
                .gray600
                .align(TextAlign.center)
                .make(),

            const SizedBox(height: 24),

            // 액션 버튼들
            Row(
              children: [
                // 닫기 버튼
                Expanded(
                  child: GFButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: '닫기',
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    size: 48,
                    fullWidthButton: true,
                    color: Colors.grey[200]!,
                    shape: GFButtonShape.pills,
                    type: GFButtonType.solid,
                  ),
                ),
                
                if (!isConnected) ...[
                  const SizedBox(width: 12),
                  // 재연결 버튼
                  Expanded(
                    child: GFButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onReconnect();
                        _showReconnectingSnackBar(context);
                      },
                      text: '재연결',
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      size: 48,
                      fullWidthButton: true,
                      color: Colors.blue[600]!,
                      shape: GFButtonShape.pills,
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 재연결 중 스낵바 표시
  void _showReconnectingSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            '실시간 연결을 재시도하고 있습니다...'.text
                .color(Colors.white)
                .make(),
          ],
        ),
        backgroundColor: Colors.blue[600],
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// 네비게이션 서비스 (간단한 글로벌 네비게이션용)
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

/// 펄스 애니메이션 연결 상태 표시
class PulsingConnectionIndicator extends StatefulWidget {
  final bool isConnected;
  final VoidCallback? onTap;

  const PulsingConnectionIndicator({
    super.key,
    required this.isConnected,
    this.onTap,
  });

  @override
  State<PulsingConnectionIndicator> createState() => 
      _PulsingConnectionIndicatorState();
}

class _PulsingConnectionIndicatorState 
    extends State<PulsingConnectionIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isConnected) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulsingConnectionIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnected != oldWidget.isConnected) {
      if (widget.isConnected) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: widget.isConnected 
                  ? Colors.green[600]!.withOpacity(_animation.value)
                  : Colors.red[600],
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}