# 🏗️ DEF 요소수 주문관리 시스템 - 아키텍처 문서

## 📋 시스템 개요

### 프로젝트 소개
요소수 판매 거래처(대리점/일반)를 위한 B2B 출고주문관리 하이브리드 앱 시스템입니다.
Flutter 기반의 모바일 앱으로 40-60대 사용자를 위한 접근성을 중점적으로 고려했습니다.

### 핵심 기술 스택
- **Frontend**: Flutter 3.32.5 + Riverpod + GetWidget + VelocityX 호환성 레이어
- **Backend**: Supabase (PostgreSQL + Realtime + Auth + Storage)
- **Architecture**: Clean Architecture + Feature-First 모듈화
- **External**: FCM, Email API, 사업자번호 검증 API

---

## 🎯 아키텍처 원칙

### Clean Architecture
Robert C. Martin의 Clean Architecture 원칙을 준수합니다:

#### 1. 독립성의 원칙
- 비즈니스 로직은 UI, 데이터베이스, 프레임워크로부터 독립적
- 각 계층은 인터페이스를 통해서만 통신
- 테스트 가능한 순수 비즈니스 로직

#### 2. 의존성 규칙
```
Presentation → Domain ← Data
     ↓           ↑        ↓
    UI       Use Cases   API
```
- 의존성은 외부에서 내부로만 향함
- Domain Layer는 아무것도 의존하지 않음
- Data와 Presentation은 Domain에만 의존

#### 3. 계층 책임
- **Domain Layer**: 비즈니스 로직, 엔티티, 유스케이스
- **Data Layer**: 데이터 소스, 모델, 리포지토리 구현
- **Presentation Layer**: UI, 상태관리, 위젯

### Feature-First 모듈화
기능 중심의 모듈 구조로 확장성과 유지보수성 확보:

```
features/
├── auth/          # 인증 및 사용자 관리
├── order/         # 주문 생성 및 관리
├── history/       # 주문 내역 및 거래명세서
├── inventory/     # 재고 현황 관리
├── notice/        # 공지사항
├── notification/  # 푸시 알림
├── dashboard/     # 실시간 대시보드
└── onboarding/    # 사용자 온보딩
```

---

## 📁 프로젝트 구조

### 전체 구조도
```
def_order_app/
├── lib/
│   ├── main.dart                    # 앱 진입점
│   ├── app.dart                     # 앱 설정
│   │
│   ├── core/                        # 핵심 공통 기능
│   │   ├── config/
│   │   │   └── supabase_config.dart # Supabase 설정
│   │   ├── constants/
│   │   │   ├── app_constants.dart   # 앱 상수
│   │   │   └── api_constants.dart   # API 엔드포인트
│   │   ├── theme/
│   │   │   ├── app_theme.dart       # 테마 설정
│   │   │   └── app_colors.dart      # 색상 팔레트
│   │   ├── utils/
│   │   │   ├── validators.dart      # 유효성 검증
│   │   │   ├── formatters.dart      # 포맷터
│   │   │   └── velocity_x_compat.dart # VelocityX 호환성
│   │   ├── errors/
│   │   │   ├── failures.dart        # 실패 타입
│   │   │   └── exceptions.dart      # 예외 처리
│   │   └── widgets/                 # 공통 위젯
│   │       └── common_widgets.dart
│   │
│   └── features/                    # Feature 모듈
│       ├── [feature_name]/
│       │   ├── domain/              # 비즈니스 로직
│       │   │   ├── entities/       # 엔티티
│       │   │   ├── repositories/   # 리포지토리 인터페이스
│       │   │   └── usecases/       # 유스케이스
│       │   ├── data/                # 데이터 계층
│       │   │   ├── models/         # 데이터 모델
│       │   │   ├── repositories/   # 리포지토리 구현
│       │   │   └── services/       # 외부 서비스
│       │   └── presentation/        # 프레젠테이션
│       │       ├── providers/      # Riverpod 프로바이더
│       │       ├── screens/        # 화면
│       │       └── widgets/        # 위젯
│       └── ...
│
├── assets/                          # 리소스
│   ├── images/
│   └── fonts/
│
├── test/                            # 테스트
│   ├── unit/
│   ├── widget/
│   └── integration/
│
└── pubspec.yaml                     # 의존성 관리
```

---

## 🔄 데이터 플로우

### API 통신 구조
```
UI (Widget)
    ↓ 이벤트
ConsumerWidget + WidgetRef
    ↓ ref.read/watch
Riverpod Provider
    ↓ 호출
UseCase
    ↓ 실행
Repository Interface
    ↓ 구현
Repository Implementation
    ↓ 요청
Data Source (Supabase/API)
    ↓ 응답
Model → Entity 변환
    ↓ Either<Failure, Success>
UI 업데이트
```

### 상태 관리 패턴

#### Riverpod StateNotifier
```dart
@riverpod
class OrderNotifier extends _$OrderNotifier {
  @override
  OrderState build() => const OrderState.initial();
  
  Future<void> createOrder(OrderEntity order) async {
    state = const OrderState.loading();
    
    final result = await ref.read(createOrderUseCaseProvider)
        .call(CreateOrderParams(order: order));
    
    state = result.fold(
      (failure) => OrderState.error(failure.message),
      (order) => OrderState.success(order),
    );
  }
}
```

#### 데모 모드 처리
```dart
// 모든 서비스에서 데모 모드 체크
if (SupabaseConfig.isDemoMode) {
  // 로컬 mock 데이터 반환
  return Right(mockDemoData);
} else {
  // 실제 Supabase API 호출
  return await _supabaseClient.from('orders').insert(data);
}
```

