# Order History Feature

## Overview
주문 내역 관리 기능으로 40-60대 사용자를 위한 최적화된 UI/UX를 제공합니다.

## Features
- 📋 주문 내역 조회 (무한 스크롤)
- 🔍 다양한 필터링 옵션 (기간, 상태, 제품 유형, 배송 방법)
- 📊 주문 통계 표시 (토글 가능)
- 📄 거래명세서 PDF 뷰어
- 💾 엑셀 다운로드 기능
- 🔄 실시간 상태 업데이트

## Architecture
```
features/history/
├── data/
│   └── services/
│       └── order_history_service.dart    # Supabase 연동 서비스
├── presentation/
│   ├── providers/
│   │   └── order_history_provider.dart   # Riverpod 상태 관리
│   ├── screens/
│   │   ├── order_history_screen.dart     # 메인 화면
│   │   └── transaction_statement_viewer.dart # PDF 뷰어
│   └── widgets/
│       ├── order_history_card.dart       # 주문 카드 위젯
│       ├── order_history_filter.dart     # 필터 위젯
│       └── order_statistics_card.dart    # 통계 카드 위젯
└── index.dart                           # Feature export
```

## Key Features for 40-60 Age Group
- **큰 글씨**: 최소 18sp 이상
- **큰 버튼**: 최소 56dp 높이
- **높은 대비**: WCAG AA 기준 충족
- **간단한 인터랙션**: 탭 중심 UI
- **명확한 피드백**: 시각적/햅틱 피드백

## Dependencies
- flutter_pdfview: ^1.3.2 (PDF 뷰어)
- dio: ^5.4.3+1 (파일 다운로드)
- path_provider: ^2.1.3 (파일 저장)

## Usage
```dart
// Navigate to order history
Navigator.pushNamed(context, '/order-history');

// Or with Riverpod
ref.read(orderHistoryProvider.notifier).loadInitial();
```