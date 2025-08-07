# 📋 GitHub 저장소를 Private에서 Public으로 변경하는 가이드

**작성일**: 2025-08-07  
**목적**: GitHub 무료 계정에서 GitHub Pages PWA 배포를 위한 저장소 공개 설정

---

## 🚨 중요 사항 (먼저 읽어주세요!)

### GitHub Pages 무료 계정 제한 사항
- **GitHub 무료 계정**: Public 저장소에서만 GitHub Pages 사용 가능
- **GitHub Pro/Team**: Private 저장소에서도 Pages 사용 가능 (하지만 사이트는 여전히 공개)
- **GitHub Enterprise**: 완전한 Private Pages 가능

**결론**: 무료 계정으로 PWA를 배포하려면 **반드시 저장소를 Public으로 변경**해야 합니다.

---

## ⚠️ Public 변경 전 보안 체크리스트

### 🔍 민감 정보 확인 및 제거

#### 1. 환경 변수 파일 확인
```bash
# 이미 .gitignore에 포함되어 있는지 확인
- .env
- .env.local
- .env.production
- google-services.json (Firebase)
- GoogleService-Info.plist (Firebase iOS)
```

#### 2. 민감한 정보가 포함된 파일 점검
```bash
# 다음과 같은 내용이 코드에 하드코딩되어 있는지 확인
- API 키 및 시크릿
- 데이터베이스 연결 문자열
- 개인 식별 정보 (PII)
- 비즈니스 민감 정보
- 실제 고객 데이터
```

#### 3. CLAUDE.md 및 TODO.md 검토
```bash
# 다음 정보가 포함되어 있는지 확인
- 실제 고객사명
- 내부 IP 주소 또는 서버 정보
- 실제 연락처 정보
```

### ✅ 현재 프로젝트 보안 상태 확인

**DEF 프로젝트 보안 점검 결과**:
- ✅ `.env` 파일이 `.gitignore`에 포함됨
- ✅ Firebase 설정 파일들 제외됨 
- ✅ 모든 민감 정보가 환경 변수로 관리됨
- ✅ 데모 모드 설정으로 실제 데이터 없음
- ✅ 고객사 정보 일반화됨 (예시 데이터 사용)

**안전하게 Public 변경 가능** ✅

---

## 🔄 저장소를 Public으로 변경하는 단계

### 1단계: GitHub 저장소 페이지 접속
```
https://github.com/hyImmerse/DEF
```

### 2단계: Settings 탭 클릭
- 저장소 이름 아래 탭 메뉴에서 **"Settings"** 클릭
- Settings 탭이 보이지 않으면 드롭다운 메뉴에서 선택

### 3단계: Danger Zone으로 이동
- 페이지 맨 아래 **"Danger Zone"** 섹션 찾기
- **"Change repository visibility"** 오른쪽의 **"Change visibility"** 버튼 클릭

### 4단계: Public 선택
- 팝업에서 **"Make public"** 옵션 선택
- 경고 메시지 읽고 이해했는지 확인

### 5단계: 확인 절차
1. **"I want to make this repository public"** 체크박스 선택
2. 저장소 이름 입력: `hyImmerse/DEF` 또는 `DEF`
3. **"I understand, make this repository public"** 버튼 클릭

---

## 📱 GitHub Pages 설정하기

### 1단계: Pages 설정 페이지 접속
1. 저장소 → **Settings** → 왼쪽 메뉴에서 **"Pages"** 클릭

### 2단계: Source 설정 (중요!)
🎯 **def_order_app 서브폴더 프로젝트의 정확한 설정**:

1. **"Build and deployment"** 섹션에서
2. **"Source"** 드롭다운에서 **"GitHub Actions"** 선택 ⭐
   
**⚠️ 주의**: "Deploy from a branch"를 선택하면 서브폴더 프로젝트가 정상 작동하지 않습니다!

