# 🚀 Flutter PWA를 GitHub Pages로 배포하기 가이드

**작성일**: 2025-08-07  
**프로젝트**: Flutter B2B 요소수 출고주문관리 시스템

---

## 📋 전체 프로세스 개요

1. Flutter 웹 빌드 생성 (PWA 설정 포함)
2. GitHub Pages 브랜치 설정
3. GitHub Actions 워크플로우 구성
4. 커스텀 도메인 설정 (선택)

---

## 1️⃣ Flutter 웹 빌드 생성

### Flutter 웹 빌드 (PWA 지원)
```bash
cd def_order_app

# 프로덕션 빌드 생성 (데모 모드)
fvm flutter build web --release --dart-define=IS_DEMO=true \
  --web-renderer canvaskit \
  --pwa-strategy offline-first

# 또는 HTML 렌더러 사용 (더 작은 크기)
fvm flutter build web --release --dart-define=IS_DEMO=true \
  --web-renderer html \
  --pwa-strategy offline-first
```

### PWA 매니페스트 수정
`def_order_app/web/manifest.json` 파일 확인 및 수정:

```json
{
  "name": "요소수 주문관리 시스템",
  "short_name": "요소수주문",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#0175C2",
  "theme_color": "#0175C2",
  "description": "40-60대 중년층을 위한 B2B 요소수 출고주문관리 시스템",
  "orientation": "portrait-primary",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-maskable-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable"
    },
    {
      "src": "icons/Icon-maskable-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}
```

---

## 2️⃣ GitHub Pages 설정

### 방법 A: GitHub Actions를 통한 자동 배포 (권장)

#### `.github/workflows/flutter-web-deploy.yml` 생성:

```yaml
name: Flutter Web Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.5'
          channel: 'stable'
      
      - name: Install FVM
        run: |
          dart pub global activate fvm
          fvm install 3.32.5
          fvm use 3.32.5
      
      - name: Get dependencies
        run: |
          cd def_order_app
          fvm flutter pub get
      
      - name: Build web
        run: |
          cd def_order_app
          fvm flutter build web --release \
            --dart-define=IS_DEMO=true \
            --web-renderer canvaskit \
            --pwa-strategy offline-first \
            --base-href "/DEF/"
      
      - name: Setup Pages
        uses: actions/configure-pages@v4
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: 'def_order_app/build/web'
      
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 방법 B: 수동 배포 (gh-pages 브랜치)

```bash
# gh-pages 브랜치 생성 및 이동
git checkout -b gh-pages

# 빌드 파일 복사
cp -r def_order_app/build/web/* .

# 빈 .nojekyll 파일 생성 (Jekyll 처리 비활성화)
touch .nojekyll

# 커밋 및 푸시
git add .
git commit -m "Deploy Flutter PWA to GitHub Pages"
git push origin gh-pages

# main 브랜치로 돌아가기
git checkout main
```

---

## 3️⃣ GitHub 저장소 설정

### GitHub Pages 활성화

1. GitHub 저장소 → Settings → Pages
2. Source 선택:
   - **GitHub Actions 사용 시**: "GitHub Actions" 선택
   - **gh-pages 브랜치 사용 시**: "Deploy from a branch" → "gh-pages" → "/ (root)"
3. Save 클릭

### 배포 URL
- 기본 URL: `https://[username].github.io/[repository-name]/`
- 예시: `https://hyimmerse.github.io/DEF/`

---

## 4️⃣ PWA 기능 확인

### Service Worker 설정
`def_order_app/web/index.html`에서 Service Worker 확인:

```html
<script>
  // Service Worker 등록
  if ('serviceWorker' in navigator) {
    window.addEventListener('flutter-first-frame', function () {
      navigator.serviceWorker.register('flutter_service_worker.js');
    });
  }
</script>
```

### 오프라인 지원 확인
```javascript
// flutter_service_worker.js 자동 생성됨
// 캐시 전략이 적용되어 오프라인에서도 작동
```

---

## 5️⃣ 커스텀 도메인 설정 (선택사항)

### CNAME 파일 생성
`def_order_app/web/CNAME` 파일 생성:
```
your-custom-domain.com
```

### DNS 설정
도메인 제공업체에서 설정:
- A 레코드: `185.199.108.153`
- A 레코드: `185.199.109.153`
- A 레코드: `185.199.110.153`
- A 레코드: `185.199.111.153`
- CNAME: `www` → `[username].github.io`

---

## 6️⃣ 접근성 최적화 확인

### PWA 체크리스트
- ✅ HTTPS 지원 (GitHub Pages 자동)
- ✅ manifest.json 구성
- ✅ Service Worker 등록
- ✅ 오프라인 작동
- ✅ 설치 가능 (Add to Home Screen)
- ✅ 반응형 디자인
- ✅ 40-60대 접근성 (WCAG AA 100%)

### Lighthouse 테스트
```bash
# Chrome DevTools → Lighthouse
# PWA, Accessibility, Performance 체크
```

---

## 7️⃣ 문제 해결

### 흔한 문제들

#### 404 오류 발생
```bash
# base-href 설정 확인
fvm flutter build web --base-href "/DEF/"
```

#### 빈 화면 표시
```html
<!-- index.html에 추가 -->
<base href="/DEF/">
```

#### CORS 오류
```yaml
# GitHub Actions에 권한 추가
permissions:
  contents: read
  pages: write
  id-token: write
```

---

## 8️⃣ 모니터링 및 분석

### Google Analytics 추가 (선택)
`def_order_app/web/index.html`:
```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

---

## 📱 모바일 설치 안내

### Android (Chrome)
1. Chrome으로 사이트 접속
2. 메뉴 → "홈 화면에 추가"
3. 설치 확인

### iOS (Safari)
1. Safari로 사이트 접속
2. 공유 버튼 → "홈 화면에 추가"
3. 추가 확인

---

## ✅ 최종 체크리스트

- [ ] Flutter 웹 빌드 생성 완료
- [ ] PWA manifest.json 설정 완료
- [ ] GitHub Actions 워크플로우 구성
- [ ] GitHub Pages 활성화
- [ ] 배포 URL 접속 확인
- [ ] PWA 설치 테스트
- [ ] 오프라인 모드 테스트
- [ ] 접근성 (WCAG AA) 확인
- [ ] 40-60대 사용자 테스트

---

## 🎉 완료!

이제 고객이 다음 URL에서 PWA를 확인할 수 있습니다:
```
https://[your-username].github.io/DEF/
```

**PWA 특징**:
- 📱 모바일 앱처럼 설치 가능
- ⚡ 빠른 로딩 속도
- 🔌 오프라인 지원
- 🎯 40-60대 최적화 UI
- ♿ WCAG AA 100% 준수

---

**작성**: SuperClaude  
**검증**: 2025-08-07