# DEF 요소수 주문관리 시스템

40-60대 사용자를 위한 Flutter 기반 B2B 주문관리 시스템

## 🚀 프로젝트 현황

### 최근 업데이트 (2025-08-04)
- ✅ **홈 화면 온보딩 가이드 구현 완료**
  - '새 주문' 버튼 강력한 하이라이트 효과 (그라데이션, 그림자, 애니메이션)
  - ShowcaseView를 활용한 온보딩 시스템 통합
  - 40-60대 사용자를 위한 Senior-friendly UI 개선
  - VelocityX 호환성 레이어로 Flutter 3.32.5 호환성 해결

### 개발 진행률
- **데모-1단계**: ✅ 데모 모드 구현 완료
- **데모-2단계**: ✅ 테스트 데이터 준비 완료
- **데모-3단계**: ✅ 핵심 화면 구현 완료 (5/5)
- **데모-4단계**: 🔄 인터랙티브 온보딩 진행 중 (2/6)
- **데모-5단계**: ⏳ PWA 빌드 및 배포 대기

## 📱 주요 기능

### 구현 완료
- ✅ 데모 모드 인증 시스템 (Riverpod)
- ✅ 주문 등록 화면 (Enhanced UI)
- ✅ 주문 내역 조회 화면
- ✅ 거래명세서 PDF 뷰어
- ✅ 실시간 재고 현황 대시보드
- ✅ 공지사항 시스템 (40-60대 최적화)
- ✅ 홈 화면 온보딩 가이드

### 진행 중
- 🔄 주문 화면 단계별 온보딩
- 🔄 스마트 툴팁 시스템
- 🔄 온보딩 진행률 표시
- 🔄 SharedPreferences 온보딩 상태 저장

## 🛠 기술 스택

- **Framework**: Flutter 3.32.5 (FVM 사용)
- **State Management**: Riverpod 2.5.1
- **Backend**: Supabase
- **UI Components**: GetWidget 6.0.0
- **Architecture**: Clean Architecture
- **Key Features**:
  - ShowcaseView 온보딩
  - PDF 생성/뷰어
  - FCM 푸시 알림
  - 실시간 데이터 동기화

## 🚀 시작하기

### 환경 설정
```bash
# Flutter 버전 설정
fvm install 3.32.5
fvm use 3.32.5

# 의존성 설치
cd def_order_app
fvm flutter pub get

# 코드 생성
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### 실행
```bash
# 웹 실행 (데모 모드)
fvm flutter run -d chrome --dart-define=IS_DEMO=true --web-port 5000

# Android 실행
fvm flutter run -d android

# iOS 실행
fvm flutter run -d ios
```

### 빌드
```bash
# 웹 빌드
fvm flutter build web --release --dart-define=IS_DEMO=true

# Android APK
fvm flutter build apk --release

# iOS
fvm flutter build ios --release --no-codesign
```

## 📂 프로젝트 구조

```
def_order_app/
├── lib/
│   ├── core/              # 핵심 유틸리티, 테마, 서비스
│   │   ├── theme/         # 앱 테마 정의
│   │   ├── services/      # Supabase, FCM 등 서비스
│   │   └── utils/         # 유틸리티 함수, VelocityX 호환성 레이어
│   ├── features/          # 기능별 모듈 (Clean Architecture)
│   │   ├── auth/          # 인증
│   │   ├── home/          # 홈 화면
│   │   ├── order/         # 주문 관리
│   │   ├── history/       # 거래 내역
│   │   ├── notice/        # 공지사항
│   │   ├── notification/  # 푸시 알림
│   │   └── onboarding/    # 온보딩
│   └── main.dart          # 앱 진입점
├── supabase/              # Supabase 함수 및 설정
├── scripts/               # 유틸리티 스크립트
└── pubspec.yaml          # 의존성 관리
```

## 🎯 대상 사용자

- **주 사용자**: 40-60대 요소수 대리점 및 거래처 담당자
- **특징**:
  - 큰 글씨 (최소 16sp)
  - 명확한 버튼과 터치 영역 (최소 48dp)
  - 단순한 네비게이션
  - 고대비 색상 (WCAG AA 준수)

## 📝 개발 문서

자세한 개발 가이드는 [DEMO-DEV-COMMANDS.md](./DEMO-DEV-COMMANDS.md)를 참조하세요.

## 🤝 기여하기

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이센스

This project is private and proprietary.