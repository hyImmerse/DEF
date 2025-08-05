import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/onboarding_keys.dart';
import 'advanced_context_tooltip_system.dart';
import '../../domain/entities/onboarding_entity.dart';

/// 주문 화면용 고급 스마트 툴팁 래퍼
/// 
/// 사용자 행동 패턴을 분석하여 개인화된 도움말 제공
class OrderAdvancedTooltips extends ConsumerWidget {
  final Widget child;
  final Function(UserBehaviorPattern)? onBehaviorAnalyzed;
  
  const OrderAdvancedTooltips({
    super.key,
    required this.child,
    this.onBehaviorAnalyzed,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdvancedContextTooltipSystem(
      screenId: OnboardingScreenType.orderCreate.id,
      tooltipConfigs: _buildTooltipConfigs(context, ref),
      baseWaitDuration: const Duration(seconds: 3),
      onBehaviorAnalyzed: (pattern) {
        // 사용자 행동 패턴 로깅
        debugPrint('사용자 행동 분석: ${pattern.totalInteractions}번 상호작용');
        onBehaviorAnalyzed?.call(pattern);
      },
      child: child,
    );
  }
  
  Map<GlobalKey, TooltipConfig> _buildTooltipConfigs(BuildContext context, WidgetRef ref) {
    return {
      // 제품 선택 툴팁
      OnboardingKeys.instance.orderProductSelectionKey: TooltipConfig(
        baseContent: '제품 종류를 선택해주세요.\n\n'
            '📦 박스(20L): 소량 주문에 적합합니다.\n'
            '🚚 벌크(대용량): 대량 주문 시 경제적입니다.',
        advancedTip: '💡 평균 주문량이 100L 이상이면 벌크가 더 경제적입니다.\n'
            '박스 대비 리터당 15% 이상 절약할 수 있어요!',
        contextualHints: [
          '처음 주문하시나요? 박스로 시작해보세요.',
          '정기 주문 시 벌크가 더 유리합니다.',
          '창고 공간을 고려하여 선택하세요.',
        ],
        basePriority: 0.9,
        processStep: 0,
        icon: Icons.inventory_2,
        iconColor: Colors.blue,
        title: '제품 선택 가이드',
        subtitle: '고객님께 맞는 제품을 선택하세요',
        highlightColor: Colors.blue,
        actions: [
          TooltipAction(
            label: '가격 비교하기',
            onPressed: () {
              // 가격 비교 화면으로 이동
              debugPrint('가격 비교 화면으로 이동');
            },
            isPrimary: true,
          ),
          TooltipAction(
            label: '나중에',
            onPressed: () {
              debugPrint('툴팁 닫기');
            },
          ),
        ],
      ),
      
      // 수량 입력 툴팁
      OnboardingKeys.instance.orderQuantityInputKey: TooltipConfig(
        baseContent: '주문하실 수량을 입력해주세요.\n\n'
            '✅ 숫자만 입력 가능합니다.\n'
            '✅ 최소 주문 수량: 박스 1개, 벌크 1톤\n'
            '✅ 빈 용기 반납도 가능합니다.',
        advancedTip: '💡 정기 주문 고객님을 위한 팁!\n\n'
            '평균 월 사용량의 1.2배를 주문하시면\n'
            '재고 부족 없이 안정적으로 사용하실 수 있습니다.',
        contextualHints: [
          '지난달 주문량: 50박스',
          '현재 재고를 확인하셨나요?',
          '배송 주기를 고려하여 주문하세요.',
        ],
        basePriority: 0.8,
        processStep: 1,
        icon: Icons.format_list_numbered,
        iconColor: Colors.green,
        title: '수량 입력',
        subtitle: '필요한 만큼만 주문하세요',
        highlightColor: Colors.green,
        actions: [
          TooltipAction(
            label: '이전 주문 확인',
            onPressed: () {
              debugPrint('이전 주문 내역 확인');
            },
            isPrimary: true,
          ),
        ],
      ),
      
      // 배송 정보 툴팁
      OnboardingKeys.instance.orderDeliveryInfoKey: TooltipConfig(
        baseContent: '배송 정보를 확인해주세요.\n\n'
            '📅 배송 희망일: 영업일 기준 2-3일 소요\n'
            '📍 배송 주소: 등록된 주소로 배송됩니다.\n'
            '📝 요청사항: 특별한 요청이 있으면 입력하세요.',
        advancedTip: '💡 배송 최적화 팁!\n\n'
            '화요일/목요일 배송을 선택하시면\n'
            '더 빠른 배송이 가능합니다.',
        contextualHints: [
          '공휴일은 배송이 불가능합니다.',
          '긴급 배송이 필요하신가요?',
          '배송 전 연락을 원하시면 요청사항에 기재하세요.',
        ],
        basePriority: 0.7,
        processStep: 2,
        icon: Icons.local_shipping,
        iconColor: Colors.orange,
        title: '배송 정보',
        subtitle: '정확한 배송을 위해 확인해주세요',
        highlightColor: Colors.orange,
        actions: [
          TooltipAction(
            label: '주소 변경',
            onPressed: () {
              debugPrint('배송 주소 변경');
            },
          ),
          TooltipAction(
            label: '확인',
            onPressed: () {
              debugPrint('배송 정보 확인');
            },
            isPrimary: true,
          ),
        ],
      ),
      
      // 주문 완료 버튼 툴팁
      OnboardingKeys.instance.orderSubmitButtonKey: TooltipConfig(
        baseContent: '주문 내용을 다시 한번 확인해주세요.\n\n'
            '✅ 제품 종류와 수량이 맞나요?\n'
            '✅ 배송 날짜와 주소가 정확한가요?\n'
            '✅ 주문 완료 후 PDF 주문서가 생성됩니다.',
        advancedTip: '💡 주문 확정 전 체크리스트\n\n'
            '□ 현재 재고 확인\n'
            '□ 예산 한도 확인\n'
            '□ 배송 일정 확인\n'
            '□ 결제 방법 확인',
        contextualHints: [
          '주문 완료 후 수정이 제한될 수 있습니다.',
          '주문서는 이메일로도 발송됩니다.',
          '문의사항은 고객센터로 연락주세요.',
        ],
        basePriority: 0.9,
        processStep: 3,
        icon: Icons.check_circle,
        iconColor: Colors.teal,
        title: '주문 최종 확인',
        subtitle: '신중하게 검토 후 주문해주세요',
        highlightColor: Colors.teal,
        actions: [
          TooltipAction(
            label: '다시 확인',
            onPressed: () {
              debugPrint('주문 내용 재확인');
            },
          ),
          TooltipAction(
            label: '주문하기',
            onPressed: () {
              debugPrint('주문 진행');
            },
            isPrimary: true,
          ),
        ],
      ),
    };
  }
}

/// 홈 화면용 고급 스마트 툴팁 래퍼
class HomeAdvancedTooltips extends ConsumerWidget {
  final Widget child;
  
