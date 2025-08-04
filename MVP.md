# DEF 요소수 주문관리 시스템 PWA 데모

## 🎯 프로젝트 개요

요소수 판매 거래처(대리점/일반)용 출고주문관리 시스템의 PWA 데모 버전입니다.
고객이 회원가입 과정 없이 주요 기능을 테스트할 수 있도록 구성되었습니다.

**개발 스택**: Flutter + Supabase + MCP + Riverpod + GetWidget + VelocityX로 빠른 MVP 개발

## 📱 데모 접속 정보

### 데모 URL
- **PWA 링크**: https://def-order-demo.web.app (예정)
- **QR 코드**: 모바일 테스트용 QR 코드 제공 예정

### 테스트 계정
1. **대리점 계정**
   - ID: dealer@demo.com
   - PW: demo1234
   - 특징: 특별 단가, 전체 기능 접근

2. **일반 거래처 계정**
   - ID: general@demo.com
   - PW: demo1234
   - 특징: 표준 단가, 제한된 기능

### 빠른 시작 (데모 모드)
- 로그인 화면의 "데모 시작하기" 버튼 클릭
- 대리점/일반 중 선택
- 자동 로그인 후 주요 기능 테스트

## 🎯 인터랙티브 온보딩 시스템

### 온보딩 오버레이 특징
데모 버전은 모바일 앱에서 흔히 볼 수 있는 인터랙티브 온보딩 시스템을 제공합니다:

1. **화면별 단계적 가이드**
   - 각 화면 첫 진입 시 자동으로 오버레이 표시
   - 중요 버튼과 기능을 하이라이트로 강조
   - 간단한 설명과 함께 "다음" 버튼으로 진행

2. **스마트 툴팁**
   - 사용자가 헤매는 것을 감지하면 자동으로 도움말 표시
   - 3초 이상 화면에 머물면 핵심 기능 안내
   - 터치하면 사라지는 간단한 말풍선 형태

3. **진행률 표시**
   - 화면 상단에 작은 진행률 바
   - 현재 단계 / 전체 단계 표시
   - "건너뛰기" 옵션 제공

4. **40-60대 최적화**
   - 큰 글씨 (20sp 이상)
   - 고대비 색상 (검정 배경에 흰색 텍스트)
   - 천천히 진행되는 애니메이션
   - 명확한 아이콘과 화살표

### 온보딩 시나리오 예시

#### 홈 화면 온보딩
```
[어두운 오버레이가 화면을 덮고, "새 주문" 버튼만 밝게 표시]

💡 "요소수를 주문하시려면 
    이 버튼을 눌러주세요"
    
    [ 다음 ] [ 건너뛰기 ]
```

#### 주문 화면 온보딩
```
[단계 1: 제품 선택 영역 하이라이트]
💡 "박스 또는 벌크를 선택하세요"

[단계 2: 수량 입력 필드 하이라이트]
💡 "원하시는 수량을 입력하세요"

[단계 3: 배송 정보 영역 하이라이트]
💡 "배송 받으실 날짜를 선택하세요"
```

### 온보딩 구현 기술 사양

#### Flutter 패키지 옵션
1. **showcaseview**: 가장 인기 있는 온보딩 패키지
   ```yaml
   dependencies:
     showcaseview: ^2.0.3
   ```

2. **tutorial_coach_mark**: 더 세밀한 커스터마이징 가능
   ```yaml
   dependencies:
     tutorial_coach_mark: ^1.2.11
   ```

3. **커스텀 구현**: 완전한 제어가 필요한 경우
   - Stack 위젯과 Overlay 사용
   - AnimatedPositioned로 부드러운 전환
   - SharedPreferences로 상태 저장

#### 온보딩 플로우 상태 관리 (Riverpod + VelocityX)
```dart
// Riverpod Provider로 온보딩 상태 관리
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

// VelocityX로 빠른 UI 구현
Container(
  child: "요소수를 주문하시려면 이 버튼을 눌러주세요"
    .text
    .white
    .xl2
    .make()
    .p16()
    .box
    .black
    .rounded
    .make(),
).onTap(() => ref.read(onboardingProvider.notifier).nextStep());

// SharedPreferences로 온보딩 완료 상태 저장
await prefs.setBool('onboarding_completed', true);
await prefs.setStringList('completed_screens', ['home', 'order']);
```

