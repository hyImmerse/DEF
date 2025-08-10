@echo off
echo =================================
echo 한글 폰트 다운로드 스크립트
echo =================================
echo.

cd /d "%~dp0\.."

if not exist "assets\fonts" (
    echo assets\fonts 디렉토리 생성 중...
    mkdir "assets\fonts"
)

echo.
echo 1. Google Fonts에서 Noto Sans KR 폰트 다운로드 중...
echo    URL: https://fonts.google.com/noto/specimen/Noto+Sans+KR

powershell -Command "& { try { Invoke-WebRequest -Uri 'https://fonts.gstatic.com/s/notosanskr/v36/PbykFmXiEBPT4ITbgNA5Cgm20xz64px_1hVWr0wuPNGmlQNMEfD4.woff2' -OutFile 'assets/fonts/NotoSansKR-Regular.woff2' -UseBasicParsing } catch { Write-Host '다운로드 실패. 수동으로 폰트를 다운로드해주세요.' -ForegroundColor Red; exit 1 } }"
powershell -Command "& { try { Invoke-WebRequest -Uri 'https://fonts.gstatic.com/s/notosanskr/v36/PbykFmXiEBPT4ITbgNA5Cgm20xz64px_1hVWr0wuPNGmlQPBEfD4.woff2' -OutFile 'assets/fonts/NotoSansKR-Bold.woff2' -UseBasicParsing } catch { Write-Host '다운로드 실패. 수동으로 폰트를 다운로드해주세요.' -ForegroundColor Red; exit 1 } }"

echo.
echo 2. WOFF2를 TTF로 변환이 필요합니다.
echo    온라인 변환기를 사용해주세요: https://convertio.co/woff2-ttf/
echo.
echo 3. 변환된 파일명을 다음과 같이 변경해주세요:
echo    - NotoSansKR-Regular.ttf
echo    - NotoSansKR-Bold.ttf
echo.
echo 4. 또는 직접 TTF 파일을 다운로드해주세요:
echo    - https://fonts.google.com/noto/specimen/Noto+Sans+KR
echo    - "Download family" 버튼 클릭
echo    - ZIP 파일 압축 해제
echo    - static 폴더에서 NotoSansKR-Regular.ttf, NotoSansKR-Bold.ttf 복사
echo.

pause