# 🛠️ 팀 개발 환경 설정 가이드

## 📁 Git 관리 파일들

### ✅ Git에 포함되는 팀 공유 파일
```bash
# 팀 표준 설정 (모든 팀원이 동일하게 적용)
.cursor-settings          # Cursor AI 도구 팀 표준
.gitignore               # Git 무시 파일 목록
docs/MD_STANDARDS.md     # MD 파일 구조 표준
scUsage.md               # SuperClaude 팀 가이드
scUsageFlutter.md        # Flutter 특화 가이드
CLAUDE.md                # 프로젝트별 AI 도구 설정
```

### ❌ Git에서 제외되는 개인 설정 파일
```bash
# 개인별 AI 도구 설정 (Git에서 제외)
.claude/                 # Claude Code 개인 설정
.copilot/                # GitHub Copilot 개인 설정
.vscode/settings.json    # VS Code 개인 설정
.idea/                   # IntelliJ 개인 설정
```

## 🚀 새 팀원 온보딩

### 1. 저장소 클론 후 자동 적용
```bash
git clone <repository>
cd <project>

# .cursor-settings가 자동으로 적용됨
# Cursor가 @docs/MD_STANDARDS.md 규칙을 자동 인식
```

### 2. 개인 AI 도구 설정 (선택)
```bash
# 개인별로 설정 (Git에 포함되지 않음)
# Claude Code 개인 설정
mkdir .claude
# 개인 프롬프트, API 키 등 설정
```

### 3. 확인 사항
- [ ] `.cursor-settings` 파일이 존재하는가?
- [ ] `@docs/MD_STANDARDS.md` 자동 참조가 작동하는가?
- [ ] 새 MD 파일 생성 시 표준이 자동 적용되는가?

## 📋 팀 규칙 적용 확인

### Cursor에서 확인할 점들
1. **새 MD 파일 생성 시**: 자동으로 표준 구조 제안
2. **@ 참조 사용 시**: 루트 경로 우선 제안
3. **문서 작성 시**: `@docs/MD_STANDARDS.md` 규칙 자동 적용

### 표준 준수 체크리스트
- [ ] 자주 사용하는 파일이 루트에 있는가?
- [ ] @ 참조가 간단한 경로를 사용하는가?
- [ ] 새 문서가 적절한 카테고리에 배치되었는가?
- [ ] 팀 전체가 동일한 구조를 사용하는가?

## 🔧 문제 해결

### `.cursor-settings` 적용 안됨
```bash
# Cursor 재시작
# 또는 워크스페이스 새로고침
```

### 표준 규칙 업데이트 시
```bash
git pull origin main
# .cursor-settings와 docs/MD_STANDARDS.md 자동 업데이트
# Cursor 재시작으로 새 규칙 적용
```

## 📞 지원

- **설정 문제**: 개발 팀 리드
- **표준 개선**: GitHub Issues
- **AI 도구 사용법**: `@scUsage.md` 참조

---

> 💡 이 설정을 통해 팀 전체가 일관된 문서화 표준을 자동으로 적용받습니다.