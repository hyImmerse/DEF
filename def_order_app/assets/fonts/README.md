# 한글 폰트 설정 가이드

PDF 생성 시 한글이 올바르게 표시되도록 한글 폰트를 설정해야 합니다.

## 1. 폰트 다운로드

### 방법 1: Google Fonts에서 직접 다운로드 (권장)

1. [Google Fonts - Noto Sans Korean](https://fonts.google.com/noto/specimen/Noto+Sans+KR) 접속
2. "Download family" 버튼 클릭
3. 다운로드된 ZIP 파일 압축 해제
4. `static` 폴더에서 다음 파일들을 찾아서 복사:
   - `NotoSansKR-Regular.ttf`
   - `NotoSansKR-Bold.ttf`
5. 이 폴더(`assets/fonts/`)에 복사

### 방법 2: 스크립트 사용

```bash
# Windows
./scripts/download_fonts.bat

# 위 스크립트는 WOFF2 파일을 다운로드합니다.
# TTF 변환이 필요하므로 방법 1을 권장합니다.
```

## 2. 필요한 파일 목록

다음 파일들이 이 폴더에 있어야 합니다:

```
assets/fonts/
├── NotoSansKR-Regular.ttf
└── NotoSansKR-Bold.ttf
```

## 3. 적용 확인

1. 폰트 파일 복사 완료 후
2. 앱 다시 시작
3. 주문 내역 → 거래명세서 → PDF 다운로드/새 탭에서 보기 테스트
4. 한글이 올바르게 표시되는지 확인

## 문제 해결

### 한글이 여전히 깨지는 경우

1. 파일명 확인:
   - `NotoSansKR-Regular.ttf` (정확한 파일명)
   - `NotoSansKR-Bold.ttf` (정확한 파일명)

2. 파일 경로 확인:
   - `def_order_app/assets/fonts/` 폴더에 위치

3. 앱 완전 재시작:
   ```bash
   fvm flutter clean
   fvm flutter pub get
   fvm flutter run -d chrome --dart-define=IS_DEMO=true
   ```

### 대체 폰트 옵션

Noto Sans KR 대신 다른 한글 폰트 사용 시 `pubspec.yaml`과 `pdf_service.dart` 파일에서 폰트명 수정 필요.

## 라이선스

- **Noto Sans KR**: SIL Open Font License 1.1 (상업적 사용 가능)
- Google Fonts에서 제공하는 무료 폰트입니다.