### 3단계: GitHub Actions 워크플로우 확인
생성된 `.github/workflows/flutter-web-deploy.yml` 파일의 핵심 설정:

```yaml
# 서브폴더 작업 디렉토리 설정
working-directory: def_order_app

# Flutter 웹 빌드 (데모 모드)
fvm flutter build web --release \
  --dart-define=IS_DEMO=true \
  --base-href "/DEF/"

# 빌드 결과물 업로드
path: 'def_order_app/build/web'
```

---

## 🚀 자동 배포 확인

### GitHub Actions 워크플로우 동작
1. `main` 브랜치에 push할 때마다 자동 빌드
2. Flutter 웹 빌드 생성 (`--dart-define=IS_DEMO=true`)
3. GitHub Pages에 자동 배포
4. PWA 매니페스트 및 Service Worker 포함

### 배포 URL 확인
배포 완료 후 다음 URL에서 접속 가능:
```
https://hyimmerse.github.io/DEF/
```

---

## 📊 배포 후 확인사항

### PWA 기능 테스트
1. **모바일 설치 가능**: "홈 화면에 추가" 버튼 확인
2. **오프라인 작동**: 네트워크 끊고 새로고침
3. **접근성 준수**: Lighthouse 점수 확인
4. **데모 모드**: 로그인 화면에서 데모 계정 작동 확인

### Lighthouse 점수 목표
- **Performance**: 90+ 점
- **Accessibility**: 100점 (WCAG AA)
- **Best Practices**: 90+ 점
- **SEO**: 90+ 점
- **PWA**: 모든 항목 통과

---

## 🔐 보안 유지 방법

### 환경 변수 관리
```bash
# GitHub Actions Secrets 사용 (필요시)
- SUPABASE_URL
- SUPABASE_ANON_KEY
- 기타 민감한 설정값
```

### 지속적 보안 관리
1. **정기적 의존성 업데이트**
2. **Dependabot 보안 알림 활성화**
3. **코드 스캔 활성화** (GitHub Advanced Security)
4. **민감 정보 실수 커밋 방지**

---

## 🚨 문제 해결

### 흔한 문제들

#### 1. 404 오류 발생
```bash
# base-href 설정 확인
--base-href "/DEF/"
```

#### 2. 빈 화면 표시
```html
<!-- index.html 확인 -->
<base href="/DEF/">
```

#### 3. PWA 설치 버튼이 나타나지 않음
```json
// manifest.json 확인
{
  "start_url": ".",
  "display": "standalone"
}
```

#### 4. Actions 권한 오류
```yaml
# 워크플로우 권한 확인
permissions:
  contents: read
  pages: write
  id-token: write
```

---

## ✅ 체크리스트

### Public 변경 전
- [ ] 민감 정보 제거 확인
- [ ] .gitignore 파일 점검
- [ ] 문서 내 개인정보 확인
- [ ] 데모 모드 설정 확인

### Public 변경 후
- [ ] GitHub Pages 설정
- [ ] Actions 워크플로우 실행 확인
- [ ] 배포 URL 접속 테스트
- [ ] PWA 기능 테스트
- [ ] 접근성 점수 확인

### 최종 확인
- [ ] https://hyimmerse.github.io/DEF/ 접속
- [ ] 데모 로그인 테스트
- [ ] 모바일에서 설치 테스트
- [ ] 오프라인 모드 테스트

---

## 📞 참고사항

**Public 변경 시 영향**:
- ✅ 코드가 모든 사람에게 공개됨
- ✅ GitHub Pages 무료 사용 가능
- ✅ Actions 무료 사용량 증가
- ✅ 오픈소스 기여 가능
- ⚠️ Private fork들이 독립적인 저장소가 됨

**되돌리기**: 언제든지 다시 Private으로 변경 가능 (단, Pages는 비활성화됨)

---

**🎉 완료되면 고객이 직접 PWA를 체험할 수 있습니다!**

---

**작성**: Claude Code Assistant  
**검증**: 2025-08-07