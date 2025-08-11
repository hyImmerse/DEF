# 📚 Documentation

프로젝트 문서 및 리포트 저장소입니다.

## 📁 폴더 구조

```
docs/
├── reports/              # 테스트 및 빌드 리포트
│   ├── flutter_build_test_report.md
│   └── production_build_report.md
├── guides/               # 사용자 가이드 (예정)
└── api/                  # API 문서 (예정)
```

## 📊 Reports

### [Flutter Build Test Report](reports/flutter_build_test_report.md)
- Flutter 3.32.5 웹 빌드 테스트 결과
- `--web-renderer` 옵션 제거 관련 분석
- CanvasKit 렌더러 자동 선택 검증

### [Production Build Report](reports/production_build_report.md)
- 프로덕션 빌드 설정 및 검증
- GitHub Actions 호환성 확인
- 성능 메트릭 및 최적화 권장사항

## 🔗 관련 링크

- [Scripts](../scripts/) - 빌드 및 테스트 자동화 스크립트
- [GitHub Actions](./.github/README_GITHUB_ACTIONS.md) - CI/CD 파이프라인 문서
- [Project README](../README.md) - 프로젝트 개요