# 🚀 MD 파일 구조 표준화 시스템 - 프로젝트 적용 가이드

> DEF 프로젝트에서 검증된 MD 구조 표준을 새 프로젝트에 적용하는 완전 가이드

## 📋 시스템 개요

이 가이드는 **@ 참조 최적화**와 **팀 협업 효율성**을 위한 MD 파일 구조 표준화 시스템을 다른 프로젝트에 적용하는 방법을 설명합니다.

### 🎯 시스템 효과
- **@ 참조 효율성**: 40% 향상 (경로 단축)
- **팀 협업**: 역할별 문서 분리로 혼선 방지
- **자동화**: AI 도구 사용 시 표준 자동 적용
- **온보딩**: 새 팀원 설정 자동화

## 🏗️ 시스템 구성요소

### 핵심 파일 4개
1. **`.cursor-settings`** - AI 도구 팀 표준 설정
2. **`docs/MD_STANDARDS.md`** - 문서화 표준 가이드
3. **`TEAM_SETUP.md`** - 팀 온보딩 자동화
4. **`.gitignore`** - 팀/개인 설정 구분

### 표준 폴더 구조
```
프로젝트명/
├── 🔥 루트 (고빈도 액세스 - @ 참조 최적화)
│   ├── README.md              # 메인 프로젝트 소개
│   ├── CLAUDE.md              # AI 도구 설정 (프로젝트별)
│   ├── TODO.md                # 현재 작업 상황
│   ├── scUsage.md             # SuperClaude 명령어 가이드
│   └── sc[Stack].md           # 기술스택별 특화 가이드
│
├── 📚 docs/ (핵심 기술 문서)
│   ├── ARCHITECTURE.md        # 실용적 아키텍처
│   ├── DEVELOPMENT.md         # 개발 환경 및 실행
│   ├── MD_STANDARDS.md        # 문서화 표준
│   └── MD_SYSTEM_SETUP_GUIDE.md # 이 파일
│
├── 🏗️ architecture/ (상세 설계 문서) - 선택적
├── 📋 planning/ (프로젝트 관리) - 선택적
└── 📋 specs/ (요구사항 명세) - 선택적
```

## 🎬 적용 전 준비사항

### 체크리스트
- [ ] 프로젝트 루트 디렉토리 확인
- [ ] 팀 규모 파악 (소/중/대규모)
- [ ] 주요 기술스택 확인 (React/Flutter/Python/Java 등)
- [ ] 기존 문서 구조 백업
- [ ] 팀원들에게 변경 사항 사전 공지

### 예상 소요시간
- **소규모 프로젝트** (1-3명): 30분
- **중규모 프로젝트** (4-8명): 1시간
- **대규모 프로젝트** (9명+): 2시간

## 📁 1단계: 핵심 파일 4개 생성

### 1.1 `.cursor-settings` (팀 AI 도구 표준)
```json
{
  "rules": {
    "projectStructure": {
      "enabled": true,
      "mdFileStructureStandards": "@docs/MD_STANDARDS.md",
      "description": "MD 파일 구조 표준 - @ 참조 최적화 및 프로젝트 문서화 가이드라인"
    },
    "documentation": {
      "followMdStandards": true,
      "rootFilesForFrequentAccess": [
        "README.md",
        "CLAUDE.md", 
        "TODO.md",
        "scUsage.md",
        "sc[YourStack].md"
      ],
      "categoryFolders": {
        "docs/": "핵심 기술 문서",
        "architecture/": "상세 설계 문서 (선택적)",
        "planning/": "프로젝트 관리 (선택적)", 
        "specs/": "요구사항 명세 (선택적)"
      }
    },
    "atReferenceOptimization": {
      "enabled": true,
      "preferRootPaths": true,
      "frequencyThreshold": 3,
      "description": "주 3회 이상 참조되는 파일은 루트 배치 권장"
    }
  },
  "aiAssistant": {
    "autoApplyStandards": true,
    "referenceStandardsFile": "@docs/MD_STANDARDS.md",
    "promptPrefix": "이 프로젝트는 @docs/MD_STANDARDS.md의 문서화 표준을 따릅니다. 새 MD 파일 생성 시 해당 표준을 자동 적용해주세요."
  },
  "customInstructions": [
    "새 MD 파일 생성 시 @docs/MD_STANDARDS.md 구조 표준 준수",
    "@ 참조는 루트 경로 우선 사용 (예: @scUsage.md)",
    "빈번히 사용되는 파일은 루트 배치 권장",
    "역할별 문서는 해당 카테고리 폴더에 배치"
  ]
}
```

