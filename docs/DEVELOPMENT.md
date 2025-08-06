# 🛠️ DEF 프로젝트 개발 가이드

## 📋 목차
- [프로젝트 개발 환경](#프로젝트-개발-환경)
- [Flutter 개발 워크플로우](#flutter-개발-워크플로우)
- [SuperClaude 커맨드 가이드](#superclaude-커맨드-가이드)
- [개발 명령어 레퍼런스](#개발-명령어-레퍼런스)

---

## 🔧 프로젝트 개발 환경

### 기술 스택
- **Framework**: Flutter 3.32.5 (FVM 사용)
- **State Management**: Riverpod 2.5.1 + StateNotifier + Freezed
- **Backend**: Supabase (데모 모드 지원)
- **UI Framework**: GetWidget 6.0.0 + VelocityX 호환성 레이어
- **Architecture**: Clean Architecture (Feature-first)

### 환경 설정
```bash
# Flutter 버전 관리
fvm install 3.32.5
fvm use 3.32.5

# 프로젝트 디렉토리 이동
cd def_order_app

# 의존성 설치
fvm flutter pub get

# 코드 생성 (Freezed/JsonSerializable/Riverpod)
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### 개발 실행
```bash
# 웹 개발 (데모 모드)
fvm flutter run -d chrome --dart-define=IS_DEMO=true --web-port 5000

# Android 개발
fvm flutter run -d android --dart-define=IS_DEMO=true

# iOS 개발
fvm flutter run -d ios --dart-define=IS_DEMO=true

# Windows 개발
fvm flutter run -d windows --dart-define=IS_DEMO=true
```

---

## 🚀 Flutter 개발 워크플로우

### 1단계: 프로젝트 초기화
```bash
# 프로젝트 분석 및 컨텍스트 로딩
/sc:load @CLAUDE.md

# Clean Architecture 설계
/sc:design "Clean Architecture feature 구조" --persona-architect --c7
```

### 2단계: Feature 모듈 개발

#### 도메인 레이어 구현
```bash
# Entity 및 UseCase 설계
/sc:implement "도메인 엔티티 구현 - Freezed 사용
- 주문 엔티티 (OrderEntity)
- 사용자 엔티티 (UserEntity)
- 재고 엔티티 (InventoryEntity)" --persona-backend --seq --validate
```

#### 데이터 레이어 구현
```bash
# Repository 패턴 구현
/sc:implement "Repository 인터페이스 및 구현체
- OrderRepository (인터페이스)
- OrderRepositoryImpl (Supabase 연동)
- 데모 모드 지원 (mock 데이터)" --persona-backend --c7 --seq
```

#### 프레젠테이션 레이어 구현
```bash
# Riverpod Provider 구현
/sc:implement "Riverpod StateNotifier Provider
- OrderNotifier extends StateNotifier<OrderState>
- AsyncValue 패턴 사용
- 에러 처리 포함" --persona-backend --c7 --seq

# Flutter UI 구현
/sc:implement "Flutter 주문 등록 화면
- GetWidget 컴포넌트 사용
- 40-60대 사용자 접근성 (16sp 폰트, 48dp 터치)
- VelocityX 호환성 레이어 활용" --persona-frontend --c7 --validate
```

### 3단계: 상태 관리 (Riverpod)

#### Provider 패턴
```dart
// Provider 정의 (riverpod_generator 사용)
@riverpod
class OrderNotifier extends _$OrderNotifier {
  @override
  OrderState build() => const OrderState.initial();
  
  Future<void> createOrder(OrderEntity order) async {
    state = const OrderState.loading();
    final result = await ref.read(createOrderUseCaseProvider).call(order);
    state = result.fold(
      (failure) => OrderState.error(failure.message),
      (order) => OrderState.success(order),
    );
  }
}
```

### 4단계: UI 컴포넌트 개발

#### GetWidget + VelocityX 호환성
```dart
import '../core/utils/velocity_x_compat.dart';

GFButton(
  onPressed: onPressed,
  text: "주문하기",
  size: GFSize.LARGE,
  fullWidthButton: true,
).p16().card.make(); // VelocityX 스타일 체이닝
```

---

## 💡 SuperClaude 커맨드 가이드

### 개발 & 구현 커맨드

#### `/sc:implement` - 기능 구현
```bash
# 기본 사용법
/sc:implement "기능 설명" --persona-[type] --[flags]

# Flutter UI 구현 최적 조합
/sc:implement "Flutter 위젯 구현
- Material 3 디자인 적용
- GetWidget 컴포넌트 사용
- 40-60대 접근성 고려
- 반응형 레이아웃" --persona-frontend --c7 --validate

# 백엔드 로직 구현
/sc:implement "Supabase 연동 서비스
- 실시간 구독 설정
- 에러 처리 및 재시도 로직
- 데모 모드 분기 처리" --persona-backend --c7 --seq
```

#### `/sc:build` - 빌드 및 패키징
```bash
# 개발 빌드
/sc:build --target mobile --persona-frontend

# 프로덕션 빌드
/sc:build --production --validate --persona-devops
```

### 분석 & 품질 커맨드

#### `/sc:analyze` - 코드 분석
```bash
# 품질 분석
/sc:analyze --focus quality --persona-refactorer

# 성능 분석
/sc:analyze --focus performance --persona-performance --think-hard

# 보안 분석
/sc:analyze --focus security --persona-security --seq
```

#### `/sc:improve` - 코드 개선
```bash
# 코드 품질 개선
/sc:improve "코드 리팩토링
- 중복 코드 제거
- SOLID 원칙 적용
- 가독성 개선" --persona-refactorer --loop

# 성능 최적화
/sc:improve "Flutter 성능 최적화
- 위젯 리빌드 최소화
- 이미지 캐싱 구현
- 레이지 로딩 적용" --persona-performance --c7
```

### 테스트 커맨드

#### `/sc:test` - 테스트 실행
```bash
# 위젯 테스트
/sc:test --type widget --persona-qa

# 통합 테스트
/sc:test --type integration --persona-qa --play

# 커버리지 포함
/sc:test --coverage --validate
```

### 문서화 커맨드

#### `/sc:document` - 문서 생성
```bash
# API 문서
/sc:document --focus api --persona-scribe=ko

# 사용자 가이드
/sc:document --focus user-guide --persona-mentor
```

---

## 📚 개발 명령어 레퍼런스

### Flutter 개발 명령어

#### 프로젝트 관리
```bash
# 패키지 추가
fvm flutter pub add [package_name]

# 패키지 업데이트
fvm flutter pub upgrade

# 캐시 정리
fvm flutter clean

# 의존성 트리 확인
fvm flutter pub deps
```

#### 코드 생성
```bash
# Freezed/JsonSerializable 생성
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Watch 모드 (자동 생성)
fvm flutter pub run build_runner watch --delete-conflicting-outputs

# 생성 파일 정리
fvm flutter packages pub run build_runner clean
```

#### 테스트
```bash
# 전체 테스트
fvm flutter test

# 특정 파일 테스트
fvm flutter test test/[file_name]_test.dart

# 커버리지 생성
fvm flutter test --coverage

# 골든 테스트 업데이트
fvm flutter test --update-goldens
```

#### 빌드
```bash
# Web 빌드
fvm flutter build web --release --dart-define=IS_DEMO=true

# Android APK
fvm flutter build apk --release --dart-define=IS_DEMO=true

# Android App Bundle
fvm flutter build appbundle --release --dart-define=IS_DEMO=true

# iOS 빌드
fvm flutter build ios --release --no-codesign --dart-define=IS_DEMO=true

# Windows 빌드
fvm flutter build windows --release --dart-define=IS_DEMO=true
```

### Git 워크플로우
```bash
# 기능 브랜치 생성
git checkout -b feature/[feature-name]

# 변경사항 확인
git status
git diff

# 커밋
git add .
git commit -m "feat: [기능 설명]"

# 푸시
git push origin feature/[feature-name]
```

### 디버깅
```bash
# Flutter Inspector 실행
fvm flutter inspector

# 성능 프로파일링
fvm flutter run --profile

# 메모리 프로파일링
fvm flutter run --debug --track-widget-creation
```

---

## 🎯 페르소나별 최적 커맨드

### Frontend 개발 (UI/UX)
```bash
# Material 3 컴포넌트
/sc:implement "Material 3 Navigation Drawer" --persona-frontend --c7

# GetWidget 활용
/sc:implement "GetWidget 버튼 컴포넌트 세트" --persona-frontend --c7 --validate

# 접근성 개선
/sc:improve "40-60대 사용자 접근성 개선" --persona-frontend --focus accessibility
```

### Backend 개발 (비즈니스 로직)
```bash
# UseCase 구현
/sc:implement "주문 생성 UseCase - Dartz Either 패턴" --persona-backend --seq

# Repository 패턴
/sc:implement "Repository 패턴 - 데모/실제 모드 분기" --persona-backend --c7

# 에러 처리
/sc:implement "전역 에러 처리 시스템" --persona-backend --seq --validate
```

### 아키텍처 설계
```bash
# 시스템 설계
/sc:design "마이크로서비스 아키텍처" --persona-architect --c7

# 모듈 구조
/sc:design "Feature-first 모듈 구조" --persona-architect --seq

# 의존성 관리
/sc:analyze "의존성 그래프 분석" --persona-architect --think-hard
```

---

## ⚡ 고급 기능

### Wave 모드
복잡한 작업을 체계적으로 관리:
- **자동 활성화**: 복잡도 ≥0.7, 파일 수 >20
- **수동 활성화**: `--wave-mode progressive|systematic`

### MCP 서버 통합
- **Context7** (`--c7`): Flutter 공식 문서 및 패턴
- **Sequential** (`--seq`): 복잡한 로직 분석
- **Magic** (`--magic`): UI 컴포넌트 생성 (React/Vue용)
- **Playwright** (`--play`): E2E 테스트

### 플래그 조합
```bash
# 고성능 최적화
--think-hard --focus performance --persona-performance

# 보안 강화
--validate --focus security --persona-security

# 품질 개선
--loop --iterations 5 --persona-refactorer
```

---

## 📞 추가 리소스

- **Flutter 공식 문서**: https://flutter.dev/docs
- **Riverpod 문서**: https://riverpod.dev
- **GetWidget 문서**: https://docs.getwidget.dev
- **프로젝트 아키텍처**: [ARCHITECTURE.md](./ARCHITECTURE.md)
- **데모 가이드**: [DEMO.md](./DEMO.md)

> 💡 이 문서는 DEF 프로젝트의 개발 가이드입니다.
> Flutter 개발과 SuperClaude 커맨드 사용법을 통합하여 제공합니다.