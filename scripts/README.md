# 📜 Scripts - 테스트 및 빌드 자동화

이 폴더는 Flutter 웹 애플리케이션의 빌드, 테스트, 배포를 위한 자동화 스크립트를 포함합니다.

## 📁 스크립트 목록

### 빌드 스크립트
- **`production_build.bat`** - 전체 프로덕션 빌드 프로세스 (의존성 설치, 코드 생성, 빌드)
- **`production_build_verbose.bat`** - 상세 출력과 함께 빌드 실행
- **`run_production_build.bat`** - 간단한 빌드 실행 스크립트

### 테스트 스크립트
- **`test_github_actions_locally.bat`** - GitHub Actions 워크플로우 로컬 테스트 (Windows)
- **`test_github_actions_locally.sh`** - GitHub Actions 워크플로우 로컬 테스트 (Linux/Mac)
- **`test_flutter_build_local.bat`** - Flutter 빌드 명령어 로컬 테스트
- **`test_flutter_build_windows.bat`** - Windows 환경 Flutter 빌드 테스트

## 🚀 사용 방법

### Windows에서 실행
```batch
# GitHub Actions 로컬 테스트
scripts\test_github_actions_locally.bat

# 프로덕션 빌드
scripts\production_build.bat

# 상세 출력과 함께 빌드
scripts\production_build_verbose.bat
```

### Linux/Mac에서 실행
```bash
# 실행 권한 부여
chmod +x scripts/test_github_actions_locally.sh

# GitHub Actions 로컬 테스트
./scripts/test_github_actions_locally.sh
```

## 📋 스크립트별 기능

### production_build.bat
1. Flutter 의존성 설치 (`flutter pub get`)
2. 코드 생성 (`build_runner`)
3. 코드 분석 (`flutter analyze`)
4. 웹 프로덕션 빌드
5. 빌드 결과 검증

### test_github_actions_locally.bat
1. FVM 설치 확인
2. Flutter 3.32.5 설치
3. 한글 폰트 다운로드
4. 의존성 설치
5. GitHub Actions와 동일한 빌드 명령 실행
6. 결과 검증

## ⚙️ 빌드 설정

모든 스크립트는 다음 설정을 사용합니다:
```bash
flutter build web --release \
  --dart-define=IS_DEMO=true \
  --base-href=/DEF/ \
  --no-tree-shake-icons
```

- **Release Mode**: 최적화된 프로덕션 빌드
- **Demo Mode**: 데모 데이터 사용 (Supabase 우회)
- **Base URL**: GitHub Pages 배포용 (`/DEF/`)
- **Icons**: 모든 아이콘 포함 (tree shaking 비활성화)

## 📌 주의사항

1. **Flutter 버전**: 3.32.5 이상 필요 (`--web-renderer` 옵션 제거됨)
2. **경로**: 프로젝트 루트에서 실행해야 함
3. **의존성**: 먼저 `flutter pub get` 실행 필요
4. **한글 폰트**: PDF 생성을 위해 NanumGothic 폰트 필요

## 🔧 문제 해결

### 빌드 실패 시
1. Flutter 버전 확인: `flutter --version`
2. 의존성 재설치: `flutter pub get`
3. 캐시 정리: `flutter clean`
4. 코드 생성 재실행: `flutter pub run build_runner build --delete-conflicting-outputs`

### GitHub Actions 에러
1. 로컬 테스트 스크립트 실행
2. 에러 메시지 확인
3. 워크플로우 파일 수정 후 재시도

## 📝 관련 문서
- [GitHub Actions 가이드](../.github/README_GITHUB_ACTIONS.md)
- [테스트 리포트](../docs/reports/)
- [프로젝트 TODO](../TODO.md)