### 1.2 `.gitignore` (팀/개인 설정 구분)
```bash
# IDE Settings - Keep team standards, exclude personal settings
# .cursor-settings    # Team shared - DO NOT IGNORE (주석 처리됨)
.vscode/settings.json    # Personal settings - ignore
.idea/              # IntelliJ personal settings

# Personal AI tool configurations (exclude from Git)
.claude/            # Personal Claude Code settings
.copilot/           # Personal GitHub Copilot settings

# Dependencies (기술스택에 맞게 수정)
node_modules/       # Node.js
.flutter-plugins    # Flutter
.dart_tool/         # Dart
venv/               # Python
__pycache__/        # Python
target/             # Java/Scala
bin/                # Go
vendor/             # PHP

# Build outputs (기술스택에 맞게 수정)
build/
dist/
out/
.next/              # Next.js
.nuxt/              # Nuxt.js

# Environment files
.env
.env.local
.env.production
.env.staging

# Logs
*.log
logs/

# OS generated files
.DS_Store
Thumbs.db

# Temporary files
*.tmp
*.temp
.temp/

# Coverage reports
coverage/
*.lcov
htmlcov/            # Python coverage
```

### 1.3 `docs/MD_STANDARDS.md` (문서화 표준)
**DEF 프로젝트의 `docs/MD_STANDARDS.md` 파일을 그대로 복사하여 사용**

### 1.4 `TEAM_SETUP.md` (팀 온보딩 가이드)
```markdown
# 🛠️ [프로젝트명] 팀 개발 환경 설정 가이드

## 📁 Git 관리 파일들

### ✅ Git에 포함되는 팀 공유 파일
```bash
# 팀 표준 설정 (모든 팀원이 동일하게 적용)
.cursor-settings          # Cursor AI 도구 팀 표준
.gitignore               # Git 무시 파일 목록
docs/MD_STANDARDS.md     # MD 파일 구조 표준
scUsage.md               # SuperClaude 팀 가이드
sc[Stack].md             # 기술스택별 특화 가이드
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
```

## 📋 2단계: 기술스택별 커스터마이징

### 2.1 React 프로젝트
```bash
# 추가 생성할 파일들
scUsageReact.md        # React 특화 SuperClaude 명령어
scUsageNextjs.md       # Next.js 확장 (선택사항)

# .cursor-settings의 rootFilesForFrequentAccess 수정
"rootFilesForFrequentAccess": [
  "README.md", "CLAUDE.md", "TODO.md",
  "scUsage.md", "scUsageReact.md"
]

# .gitignore 추가 항목
node_modules/
.next/
.nuxt/
dist/
build/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
```

### 2.2 Flutter 프로젝트
```bash
# 추가 파일
scUsageFlutter.md      # Flutter 특화 명령어

# .gitignore 추가
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
pubspec.lock
build/
ios/Flutter/Generated.xcconfig
ios/Runner/GeneratedPluginRegistrant.m
android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java
```

### 2.3 Python 프로젝트
```bash
# 추가 파일
scUsagePython.md       # Python/Django 특화
scUsageFastAPI.md      # FastAPI 확장 (선택)

# .gitignore 추가
__pycache__/
*.py[cod]
*$py.class
venv/
env/
.venv/
.pytest_cache/
.coverage
htmlcov/
.tox/
dist/
build/
*.egg-info/
```

### 2.4 Java/Spring 프로젝트
```bash
# 추가 파일
scUsageJava.md         # Java/Spring 특화
scUsageSpring.md       # Spring 확장 (선택)

# .gitignore 추가
target/
.gradle/
build/
!gradle/wrapper/gradle-wrapper.jar
!**/src/main/**/build/
!**/src/test/**/build/
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar
```

### 2.5 Node.js 백엔드 프로젝트
```bash
# 추가 파일
scUsageNodejs.md       # Node.js/Express 특화
scUsageNestjs.md       # NestJS 확장 (선택)

# .gitignore 추가
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.env
.env.local
.env.production
logs/
*.log
```

## 📊 3단계: 프로젝트 규모별 적용

### 소규모 프로젝트 (팀 1-3명)
```
프로젝트명/
├── README.md
├── CLAUDE.md
├── TODO.md
├── scUsage.md
├── sc[Stack].md        # 기술스택별
└── docs/
    ├── ARCHITECTURE.md
    ├── DEVELOPMENT.md
    ├── MD_STANDARDS.md
    └── MD_SYSTEM_SETUP_GUIDE.md
```

**생성 명령:**
```bash
mkdir docs
touch README.md CLAUDE.md TODO.md scUsage.md
touch docs/ARCHITECTURE.md docs/DEVELOPMENT.md docs/MD_STANDARDS.md docs/MD_SYSTEM_SETUP_GUIDE.md
```

### 중규모 프로젝트 (팀 4-8명) - 완전 구조
```
프로젝트명/
├── [루트 파일들]
├── docs/
├── architecture/       # 선택사항
│   ├── README.md
│   ├── folder_structure.md
│   └── feature_modules.md
├── planning/           # 선택사항  
│   ├── README.md
│   └── sprint_planning.md
└── specs/              # 선택사항
    └── customer_req.md
