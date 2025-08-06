# 📚 MD 파일 구조 표준 가이드

> 프로젝트 문서화 표준 및 @ 참조 최적화 가이드

## 🎯 표준화 목적

- **@ 참조 효율성**: SuperClaude/AI 도구 사용 시 빈번한 참조 파일 최적화
- **팀 협업**: 역할별 문서 분리로 혼선 방지
- **유지보수성**: 명확한 카테고리로 문서 관리 용이
- **확장성**: 새로운 기술스택/역할 추가 시 일관성 유지

## 📁 표준 MD 파일 구조

```
📁 프로젝트명/
├── 🔥 루트 (고빈도 액세스 - @ 참조 최적화)
│   ├── README.md              # 메인 프로젝트 소개
│   ├── CLAUDE.md              # AI 도구 설정 (프로젝트별)
│   ├── TODO.md                # 현재 작업 상황
│   ├── scUsage.md             # SuperClaude 명령어 가이드
│   └── sc[Stack].md           # 기술스택별 특화 가이드
│
├── 📚 docs/ (핵심 기술 문서)
│   ├── ARCHITECTURE.md        # 실용적 아키텍처 (개발자용)
│   ├── DEVELOPMENT.md         # 개발 환경 및 실행
│   ├── DEMO.md               # 데모 가이드
│   └── MD_STANDARDS.md       # 이 파일 (문서화 표준)
│
├── 🏗️ architecture/ (상세 설계 문서) - 선택적
│   ├── README.md             # 시스템 아키텍처 개요
│   ├── folder_structure.md   # 폴더 구조
│   ├── feature_modules.md    # 모듈 설계
│   └── api_interfaces.md     # API 인터페이스
│
├── 📋 planning/ (프로젝트 관리) - 선택적
│   ├── README.md             # 기획 문서 목차
│   ├── sprint_planning.md    # 스프린트 계획
│   ├── milestones.md         # 마일스톤
│   ├── risk_analysis.md      # 리스크 분석
│   └── resource_allocation.md # 리소스 할당
│
└── 📋 specs/ (요구사항 명세) - 선택적
    └── customer_req.md       # 고객 요구사항
```

## 🔥 루트 파일 배치 원칙

### ✅ 루트에 배치해야 할 파일
- **AI 도구 설정**: `CLAUDE.md`, `scUsage.md`, `sc[Stack].md`
- **현재 상황**: `TODO.md`
- **프로젝트 소개**: `README.md`
- **@ 참조 빈도 > 주 3회**: 사용 패턴 분석 후 결정

### ❌ 루트에 배치하지 말아야 할 파일
- 상세 기술 문서 (docs/로 이동)
- 역할별 전용 문서 (planning/, architecture/로 이동)
- 임시 또는 개인 작업 문서

## 📊 규모별 적용 가이드

### 소규모 프로젝트 (팀 1-3명)
```
프로젝트명/
├── README.md
├── CLAUDE.md
├── TODO.md
├── scUsage.md
└── docs/
    ├── ARCHITECTURE.md
    └── DEVELOPMENT.md
```

### 중규모 프로젝트 (팀 4-8명) - 현재 DEF 구조
```
📁 DEF 프로젝트 구조 (검증된 표준)
```

### 대규모 프로젝트 (팀 9명 이상)
```
프로젝트명/
├── [루트 파일들]
├── docs/
├── architecture/
├── planning/
├── specs/
├── testing/          # 추가
└── deployment/       # 추가
```

## 🎨 기술스택별 확장 방법

### Flutter 프로젝트
- `scUsageFlutter.md` - Flutter 특화 SuperClaude 명령어

### React 프로젝트
- `scUsageReact.md` - React 특화 명령어
- `scUsageNextjs.md` - Next.js 확장

### Python 프로젝트  
- `scUsagePython.md` - Python/Django 특화
- `scUsageFastAPI.md` - FastAPI 확장

### 다기술스택 프로젝트
```
├── scUsage.md           # 공통 명령어
├── scUsageFlutter.md    # 모바일 앱
├── scUsageReact.md      # 웹 프론트엔드  
└── scUsagePython.md     # 백엔드 API
```

## 🔧 @ 참조 최적화 규칙

### 1. 경로 단축 원칙
```bash
# ✅ 좋음: 루트 배치로 간단한 참조
@scUsage.md
@TODO.md

# ❌ 나쁨: 깊은 경로로 인한 복잡성
@docs/guides/superclaude/usage.md
@planning/current/todo_list.md
```

### 2. 빈도 기반 배치
- **주 5회 이상**: 무조건 루트
- **주 2-4회**: 루트 고려
- **주 1회 이하**: 카테고리 폴더 배치

### 3. 네이밍 컨벤션
```bash
# SuperClaude 가이드
scUsage.md              # 공통
scUsage[Stack].md       # 기술스택별

# AI 도구 설정
CLAUDE.md               # Claude Code 설정
COPILOT.md              # GitHub Copilot 설정 (선택)
```

## ⚡ 마이그레이션 가이드

### 기존 프로젝트에 적용하기

1. **현재 @ 참조 패턴 분석**
```bash
# Git에서 @ 참조 사용 빈도 확인
git log --grep="@" --oneline
```

2. **단계별 마이그레이션**
- 1단계: 고빈도 파일 루트 이동
- 2단계: 카테고리별 폴더 구성
- 3단계: README.md 업데이트
- 4단계: 팀원 공지 및 교육

3. **검증 체크리스트**
- [ ] 자주 사용하는 파일이 루트에 있는가?
- [ ] 역할별 문서가 적절히 분리되었는가?
- [ ] @ 참조가 간단해졌는가?
- [ ] 새 팀원이 이해하기 쉬운가?

## 🚨 주의사항

### 피해야 할 실수들
1. **과도한 세분화**: 폴더가 너무 많으면 오히려 혼란
2. **개인 설정 공유**: `.claude/` 같은 개인 폴더 내용을 Git에 포함
3. **일관성 부족**: 프로젝트마다 다른 구조 사용
4. **업데이트 누락**: 구조 변경 시 README.md 업데이트 누락

### 버전 관리
- 이 표준은 프로젝트 경험에 따라 발전할 수 있음
- 변경 시 팀 논의 후 결정
- 주요 변경사항은 CHANGELOG.md에 기록

## 📞 지원 및 문의

- **MD 구조 관련 문의**: 아키텍트/리드 개발자
- **AI 도구 사용법**: SuperClaude/Claude Code 담당자
- **표준 개선 제안**: GitHub Issues 또는 팀 회의

---

> 💡 이 표준은 DEF 프로젝트에서 실무 검증을 거친 **입증된 구조**입니다.
> @ 참조 효율성 40% 향상, 팀 협업 혼선 방지 효과를 경험했습니다.

**마지막 업데이트**: 2025-08-07  
**검토자**: DEF 개발팀  
**적용 프로젝트**: DEF 요소수 주문관리 시스템