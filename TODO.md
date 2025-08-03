# 요소수 판매 거래처 출고주문관리 앱 개발 TODO

## 프로젝트 개요
- **프로젝트명**: 요소수 판매 거래처용 출고주문관리 하이브리드앱
- **기술 스택**: Flutter + Supabase + MCP + Riverpod/BLoC + GetWidget + VelocityX
- **대상**: 대리점 및 일반 거래처 (40~60대 사용자)
- **플랫폼**: Android/iOS 하이브리드앱 + 관리자용 PC웹

## 개발 단계별 SuperClaude 커맨드

### 📋 1단계: 프로젝트 초기화 및 분석 (1주차) ✅

```bash
# 1.1 프로젝트 요구사항 분석 및 컨텍스트 로딩 ✅
/sc:load @요소컴케이엠(주)_출고주문관리앱제작.xlsx

# 1.2 시스템 아키텍처 설계 (Flutter + Supabase) ✅
/sc:design "Clean Architecture 기반 폴더 구조, Feature-first 모듈 설계, Supabase 스키마 설계" --scope system --persona-architect --c7 --seq

# 1.3 개발 워크플로우 수립 ✅
/sc:workflow "스프린트 계획 수립, 마일스톤 설정, 리스크 분석" --from-requirements --persona-architect
```

### 🏗️ 2단계: 핵심 인프라 구축 (1-2주차) ✅

```bash
# 2.1 Flutter 프로젝트 생성 및 기본 설정 ✅
/sc:implement "Flutter 3.x 프로젝트 생성, 필수 패키지 설정 (Riverpod, Supabase, GetWidget, VelocityX), 플랫폼별 설정 (Android/iOS)" --persona-backend --c7
# ✅ Flutter 3.32.5 (FVM) 프로젝트 생성 완료
# ✅ 필수 패키지 추가 (GetWidget 6.0.0 업데이트)
# ✅ Android/iOS 플랫폼 설정 (권한, 앱 이름)
# ✅ Clean Architecture 기본 구조 생성
# ✅ 40-60대 사용자를 위한 테마 설정

# 2.2 Supabase 백엔드 구축 ✅
/sc:implement "테이블 설계 (users, orders, products, inventory, notices), Row Level Security (RLS) 정책 설정, Edge Functions 구성" --persona-backend --c7 --seq
# ✅ 10개 테이블 설계 완료 (profiles, orders, products, inventory, notices 등)
# ✅ Row Level Security (RLS) 모든 테이블에 활성화
# ✅ Edge Functions 구성 (process-order, send-notification, validate-business-number)
# ✅ 데이터베이스 마이그레이션 파일 생성
# ✅ Supabase 클라이언트 설정 및 서비스 레이어 구현

# 2.3 인증 시스템 구현 ✅
/sc:implement "사업자번호 기반 인증 시스템 - Supabase Auth 커스터마이징, 사업자번호 검증 로직, 회원 등급 시스템 (대리점/일반)" --persona-security --c7 --seq --validate
# ✅ 사업자번호 검증 Edge Function 구현 (체크섬 알고리즘)
# ✅ Supabase Auth 커스터마이징 (PKCE flow, 자동 토큰 갱신)
# ✅ 회원 등급 시스템 구현 (dealer/general, pending/approved/rejected/inactive)
# ✅ 로그인/회원가입/비밀번호 재설정 화면 구현
# ✅ 보안 검증 완료 (RLS, 권한 분리, 40-60대 사용자 UX)
```

### 🎨 3단계: 모바일 앱 UI/UX 개발 (2-3주차)

