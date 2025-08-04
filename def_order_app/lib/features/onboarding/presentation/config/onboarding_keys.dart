import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_entity.dart';

/// 온보딩 키 관리 클래스
/// 
/// 각 화면의 온보딩 대상 위젯들의 GlobalKey를 중앙에서 관리
class OnboardingKeys {
  // Private constructor for singleton
  OnboardingKeys._();
  
  static final OnboardingKeys _instance = OnboardingKeys._();
  static OnboardingKeys get instance => _instance;

  // ===== 홈 화면 온보딩 키 =====
  final GlobalKey homeWelcomeKey = GlobalKey();
  final GlobalKey homeNewOrderButtonKey = GlobalKey();
  final GlobalKey homeOrderStatsKey = GlobalKey();
  final GlobalKey homeInventoryKey = GlobalKey();
  final GlobalKey homeBottomNavKey = GlobalKey();

  // ===== 주문 등록 화면 온보딩 키 =====
  final GlobalKey orderProductSelectionKey = GlobalKey();
  final GlobalKey orderQuantityInputKey = GlobalKey();
  final GlobalKey orderDeliveryInfoKey = GlobalKey();
  final GlobalKey orderSubmitButtonKey = GlobalKey();

  // ===== 주문 내역 화면 온보딩 키 =====
  final GlobalKey historyFilterKey = GlobalKey();
  final GlobalKey historyListKey = GlobalKey();
  final GlobalKey historySearchKey = GlobalKey();

  // ===== 공지사항 화면 온보딩 키 =====
  final GlobalKey noticeFiltersKey = GlobalKey();
  final GlobalKey noticeListKey = GlobalKey();
  final GlobalKey noticeUrgentKey = GlobalKey();

  /// 모든 키 리셋 (개발/테스트용)
  void resetAllKeys() {
    // 새로운 키로 교체
    // 실제로는 사용하지 않는 것이 좋음 - 위젯 트리와의 연결 문제 발생 가능
  }
}

/// 화면별 온보딩 단계 정의
class OnboardingSteps {
  OnboardingSteps._();

  /// 홈 화면 온보딩 단계들
  static List<OnboardingStepEntity> getHomeSteps() {
    return [
      OnboardingStepEntity(
        id: 'home_welcome',
        title: '요소수 주문관리에 오신 것을 환영합니다! 👋',
        description: '40-60대 사용자를 위해 특별히 설계된 쉽고 편리한 주문 시스템입니다. 큰 글씨와 간단한 조작으로 누구나 쉽게 사용할 수 있어요.',
        targetKey: OnboardingKeys.instance.homeWelcomeKey.toString(),
        type: OnboardingStepType.basic,
        order: 0,
        isSkippable: false,
      ),
      OnboardingStepEntity(
        id: 'home_new_order',
        title: '새 주문 등록하기 📋',
        description: '이 버튼을 눌러서 새로운 주문을 등록하세요. 박스 단위나 벌크 단위로 주문할 수 있습니다.',
        targetKey: OnboardingKeys.instance.homeNewOrderButtonKey.toString(),
        type: OnboardingStepType.tap,
        order: 1,
        actionText: '주문하러 가기',
      ),
      OnboardingStepEntity(
        id: 'home_stats',
        title: '주문 현황 한눈에 보기 📊',
        description: '이번 달 주문 건수, 대기 중인 주문, 완료된 주문을 한눈에 확인할 수 있어요.',
        targetKey: OnboardingKeys.instance.homeOrderStatsKey.toString(),
        type: OnboardingStepType.highlight,
        order: 2,
      ),
      OnboardingStepEntity(
        id: 'home_inventory',
        title: '실시간 재고 현황 📦',
        description: '현재 창고의 재고 상황을 실시간으로 확인하세요. 재고가 부족하면 자동으로 알림을 받을 수 있어요.',
        targetKey: OnboardingKeys.instance.homeInventoryKey.toString(),
        type: OnboardingStepType.highlight,
        order: 3,
      ),
      OnboardingStepEntity(
        id: 'home_navigation',
        title: '하단 메뉴로 이동하기 🗂️',
        description: '하단의 메뉴를 터치해서 주문 내역, 공지사항 등 다른 화면으로 이동할 수 있어요.',
        targetKey: OnboardingKeys.instance.homeBottomNavKey.toString(),
        type: OnboardingStepType.swipe,
        order: 4,
      ),
    ];
  }

