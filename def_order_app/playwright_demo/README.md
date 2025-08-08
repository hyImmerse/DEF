# 🎬 DEF Flutter 앱 Playwright 데모 스크립트

## 📁 폴더 구조

```
playwright_demo/
├── README.md                       # 이 파일
├── record_demo_complete_6min.js    # 메인 데모 녹화 스크립트
├── playwright.config.optimized.js # Playwright 설정 파일
├── package.json                    # npm 의존성 (생성 필요)
├── DEMO_SCENARIO_6MIN.md           # 6분 데모 시나리오 설명서
├── MATERIAL3_DEMO_GUIDE.md         # Material 3 디자인 가이드
├── ACCESSIBILITY_HIGHLIGHTS.md     # 접근성 개선 포인트
└── videos/                         # 녹화된 비디오 저장 위치
    └── complete_6min/
└── screenshots/                    # 스크린샷 저장 위치
    └── complete_6min/
```

## 🚀 사용 방법

### 1. 의존성 설치
```bash
cd playwright_demo
npm install
npx playwright install chromium
```

### 2. Flutter 앱 실행 (별도 터미널)
```bash
cd ../  # def_order_app 디렉토리로 이동
fvm flutter run -d web-server --web-port=52378 --dart-define=IS_DEMO=true
```

### 3. 데모 녹화 실행
```bash
# playwright_demo 폴더에서 실행
node record_demo_complete_6min.js
```

## 📊 데모 내용

- **Scene 1**: 스플래시 & 로그인 (접근성 개선 시연)
- **Scene 2**: Material 3 대시보드 (색상 체계 시연)
- **Scene 3**: 3단계 주문 프로세스 (UI/UX 개선)
- **Scene 4**: 실시간 재고 현황 (데이터 시각화)
- **Scene 5**: 완료 및 성과 요약 (결과 검증)

## 🎯 주요 특징

- **총 녹화 시간**: 6분 (360초)
- **해상도**: 430x932 (모바일 최적화)
- **접근성**: WCAG 2.1 AA 100% 준수
- **사용자 대상**: 40-60세 중년층

## 🔧 문제 해결

### Flutter 앱이 로드되지 않는 경우
1. Flutter 개발 서버가 실행 중인지 확인
2. `http://localhost:52378/` 접근 가능한지 브라우저에서 확인
3. 데모 모드(`IS_DEMO=true`) 설정 확인

### 셀렉터 오류가 발생하는 경우
1. Flutter 앱의 실제 텍스트 확인
2. `record_demo_complete_6min.js`의 셀렉터 배열 수정
3. Playwright 개발자 도구 사용하여 요소 검사

## 📝 수정된 주요 셀렉터

- 타이틀: `'text=요소수 주문관리'` (기존: `'text=요소수 출고 주문관리 시스템'`)
- 버튼: `'text=대모 시작하기'` (기존: `'text=로그인'`)
- 안내: `'text=바로 로그인 버튼을 눌러주세요'` 추가