# Feature-First 모듈 설계

## 모듈 구성 원칙

### 1. 독립성
- 각 feature는 독립적으로 개발, 테스트, 배포 가능
- 다른 feature에 직접 의존하지 않음
- 공통 기능은 core 모듈 활용

### 2. 책임 분리
- 각 feature는 하나의 비즈니스 도메인만 담당
- UI, 비즈니스 로직, 데이터 접근을 feature 내에서 완결

## 주요 Feature 모듈

### 1. Auth Feature (인증)
```
auth/
├── domain/
│   ├── entities/
│   │   ├── user.dart                    # 사용자 엔티티
│   │   ├── user_grade.dart              # 회원 등급 (대리점/일반)
│   │   └── business_info.dart           # 사업자 정보
│   │
│   ├── repositories/
│   │   └── auth_repository.dart         # 인증 리포지토리 인터페이스
│   │
│   └── usecases/
│       ├── login_with_business_number.dart
│       ├── register_new_dealer.dart
│       ├── verify_business_number.dart
│       └── reset_password.dart
│
├── data/
│   ├── models/
│   │   ├── user_model.dart              # Supabase 모델
│   │   └── business_info_model.dart
│   │
│   ├── datasources/
│   │   ├── auth_supabase_datasource.dart
│   │   └── business_api_datasource.dart  # 사업자번호 검증 API
│   │
│   └── repositories/
│       └── auth_repository_impl.dart
│
└── presentation/
    ├── providers/
    │   ├── auth_state_provider.dart      # Riverpod StateNotifier
    │   └── login_form_provider.dart
    │
    ├── pages/
    │   ├── login_page.dart
    │   ├── register_page.dart
    │   ├── approval_waiting_page.dart   # 관리자 승인 대기
    │   └── password_reset_page.dart
    │
    └── widgets/
        ├── business_number_field.dart    # GetWidget 기반
        └── grade_selector.dart
```

### 2. Order Feature (주문 관리)
```
order/
├── domain/
│   ├── entities/
│   │   ├── order.dart
│   │   ├── order_item.dart
│   │   ├── product_type.dart           # 박스/벌크
│   │   └── delivery_info.dart
│   │
│   ├── repositories/
│   │   └── order_repository.dart
│   │
│   └── usecases/
│       ├── create_order.dart
│       ├── update_order.dart
│       ├── cancel_order.dart
│       ├── get_order_list.dart
│       └── calculate_price.dart         # 등급별 단가 계산
│
├── data/
│   └── [구현 상세]
│
└── presentation/
    ├── providers/
    │   ├── order_list_provider.dart     # 주문 목록 상태
    │   ├── order_form_provider.dart     # 주문 폼 상태
    │   └── order_filter_provider.dart   # 필터링 상태
    │
    ├── pages/
    │   ├── order_list_page.dart
    │   ├── order_create_page.dart
    │   ├── order_edit_page.dart
    │   └── order_detail_page.dart
    │
    └── widgets/
        ├── product_type_selector.dart   # 박스/벌크 선택
        ├── javara_quantity_input.dart   # 자바라 수량
        ├── delivery_date_picker.dart    # 출고일 선택
        └── order_status_badge.dart      # 상태 표시
```

### 3. Invoice Feature (거래명세서)
```
invoice/
├── domain/
│   ├── entities/
│   │   └── invoice.dart
│   │
│   ├── repositories/
│   │   └── invoice_repository.dart
│   │
│   └── usecases/
│       ├── generate_invoice_pdf.dart
│       ├── send_invoice_email.dart
│       └── download_invoice.dart
│
├── data/
│   └── [PDF 생성, 이메일 발송 구현]
│
└── presentation/
    ├── providers/
    │   └── invoice_provider.dart
    │
    ├── pages/
    │   └── invoice_viewer_page.dart
    │
    └── widgets/
        └── pdf_viewer_widget.dart
```

### 4. Inventory Feature (재고 관리)
```
inventory/
├── domain/
│   ├── entities/
│   │   ├── inventory.dart
│   │   ├── bulk_tank.dart              # 벌크 탱크
│   │   └── warehouse.dart              # 창고 정보
│   │
│   └── usecases/
│       ├── check_stock_availability.dart
│       ├── update_inventory.dart
│       └── manage_bulk_tanks.dart
│
└── [data, presentation 구현]
```

### 5. Notification Feature (알림)
```
notification/
├── domain/
│   ├── entities/
│   │   ├── notification.dart
│   │   └── notification_type.dart
│   │
│   └── usecases/
│       ├── send_push_notification.dart
│       ├── get_notifications.dart
│       └── mark_as_read.dart
│
└── [FCM 통합 구현]
```

### 6. Admin Feature (관리자 전용)
```
admin/
├── user_management/
│   ├── domain/
│   │   └── usecases/
│   │       ├── approve_user.dart
│   │       ├── set_user_price.dart
│   │       └── manage_delivery_address.dart
│   │
│   └── presentation/
│       └── pages/
│           └── user_management_page.dart
│
├── price_management/
│   ├── domain/
│   │   └── usecases/
│   │       ├── set_dealer_price.dart    # 대리점 통일가
│   │       └── set_general_price.dart   # 일반 개별가
│   │
│   └── [가격 보안 처리]
│
└── statistics/
    └── [통계 및 리포트]
```

## 모듈 간 통신

### 1. 이벤트 버스
```dart
// core/events/event_bus.dart
class EventBus {
  // Feature 간 통신을 위한 이벤트 버스
}
```

### 2. 공유 상태
```dart
// core/providers/shared_providers.dart
final currentUserProvider = StateProvider<User?>((ref) => null);
final cartProvider = StateNotifierProvider<CartNotifier, Cart>(...);
```

### 3. Deep Linking
```dart
// config/routes/deep_link_handler.dart
class DeepLinkHandler {
  // Feature 간 네비게이션 처리
}
```

## 확장성 고려사항

### 1. 플러그인 아키텍처
- 새로운 feature 추가 시 기존 코드 수정 최소화
- 인터페이스 기반 설계로 확장 용이

### 2. 마이크로 프론트엔드
- 각 feature를 독립적인 패키지로 분리 가능
- 대규모 팀 협업 시 유용

### 3. 테스트 전략
- Feature 단위 통합 테스트
- Mock 리포지토리를 통한 독립적 테스트