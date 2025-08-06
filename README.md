# 🚛 DEF 요소수 주문관리 시스템

> 40-60대 사용자를 위한 B2B 출고주문관리 시스템

[![Flutter](https://img.shields.io/badge/Flutter-3.32.5-blue)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.5.1-purple)](https://riverpod.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-green)](https://supabase.com)
[![License](https://img.shields.io/badge/License-Private-red)](LICENSE)

## 📋 프로젝트 소개

요소수(AdBlue) 판매 거래처를 위한 종합 주문관리 시스템입니다.
대리점과 일반 거래처의 차별화된 요구사항을 모두 충족하며, 
특히 40-60대 사용자의 디지털 접근성을 최우선으로 고려하여 설계되었습니다.

### 🎯 핵심 가치
- **간편한 주문 프로세스**: 3단계로 완료되는 직관적인 주문 시스템
- **실시간 재고 확인**: 공장/창고별 재고 현황 즉시 확인
- **자동화된 문서 처리**: 거래명세서 자동 생성 및 발송
- **차등 가격 시스템**: 회원 등급별 맞춤 단가 적용

## 🚀 프로젝트 현황

### 📊 개발 진행률
| 단계 | 상태 | 설명 |
|------|------|------|
| **Phase 1** | ✅ 완료 | 데모 모드 및 인증 시스템 |
| **Phase 2** | ✅ 완료 | 테스트 데이터 및 목업 |
| **Phase 3** | ✅ 완료 | 핵심 비즈니스 화면 (5/5) |
| **Phase 4** | 🔄 33% | 온보딩 시스템 (2/6) |
| **Phase 5** | ⏳ 대기 | PWA 빌드 및 배포 |

### ✨ 주요 기능
- 📝 **주문 관리**: 박스/벌크 제품 주문, 수정, 취소
- 📊 **재고 현황**: 실시간 재고 모니터링 대시보드
- 📄 **거래명세서**: PDF 생성 및 다운로드
- 🔔 **알림 시스템**: 주문 상태 변경 푸시 알림
- 👥 **회원 등급**: 대리점/일반 차등 가격 적용
- 🎓 **온보딩**: 단계별 사용 가이드

## 🛠️ 기술 스택

```yaml
Frontend:
  - Flutter: 3.32.5 (FVM)
  - State: Riverpod 2.5.1
  - UI: GetWidget 6.0.0
  - Architecture: Clean Architecture

Backend:
  - Platform: Supabase
  - Database: PostgreSQL
  - Realtime: WebSocket
  - Storage: Supabase Storage

Features:
  - Auth: 사업자번호 기반 인증
  - PDF: 거래명세서 생성
  - Push: FCM 알림
  - Offline: SharedPreferences

```

## 🚀 빠른 시작

### 필수 요구사항
- Flutter 3.32.5 이상
- Dart 3.0 이상
- FVM (Flutter Version Management)
- Git

### 설치 및 실행
```bash
# 1. 저장소 클론
git clone https://github.com/def-order/def-order-app.git
cd def-order-app

# 2. Flutter 버전 설정 (FVM)
fvm install 3.32.5
fvm use 3.32.5

# 3. 프로젝트 디렉토리 이동
cd def_order_app

# 4. 의존성 설치
fvm flutter pub get

# 5. 코드 생성
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 6. 데모 모드로 실행
fvm flutter run -d chrome --dart-define=IS_DEMO=true --web-port 5000
```

### 데모 계정
| 구분 | 이메일 | 비밀번호 | 특징 |
|------|--------|----------|------|
| 대리점 | dealer@demo.com | demo1234 | 특별 단가 |
| 일반 | general@demo.com | demo1234 | 표준 단가 |

## 📚 문서

프로젝트의 상세한 정보는 다음 문서를 참조하세요:

- 📱 [데모 가이드](./docs/DEMO.md) - 데모 시나리오 및 테스트
- 🛠️ [개발 가이드](./docs/DEVELOPMENT.md) - 개발 환경 및 명령어
- 🏗️ [아키텍처](./docs/ARCHITECTURE.md) - 시스템 설계 및 구조
- 💡 [SuperClaude 사용법](./docs/SC_USAGE.md) - SuperClaude 커맨드 가이드
- 🎯 [Flutter 전용 가이드](./docs/SC_USAGE_FLUTTER.md) - Flutter 특화 커맨드
- 🤖 [Claude Code 설정](./CLAUDE.md) - AI 도구 사용법

## 🗂️ 프로젝트 구조

```
DEF/
├── def_order_app/        # Flutter 애플리케이션
│   ├── lib/
│   │   ├── core/        # 공통 기능
│   │   └── features/    # Feature 모듈
│   │       ├── auth/    # 인증
│   │       ├── order/   # 주문
│   │       ├── history/ # 내역
│   │       └── ...
│   └── assets/          # 리소스
├── docs/                # 프로젝트 문서
├── planning/            # 기획 문서
└── specs/              # 요구사항 명세
```

## 👥 팀 & 기여

### 개발팀
- **프로젝트 매니저**: PM Team
- **Flutter 개발**: Mobile Team
- **백엔드**: Backend Team
- **UI/UX**: Design Team

### 기여 방법
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 지원 & 문의

- **기술 지원**: dev@def-order.com
- **영업 문의**: sales@def-order.com
- **버그 리포트**: [GitHub Issues](https://github.com/def-order/issues)

## 📄 라이선스

이 프로젝트는 비공개 상업용 라이선스 하에 있습니다.
무단 복제 및 배포를 금지합니다.

Copyright © 2025 DEF Order System. All rights reserved.

---

<div align="center">
  
**[🏠 홈페이지](https://def-order.com)** | 
**[📖 문서](./docs)** | 
**[🎮 데모](https://def-order-demo.web.app)**

</div>