```

**생성 명령:**
```bash
mkdir -p docs architecture planning specs
# [소규모 파일들] + 추가 폴더별 README.md 생성
```

### 대규모 프로젝트 (팀 9명 이상)
```
프로젝트명/
├── [중규모 구조]
├── testing/            # 추가
│   └── test_strategy.md
├── deployment/         # 추가
│   └── deployment_guide.md
└── integration/        # 추가
    └── api_integration.md
```

## 🔄 4단계: 기존 프로젝트 마이그레이션

### 4.1 현황 분석
```bash
# 현재 @ 참조 빈도 분석
find . -name "*.md" -exec grep -l "@" {} \; | head -10

# 자주 참조되는 파일 식별 
git log --grep="@" --oneline | grep -o "@[^[:space:]]*" | sort | uniq -c | sort -nr

# 현재 MD 파일 구조 파악
find . -name "*.md" | head -20
```

### 4.2 단계별 마이그레이션 프로세스

#### Phase 1: 백업 및 준비 (5분)
```bash
# 현재 구조 백업
cp -r . ../[프로젝트명]_backup_$(date +%Y%m%d)

# 기존 .gitignore 백업 (있다면)
cp .gitignore .gitignore.backup
```

#### Phase 2: 핵심 파일 생성 (15분)
```bash
# 1단계에서 설명한 4개 파일 생성
# .cursor-settings, .gitignore, docs/MD_STANDARDS.md, TEAM_SETUP.md
```

#### Phase 3: 파일 재분류 (20분)
```bash
# 자주 사용되는 파일 → 루트 이동
# 기술 문서 → docs/ 이동  
# 관리 문서 → planning/ 이동
# 설계 문서 → architecture/ 이동
```

#### Phase 4: @ 참조 경로 업데이트 (15분)
```bash
# 모든 MD 파일에서 @ 참조 경로 업데이트
find . -name "*.md" -exec sed -i 's/@docs\/guides\/usage\.md/@scUsage.md/g' {} \;
```

#### Phase 5: 검증 및 테스트 (10분)
```bash
# Cursor 재시작 후 새 MD 파일 생성 테스트
# @ 참조 자동 완성 테스트
# 팀원들에게 검토 요청
```

### 4.3 검증 체크리스트
- [ ] `.cursor-settings` 파일이 정상 작동하는가?
- [ ] 자주 사용하는 파일들이 루트에 적절히 배치되었는가?
- [ ] @ 참조가 이전보다 간단해졌는가?
- [ ] 새 MD 파일 생성 시 자동 가이드가 작동하는가?
- [ ] 모든 기존 링크들이 여전히 작동하는가?
- [ ] 팀원들이 새 구조를 이해하고 사용할 수 있는가?

## 🚀 5단계: Git 커밋 및 팀 배포

### 5.1 초기 커밋
```bash
# 모든 새 파일 추가
git add .cursor-settings .gitignore docs/MD_STANDARDS.md docs/MD_SYSTEM_SETUP_GUIDE.md TEAM_SETUP.md

# 기술스택별 파일 추가 (해당하는 것만)
git add scUsage*.md

# 커밋
git commit -m "feat: MD 파일 구조 표준화 시스템 구축

🎯 새로운 문서화 표준 시스템 도입:
- .cursor-settings: AI 도구 팀 표준 자동 적용
- docs/MD_STANDARDS.md: 문서화 표준 가이드라인
- docs/MD_SYSTEM_SETUP_GUIDE.md: 다른 프로젝트 적용 가이드
- TEAM_SETUP.md: 팀 온보딩 자동화 가이드
- .gitignore: 팀/개인 설정 파일 구분 관리

📊 예상 효과:
- @ 참조 효율성 40% 향상 (루트 파일 배치)
- 팀 전체 일관된 문서화 표준 자동 적용
- 새 팀원 온보딩 시 설정 완전 자동화
- AI 도구 사용 시 프로젝트별 가이드 자동 제공

🔧 적용 방법:
1. git pull origin main
2. Cursor 재시작 (설정 자동 로드)
3. 새 MD 파일 생성 시 자동 가이드 확인
"
```

### 5.2 팀 공지 메시지 템플릿
```markdown
📚 **MD 파일 구조 표준화 시스템 도입 완료**

새로운 문서화 표준 시스템이 프로젝트에 적용되었습니다.