## 🧪 주요 테스트 시나리오

### 1. 요소수 주문 등록
1. 홈 화면에서 "새 주문" 버튼 클릭
2. 제품 유형 선택
   - 박스 (10L 단위)
   - 벌크 (1,000L 단위)
3. 수량 및 옵션 입력
   - 주문 수량
   - 자바라 수량
   - 반납통 수량 (벌크만)
4. 배송 정보
   - 출고 희망일 선택
   - 배송지 선택/입력
   - 배송 방법 기입
5. 주문 확인
   - 자동 가격 계산 확인
   - 등급별 단가 적용 확인

### 2. 주문 내역 조회
1. 하단 탭에서 "주문 내역" 선택
2. 필터링 기능 테스트
   - 기간별 조회 (1주/1개월/3개월)
   - 상태별 필터 (대기/확정/완료)
   - 제품 유형별 필터
3. 주문 상세 보기
   - 주문 정보 확인
   - 상태 변경 이력
   - 수정/취소 기능 (대기 상태만)

### 3. 거래명세서 확인
1. 완료된 주문 선택
2. "거래명세서 보기" 버튼 클릭
3. PDF 뷰어에서 확인
   - 거래 내역
   - 금액 정보
   - 회사 정보
4. 다운로드 기능 테스트

### 4. 공지사항 및 알림
1. 홈 화면의 공지사항 배너 확인
2. 공지사항 목록 조회
3. 푸시 알림 시뮬레이션
   - 주문 확정 알림
   - 공지사항 알림

### 5. 재고 현황 확인
1. 홈 화면의 재고 위젯 확인
2. 실시간 재고 상태
   - 박스/벌크별 재고
   - 공장/창고별 현황
   - 재고 부족 경고

## 📖 상세 테스트 가이드 (40-60대 사용자용)

### 🚀 시작하기

#### 1단계: 데모 접속
1. **웹 브라우저 열기** (Chrome 추천)
2. **주소창에 입력**: `https://def-order-demo.web.app`
3. **"데모 시작하기" 버튼** 찾아서 클릭
   - 💡 팁: 화면 중앙의 큰 파란색 버튼입니다

#### 2단계: 계정 선택
- **대리점으로 테스트**: "대리점 데모" 버튼 클릭
- **일반 거래처로 테스트**: "일반 거래처 데모" 버튼 클릭
- 💡 차이점: 대리점은 특별 단가가 적용됩니다

### 🎓 온보딩 가이드 활용법

데모에 처음 접속하시면 **자동으로 온보딩 가이드가 시작**됩니다:

1. **화면이 어두워지면서 중요한 버튼만 밝게 표시됩니다**
   - 걱정하지 마세요! 이것은 사용법을 알려드리는 안내입니다

2. **말풍선 형태의 설명을 읽어보세요**
   - 큰 글씨로 간단하게 설명되어 있습니다
   - 천천히 읽으셔도 됩니다

3. **"다음" 버튼을 눌러 계속 진행하세요**
   - 이미 사용법을 아신다면 "건너뛰기"를 누르셔도 됩니다

4. **언제든지 도움이 필요하시면**
   - 화면에서 3초 이상 멈춰있으면 자동으로 도움말이 나타납니다
   - 화면 우측 상단의 "?" 버튼을 눌러도 됩니다

### 📝 시나리오 1: 박스 주문하기 (대리점)

#### 입력 예시
```
제품: 박스
수량: 50 (숫자만 입력)
자바라: 10 (숫자만 입력)
배송희망일: 내일 날짜 선택
배송지: 기본 배송지 사용
배송방법: "택배" 입력
```

#### 단계별 가이드
1. **홈 화면에서 "새 주문" 버튼 클릭**
   - 위치: 화면 하단 중앙의 큰 버튼
   - 색상: 파란색

2. **제품 선택 화면**
   - "박스 (10L)" 카드를 터치
   - 선택되면 테두리가 파란색으로 변경됨

3. **수량 입력 화면**
   - 박스 수량: `50` 입력
   - 자바라 수량: `10` 입력
   - 💡 팁: 숫자 키패드가 자동으로 나타납니다

