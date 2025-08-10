import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/utils/velocity_x_compat.dart'; // VelocityX 호환성 레이어
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notice/presentation/screens/enhanced_notice_list_screen.dart';
import '../../../order/presentation/screens/enhanced_order_list_screen.dart';
import '../../../order/presentation/screens/enhanced_order_create_screen.dart';
import '../../../order/presentation/screens/enhanced_order_registration_screen.dart';
import '../../../order/presentation/screens/order_detail_screen.dart';
import '../../../order/presentation/providers/order_provider.dart';
import '../../../order/data/models/order_model.dart';
import '../../../history/presentation/screens/order_history_screen.dart';
import '../../../notice/presentation/providers/notice_push_handler.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';
import '../../../onboarding/presentation/config/onboarding_keys.dart';
import '../../../onboarding/presentation/widgets/senior_friendly_showcase.dart';
import '../../../onboarding/presentation/widgets/onboarding_completion_widget.dart' as completion;
import '../../../onboarding/domain/entities/onboarding_entity.dart';
import 'package:intl/intl.dart';

/// 40-60대 사용자를 위한 Enhanced 홈 화면 with 온보딩
/// 
/// 특징:
/// - ShowcaseView 통합 온보딩 시스템
/// - 40-60대 친화적 UI/UX
/// - 큰 글씨, 명확한 네비게이션
/// - 단계별 사용법 안내
class EnhancedHomeScreen extends ConsumerStatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  ConsumerState<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends ConsumerState<EnhancedHomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _orderScrollController = ScrollController();
  
  // 현재 선택된 필터
  OrderStatus? _selectedStatus;

  final List<Widget> _screens = [
    const EnhancedOrderListScreen(),
    const OrderHistoryScreen(),
    const EnhancedNoticeListScreen(),
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
    _checkAndStartOnboarding();
    _orderScrollController.addListener(_onOrderScroll);
    
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderListProvider.notifier).loadOrders(refresh: true);
    });
  }

  @override
  void dispose() {
    _orderScrollController.dispose();
    super.dispose();
  }
  
  void _onOrderScroll() {
    if (_orderScrollController.position.pixels >=
        _orderScrollController.position.maxScrollExtent - 200) {
      final orderListState = ref.read(orderListProvider);
      if (orderListState.hasMore && !orderListState.isLoading) {
        ref.read(orderListProvider.notifier).loadOrders();
      }
    }
  }

  /// FCM 초기화
  Future<void> _initializeFCM() async {
    if (kIsWeb) return;
    
    final messaging = FirebaseMessaging.instance;
    final pushHandler = ref.read(noticePushHandlerProvider);

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      if (token != null) {
        await pushHandler.updateFCMToken(token);
      }

      messaging.onTokenRefresh.listen((token) {
        pushHandler.updateFCMToken(token);
      });

      FirebaseMessaging.onMessage.listen((message) {
        pushHandler.showInAppNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        pushHandler.handleMessage(message);
      });

      await pushHandler.handleInitialMessage();
    }
  }

  /// 온보딩 필요 여부 확인 및 시작
  void _checkAndStartOnboarding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final onboardingState = ref.read(onboardingProvider);
      final needsOnboarding = ref.read(needsOnboardingProvider);
      
      if (needsOnboarding && !onboardingState.isShowcasing) {
        _startHomeOnboarding();
      }
    });
  }

  /// 홈 화면 온보딩 시작
  void _startHomeOnboarding() {
    final steps = OnboardingSteps.getHomeSteps();
    ref.read(onboardingProvider.notifier).setCurrentScreen(
      OnboardingScreenType.home.id,
      steps,
    );
    
    // ShowcaseView 시작
    final keys = [
      OnboardingKeys.instance.homeWelcomeKey,
      OnboardingKeys.instance.homeNewOrderButtonKey,
      OnboardingKeys.instance.homeOrderStatsKey,
      OnboardingKeys.instance.homeInventoryKey,
      OnboardingKeys.instance.homeBottomNavKey,
    ];
    
    ShowCaseWidget.of(context).startShowCase(keys);
    ref.read(onboardingProvider.notifier).startOnboarding();
  }

  /// 온보딩 다음 단계
  void _onOnboardingNext() {
    final onboardingState = ref.read(onboardingProvider);
    final currentStepIndex = onboardingState.currentStepIndex;
    final totalSteps = onboardingState.currentSteps.length;
    
    if (currentStepIndex < totalSteps - 1) {
      ref.read(onboardingProvider.notifier).nextStep();
    } else {
      _completeOnboarding();
    }
  }

  /// 온보딩 완료
  void _completeOnboarding() {
    ref.read(onboardingProvider.notifier).completeCurrentScreenOnboarding();
    
    // 완료 축하 다이얼로그 표시
    _showOnboardingCompletionDialog();
  }

  /// 온보딩 건너뛰기
  void _onOnboardingSkip() {
    ref.read(onboardingProvider.notifier).skipOnboarding();
  }

  /// 온보딩 완료 다이얼로그
  void _showOnboardingCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: completion.OnboardingCompletionWidget(
          screenName: '홈 화면',
          onDismiss: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final onboardingState = ref.watch(onboardingProvider);
    final userName = authState.profile?.representativeName ?? '사용자';

    return ShowCaseWidget(
      builder: (context) => Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey[50],
          appBar: _buildAppBar(userName),
          drawer: _buildDrawer(userName, authState),
          body: Column(
            children: [
              // 온보딩 진행률 표시 (온보딩 중일 때만)
              if (onboardingState.isShowcasing)
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: completion.OnboardingProgressIndicator(
                    currentStep: onboardingState.currentStepIndex,
                    totalSteps: onboardingState.currentSteps.length,
                  ).centered(),
                ),
              
              // 메인 콘텐츠
              Expanded(
                child: _buildMainContent(),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigation(),
          floatingActionButton: _buildFloatingActionButton(),
        ),
    );
  }

  /// 앱바 빌드
  PreferredSizeWidget _buildAppBar(String userName) {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: SeniorFriendlyShowcase(
        key: GlobalKey(),
        showcaseKey: OnboardingKeys.instance.homeWelcomeKey,
        step: OnboardingSteps.getHomeSteps()[0],
        onNext: _onOnboardingNext,
        onSkip: _onOnboardingSkip,
        child: Row(
          children: [
            '$userName님, 안녕하세요! 👋'
                .text
                .size(20)
                .fontWeight(FontWeight.bold)
                .color(Colors.white)
                .make(),
          ],
        ),
      ),
      actions: [
        // 온보딩 다시 시작 버튼 (개발용)
        if (kDebugMode)
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: _startHomeOnboarding,
            tooltip: '온보딩 다시 시작',
          ),
        
        // 로그아웃 버튼
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white, size: 28),
          onPressed: () {
            ref.read(authProvider.notifier).signOut();
          },
          tooltip: '로그아웃',
        ),
      ],
    );
  }

  /// 드로어 빌드
  Widget _buildDrawer(String userName, dynamic authState) {
    return Drawer(
      child: Column(
        children: [
          // 드로어 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.primaryColor,
                    size: 40,
                  ),
                ),
                16.heightBox,
                userName.text
                    .size(22)
                    .fontWeight(FontWeight.bold)
                    .color(Colors.white)
                    .make(),
                8.heightBox,
                Text(
                  authState.profile?.phone ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          // 메뉴 항목들
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.shopping_cart,
                  title: '주문 관리',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 0);
                  },
                  isSelected: _selectedIndex == 0,
                ),
                _buildDrawerItem(
                  icon: Icons.history,
                  title: '주문 내역',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 1);
                  },
                  isSelected: _selectedIndex == 1,
                ),
                _buildDrawerItem(
                  icon: Icons.notifications,
                  title: '공지사항',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 2);
                  },
                  isSelected: _selectedIndex == 2,
                ),
                const Divider(thickness: 1),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: '설정',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: '설정 화면은 준비 중입니다'.text.make(),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline,
                  title: '도움말',
                  onTap: () {
                    Navigator.pop(context);
                    _startHomeOnboarding();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 드로어 항목 빌드
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
          size: 28,
        ),
        title: title.text
            .size(18)
            .color(isSelected ? AppTheme.primaryColor : Colors.grey[800])
            .fontWeight(isSelected ? FontWeight.w600 : FontWeight.normal)
            .make(),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  /// 메인 콘텐츠 빌드
  Widget _buildMainContent() {
    // 선택된 화면에 따라 온보딩 적용
    Widget currentScreen = _screens[_selectedIndex];
    
    // 주문 관리 화면인 경우 추가 온보딩 적용
    if (_selectedIndex == 0) {
      currentScreen = CustomScrollView(
        slivers: [
          // 새 주문 버튼 (온보딩 대상) - 강화된 하이라이트
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            child: Column(
              children: [
                // 온보딩 중일 때 추가 안내 텍스트
                if (ref.watch(onboardingProvider).isShowcasing)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.tips_and_updates,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                        8.widthBox,
                        Expanded(
                          child: '여기를 눌러 새로운 주문을 시작하세요!'
                              .text
                              .size(16)
                              .color(AppTheme.primaryColor)
                              .fontWeight(FontWeight.w600)
                              .make(),
                        ),
                      ],
                    ),
                  ),
                
                // 메인 버튼 - FloatingActionButton 스타일로 통일
                SeniorFriendlyShowcase(
                  key: GlobalKey(),
                  showcaseKey: OnboardingKeys.instance.homeNewOrderButtonKey,
                  step: OnboardingSteps.getHomeSteps()[1],
                  onNext: _onOnboardingNext,
                  onSkip: _onOnboardingSkip,
                  showPrevious: true,
                  onPrevious: () => ref.read(onboardingProvider.notifier).previousStep(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56, // 표준 버튼 높이
                      child: FloatingActionButton.extended(
                        heroTag: "main_order_button", // 고유 heroTag 추가
                        onPressed: () {
                          // 주문 등록 화면으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EnhancedOrderCreateScreen(),
                            ),
                          );
                        },
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        highlightElevation: 8,
                        hoverElevation: 6,
                        extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 24,
                          ),
                        ),
                        label: const Text(
                          '새 주문 등록하기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // 온보딩 중일 때 애니메이션 힌트
                if (ref.watch(onboardingProvider).isShowcasing)
                  Column(
                    children: [
                      12.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                          ).pSymmetric(h: 2),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                          ).pSymmetric(h: 2),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                          ).pSymmetric(h: 2),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          ),
          
          // 주문 현황 통계 (온보딩 대상)
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SeniorFriendlyShowcase(
                key: GlobalKey(),
                showcaseKey: OnboardingKeys.instance.homeOrderStatsKey,
                step: OnboardingSteps.getHomeSteps()[2],
                onNext: _onOnboardingNext,
                onSkip: _onOnboardingSkip,
                showPrevious: true,
                onPrevious: () => ref.read(onboardingProvider.notifier).previousStep(),
                child: _buildOrderStatsCard(),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: 8.heightBox,
          ),
          
          // 실시간 재고 현황 (온보딩 대상)
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SeniorFriendlyShowcase(
                key: GlobalKey(),
                showcaseKey: OnboardingKeys.instance.homeInventoryKey,
                step: OnboardingSteps.getHomeSteps()[3],
                onNext: _onOnboardingNext,
                onSkip: _onOnboardingSkip,
                showPrevious: true,
                onPrevious: () => ref.read(onboardingProvider.notifier).previousStep(),
                child: _buildInventoryCard(),
              ),
            ),
          ),
          
          // 나머지 주문 목록을 위한 플레이스홀더
          _buildOrderListContent(),
        ],
      );
    }
    
    return currentScreen;
  }

  /// 주문 통계 카드
  Widget _buildOrderStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '이번 달 주문 현황 📊'
              .text
              .size(18)
              .fontWeight(FontWeight.bold)
              .color(Colors.black87)
              .make(),
          16.heightBox,
          Row(
            children: [
              Expanded(
                child: _buildStatItem('대기중', '3건', Colors.orange),
              ),
              Expanded(
                child: _buildStatItem('확정됨', '12건', Colors.blue),
              ),
              Expanded(
                child: _buildStatItem('완료됨', '28건', Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 통계 항목
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        value.text
            .size(20)
            .fontWeight(FontWeight.bold)
            .color(color)
            .make(),
        4.heightBox,
        label.text
            .size(14)
            .color(Colors.grey[600])
            .make(),
      ],
    );
  }

  /// 재고 현황 카드
  Widget _buildInventoryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '실시간 재고 현황 📦'
              .text
              .size(18)
              .fontWeight(FontWeight.bold)
              .color(Colors.black87)
              .make(),
          16.heightBox,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '박스 (20L)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '1,250개',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '벌크 (대용량)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '89개',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 하단 네비게이션 빌드
  Widget _buildBottomNavigation() {
    return SeniorFriendlyShowcase(
      key: GlobalKey(),
      showcaseKey: OnboardingKeys.instance.homeBottomNavKey,
      step: OnboardingSteps.getHomeSteps()[4],
      onNext: _onOnboardingNext,
      onSkip: _onOnboardingSkip,
      showPrevious: true,
      onPrevious: () => ref.read(onboardingProvider.notifier).previousStep(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey[600],
          selectedFontSize: 14,
          unselectedFontSize: 12,
          iconSize: 28,
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
        ),
      ),
    );
  }

  /// 플로팅 액션 버튼
  Widget? _buildFloatingActionButton() {
    if (_selectedIndex != 0) return null;
    
    return FloatingActionButton.extended(
      heroTag: "floating_order_button", // 고유 heroTag 추가
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EnhancedOrderRegistrationScreen(),
          ),
        );
      },
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: Text(
        '새 주문',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 주문 목록 콘텐츠 빌드 (Sliver 형태)
  Widget _buildOrderListContent() {
    final orderListState = ref.watch(orderListProvider);
    
    return SliverList(
      delegate: SliverChildListDelegate([
        // 주문 상태 필터 섹션
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: '주문 상태'.text.size(16).bold.make(),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatusFilterChip('전체', null),
                    const SizedBox(width: 12),
                    _buildStatusFilterChip('주문대기', OrderStatus.pending),
                    const SizedBox(width: 12),
                    _buildStatusFilterChip('주문확정', OrderStatus.confirmed),
                    const SizedBox(width: 12),
                    _buildStatusFilterChip('출고완료', OrderStatus.shipped),
                    const SizedBox(width: 12),
                    _buildStatusFilterChip('배송완료', OrderStatus.completed),
                    const SizedBox(width: 12),
                    _buildStatusFilterChip('주문취소', OrderStatus.cancelled),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // 주문 목록
        ..._buildOrderCards(orderListState),
      ]),
    );
  }

  /// 상태 필터 칩
  Widget _buildStatusFilterChip(String label, OrderStatus? status) {
    final isSelected = _selectedStatus == status;
    
    return GestureDetector(
      onTap: () => _onStatusFilterChanged(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: label.text
            .size(14)
            .color(isSelected ? Colors.white : Colors.grey[700]!)
            .bold
            .make(),
      ),
    );
  }

  /// 상태 필터 변경
  void _onStatusFilterChanged(OrderStatus? status) {
    setState(() {
      _selectedStatus = status;
    });
    ref.read(orderListProvider.notifier).applyFilters(statusFilter: status);
  }

  /// 주문 카드들 빌드
  List<Widget> _buildOrderCards(OrderListState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(40),
          alignment: Alignment.center,
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              '주문 목록을 불러오는 중...'.text.size(16).gray600.make(),
            ],
          ),
        ),
      ];
    }

    if (state.error != null && state.orders.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(40),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 20),
              '데이터를 불러올 수 없습니다'.text.size(18).gray600.make(),
              const SizedBox(height: 12),
              state.error!.message.text.size(14).gray500.makeCentered(),
              const SizedBox(height: 24),
              GFButton(
                onPressed: () {
                  ref.read(orderListProvider.notifier).loadOrders(refresh: true);
                },
                text: '다시 시도',
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                size: 50,
                color: AppTheme.primaryColor,
                shape: GFButtonShape.pills,
              ),
            ],
          ),
        ),
      ];
    }

    if (state.orders.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(40),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 20),
              '주문이 없습니다'.text.size(18).gray600.make(),
              const SizedBox(height: 12),
              '새로운 주문을 등록해보세요'.text.size(14).gray500.make(),
            ],
          ),
        ),
      ];
    }

    List<Widget> cards = [];
    
    // 주문 카드들
    for (int i = 0; i < state.orders.length; i++) {
      cards.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _buildOrderCard(state.orders[i]),
      ));
    }
    
    // 더 불러오기 로딩 인디케이터
    if (state.hasMore) {
      cards.add(Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: state.isLoading
            ? Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  '더 많은 주문을 불러오는 중...'.text.size(14).gray500.make(),
                ],
              )
            : const SizedBox.shrink(),
      ));
    }
    
    return cards;
  }

  /// 주문 카드 빌드
  Widget _buildOrderCard(OrderModel order) {
    final NumberFormat currencyFormat = NumberFormat('#,###');
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailScreen(orderId: order.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        order.orderNumber.text.size(16).bold.make(),
                        const SizedBox(height: 4),
                        dateFormat.format(order.createdAt).text
                            .size(12)
                            .gray600
                            .make(),
                      ],
                    ),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              const SizedBox(height: 12),
              
              // 제품 정보
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getProductIcon(order.productType),
                      size: 20,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getProductTypeName(order.productType).text
                            .size(14)
                            .bold
                            .make(),
                        '수량: ${currencyFormat.format(order.quantity)}개'.text
                            .size(12)
                            .gray600
                            .make(),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      '₩${currencyFormat.format(order.totalPrice)}'.text
                          .size(16)
                          .bold
                          .color(AppTheme.primaryColor)
                          .make(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 상태 칩
  Widget _buildStatusChip(OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status) {
      case OrderStatus.draft:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        statusText = '임시저장';
        break;
      case OrderStatus.pending:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        statusText = '주문대기';
        break;
      case OrderStatus.confirmed:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[700]!;
        statusText = '주문확정';
        break;
      case OrderStatus.shipped:
        backgroundColor = Colors.purple[100]!;
        textColor = Colors.purple[700]!;
        statusText = '출고완료';
        break;
      case OrderStatus.completed:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        statusText = '배송완료';
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        statusText = '주문취소';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: statusText.text.size(12).color(textColor).bold.make(),
    );
  }

  IconData _getProductIcon(ProductType type) {
    switch (type) {
      case ProductType.box:
        return Icons.inventory_2;
      case ProductType.bulk:
        return Icons.storage;
    }
  }

  String _getProductTypeName(ProductType type) {
    switch (type) {
      case ProductType.box:
        return '박스 (20L)';
      case ProductType.bulk:
        return '벌크 (1000L)';
    }
  }
}