  /// 주문 등록 화면 온보딩 단계들
  static List<OnboardingStepEntity> getOrderCreateSteps() {
    return [
      OnboardingStepEntity(
        id: 'order_product_selection',
        title: '제품 종류 선택하기 🧪',
        description: '박스 단위(20L 용기) 또는 벌크 단위(대용량)를 선택하세요. 용량에 따라 가격이 다릅니다.',
        targetKey: OnboardingKeys.instance.orderProductSelectionKey.toString(),
        type: OnboardingStepType.tap,
        order: 0,
        actionText: '제품 선택하기',
      ),
      OnboardingStepEntity(
        id: 'order_quantity',
        title: '수량 입력하기 🔢',
        description: '필요한 수량을 입력하세요. 빈 용기 반납 수량도 함께 입력할 수 있어요.',
        targetKey: OnboardingKeys.instance.orderQuantityInputKey.toString(),
        type: OnboardingStepType.input,
        order: 1,
      ),
      OnboardingStepEntity(
        id: 'order_delivery',
        title: '배송 정보 확인하기 🚚',
        description: '배송 날짜와 주소를 확인하세요. 변경이 필요하면 수정할 수 있어요.',
        targetKey: OnboardingKeys.instance.orderDeliveryInfoKey.toString(),
        type: OnboardingStepType.basic,
        order: 2,
      ),
      OnboardingStepEntity(
        id: 'order_submit',
        title: '주문 완료하기 ✅',
        description: '모든 정보를 확인한 후 이 버튼을 눌러 주문을 완료하세요. 주문서 PDF가 자동으로 생성됩니다.',
        targetKey: OnboardingKeys.instance.orderSubmitButtonKey.toString(),
        type: OnboardingStepType.tap,
        order: 3,
        actionText: '주문 완료',
      ),
    ];
  }

  /// 주문 내역 화면 온보딩 단계들
  static List<OnboardingStepEntity> getOrderHistorySteps() {
    return [
      OnboardingStepEntity(
        id: 'history_filter',
        title: '주문 상태별 필터링 🔍',
        description: '전체, 대기중, 확정, 완료 등 상태별로 주문을 필터링해서 볼 수 있어요.',
        targetKey: OnboardingKeys.instance.historyFilterKey.toString(),
        type: OnboardingStepType.tap,
        order: 0,
      ),
      OnboardingStepEntity(
        id: 'history_search',
        title: '주문 검색하기 🔎',
        description: '주문번호나 날짜로 특정 주문을 빠르게 찾을 수 있어요.',
        targetKey: OnboardingKeys.instance.historySearchKey.toString(),
        type: OnboardingStepType.input,
        order: 1,
      ),
      OnboardingStepEntity(
        id: 'history_list',
        title: '주문 내역 보기 📋',
        description: '주문을 터치하면 상세 정보를 볼 수 있고, PDF 다운로드도 가능해요.',
        targetKey: OnboardingKeys.instance.historyListKey.toString(),
        type: OnboardingStepType.tap,
        order: 2,
        actionText: '상세 보기',
      ),
    ];
  }

  /// 공지사항 화면 온보딩 단계들
  static List<OnboardingStepEntity> getNoticeSteps() {
    return [
      OnboardingStepEntity(
        id: 'notice_urgent',
        title: '긴급 공지사항 확인하기 🚨',
        description: '빨간 테두리의 긴급 공지사항을 먼저 확인하세요. 중요한 정보가 포함되어 있어요.',
        targetKey: OnboardingKeys.instance.noticeUrgentKey.toString(),
        type: OnboardingStepType.highlight,
        order: 0,
      ),
      OnboardingStepEntity(
        id: 'notice_filters',
        title: '공지사항 분류하기 🗂️',
        description: '전체, 긴급, 일반, 읽지 않음으로 공지사항을 분류해서 볼 수 있어요.',
        targetKey: OnboardingKeys.instance.noticeFiltersKey.toString(),
        type: OnboardingStepType.tap,
        order: 1,
      ),
      OnboardingStepEntity(
        id: 'notice_list',
        title: '공지사항 읽기 📖',
        description: '공지사항을 터치하면 자세한 내용을 볼 수 있어요. 읽으면 자동으로 읽음 표시가 됩니다.',
        targetKey: OnboardingKeys.instance.noticeListKey.toString(),
        type: OnboardingStepType.tap,
        order: 2,
        actionText: '공지 읽기',
      ),
    ];
  }

  /// 화면 타입에 따른 단계 반환
  static List<OnboardingStepEntity> getStepsForScreen(OnboardingScreenType screenType) {
    switch (screenType) {
      case OnboardingScreenType.home:
        return getHomeSteps();
      case OnboardingScreenType.orderCreate:
        return getOrderCreateSteps();
      case OnboardingScreenType.orderHistory:
        return getOrderHistorySteps();
      case OnboardingScreenType.notice:
        return getNoticeSteps();
      case OnboardingScreenType.settings:
        return []; // 설정 화면은 온보딩 없음
    }
  }
}

/// 온보딩 단계별 색상 테마
class OnboardingColors {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color overlayColor = Color(0x88000000);
  
  /// 단계 타입별 색상
  static Color getColorForType(OnboardingStepType type) {
    switch (type) {
      case OnboardingStepType.basic:
        return primaryColor;
      case OnboardingStepType.custom:
        return accentColor;
      case OnboardingStepType.highlight:
        return warningColor;
      case OnboardingStepType.swipe:
        return accentColor;
      case OnboardingStepType.tap:
        return primaryColor;
      case OnboardingStepType.input:
        return accentColor;
    }
  }
}