4. **배송 정보 화면**
   - 출고희망일: 달력에서 내일 날짜 터치
   - 배송지: "기본 배송지 사용" 체크
   - 배송방법: `택배` 입력

5. **주문 확인 화면**
   - 예상 금액 확인
   - "주문하기" 버튼 클릭

#### 예상 결과
- 주문번호: ORD-2025-0001 (예시)
- 총 금액: 대리점 특별가 적용
- 상태: "주문 대기"
- 알림: "주문이 접수되었습니다" 메시지

### 📝 시나리오 2: 벌크 주문하기 (일반 거래처)

#### 입력 예시
```
제품: 벌크
수량: 3 (숫자만 입력)
자바라: 5 (숫자만 입력)
반납통: 2 (숫자만 입력)
배송희망일: 3일 후 선택
배송지: 새 주소 입력
배송방법: "직접 수령" 입력
```

#### 단계별 가이드
1. **제품 선택**
   - "벌크 (1,000L)" 카드 터치
   
2. **수량 입력**
   - 벌크 수량: `3` 입력
   - 자바라 수량: `5` 입력
   - 반납통 수량: `2` 입력
   - ⚠️ 주의: 반납통은 벌크만 가능

3. **배송 정보**
   - 출고희망일: 3일 후 날짜 선택
   - 배송지: "새 주소 추가" 클릭
     - 주소: `서울시 강남구 테헤란로 123`
     - 상세주소: `○○빌딩 1층`
   - 배송방법: `직접 수령` 입력

#### 예상 결과
- 일반 거래처 단가 적용
- 반납통 수량이 주문서에 표시
- 새 배송지가 저장됨

### 📊 시나리오 3: 주문 내역 확인

#### 조작 방법
1. **하단 메뉴에서 "주문 내역" 아이콘 터치**
   - 위치: 화면 하단 왼쪽에서 두 번째
   - 아이콘: 📋 모양

2. **필터 사용하기**
   - 기간 선택: "1개월" 버튼 터치
   - 상태 선택: "전체" → "대기중" 변경
   - 제품 선택: "전체" 유지

3. **주문 상세 보기**
   - 원하는 주문 카드를 터치
   - 상세 정보 확인

#### 확인 항목
- ✅ 주문번호와 날짜
- ✅ 제품 종류와 수량
- ✅ 현재 상태
- ✅ 예상 배송일

### 📄 시나리오 4: 거래명세서 확인

#### 조작 방법
1. **"완료" 상태의 주문 찾기**
   - 주문 내역에서 초록색 "완료" 태그 찾기

2. **주문 상세 화면 진입**
   - 완료된 주문 카드 터치

3. **"거래명세서 보기" 버튼 클릭**
   - 위치: 화면 하단
   - 색상: 초록색

4. **PDF 확인**
   - 자동으로 PDF 뷰어 열림
   - 확대/축소: 두 손가락으로 벌리기/오므리기

5. **다운로드**
   - 우측 상단 "⬇️" 아이콘 터치
   - 다운로드 폴더에 저장됨

### 💡 자주 하는 실수와 해결 방법

#### 문제 1: 숫자 입력이 안 돼요
- **해결**: 입력창을 한 번 터치하면 키패드가 나타납니다
- **팁**: 한글이 아닌 숫자만 입력하세요

#### 문제 2: 달력에서 날짜 선택이 어려워요
- **해결**: 원하는 날짜를 천천히 한 번만 터치하세요
- **팁**: 오늘 날짜는 다른 색으로 표시됩니다

#### 문제 3: 주문 후 화면이 안 바뀌어요
- **해결**: 3-5초 기다려주세요
- **팁**: "처리 중..." 메시지가 나타납니다

#### 문제 4: PDF가 안 보여요
- **해결**: 
  1. 인터넷 연결 확인
  2. 다른 브라우저로 시도 (Chrome 추천)
  3. 새로고침 (F5 키)

### 🎯 테스트 체크리스트

대리점 계정 테스트:
- [ ] 박스 주문 생성
- [ ] 특별 단가 확인
- [ ] 주문 내역 조회
- [ ] 주문 수정 (대기 상태)
- [ ] 거래명세서 확인

일반 거래처 테스트:
- [ ] 벌크 주문 생성
- [ ] 표준 단가 확인
- [ ] 반납통 수량 입력
- [ ] 새 배송지 추가
- [ ] 필터링 기능 사용

