import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notice/presentation/screens/notice_list_screen.dart';
import '../../../order/presentation/screens/order_management_screen.dart';
import '../../../history/presentation/screens/order_history_screen.dart';
import '../../../notice/presentation/providers/notice_push_handler.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const OrderManagementScreen(),
    const OrderHistoryScreen(),
    const NoticeListScreen(),
  ];

  final List<String> _titles = [
    '주문 관리',
    '주문 내역',
    '공지사항',
  ];

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    if (kIsWeb) return; // 웹에서는 FCM 초기화하지 않음
    
    final messaging = FirebaseMessaging.instance;
    final pushHandler = ref.read(noticePushHandlerProvider);

    // 권한 요청
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // FCM 토큰 가져오기
      final token = await messaging.getToken();
      if (token != null) {
        await pushHandler.updateFCMToken(token);
      }

      // 토큰 갱신 리스너
      messaging.onTokenRefresh.listen((token) {
        pushHandler.updateFCMToken(token);
      });

      // 포그라운드 메시지 리스너
      FirebaseMessaging.onMessage.listen((message) {
        pushHandler.showInAppNotification(message);
      });

      // 백그라운드에서 앱 열었을 때
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        pushHandler.handleMessage(message);
      });

      // 초기 메시지 처리 (앱이 종료된 상태에서 알림 클릭)
      await pushHandler.handleInitialMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userName = authState.profile?.nickname ?? '사용자';

    return Scaffold(
      appBar: GFAppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).signOut();
            },
          ),
        ],
      ),
      drawer: GFDrawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            GFDrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GFAvatar(
                    size: GFSize.LARGE,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: AppTheme.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    authState.profile?.phoneNumber ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GFListTile(
              titleText: '주문 관리',
              icon: const Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            GFListTile(
              titleText: '주문 내역',
              icon: const Icon(Icons.history),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            GFListTile(
              titleText: '공지사항',
              icon: const Icon(Icons.notifications),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            const Divider(),
            GFListTile(
              titleText: '설정',
              icon: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                // TODO: 설정 화면으로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('설정 화면은 준비 중입니다')),
                );
              },
            ),
            GFListTile(
              titleText: '로그아웃',
              icon: const Icon(Icons.logout),
              onTap: () {
                Navigator.pop(context);
                ref.read(authProvider.notifier).signOut();
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '주문 관리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '주문 내역',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '공지사항',
          ),
        ],
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}