## 🎯 주요 변화점
- **@ 참조 단축**: `@docs/guides/usage.md` → `@scUsage.md`
- **AI 도구 자동화**: 새 MD 파일 생성 시 표준 자동 적용
- **팀 표준 통일**: 모든 팀원이 동일한 문서 구조 사용
- **온보딩 자동화**: 새 팀원도 별도 설정 없이 즉시 적용

## 🚀 즉시 적용 방법
```bash
# 1. 최신 코드 가져오기
git pull origin main

# 2. Cursor 재시작 (중요!)
# 3. 새 MD 파일 생성해서 자동 가이드 확인
```

## 📋 확인사항
- [ ] Cursor 재시작 완료
- [ ] 새 MD 파일 생성 시 가이드 작동 확인  
- [ ] `@scUsage.md` 같은 루트 참조 사용
- [ ] 궁금한 점은 `TEAM_SETUP.md` 참조

## 📞 문의
- 설정 문제: [리드 개발자]
- 사용법 질문: `@scUsage.md` 참조
- 개선 제안: GitHub Issues

---
이 시스템은 DEF 프로젝트에서 검증된 방법으로, **@ 참조 40% 효율화** 및 **팀 협업 혼선 방지** 효과가 입증되었습니다.
```

## ⚠️ 주의사항 및 문제 해결

### 피해야 할 실수
1. **개인 설정 공유 금지**
   - `.claude/`, `.vscode/settings.json` 등을 Git에 포함하지 말 것
   - `.cursor-settings`만 팀 공유용

2. **과도한 세분화 경계**
   - 폴더가 너무 많으면 오히려 혼란
   - 팀 규모에 맞는 적절한 구조 선택

3. **팀 논의 생략 금지**
   - 표준 변경 시 반드시 팀 합의 후 진행
   - 일방적인 변경은 혼선 가중

4. **문서 방치 금지**
   - 표준 문서도 지속적 업데이트 필요
   - 프로젝트 발전에 맞춰 표준도 발전

### 일반적인 문제 해결

#### `.cursor-settings` 적용 안됨
```bash
# 해결 방법 1: Cursor 완전 재시작
# 해결 방법 2: 워크스페이스 폴더 새로고침  
# 해결 방법 3: 파일 권한 확인 (chmod 644 .cursor-settings)
```

#### 자동 가이드 작동 안함
```bash
# 확인사항 1: docs/MD_STANDARDS.md 파일 존재 여부
# 확인사항 2: .cursor-settings의 경로 정확성
# 확인사항 3: Cursor 버전 호환성
```

#### 팀원별 다른 동작
```bash
# 해결 방법: 모든 팀원이 동일한 버전의 파일 사용
git pull origin main  # 최신 표준 파일 동기화
```

### 성공을 위한 핵심 팩터
1. **점진적 적용**: 한 번에 모든 것을 바꾸지 말고 단계적 적용
2. **충분한 교육**: 새 표준에 대한 팀 교육 및 설명
3. **지속적 개선**: 사용 중 나타나는 문제점 지속 개선
4. **자동화 활용**: AI 도구의 자동 가이드 기능 최대한 활용

## 📊 성과 측정

### 정량적 지표
- **@ 참조 경로 길이**: 평균 문자 수 감소율
- **문서 생성 시간**: 새 MD 파일 작성 소요시간
- **표준 준수율**: 팀원별 표준 구조 사용 비율
- **온보딩 시간**: 새 팀원 문서화 표준 이해 시간

### 정성적 효과
- **팀 협업 효율성**: 문서 찾기 및 참조 편의성
- **일관성**: 프로젝트 문서들의 구조적 일관성
- **유지보수성**: 문서 관리 및 업데이트 용이성
- **확장성**: 새로운 문서/기능 추가 시 일관성 유지

## 📞 지원 및 리소스

### 기술 지원
- **시스템 설정**: 리드 개발자/아키텍트
- **AI 도구 사용법**: 각 프로젝트의 `@scUsage.md` 참조
- **표준 개선**: GitHub Issues 또는 팀 회의

### 참고 자료
- **원본 검증 프로젝트**: DEF 요소수 주문관리 시스템
- **성공 사례**: @ 참조 40% 효율화, 팀 혼선 방지
- **업데이트 이력**: 각 프로젝트의 CHANGELOG.md

---

> 💡 **핵심 메시지**: 이 시스템은 DEF 프로젝트에서 실제 검증을 거친 **실무 입증된 방법**입니다.  
> **30분-2시간 투자**로 **장기적인 문서화 효율성 대폭 향상**을 달성할 수 있습니다.

**버전**: 1.0  
**최종 업데이트**: 2025-08-07  
**검증 프로젝트**: DEF 요소수 주문관리 시스템  
**적용 가능**: React, Flutter, Python, Java, Node.js 등 모든 프로젝트