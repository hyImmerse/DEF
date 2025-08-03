# 요소수 출고주문관리 앱 - Clean Architecture 폴더 구조

## 프로젝트 루트 구조

```
def_order_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── injection.dart
│   │
│   ├── core/                      # 핵심 공통 기능
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── api_constants.dart
│   │   │   └── supabase_constants.dart
│   │   │
│   │   ├── themes/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_typography.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── formatters.dart
│   │   │   └── extensions.dart
│   │   │
│   │   ├── errors/
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   │
│   │   ├── usecases/
│   │   │   └── usecase.dart
│   │   │
│   │   └── widgets/              # GetWidget 기반 공통 위젯
│   │       ├── gf_custom_button.dart
│   │       ├── gf_custom_card.dart
│   │       └── velocity_extensions.dart
│   │
│   ├── features/                 # Feature-first 모듈
│   │   ├── auth/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       ├── register_usecase.dart
│   │   │   │       └── reset_password_usecase.dart
│   │   │   │
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   │   └── auth_local_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart
│   │   │       ├── pages/
│   │   │       │   ├── login_page.dart
│   │   │       │   ├── register_page.dart
│   │   │       │   └── reset_password_page.dart
│   │   │       └── widgets/
│   │   │           ├── business_number_input.dart
│   │   │           └── password_strength_indicator.dart
│   │   │
│   │   ├── order/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── order.dart
│   │   │   │   │   └── order_item.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── order_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── create_order_usecase.dart
│   │   │   │       ├── get_orders_usecase.dart
│   │   │   │       └── update_order_usecase.dart
│   │   │   │
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── order_model.dart
│   │   │   │   │   └── order_item_model.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   └── order_remote_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── order_repository_impl.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── order_list_provider.dart
│   │   │       │   └── order_form_provider.dart
│   │   │       ├── pages/
│   │   │       │   ├── order_list_page.dart
│   │   │       │   ├── order_create_page.dart
│   │   │       │   └── order_detail_page.dart
│   │   │       └── widgets/
│   │   │           ├── order_card.dart
│   │   │           ├── product_selector.dart
│   │   │           └── delivery_date_picker.dart
│   │   │
│   │   ├── inventory/
│   │   │   ├── domain/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   │
│   │   ├── invoice/
│   │   │   ├── domain/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   │
│   │   ├── notification/
│   │   │   ├── domain/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   │
│   │   └── admin/                # 관리자 전용 기능
│   │       ├── user_management/
│   │       ├── price_management/
│   │       └── statistics/
│   │
│   └── config/
│       ├── routes/
│       │   ├── app_router.dart
│       │   └── route_guards.dart
│       └── injection/
│           ├── injection_container.dart
│           └── feature_injections/
│
├── assets/
│   ├── images/
│   ├── fonts/
│   └── lottie/
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── web/                          # 관리자 웹 앱
│   └── admin/
│
└── pubspec.yaml
```

## Clean Architecture 원칙

### 1. 계층 분리
- **Domain Layer**: 비즈니스 로직, 엔티티, 유스케이스
- **Data Layer**: 데이터 소스, 모델, 리포지토리 구현
- **Presentation Layer**: UI, 상태관리, 위젯

### 2. 의존성 규칙
- Domain → 아무것도 의존하지 않음
- Data → Domain에만 의존
- Presentation → Domain에만 의존

### 3. Feature-First 구조의 장점
- 기능별 독립적인 개발 가능
- 팀 협업 용이
- 기능 추가/제거 간편
- 테스트 용이성

## 주요 특징

### 1. Riverpod + BLoC 하이브리드
- 전역 상태: Riverpod Provider
- 복잡한 비즈니스 로직: BLoC Pattern
- UI 상태: StateNotifier

### 2. GetWidget + VelocityX 통합
- core/widgets에 커스텀 GetWidget 컴포넌트
- VelocityX 확장 메서드 정의

### 3. Supabase 통합
- 각 feature의 datasource에서 Supabase 클라이언트 사용
- 실시간 기능은 별도 스트림 관리

### 4. 40-60대 사용자 고려
- 큰 폰트 사이즈 기본값
- 명확한 터치 영역
- 단순한 네비게이션