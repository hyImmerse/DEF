# SuperClaude 커맨드 사용 가이드

SuperClaude는 Claude Code의 확장된 명령어 시스템으로, 프로젝트 개발의 전체 라이프사이클에서 사용할 수 있는 강력한 도구입니다.

## 📋 목차
- [프로젝트 개발 단계별 워크플로우](#프로젝트-개발-단계별-워크플로우)
- [SuperClaude 커맨드 분류](#superclaude-커맨드-분류)
- [페르소나 시스템](#페르소나-시스템)
- [상세 커맨드 가이드](#상세-커맨드-가이드)
- [실전 예시](#실전-예시)

## 🚀 프로젝트 개발 단계별 워크플로우

### 1단계: 프로젝트 초기화 (빈 프로젝트 → 기본 구조)

```bash
# 프로젝트 분석 및 컨텍스트 로딩
/sc:load

# 프로젝트 요구사항 분석 및 아키텍처 설계
/sc:design --scope system --persona-architect

# 개발 계획 수립
/sc:workflow --from-requirements
```

### 2단계: 핵심 기능 구현

```bash
# 백엔드 API 구현
/sc:implement "사용자 인증 시스템" --persona-backend --c7

# 프론트엔드 컴포넌트 구현
/sc:implement "대시보드 UI" --persona-frontend --magic

# 데이터베이스 설계 및 구현
/sc:implement "데이터 모델링" --persona-backend --seq
```

### 3단계: 품질 보증

```bash
# 코드 품질 분석
/sc:analyze --focus quality --persona-refactorer

# 보안 분석
/sc:analyze --focus security --persona-security

# 성능 최적화
/sc:improve --focus performance --persona-performance
```

### 4단계: 테스트 및 검증

```bash
# 테스트 구현 및 실행
/sc:test --type unit --persona-qa

# E2E 테스트
/sc:test --type e2e --play

# 테스트 커버리지 확인
/sc:test --coverage --persona-qa
```

### 5단계: 문서화

```bash
# API 문서 생성
/sc:document --focus api --persona-scribe=ko

# 사용자 가이드 작성
/sc:document --focus user-guide --persona-mentor

# 프로젝트 전체 문서화
/sc:index --comprehensive
```

### 6단계: 배포 준비

```bash
# 빌드 및 패키징
/sc:build --production --validate

# 배포 스크립트 준비
/sc:implement "CI/CD 파이프라인" --persona-devops

# 프로덕션 체크리스트
/sc:analyze --focus production-ready
```

## 🎯 SuperClaude 커맨드 분류

### 개발 & 구현
- **`/sc:implement`**: 기능 구현 및 코드 작성
- **`/sc:build`**: 빌드, 컴파일, 패키징
- **`/sc:design`**: 시스템 아키텍처 및 API 설계
- **`/sc:workflow`**: 구조화된 구현 워크플로우 생성

### 분석 & 품질
- **`/sc:analyze`**: 코드 품질, 보안, 성능 분석
- **`/sc:improve`**: 체계적인 품질 개선
- **`/sc:cleanup`**: 코드 정리 및 최적화
- **`/sc:troubleshoot`**: 문제 진단 및 해결

### 테스트 & 검증
- **`/sc:test`**: 테스트 실행 및 커버리지 관리
- **`/sc:estimate`**: 개발 시간 및 복잡도 추정

### 문서화 & 지식관리
- **`/sc:document`**: 특정 컴포넌트 문서화
- **`/sc:index`**: 종합적인 프로젝트 문서 생성
- **`/sc:explain`**: 코드 및 개념 설명

### 프로젝트 관리
- **`/sc:load`**: 프로젝트 컨텍스트 분석
- **`/sc:task`**: 복잡한 작업 관리
- **`/sc:spawn`**: 작업 분할 및 병렬 실행
- **`/sc:git`**: Git 워크플로우 관리

## 👥 페르소나 시스템

SuperClaude는 11개의 전문 페르소나를 제공합니다:

### 기술 전문가
- **`--persona-architect`**: 시스템 아키텍처 전문가
  - 장기적 관점의 설계
  - 확장성과 유지보수성 중시
  - 의존성 관리 및 모듈화

- **`--persona-frontend`**: UI/UX 전문가
  - 사용자 중심 설계
  - 접근성 및 성능 최적화
  - 반응형 디자인

- **`--persona-backend`**: 서버 및 인프라 전문가
  - 안정성과 보안 중시
  - API 설계 및 데이터 무결성
  - 확장 가능한 서버 아키텍처

- **`--persona-security`**: 보안 전문가
  - 위협 모델링
  - 취약점 분석
  - 보안 표준 준수

- **`--persona-performance`**: 성능 최적화 전문가
  - 병목 지점 식별
  - 측정 기반 최적화
  - 사용자 경험 개선

### 프로세스 & 품질 전문가
- **`--persona-analyzer`**: 근본 원인 분석 전문가
  - 체계적 문제 해결
  - 증거 기반 분석
  - 패턴 인식

- **`--persona-qa`**: 품질 보증 전문가
  - 포괄적 테스트 전략
  - 위험 기반 테스트
  - 품질 게이트 관리

- **`--persona-refactorer`**: 코드 품질 전문가
  - 기술 부채 관리
  - 코드 단순화
  - 유지보수성 개선

- **`--persona-devops`**: 인프라 및 배포 전문가
  - 자동화 우선
  - 모니터링 및 관찰성
  - 안정적인 배포

### 지식 & 커뮤니케이션
- **`--persona-mentor`**: 교육 및 지식 전달 전문가
  - 단계별 학습 가이드
  - 개념 설명 및 예시
  - 스킬 개발 지원

- **`--persona-scribe=lang`**: 전문 문서 작성자
  - 명확한 기술 문서
  - 다국어 지원 (ko, en, ja 등)
  - 문화적 맥락 고려

### 페르소나 자동 활성화
SuperClaude는 컨텍스트에 따라 적절한 페르소나를 자동으로 활성화합니다:
- UI 컴포넌트 작업 → `--persona-frontend` + `--magic`
- API 구현 → `--persona-backend` + `--c7`
- 보안 분석 → `--persona-security` + `--seq`
- 성능 문제 → `--persona-performance` + `--think`

## 📖 상세 커맨드 가이드

### /sc:implement
**목적**: 기능 및 코드 구현
**특징**: 지능적 페르소나 활성화, MCP 통합

```bash
# 기본 사용법
/sc:implement "로그인 기능 구현"

# 페르소나 지정
/sc:implement "REST API 엔드포인트" --persona-backend

# MCP 서버 활용
/sc:implement "React 컴포넌트" --magic --c7

# 복잡한 시스템 구현 (Wave 모드 자동 활성화)
/sc:implement "전체 인증 시스템" --wave-mode progressive
```

### /sc:analyze
**목적**: 종합적인 코드 및 시스템 분석
**특징**: 다차원 분석, Wave 지원

```bash
# 전체 시스템 분석
/sc:analyze --comprehensive --persona-architect

# 보안 중심 분석
/sc:analyze --focus security --persona-security

# 성능 분석
/sc:analyze --focus performance --think-hard

# 대규모 코드베이스 분석 (자동 위임)
/sc:analyze @monorepo/ --delegate --parallel-dirs
```

### /sc:improve
**목적**: 체계적 품질 개선
**특징**: 반복적 개선, 검증된 향상

```bash
# 코드 품질 개선
/sc:improve --focus quality --persona-refactorer

# 성능 최적화
/sc:improve --focus performance --loop

# 반복적 개선
/sc:improve --iterations 5 --interactive

# 대규모 개선 (Wave 모드)
/sc:improve --wave-mode systematic --wave-validation
```

### /sc:build
**목적**: 빌드, 컴파일, 패키징
**특징**: 프레임워크 자동 감지, 에러 처리

```bash
# 기본 빌드
/sc:build

# 프로덕션 빌드
/sc:build --production --validate

# 특정 타겟 빌드
/sc:build --target backend --persona-backend

# UI 빌드 최적화
/sc:build --target frontend --persona-frontend --magic
```

### /sc:test
**목적**: 테스트 실행 및 관리
**특징**: 다양한 테스트 타입, 커버리지

```bash
# 전체 테스트
/sc:test --persona-qa

# 단위 테스트만
/sc:test --type unit

# E2E 테스트
/sc:test --type e2e --play

# 커버리지 포함
/sc:test --coverage --validate
```

### /sc:document
**목적**: 문서 생성
**특징**: 다국어 지원, 자동 생성

```bash
# API 문서
/sc:document --focus api --persona-scribe=ko

# 사용자 가이드
/sc:document --focus user-guide --persona-mentor

# 아키텍처 문서
/sc:document --focus architecture --persona-architect
```

## 💡 실전 예시

### 1. 새 프로젝트 시작하기
```bash
# 1. 프로젝트 요구사항 분석
/sc:load @requirements.md

# 2. 시스템 아키텍처 설계
/sc:design --scope system --persona-architect --c7

# 3. 개발 워크플로우 생성
/sc:workflow --from-requirements --persona-architect
```

### 2. 복잡한 기능 구현
```bash
# 1. 결제 시스템 구현 (자동으로 Wave 모드 활성화)
/sc:implement "결제 시스템 - 카드/계좌이체/간편결제 지원" --persona-backend --c7

# 2. 보안 검증
/sc:analyze --focus security --persona-security --seq

# 3. 테스트 구현
/sc:test --type integration --persona-qa --play
```

### 3. 레거시 코드 개선
```bash
# 1. 전체 분석
/sc:analyze --comprehensive --persona-analyzer --seq

# 2. 점진적 개선
/sc:improve --wave-mode progressive --persona-refactorer

# 3. 리팩토링 후 검증
/sc:test --regression --persona-qa
```

### 4. 프로덕션 배포 준비
```bash
# 1. 프로덕션 준비 상태 체크
/sc:analyze --focus production-ready --persona-devops

# 2. 성능 최적화
/sc:improve --focus performance --persona-performance

# 3. 최종 빌드 및 검증
/sc:build --production --validate --persona-devops
```

## ⚡ 고급 기능

### Wave 모드 (복잡한 작업 자동 관리)
- **자동 활성화**: 복잡도 ≥0.7, 파일 수 >20, 작업 유형 >2
- **수동 활성화**: `--wave-mode progressive|systematic|adaptive`
- **검증 모드**: `--wave-validation` (중요한 작업용)

### 작업 위임 시스템
- **자동 위임**: 디렉토리 수 >7 또는 파일 수 >50
- **수동 위임**: `--delegate files|folders|auto`
- **병렬 처리**: `--concurrency [n]`

### MCP 서버 통합
- **Context7**: `--c7` (라이브러리 문서)
- **Sequential**: `--seq` (복잡한 분석)
- **Magic**: `--magic` (UI 컴포넌트)
- **Playwright**: `--play` (브라우저 자동화)

### 🎨 Flutter UI 작업 전용 옵션 조합

#### Flutter UI 컴포넌트 구현 최적 조합
```bash
# 🥇 최고 추천: Flutter 위젯 + Material/Cupertino 패턴
/sc:implement "Flutter 스플래시 화면" --persona-frontend --c7 --validate

# 🥈 복잡한 Flutter UI 시스템
/sc:implement "Flutter 전체 UI 시스템" --persona-frontend --c7 --seq --wave-mode progressive

# 🥉 성능 중심 Flutter UI
/sc:implement "Flutter 고성능 UI" --persona-frontend --c7 --focus performance --think

# 🏅 테스트 포함 Flutter UI 개발
/sc:implement "Flutter UI 컴포넌트" --persona-frontend --c7 --seq --validate
```

#### Flutter UI 작업별 최적 옵션
- **Material Design 3**: `--c7 --validate` (공식 Material 위젯)
- **Cupertino (iOS 스타일)**: `--c7 --persona-frontend` (iOS 디자인)
- **커스텀 위젯**: `--c7 --seq` (CustomPainter, 애니메이션)
- **반응형 레이아웃**: `--c7 --think --focus performance`
- **상태 관리 UI**: `--c7 --seq --validate` (Riverpod 통합)
- **플랫폼별 분기**: `--c7 --think` (Platform adaptive)

#### Flutter 빌드 및 성능 옵션
```bash
# Flutter 개발 빌드
/sc:build --target mobile --persona-frontend --c7

# Flutter UI 성능 분석
/sc:analyze --focus performance --persona-frontend --think-hard

# Flutter UI 성능 개선
/sc:improve --focus performance --persona-frontend --c7 --loop
```

#### Flutter UI 프레임워크 및 패키지 활용
```bash
# Material Design 3 컴포넌트
/sc:implement "Material 3 Navigation Drawer" --c7 --persona-frontend

# Cupertino 위젯 (iOS 스타일)
/sc:implement "Cupertino Tab Bar" --c7 --persona-frontend

# 인기 UI 패키지 활용
/sc:implement "auto_size_text 위젯" --c7 --validate
/sc:implement "flutter_staggered_grid_view 그리드" --c7 --seq
/sc:implement "liquid_pull_to_refresh 새로고침" --c7 --persona-frontend
```

## 📱 Flutter 특화 가이드

### Flutter에서 주로 사용하는 UI 프레임워크 및 패키지

#### 🎯 공식 UI 프레임워크
1. **Material Design (material.dart)**
   - Google의 디자인 시스템
   - Android 스타일의 위젯과 테마
   - Material 3 (Material You) 지원
   
2. **Cupertino (cupertino.dart)**
   - Apple의 iOS 디자인 가이드라인
   - iOS 네이티브 스타일 위젯
   - 플랫폼별 적응형 UI 구현

#### 📦 인기 UI 패키지
1. **레이아웃 & 구조**
   - `flutter_staggered_grid_view`: Pinterest 스타일 그리드
   - `flutter_platform_widgets`: 플랫폼 적응형 위젯
   - `responsive_framework`: 반응형 레이아웃

2. **네비게이션 & 바텀바**
   - `fancy_bottom_navigation`: 애니메이션 바텀 네비게이션
   - `bubble_bottom_bar`: 버블 스타일 바텀바
   - `flutter_speed_dial`: Material FAB 확장

3. **텍스트 & 입력**
   - `auto_size_text`: 자동 크기 조절 텍스트
   - `flutter_tags`: 태그 입력 위젯
   - `zefyr`: 리치 텍스트 에디터

4. **리스트 & 스크롤**
   - `liquid_pull_to_refresh`: 액체 효과 새로고침
   - `sticky_headers`: 고정 헤더 리스트
   - `infinite_listview`: 무한 스크롤

5. **애니메이션 & 전환**
   - `folding_cell`: 접히는 셀 애니메이션
   - `flutter_fluid_slider`: 유동적 슬라이더
   - `animations`: 공식 애니메이션 패키지

6. **상태 관리와 UI 통합**
   - `flutter_riverpod`: 반응형 UI 상태 관리
   - `flutter_hooks`: React Hook 스타일 위젯
   - `flutter_bloc`: BLoC 패턴 구현

### Flutter 프로젝트 개발 워크플로우
```bash
# 1. Flutter 프로젝트 구조 분석
/sc:load @CLAUDE.md

# 2. Clean Architecture 기반 feature 설계
/sc:design --scope feature --persona-architect --c7

# 3. Riverpod 상태 관리 구현
/sc:implement "Riverpod StateNotifier" --persona-backend --c7 --seq

# 4. Flutter UI 컴포넌트 구현
/sc:implement "Flutter 위젯" --persona-frontend --magic --c7 --validate
```

### Flutter 개발 단계별 최적 명령어

#### 🏗️ 아키텍처 및 설계
```bash
# Feature-First 아키텍처 설계
/sc:design "Clean Architecture feature 구조" --persona-architect --c7

# 도메인 엔티티 및 유스케이스 설계
/sc:implement "도메인 레이어 구현" --persona-backend --seq --validate
```

#### 🎨 UI/UX 개발
```bash
# 스플래시 화면 (@specs/image 참조 필수)
/sc:implement "Flutter 스플래시 화면 - @specs/image/폴더명/파일명.png 참조" --persona-frontend --magic --c7 --validate

# 복합 화면 (지도, 리스트 등)
/sc:implement "복합 UI 화면" --persona-frontend --magic --wave-mode progressive

# 반응형 디자인
/sc:implement "반응형 위젯" --persona-frontend --magic --focus performance

# 애니메이션 및 전환 효과
/sc:implement "Flutter 애니메이션" --persona-frontend --magic --c7
```

#### 🔄 상태 관리 (Riverpod)
```bash
# Provider 및 StateNotifier
/sc:implement "Riverpod Provider" --persona-backend --c7 --seq

# AsyncValue 및 에러 처리
/sc:implement "비동기 상태 관리" --persona-backend --seq --validate

# 상태 관리 리팩토링 (Provider → Riverpod)
/sc:improve "상태 관리 마이그레이션" --persona-refactorer --seq --wave-mode progressive
```

#### 🗺️ 지도 기능 (Kakao Map)
```bash
# 지도 기본 구현
/sc:implement "Kakao Map 통합" --persona-frontend --magic --c7 --focus performance

# 매물 마커 및 클러스터링
/sc:implement "지도 마커 시스템" --persona-frontend --magic --c7 --validate

# 위치 기반 검색
/sc:implement "위치 기반 매물 검색" --persona-backend --c7 --seq
```

#### 🔐 데이터 레이어
```bash
# Repository 패턴 구현
/sc:implement "Repository 인터페이스" --persona-backend --seq --validate

# API 통신 (Dio)
/sc:implement "REST API 클라이언트" --persona-backend --c7 --seq

# 로컬 데이터베이스 (Isar/Drift)
/sc:implement "로컬 DB 스키마" --persona-backend --c7 --validate
```

#### 🧪 테스트
```bash
# 위젯 테스트
/sc:test --type widget --persona-qa --play

# 단위 테스트 (도메인 로직)
/sc:test --type unit --persona-qa --validate

# 통합 테스트 (API, DB)
/sc:test --type integration --persona-qa --seq
```

#### 📦 빌드 및 배포
```bash
# Flutter 개발 빌드
/sc:build --target mobile --persona-frontend --magic

# 프로덕션 빌드 (Android/iOS)
/sc:build --production --target mobile --persona-devops --validate

# 성능 프로파일링
/sc:analyze --focus performance --persona-performance --think-hard
```

### Flutter 특화 베스트 프랙티스

#### 💡 개발 원칙
- **디자인 참조 필수**: UI 작업 시 `@specs/image/` 경로 포함
- **Clean Architecture**: feature 단위 개발
- **상태 관리**: Provider보다 Riverpod 우선 사용
- **플랫폼 분기**: 웹은 Placeholder, 모바일은 네이티브 구현
- **코드 생성**: Freezed 모델 수정 후 `build_runner` 실행

#### 🔄 개발 사이클
```bash
# 1. 요구사항 → 설계
/sc:design "feature 아키텍처" --persona-architect --c7

# 2. 도메인 → 데이터 → 프레젠테이션 순서 구현
/sc:implement "도메인 레이어" --persona-backend --seq
/sc:implement "데이터 레이어" --persona-backend --c7
/sc:implement "UI 레이어" --persona-frontend --magic --c7

# 3. 테스트 → 성능 → 배포
/sc:test --comprehensive --persona-qa
/sc:improve --focus performance --persona-performance
/sc:build --production --validate --persona-devops
```

## 🔧 유용한 팁

1. **명령어 조합**: 여러 플래그를 조합해서 최적의 결과 얻기
2. **자동 활성화 활용**: 키워드 기반 자동 페르소나 활성화 이용
3. **점진적 접근**: 복잡한 작업은 단계별로 나누어 진행
4. **검증 습관화**: `--validate` 플래그로 품질 보장
5. **문서화 병행**: 구현과 동시에 문서 작성
6. **Flutter 특화**: `--c7` 중심으로 Flutter 공식 패턴 활용
7. **이미지 참조**: UI 작업 시 `@specs/image/` 경로 필수 포함

## 🚀 Flutter UI 개발 최적 전략

### Magic 대신 Context7 사용 이유
- **Magic**: React/Vue/Angular에 최적화된 웹 프레임워크용
- **Context7**: Flutter 공식 문서 및 패턴 제공
- **Sequential**: 복잡한 Flutter 위젯 로직 분석

### Flutter UI 개발 추천 워크플로우
1. **디자인 참조**: `@specs/image/` 폴더의 디자인 확인
2. **패턴 검색**: `--c7`로 Flutter 공식 위젯 패턴 확인
3. **구현**: 네이티브 도구로 Flutter 위젯 생성
4. **최적화**: `--seq --think`로 성능 및 상태 관리 최적화
5. **검증**: `--validate`로 코드 품질 확인

SuperClaude는 Flutter 프로젝트에 최적화된 개발 도구로, Context7과 Sequential을 중심으로 Flutter 특화 개발을 지원합니다.