  const HomeAdvancedTooltips({
    super.key,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdvancedContextTooltipSystem(
      screenId: OnboardingScreenType.home.id,
      tooltipConfigs: {
        // 새 주문 버튼
        OnboardingKeys.instance.homeNewOrderButtonKey: TooltipConfig(
          baseContent: '새로운 주문을 시작하려면 이 버튼을 누르세요.\n\n'
              '🚀 빠른 주문: 3단계로 간단하게\n'
              '📋 주문 내역: 언제든 확인 가능\n'
              '📧 주문서: PDF로 자동 생성',
          advancedTip: '💡 자주 주문하시는 상품이 있나요?\n\n'
              '즐겨찾기 기능을 사용하면\n'
              '더 빠르게 주문할 수 있습니다!',
          basePriority: 0.95,
          icon: Icons.add_shopping_cart,
          iconColor: Colors.blue,
          title: '주문 시작하기',
          highlightColor: Colors.blue,
        ),
        
        // 주문 통계
        OnboardingKeys.instance.homeOrderStatsKey: TooltipConfig(
          baseContent: '이번 달 주문 현황을 한눈에 확인하세요.\n\n'
              '📊 총 주문 건수\n'
              '⏳ 대기 중인 주문\n'
              '✅ 완료된 주문',
          contextualHints: [
            '클릭하면 상세 내역을 볼 수 있습니다.',
            '월별 비교도 가능합니다.',
          ],
          basePriority: 0.6,
          icon: Icons.analytics,
          iconColor: Colors.purple,
          title: '주문 통계',
        ),
        
        // 재고 현황
        OnboardingKeys.instance.homeInventoryKey: TooltipConfig(
          baseContent: '실시간 재고 현황입니다.\n\n'
              '🟢 재고 충분: 안심하고 주문하세요\n'
              '🟡 재고 보통: 서둘러 주문하세요\n'
              '🔴 재고 부족: 대체 상품을 고려하세요',
          advancedTip: '재고 알림을 설정하면\n'
              '재고 부족 시 자동으로 알려드립니다.',
          basePriority: 0.7,
          icon: Icons.inventory,
          iconColor: Colors.green,
          title: '재고 현황',
        ),
      },
      baseWaitDuration: const Duration(seconds: 4), // 홈 화면은 좀 더 여유있게
      child: child,
    );
  }
}