---

## 🎨 Feature 모듈 상세

### Auth Feature (인증)
```
auth/
├── domain/
│   ├── entities/
│   │   ├── user_entity.dart        # 사용자 엔티티
│   │   └── profile_entity.dart     # 프로필 정보
│   ├── repositories/
│   │   └── auth_repository.dart    # 인증 인터페이스
│   └── usecases/
│       ├── login_usecase.dart
│       └── register_usecase.dart
├── data/
│   ├── models/
│   │   └── profile_model.dart      # Freezed 모델
│   ├── services/
│   │   └── auth_service.dart       # Supabase 인증
│   └── repositories/
│       └── auth_repository_impl.dart
└── presentation/
    ├── providers/
    │   ├── auth_provider.dart       # 인증 상태
    │   └── demo_auth_provider.dart  # 데모 모드
    └── screens/
        └── login_screen.dart
```

### Order Feature (주문)
```
order/
├── domain/
│   ├── entities/
│   │   └── order_entity.dart       # 주문 엔티티
│   ├── repositories/
│   │   └── order_repository.dart   # 주문 인터페이스
│   └── usecases/
│       ├── create_order_usecase.dart
│       └── get_orders_usecase.dart
├── data/
│   ├── models/
│   │   └── order_model.dart        # Freezed 모델
│   ├── services/
│   │   ├── order_service.dart      # 주문 서비스
│   │   └── pdf_service.dart        # PDF 생성
│   └── repositories/
│       ├── order_repository_impl.dart
│       └── demo_order_repository_impl.dart
└── presentation/
    ├── providers/
    │   ├── order_provider.dart      # 주문 상태
    │   └── order_list_provider.dart # 목록 상태
    └── screens/
        ├── order_create_screen.dart
        └── order_list_screen.dart
```

---

## 🔐 보안 및 인증

### 사용자 등급 시스템
```dart
enum UserGrade {
  dealer,   // 대리점 - 특별 단가, 전체 기능
  general   // 일반 - 표준 단가, 제한 기능
}
```

### 데이터 보안
- Row Level Security (RLS)로 데이터 접근 제어
- 사업자번호 검증 API 연동
- 관리자 승인 후 활성화
- 민감한 가격 정보는 서버사이드 처리

---

## 📱 UI/UX 설계 원칙

### 40-60대 사용자 접근성
- **최소 폰트 크기**: 16sp
- **터치 타겟**: 48dp 이상
- **색상 대비**: WCAG AA 기준
- **네비게이션**: 최대 3탭 깊이
- **온보딩**: ShowcaseView로 단계별 안내

### GetWidget + VelocityX 통합
```dart
// VelocityX 호환성 레이어 사용
import 'core/utils/velocity_x_compat.dart';

GFButton(
  onPressed: onPressed,
  text: "주문하기",
  size: GFSize.LARGE,
).p16().card.make();
```

---

## 🧪 테스트 전략

### 테스트 구조
```
test/
├── unit/           # 비즈니스 로직 테스트
│   ├── usecases/
│   └── repositories/
├── widget/         # UI 컴포넌트 테스트
│   └── screens/
└── integration/    # 통합 테스트
    └── features/
```

### 테스트 패턴
- **Unit Tests**: UseCase와 비즈니스 로직
- **Widget Tests**: UI 컴포넌트와 상호작용
- **Integration Tests**: 전체 플로우 검증
- **Golden Tests**: UI 일관성 보장

---

## 🚀 배포 및 CI/CD

### 빌드 설정
```bash
# 프로덕션 빌드
fvm flutter build web --release --dart-define=IS_DEMO=false

# 데모 빌드
fvm flutter build web --release --dart-define=IS_DEMO=true
```

### 환경 변수
- `.env`: Supabase URL, API 키
- `--dart-define`: 빌드 시 환경 설정
- GitHub Secrets: 민감한 정보 관리

---

## 📊 성능 최적화

### 최적화 전략
- **이미지 캐싱**: CachedNetworkImage 사용
- **페이지네이션**: 20개 단위 로딩
- **레이지 로딩**: 필요 시점 데이터 로드
- **상태 최적화**: select()로 리빌드 최소화

### 메모리 관리
- Provider 적절한 dispose
- Stream 구독 해제
- 이미지 메모리 캐시 제한

---

## 🔗 외부 연동

### Supabase 서비스
- **Database**: PostgreSQL 기반 데이터 저장
- **Auth**: 사용자 인증 및 세션 관리
- **Storage**: 파일 및 이미지 저장
- **Realtime**: 실시간 데이터 동기화

### 외부 API
- **사업자번호 검증**: 국세청 API
- **FCM**: Firebase 푸시 알림
- **Email**: 거래명세서 발송

---

## 📈 확장성 고려사항

### 모듈 확장
- Feature 단위로 독립적 확장
- 새로운 비즈니스 요구사항 수용
- 플러그인 방식의 기능 추가

### 성능 확장
- 수평적 확장 가능한 구조
- 캐싱 전략 최적화
- 비동기 처리 극대화

---

## 📞 기술 지원

추가 아키텍처 정보나 기술 지원이 필요한 경우:
- **개발 문서**: [DEVELOPMENT.md](./DEVELOPMENT.md)
- **데모 가이드**: [DEMO.md](./DEMO.md)
- **프로젝트 개요**: [README.md](../README.md)

> 💡 이 문서는 DEF 프로젝트의 기술 아키텍처를 설명합니다.
> Clean Architecture와 Feature-First 접근법으로 확장 가능한 구조를 제공합니다.