```bash
# 3.1 디자인 시스템 및 테마 설정
/sc:implement "Flutter 디자인 시스템 - GetWidget 테마 설정, VelocityX 유틸리티 설정, 40-60대 사용자를 위한 큰 폰트/버튼" --persona-frontend --c7 --validate

# 3.2 인증 화면 구현
/sc:implement "로그인/회원가입 화면 - 사업자번호 입력 UI, 비밀번호 재설정 플로우, 관리자 승인 대기 화면" --persona-frontend --c7 --seq

# 3.3 주문 관리 화면
/sc:implement "주문 등록 화면 - 박스/벌크 선택 UI, 자바라 수량 입력, 출고일 선택 (달력), 배송 정보 입력" --persona-frontend --c7 --wave-mode progressive

# 3.4 주문 내역 화면
/sc:implement "주문 내역 조회 화면 - 기간별 필터링, 상태별 표시 (대기/확정/완료), 거래명세서 PDF 뷰어" --persona-frontend --c7 --seq
```

### 💼 4단계: 비즈니스 로직 구현 (3-4주차)

```bash
# 4.1 상태 관리 설정 (Riverpod)
/sc:implement "Riverpod 상태 관리 아키텍처 - Provider 구조 설계, AsyncNotifier 패턴, 에러 처리 전략" --persona-backend --c7 --seq

# 4.2 주문 도메인 로직
/sc:implement "주문 비즈니스 로직 - 주문 CRUD 기능, 재고 확인 로직, 단가 계산 (등급별)" --persona-backend --c7 --seq --validate

# 4.3 푸시 알림 시스템
/sc:implement "FCM 푸시 알림 - 주문 상태 변경 알림, 공지사항 알림, 플랫폼별 설정" --persona-backend --c7 --seq

# 4.4 PDF 생성 및 이메일 발송
/sc:implement "거래명세서 PDF 생성 - PDF 템플릿 설계, Supabase Storage 연동, 이메일 발송 기능" --persona-backend --c7 --seq
```

### 🖥️ 5단계: 관리자 웹 개발 (4-5주차)

```bash
# 5.1 React 관리자 웹 설정
/sc:implement "React 관리자 대시보드 - React + TypeScript 설정, CoreUI 또는 React Admin 설정, Supabase 연동" --persona-frontend --c7 --seq

# 5.2 관리자 기능 구현
/sc:implement "관리자 핵심 기능 - 회원 관리 (승인/거절/단가설정), 주문 통합 관리, 재고 관리 (공장/창고), 통계 대시보드" --persona-backend --c7 --wave-mode systematic

# 5.3 공지사항 시스템
/sc:implement "공지사항 관리 시스템 - 공지 작성/편집, 대상 선택 (대리점/일반), 푸시 알림 연동" --persona-backend --c7
```

### 🔒 6단계: 보안 및 최적화 (5-6주차)

```bash
# 6.1 보안 강화
/sc:analyze "단가 정보 보안, API 엔드포인트 보호, 데이터 암호화" --focus security --persona-security --seq --ultrathink

# 6.2 성능 최적화
/sc:improve "리스트 가상화, 이미지 최적화, API 호출 최적화" --focus performance --persona-performance --c7 --loop

# 6.3 접근성 개선 (40-60대 사용자)
/sc:improve "폰트 크기 조절, 대비 개선, 터치 영역 확대" --focus accessibility --persona-frontend --c7
```

### 🧪 7단계: 테스트 및 QA (6주차)

```bash
# 7.1 단위 테스트
/sc:test "비즈니스 로직 테스트, 상태 관리 테스트" --type unit --persona-qa --validate

# 7.2 통합 테스트
/sc:test "API 통합 테스트, Supabase 연동 테스트" --type integration --persona-qa --seq

# 7.3 E2E 테스트
/sc:test "주요 사용자 시나리오, 크로스 플랫폼 테스트" --type e2e --persona-qa --play

# 7.4 사용성 테스트
/sc:analyze "40-60대 사용자 그룹 테스트, UI/UX 피드백 수집" --focus usability --persona-frontend --seq
```

### 📦 8단계: 배포 준비 (7주차)