## 🛠️ 기술 구현

### Frontend
- **Framework**: Flutter 3.32.5 (FVM)
- **State Management**: Riverpod
- **UI Libraries**: 
  - GetWidget 6.0.0 (UI 컴포넌트)
  - VelocityX (빠른 UI 개발)
- **Architecture**: Clean Architecture (Feature-First)
- **온보딩 시스템**: 
  - showcaseview 패키지 또는 커스텀 오버레이
  - SharedPreferences로 온보딩 완료 상태 저장
  - 화면별 단계적 가이드 설정

### Backend
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth with Demo Mode
- **Real-time**: Supabase Realtime
- **Storage**: Supabase Storage (PDF)

### Development Stack
- **Full Stack**: Flutter + Supabase + MCP + Riverpod + GetWidget + VelocityX
- **MCP Integration**: SuperClaude 명령어 시스템으로 빠른 MVP 개발
- **Rapid Development**: VelocityX로 UI 개발 속도 향상

### Deployment
- **Build**: Flutter Web (PWA)
- **CI/CD**: GitHub Actions
- **Hosting**: Firebase Hosting
- **Domain**: Custom domain (optional)

## 📋 구현 상태

### ✅ 완료된 기능
- [x] Flutter 프로젝트 구조 설정
- [x] Supabase 백엔드 구축
- [x] 인증 시스템 (사업자번호 기반)
- [x] 주문 관리 CRUD
- [x] 주문 내역 조회
- [x] 거래명세서 PDF 생성/조회
- [x] 공지사항 시스템
- [x] FCM 푸시 알림
- [x] 40-60대 사용자 최적화 UI

### 🚧 데모용 추가 구현
- [x] 데모 인증 Provider ✅
- [x] 로그인 화면 데모 버튼 ✅
- [ ] 인터랙티브 온보딩 시스템
  - [ ] 화면별 온보딩 오버레이
  - [ ] 스마트 툴팁 시스템
  - [ ] 진행률 표시 및 스킵 기능
- [ ] 테스트 데이터 시딩
- [ ] GitHub Actions 설정
- [ ] Firebase Hosting 배포

## 🔧 개발 명령어

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

## 📊 테스트 데이터

### 샘플 주문
- 대기 상태: 3건
- 확정 상태: 5건
- 완료 상태: 10건
- 다양한 제품 유형 및 수량

### 샘플 재고
- 박스: 공장 500개, 창고 300개
- 벌크: 공장 50개, 창고 30개
- 빈통: 20개

### 샘플 공지사항
- 일반 공지: 3건
- 긴급 공지: 1건
- 이벤트 공지: 2건

## ⚠️ 제한사항 및 주의사항

### 데모 환경 제한
- 실제 이메일 발송 비활성화
- 실제 사업자번호 검증 생략
- 테스트 데이터만 표시
- 일부 관리자 기능 제한

### 보안 고려사항
- 데모 계정은 읽기 전용 권한
- 실제 단가 정보 숨김 처리
- 테스트 데이터는 주기적으로 초기화

## 📱 PWA 기능

### 설치 가능
- 홈 화면에 추가
- 오프라인 기본 지원
- 푸시 알림 (권한 요청)

### 반응형 디자인
- 모바일 최적화
- 태블릿 지원
- 데스크톱 호환

## 🚀 향후 계획

### Phase 1 (현재)
- PWA 데모 구현
- 기본 기능 테스트
- 고객 피드백 수집

### Phase 2
- 관리자 웹 개발
- ERP 연동 준비
- 보안 강화

### Phase 3
- 앱스토어 배포
- 실제 운영 환경 구축
- 확장 기능 개발

## 📞 문의사항

기술 지원이나 추가 정보가 필요하신 경우 아래로 연락 주세요:
- 이메일: support@defcompany.com
- 전화: 02-1234-5678

---

*이 문서는 DEF 요소수 주문관리 시스템의 PWA 데모 가이드입니다.*
*최종 업데이트: 2025-08-03*
*개발 스택: Flutter + Supabase + MCP + Riverpod + GetWidget + VelocityX*

## 📝 SuperClaude 개발 명령어

