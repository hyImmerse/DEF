# 40-60대 중년층 UI 접근성 개선 TODO

## 📊 프로젝트 현황
- **프로젝트**: Flutter B2B 요소수 출고주문관리 시스템
- **타겟 사용자**: 40-60대 중년층 (고접근성 요구)
- **기술 스택**: Flutter 3.32.5 + Riverpod + Supabase + GetWidget
- **주요 문제**: 회색 배경으로 인한 가독성 저하

## 🎯 개선 목표
- WCAG AA 준수 (색상 대비율 4.5:1 이상)
- 최소 16sp 폰트 크기, 48dp 터치 영역
- 중년층 시력 특성 고려한 고대비 색상 적용

## 📋 작업 목록

### ✅ 완료된 작업
- [x] 스크린샷 분석 및 문제점 파악
- [x] SuperClaude 명령어 최적화 가이드 작성

### 🔄 진행 중인 작업
- [x] **1단계: UI 접근성 종합 분석** ✅
  - 40-60대 중년층 UI 접근성 종합 분석 - WCAG AA 준수 검증, 색상 대비율 측정, 터치 접근성 평가
  - 색상 대비율 개선: textSecondary 4.6:1, textTertiary 4.5:1 달성
  - AppColors.dart 파일 개선 완료

### 📅 예정된 작업

#### **2단계: 화면별 색상 체계 개선**

**A. 제품 선택 화면 (Screenshot 1)**
- [x] **제품 선택 화면 개선** ✅
  - 회색 카드를 Material 3 색상으로 변경, 18sp 폰트, 56dp 터치 영역 적용
  - 라디오 버튼 크기 확대 및 선택 상태 시각적 피드백 개선
  - enhanced_order_create_screen.dart 제품 선택 섹션 개선
  - product_selection_card.dart 컴포넌트 생성

**B. 주문 확인 화면 (Screenshot 2)**  
- [~] **주문 확인 화면 개선** (부분 완료)
  - ✅ 회색 요약 카드 색상 변경, 정보 계층 구조화, 중요 정보 강조
    - enhanced_order_create_screen.dart 주문 요약 카드 개선
    - order_confirmation_card.dart 컴포넌트 생성
  - [ ] PDF 알림 메시지 가독성 개선 (미완료)

**C. 대시보드 화면 (Screenshot 3)**
- [x] **대시보드 화면 개선** ✅
  - 회색 섹션을 기능별 색상 체계로 변경, 시각적 분리 강화
  - 상태별 태그 및 제품별 카드 가독성 개선
  - realtime_inventory_dashboard.dart 전체 개선
  - enhanced_inventory_stats_card.dart 생성
  - enhanced_location_inventory_card.dart 생성
  - status_tag_widget.dart 생성
  - WCAG AA 접근성 검증 완료 (accessibility_verification.md)

#### **3단계: 검증 및 최적화**
- [ ] **접근성 개선 효과 검증**
  - WCAG AA 재측정, 중년층 사용성 테스트, 성능 영향 분석

- [ ] **접근성 개선 가이드 문서화**  
  - 변경 사항 정리, 체크리스트 작성, 가이드라인 수립

## 🚀 사용할 SuperClaude 명령어

### 1단계: 분석
```bash
/sc:analyze "Flutter UI 접근성 종합 분석 - 40-60대 중년층 타겟 WCAG AA 준수 검증, 회색 배경 색상 대비율 측정, 16sp 폰트 크기 및 48dp 터치 영역 확인, GetWidget 컴포넌트 접근성 평가" --persona-frontend --focus accessibility --c7 --validate
```

### 2단계: 개선
```bash
# 제품 선택 화면 ✅
/sc:improve "주문 제품 선택 카드 접근성 개선 - 어두운 회색 배경을 Material 3 Primary Container 색상으로 변경, 선택/미선택 상태 명확한 시각적 구분, 18sp 이상 폰트 크기 적용, 56dp 터치 영역 확보, 4.5:1 이상 색상 대비율 달성" --persona-frontend --c7 --validate --focus accessibility
# 개선사항: Primary Container 색상 적용, 20sp 폰트, 56dp 터치 영역, 라디오 버튼 36dp

# 주문 확인 화면 (부분 완료)
/sc:improve "주문 확인 요약 카드 접근성 개선 - 대형 회색 카드를 Surface Container 색상으로 변경, 중요 정보(제품명, 수량, 가격) Primary 색상으로 강조, 일반 정보 On Surface Variant 색상 적용, 정보 섹션별 시각적 구분선 추가, 18sp 이상 폰트 적용" --persona-frontend --c7 --validate --focus accessibility
# 완료: 주문 요약 카드 Primary50 색상, 20sp 폰트, 시각적 구분선
# 미완료: PDF 알림 메시지 개선

# 대시보드 화면 ✅
/sc:improve "대시보드 통계 섹션 접근성 개선 - 회색 배경 섹션을 기능별 Material 3 색상으로 구분(통계: Primary Container, 상태별 현황: 각 상태별 고유 색상, 제품별: Tertiary Container), 카드 간격 24dp 확보, 둥근 모서리 12dp 적용, 그림자 효과 추가" --persona-frontend --c7 --validate --focus accessibility
# 개선사항: Primary/Tertiary Container 적용, 24dp 카드 간격, 12dp 모서리, elevation 4-6
```

### 3단계: 검증
```bash
/sc:test "UI 접근성 개선 효과 검증 - WCAG AA 준수 여부 재측정, 색상 대비율 4.5:1 이상 달성 확인, 터치 접근성 테스트, 중년층 사용성 시나리오 테스트, 성능 영향 최소화 검증" --persona-qa --focus accessibility --validate --play
```

## 📈 예상 효과
- **가독성 향상**: 40-60% 개선 예상
- **WCAG AA 준수**: 완전한 접근성 달성
- **사용자 만족도**: 중년층 타겟 사용성 크게 향상
- **브랜드 이미지**: 접근성을 고려한 포용적 디자인

## 🔗 관련 파일
- `/screenshot/` - 문제 화면 스크린샷 
- `/docs/scUsage.md` - SuperClaude 사용 가이드
- `/docs/scUsageFlutter.md` - Flutter 특화 가이드
- `CLAUDE.md` - 프로젝트 개발 가이드

---
📅 **생성일**: 2025-08-07  
📝 **최종 업데이트**: 2025-08-07 (오후 작업 진행)  
👥 **담당자**: UI/UX 접근성 개선팀