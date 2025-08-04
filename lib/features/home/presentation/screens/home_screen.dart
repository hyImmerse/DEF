import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import '../../../auth/data/services/auth_service.dart';
import '../../../auth/data/providers/demo_auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final user = authService.currentUser;
    final demoState = ref.watch(demoAuthProvider);

    return Scaffold(
      appBar: AppBar(
        title: "DEF 요소수".text.make(),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: 알림 화면으로 이동
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await authService.signOut();
                if (demoState.isDemoMode) {
                  ref.read(demoAuthProvider.notifier).logout();
                }
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('내 정보'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('설정'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Text('로그아웃'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 환영 메시지
            if (user != null) ...[
              GFCard(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "환영합니다!"
                        .text
                        .xl2
                        .bold
                        .color(Theme.of(context).primaryColor)
                        .make(),
                    const SizedBox(height: 8),
                    "${user.companyName} 님"
                        .text
                        .xl3
                        .bold
                        .make(),
                    const SizedBox(height: 4),
                    user.grade == 'dealer'
                        ? GFBadge(
                            text: "대리점",
                            color: GFColors.SUCCESS,
                            size: GFSize.LARGE,
                          )
                        : GFBadge(
                            text: "일반 거래처",
                            color: GFColors.INFO,
                            size: GFSize.LARGE,
                          ),
                    if (demoState.isDemoMode) ...[
                      const SizedBox(height: 8),
                      GFBadge(
                        text: "데모 모드",
                        color: GFColors.WARNING,
                        size: GFSize.MEDIUM,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 빠른 메뉴
            "빠른 메뉴".text.xl2.bold.make(),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildQuickMenuItem(
                  context,
                  icon: Icons.add_shopping_cart,
                  title: "새 주문",
                  subtitle: "요소수 주문하기",
                  color: Colors.blue,
                  onTap: () {
                    // TODO: 주문 화면으로 이동
                  },
                ),
                _buildQuickMenuItem(
                  context,
                  icon: Icons.history,
                  title: "주문 내역",
                  subtitle: "지난 주문 확인",
                  color: Colors.green,
                  onTap: () {
                    // TODO: 주문 내역 화면으로 이동
                  },
                ),
                _buildQuickMenuItem(
                  context,
                  icon: Icons.inventory,
                  title: "재고 현황",
                  subtitle: "실시간 재고 확인",
                  color: Colors.orange,
                  onTap: () {
                    // TODO: 재고 현황 화면으로 이동
                  },
                ),
                _buildQuickMenuItem(
                  context,
                  icon: Icons.description,
                  title: "거래명세서",
                  subtitle: "명세서 조회",
                  color: Colors.purple,
                  onTap: () {
                    // TODO: 거래명세서 화면으로 이동
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 공지사항
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "공지사항".text.xl2.bold.make(),
                TextButton(
                  onPressed: () {
                    // TODO: 공지사항 목록으로 이동
                  },
                  child: "전체보기".text.lg.color(Theme.of(context).primaryColor).make(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNoticeItem(
              context,
              title: "[긴급] 12월 배송 일정 안내",
              date: "2025-08-03",
              isImportant: true,
            ),
            _buildNoticeItem(
              context,
              title: "요소수 가격 인상 안내",
              date: "2025-08-02",
            ),
            _buildNoticeItem(
              context,
              title: "시스템 점검 안내",
              date: "2025-08-01",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '주문내역',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: '재고',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내정보',
          ),
        ],
        onTap: (index) {
          // TODO: 네비게이션 처리
        },
      ),
    );
  }

  Widget _buildQuickMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GFCard(
      elevation: 4,
      boxFit: BoxFit.cover,
      content: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            title.text.lg.bold.make(),
            const SizedBox(height: 4),
            subtitle.text.sm.gray600.make(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeItem(
    BuildContext context, {
    required String title,
    required String date,
    bool isImportant = false,
  }) {
    return GFListTile(
      titleText: title,
      subTitleText: date,
      icon: isImportant
          ? const Icon(Icons.priority_high, color: Colors.red)
          : const Icon(Icons.info_outline, color: Colors.grey),
      padding: const EdgeInsets.symmetric(vertical: 8),
      onTap: () {
        // TODO: 공지사항 상세 보기
      },
    );
  }
}