### 1단계: 데모 모드 구현 ✅
```bash
# 데모 인증 Provider 구현 (Riverpod) ✅
/implement "데모 모드 인증 시스템 - Riverpod Provider로 테스트 계정 자동 로그인" --persona-backend --c7 --seq

# 로그인 화면 수정 (GetWidget + VelocityX) ✅
/implement "로그인 화면에 데모 시작하기 버튼 추가 - GetWidget UI 컴포넌트와 VelocityX 활용" --persona-frontend --c7 --validate
```

### 2단계: 테스트 데이터 준비
```bash
# Supabase 테스트 데이터 시딩 스크립트
/implement "Supabase 테스트 데이터 시딩 스크립트 - seed.sql 파일로 대리점/일반 거래처 데이터 생성" --persona-backend --c7 --seq

# 데모 시나리오 데이터 생성
/implement "데모용 주문, 재고, 거래명세서 샘플 데이터 - 다양한 상태(대기/확정/완료)의 주문 데이터" --persona-backend --validate

# Flutter 앱에서 테스트 데이터 초기화
/implement "데모 모드 초기 데이터 로더 - SharedPreferences로 최초 실행 감지" --persona-backend --c7
```

### 3단계: 인터랙티브 온보딩 오버레이 시스템 구현
```bash
# showcaseview 패키지 설정 및 기본 구조
/implement "Flutter showcaseview 패키지 통합 - 화면별 온보딩 키 설정 및 Provider 구조" --persona-frontend --c7 --validate

# 홈 화면 온보딩 오버레이
/implement "홈 화면 온보딩 가이드 - '새 주문' 버튼 하이라이트, GetWidget + VelocityX 스타일링" --persona-frontend --c7 --magic

# 주문 화면 단계별 온보딩
/implement "주문 화면 3단계 온보딩 - 제품선택→수량입력→배송정보 순차적 가이드" --persona-frontend --seq --validate

# 스마트 툴팁 시스템 (Riverpod 상태 관리)
/implement "컨텍스트 인식 툴팁 - 3초 대기 감지, 40-60대 최적화 큰 글씨" --persona-frontend --c7 --seq --think

# 온보딩 진행률 표시 (VelocityX)
/implement "온보딩 진행률 바 - 상단 고정, 현재/전체 단계 표시, 건너뛰기 옵션" --persona-frontend --persona-mentor --c7

# SharedPreferences 온보딩 상태 저장
/implement "온보딩 완료 상태 관리 - 화면별 완료 여부 저장, 재접속시 스킵" --persona-backend --c7
```

### 4단계: PWA 빌드 및 배포
```bash
# GitHub Actions 워크플로우 설정
/implement "GitHub Actions Flutter Web 빌드 파이프라인 - main 브랜치 푸시시 자동 빌드" --persona-devops --c7 --seq

# PWA 매니페스트 및 서비스 워커
/implement "Flutter PWA 매니페스트 - 앱 아이콘, 오프라인 지원, 설치 가능" --persona-frontend --c7 --validate

# Firebase Hosting 설정
/implement "Firebase Hosting 설정 - firebase.json, 자동 배포 연동" --persona-devops --validate

# 환경 변수 및 보안 설정
/implement "GitHub Secrets 설정 - Supabase 키, Firebase 토큰 안전 관리" --persona-security --seq

# 빌드 최적화
/build --production --target web --persona-devops --validate
```

### 5단계: 기본 문서화
```bash
# 고객용 데모 가이드 (40-60대 최적화)
/document "PWA 데모 사용 가이드 - 큰 글씨, 단계별 스크린샷, 쉬운 설명" --focus user-guide --persona-scribe=ko --persona-mentor

# 테스트 시나리오 문서
/document "주요 기능 테스트 시나리오 - 체크리스트 형식" --persona-mentor --persona-scribe=ko --validate

# 자주 묻는 질문 (FAQ)
/document "데모 FAQ - 로그인 문제, 주문 방법, PDF 다운로드" --persona-mentor --persona-scribe=ko

# 기술 문서 (개발자용)
/document "PWA 데모 기술 명세서 - 아키텍처, API, 배포 가이드" --focus architecture --persona-architect --c7
```