```bash
# 8.1 프로덕션 빌드
/sc:build "Android APK/AAB 빌드, iOS IPA 빌드, 웹 빌드 최적화" --production --target mobile --persona-devops --validate

# 8.2 배포 자동화
/sc:implement "CI/CD 파이프라인 - GitHub Actions 설정, 자동 빌드/테스트, 스토어 배포 준비" --persona-devops --c7

# 8.3 모니터링 설정
/sc:implement "앱 모니터링 - 크래시 리포팅, 성능 모니터링, 사용자 분석" --persona-devops --c7
```

### 📚 9단계: 문서화 및 인수인계 (7-8주차)

```bash
# 9.1 기술 문서 작성
/sc:document "API 문서, 데이터베이스 스키마, 배포 가이드" --focus technical --persona-scribe=ko

# 9.2 사용자 매뉴얼
/sc:document "거래처용 사용 가이드, 관리자용 매뉴얼, FAQ" --focus user-guide --persona-mentor --persona-scribe=ko

# 9.3 유지보수 가이드
/sc:document "코드 구조 설명, 확장 가이드, 트러블슈팅" --focus maintenance --persona-architect
```

## 🎯 핵심 포인트

### 기술적 고려사항
- **Supabase RLS**: 거래처별 데이터 격리
- **단가 보안**: 권한별 접근 제어
- **오프라인 지원**: 주문 임시 저장
- **플랫폼 최적화**: Android/iOS 네이티브 기능 활용

### UX 고려사항 (40-60대 사용자)
- **큰 터치 영역**: 최소 48dp
- **명확한 폰트**: 16sp 이상
- **단순한 플로우**: 3단계 이내 완료
- **시각적 피드백**: 명확한 상태 표시

### 확장 가능성
- **ERP 연동**: API 인터페이스 준비
- **홈택스 연동**: 세금계산서 자동화
- **다중 제품**: 제품 확장 구조

## 📊 예상 일정
- **총 개발 기간**: 7-8주
- **MVP 완성**: 4-5주
- **QA 및 안정화**: 2-3주
- **문서화 및 인수**: 1주

## 🚀 진행 현황 (2025-01-08 기준)
### 완료된 작업
- ✅ 1단계: 프로젝트 초기화 및 분석 (100%)
  - 요구사항 분석 완료
  - 시스템 아키텍처 설계 완료 (Clean Architecture)
  - 개발 워크플로우 수립 완료 (5개 스프린트, 6개 마일스톤)
  
- ✅ 2단계: 핵심 인프라 구축 (100%)
  - 2.1: Flutter 프로젝트 기본 설정
    - Flutter 3.32.5 with FVM 설정
    - 필수 패키지 설치 (GetWidget 6.0.0)
    - Android/iOS 플랫폼 설정
    - Clean Architecture 폴더 구조 생성
    - 40-60대 사용자를 위한 UX 테마 적용
  - 2.2: Supabase 백엔드 구축
    - 10개 테이블 스키마 설계 및 마이그레이션
    - Row Level Security (RLS) 정책 설정
    - Edge Functions 3개 구현 (주문처리, 알림, 사업자번호검증)
    - Freezed 모델 및 서비스 레이어 구현
  - 2.3: 인증 시스템 구현
    - 사업자번호 기반 인증 로직
    - 회원 등급 시스템 (dealer/general)
    - 승인 상태 관리 (pending/approved/rejected/inactive)
    - 인증 관련 UI 화면 3개 구현
    - 보안 검증 문서 작성

### 다음 작업
- ⏳ 3단계: 모바일 앱 UI/UX 개발
  - 3.1: 디자인 시스템 및 테마 설정
  - 3.2: 인증 화면 구현 (추가 개선)
  - 3.3: 주문 관리 화면
  - 3.4: 주문 내역 화면

## 💰 리소스 배분
- **모바일 앱 개발**: 40%
- **관리자 웹 개발**: 25%
- **백엔드/인프라**: 20%
- **테스트/QA**: 10%
- **문서화/교육**: 5%