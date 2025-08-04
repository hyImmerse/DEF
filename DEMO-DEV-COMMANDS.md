# DEF 요소수 주문관리 시스템 - 고객 데모 개발 명령어

## 🎯 고객 데모를 위한 필수 개발 단계

### 데모-1단계: 데모 모드 구현 ✅
```bash
# 데모 인증 Provider 구현 (Riverpod) ✅
/sc:implement "데모 모드 인증 시스템 - Riverpod Provider로 테스트 계정 자동 로그인" --persona-backend --c7 --seq

# 로그인 화면 수정 (GetWidget + VelocityX) ✅
/sc:implement "로그인 화면에 데모 시작하기 버튼 추가 - GetWidget UI 컴포넌트와 VelocityX 활용" --persona-frontend --c7 --validate
```

### 데모-2단계: 테스트 데이터 준비 ✅
```bash
# Supabase 테스트 데이터 시딩 스크립트 ✅
/sc:implement "Supabase 테스트 데이터 시딩 스크립트 - seed.sql 파일로 대리점/일반 거래처 데이터 생성" --persona-backend --c7 --seq

# 데모 시나리오 데이터 생성 ✅
/sc:implement "데모용 주문, 재고, 거래명세서 샘플 데이터 - 다양한 상태(대기/확정/완료)의 주문 데이터" --persona-backend --validate

# Flutter 앱에서 테스트 데이터 초기화 ✅
/sc:implement "데모 모드 초기 데이터 로더 - SharedPreferences로 최초 실행 감지" --persona-backend --c7
```

### 데모-3단계: 핵심 화면 구현 ✅
```bash
# 주문 등록 화면 ✅
/sc:implement "요소수 주문 등록 화면 - 박스/벌크 선택, 수량 입력, GetWidget + VelocityX" --persona-frontend --c7 --validate

# 주문 내역 화면 ✅
/sc:implement "주문 내역 조회 화면 - 필터링, 상태별 표시, 무한 스크롤" --persona-frontend --c7 --seq

# 거래명세서 화면 ✅
/sc:implement "거래명세서 PDF 뷰어 - pdf 패키지 사용, 다운로드 기능" --persona-frontend --c7 --validate

# 재고 현황 위젯 ✅
/sc:implement "실시간 재고 현황 대시보드 - Supabase Realtime 연동" --persona-backend --c7 --seq

# 공지사항 시스템 ✅
/sc:implement "공지사항 목록 및 상세 화면 - 긴급/일반 구분, 읽음 표시" --persona-frontend --c7
```

### 데모-4단계: 인터랙티브 온보딩 ← 현재 여기
```bash
# showcaseview 패키지 설정 및 기본 구조 ✅
/sc:implement "Flutter showcaseview 패키지 통합 - 화면별 온보딩 키 설정 및 Provider 구조" --persona-frontend --c7 --validate

# 홈 화면 온보딩 오버레이
/sc:implement "홈 화면 온보딩 가이드 - '새 주문' 버튼 하이라이트, GetWidget + VelocityX 스타일링" --persona-frontend --c7 --magic

# 주문 화면 단계별 온보딩
/sc:implement "주문 화면 3단계 온보딩 - 제품선택→수량입력→배송정보 순차적 가이드" --persona-frontend --seq --validate

# 스마트 툴팁 시스템 (Riverpod 상태 관리)
/sc:implement "컨텍스트 인식 툴팁 - 3초 대기 감지, 40-60대 최적화 큰 글씨" --persona-frontend --c7 --seq --think

# 온보딩 진행률 표시 (VelocityX)
/sc:implement "온보딩 진행률 바 - 상단 고정, 현재/전체 단계 표시, 건너뛰기 옵션" --persona-frontend --persona-mentor --c7

# SharedPreferences 온보딩 상태 저장
/sc:implement "온보딩 완료 상태 관리 - 화면별 완료 여부 저장, 재접속시 스킵" --persona-backend --c7
```

### 데모-5단계: PWA 빌드 및 배포
```bash
# GitHub Actions 워크플로우 설정
/sc:implement "GitHub Actions Flutter Web 빌드 파이프라인 - main 브랜치 푸시시 자동 빌드" --persona-devops --c7 --seq

# PWA 매니페스트 및 서비스 워커
/sc:implement "Flutter PWA 매니페스트 - 앱 아이콘, 오프라인 지원, 설치 가능" --persona-frontend --c7 --validate

# Firebase Hosting 설정
/sc:implement "Firebase Hosting 설정 - firebase.json, 자동 배포 연동" --persona-devops --validate

# 환경 변수 및 보안 설정
/sc:implement "GitHub Secrets 설정 - Supabase 키, Firebase 토큰 안전 관리" --persona-security --seq

# 빌드 최적화
/sc:build --production --target web --persona-devops --validate
```

## 🚀 실행 명령어

### 로컬 실행
```bash
# Flutter 버전 설정
fvm use 3.32.5

# 의존성 설치
fvm flutter pub get

# 코드 생성
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 웹 실행 (데모 모드)
fvm flutter run -d chrome --dart-define=IS_DEMO=true
```

### 빌드 및 배포
```bash
# PWA 빌드
fvm flutter build web --release --dart-define=IS_DEMO=true

# Firebase 배포 (수동)
firebase deploy --only hosting
```

## 📌 구현 우선순위

1. **데모-2단계**: 테스트 데이터 (화면에 표시할 샘플 데이터)
2. **데모-3단계**: 핵심 화면 (고객이 실제로 테스트할 화면)
3. **데모-4단계**: 온보딩 (처음 사용하는 고객 안내)
4. **데모-5단계**: 배포 (실제 접속 가능한 링크)

## ✅ 완료 상태
- [x] 데모-1단계: 데모 모드 구현
- [x] 데모-2단계: 테스트 데이터 준비
- [x] 데모-3단계: 핵심 화면 구현 (5/5 완료)
  - [x] 주문 등록 화면 (Enhanced)
  - [x] 주문 내역 화면 (Enhanced) 
  - [x] 거래명세서 PDF 뷰어
  - [x] 실시간 재고 현황 대시보드
  - [x] 공지사항 시스템 (Enhanced - 40-60대 최적화)
- [ ] 데모-4단계: 인터랙티브 온보딩
- [ ] 데모-5단계: PWA 빌드 및 배포