### 6단계: 테스트 및 검증
```bash
# 단위 테스트 (Provider, Service)
/test "데모 인증 및 주문 로직" --type unit --persona-qa --validate

# 위젯 테스트 (UI 컴포넌트)
/test "로그인 화면, 홈 화면 위젯" --type widget --persona-qa --c7

# E2E 시나리오 테스트
/test "데모 주요 시나리오 - 로그인→주문→조회 플로우" --type e2e --persona-qa --play

# 크로스 브라우저 테스트
/test "Chrome, Safari, Edge 호환성" --type e2e --play --validate

# PWA 기능 테스트
/test "오프라인 모드, 설치, 푸시 알림" --persona-qa --play

# 성능 및 접근성 검증
/analyze "PWA 성능 - Lighthouse 점수, Core Web Vitals" --focus performance --persona-frontend --think-hard

# 40-60대 사용성 테스트
/analyze "버튼 크기, 글씨 크기, 대비율 검증" --focus accessibility --persona-frontend --validate
```

### 7단계: 온보딩 시스템 최적화
```bash
# 온보딩 사용자 행동 분석
/analyze "온보딩 완료율, 이탈 지점, 평균 소요 시간 분석" --persona-analyzer --seq --think

# 40-60대 사용자 피드백 수집 및 분석
/analyze "연령대별 온보딩 패턴 - 터치 실수, 읽기 시간, 건너뛰기 비율" --persona-analyzer --c7

# 온보딩 UX 반복 개선
/improve "온보딩 UX - 애니메이션 속도 조절, 글씨 크기 증가, 설명 간소화" --persona-frontend --loop --iterations 3

# 온보딩 대안 설계
/design "온보딩 변형 - 2단계 vs 5단계, 비디오 vs 오버레이" --persona-frontend --persona-mentor

# A/B 테스트 실행
/test "온보딩 변형 테스트 - 완료율, 이해도, 만족도 측정" --persona-qa --play --validate

# 최종 온보딩 최적화
/improve "최종 온보딩 시스템 - A/B 테스트 결과 반영" --persona-frontend --wave-mode progressive --validate
```

### 8단계: 핵심 화면 구현 (추가)
```bash
# 주문 등록 화면
/implement "요소수 주문 등록 화면 - 박스/벌크 선택, 수량 입력, GetWidget + VelocityX" --persona-frontend --c7 --validate

# 주문 내역 화면
/implement "주문 내역 조회 화면 - 필터링, 상태별 표시, 무한 스크롤" --persona-frontend --c7 --seq

# 거래명세서 화면
/implement "거래명세서 PDF 뷰어 - pdf 패키지 사용, 다운로드 기능" --persona-frontend --c7 --validate

# 재고 현황 위젯
/implement "실시간 재고 현황 대시보드 - Supabase Realtime 연동" --persona-backend --c7 --seq

# 공지사항 시스템
/implement "공지사항 목록 및 상세 화면 - 긴급/일반 구분, 읽음 표시" --persona-frontend --c7
```

### 9단계: 데이터 및 비즈니스 로직
```bash
# 주문 Repository 패턴
/implement "주문 관리 Repository - CRUD 작업, Supabase 연동" --persona-backend --seq --validate

# 주문 상태 관리
/implement "주문 상태 관리 시스템 - 대기→확정→완료 플로우, Riverpod StateNotifier" --persona-backend --c7 --seq

# 가격 계산 로직
/implement "등급별 단가 계산 - 대리점/일반 차등 적용, 자동 계산" --persona-backend --validate

# PDF 생성 서비스
/implement "거래명세서 PDF 생성 - pdf 패키지, Supabase Storage 저장" --persona-backend --c7 --seq
```

### 10단계: 성능 최적화 및 마무리
```bash
# 이미지 최적화
/improve "이미지 자산 최적화 - WebP 변환, 지연 로딩" --persona-performance --validate

# 코드 스플리팅
/improve "Flutter Web 코드 스플리팅 - deferred loading 적용" --persona-performance --c7

# 캐싱 전략
/implement "오프라인 캐싱 전략 - Service Worker, 주요 데이터 로컬 저장" --persona-backend --seq

# 최종 번들 크기 최적화
/improve "Flutter Web 번들 크기 - tree shaking, 불필요 패키지 제거" --persona-performance --loop

# 프로덕션 체크리스트
/analyze "프로덕션 준비 상태 - 보안, 성능, 접근성 최종 점검" --comprehensive --wave-mode systematic
```