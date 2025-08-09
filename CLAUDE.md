# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter-based B2B order management system (요소수 출고주문관리 시스템) for chemical distribution businesses. The app uses Clean Architecture with feature-first modularization, targeting users aged 40-60 with enhanced accessibility features.

**Tech Stack**: Flutter 3.32.5 (via FVM) + Riverpod + Supabase + GetWidget  
**Project Root**: `def_order_app/` directory contains the Flutter application  
**Project Status**: Demo phase implementation in progress (4/5 phases complete)

## Common Development Commands

### Environment Setup
```bash
# Use FVM for consistent Flutter version (required)
fvm install 3.32.5
fvm use 3.32.5

# Navigate to project directory
cd def_order_app

# Install dependencies
fvm flutter pub get

# Generate code for Freezed/JsonSerializable/Riverpod
fvm flutter pub run build_runner build --delete-conflicting-outputs
# OR use the provided script:
./scripts/generate_types.sh
```

### Development Commands
```bash
# Run the app (always use demo mode for development)
fvm flutter run -d chrome --dart-define=IS_DEMO=true --web-port 5000
fvm flutter run -d android --dart-define=IS_DEMO=true  
fvm flutter run -d ios --dart-define=IS_DEMO=true
fvm flutter run -d windows --dart-define=IS_DEMO=true

# Code quality checks
fvm flutter analyze
fvm flutter test
fvm flutter test --coverage

# Build for release
fvm flutter build web --release --dart-define=IS_DEMO=true
fvm flutter build apk --release --dart-define=IS_DEMO=true
fvm flutter build ios --release --no-codesign --dart-define=IS_DEMO=true
```

### Flutter Run Commands 상세 분석

#### 개발 명령어 비교

**✅ 올바른 사용법: `fvm flutter run -d chrome --dart-define=IS_DEMO=true`**
- **데모 모드 활성화**: Supabase 우회, 로컬 mock 데이터 사용
- **보안**: API 키/인증 정보 노출 없음
- **용도**: 개발, 테스트, PWA 배포에 적합
- **Hot Reload**: Debug 모드에서 자동 활성화

**❌ 잘못된 사용법: `fvm flutter run -d chrome --hot`**
- `--hot` 플래그는 존재하지 않음 (hot reload는 기본 활성화)
- IS_DEMO 미지정 시 defaultValue='true'로 자동 설정
- 명령어 의도가 불명확함

#### PWA 배포 아키텍처

**Demo Mode (IS_DEMO=true) 특징**:
| 구분 | Demo Mode | Production Mode |
|------|-----------|-----------------|
| **데이터 소스** | LocalStorageService | Supabase Realtime |
| **인증** | Hardcoded Demo Users | Supabase Auth |
| **보안** | 완전 오프라인 | RLS + JWT |
| **배포** | Static CDN 가능 | 서버 환경 필요 |
| **성능** | 즉시 응답 (0ms) | 네트워크 지연 |

**PWA 빌드 및 배포**:
```bash
# PWA Production 빌드
fvm flutter build web --release --dart-define=IS_DEMO=true

# 빌드 결과물 위치
# build/web/ → GitHub Pages에 직접 배포 가능

# 배포 프로세스
# 1. 빌드 실행
# 2. build/web/ 폴더를 GitHub Pages branch에 복사
# 3. Custom domain 설정 (선택사항)
# 4. PWA 설치 프롬프트 자동 활성화
```

**중요 사항**:
- 항상 `--dart-define=IS_DEMO=true` 명시적 선언
- GitHub Pages 배포 시 반드시 Demo Mode 사용
- Demo 계정: dealer@demo.com / demo1234, general@demo.com / demo1234

### Code Generation
```bash
# Generate Freezed/JsonSerializable/Riverpod code
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
fvm flutter pub run build_runner watch --delete-conflicting-outputs

# Clean and regenerate all generated files
fvm flutter packages pub run build_runner clean
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture & Code Structure

### Clean Architecture Layers

1. **Domain Layer** (`lib/features/*/domain/`)
   - Pure Dart business logic
   - Entities (with Freezed)
   - Use Cases (implementing UseCase interface)
   - Repository interfaces
   - No external dependencies

2. **Data Layer** (`lib/features/*/data/`)
   - Repository implementations
   - Models (Freezed + JsonSerializable)
   - Services (Supabase, API clients)
   - Data sources

3. **Presentation Layer** (`lib/features/*/presentation/`)
   - Screens/Pages
   - Widgets
   - Providers (Riverpod StateNotifier)
   - UI state management

### Feature Modules

Each feature follows the same structure:
```
features/
├── auth/          # Authentication & user management
├── order/         # Order creation and management
├── history/       # Order history and statements
├── notice/        # Announcements and notifications
├── notification/  # Push notifications (FCM)
└── home/          # Main dashboard
```

### State Management Pattern

**Riverpod + StateNotifier + Riverpod Generator** is the primary pattern:
```dart
// Provider definition with riverpod_generator
@riverpod
class OrderNotifier extends _$OrderNotifier {
  @override
  OrderState build() => const OrderState.initial();
  
  Future<void> createOrder(OrderEntity order) async {
    // Implementation
  }
}

// Use in widgets (ConsumerWidget pattern)
class OrderScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderNotifierProvider);
    // Handle states: loading, data, error
    return orderState.when(
      loading: () => CircularProgressIndicator(),
      data: (orders) => OrderList(orders: orders),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

### Key Services

1. **Supabase Config** (`core/config/supabase_config.dart`)
   - Centralized Supabase client management with demo mode support
   - Authentication, database operations, realtime subscriptions
   - Row Level Security (RLS) for data protection
   - **Critical**: All services must check `SupabaseConfig.isDemoMode` before operations

2. **FCM Service** (`core/services/fcm_service.dart`)
   - Push notifications for orders and notices
   - Demo mode compatible (no-op in demo)

3. **Local Storage Service** (`core/services/local_storage_service.dart`)
   - SharedPreferences wrapper for offline support and demo data

## Important Implementation Details

### User Grade System
- **대리점 (Distributor)**: Full access, special pricing
- **일반 (Regular)**: Limited features, standard pricing
- Pricing calculations are server-side only for security

### Accessibility Requirements (40-60 age group)
- Minimum font size: 16sp
- Touch targets: 48dp minimum
- High contrast colors (WCAG AA compliant)
- Simple navigation (max 3 taps to complete tasks)

### GetWidget + VelocityX Compatibility Layer
The project uses GetWidget for UI components with a custom VelocityX compatibility layer:
```dart
// Import the compatibility layer
import '../core/utils/velocity_x_compat.dart';

// Usage remains the same as VelocityX
GFButton(
  onPressed: onPressed,
  text: "주문하기",
  size: GFSize.LARGE,
  fullWidthButton: true,
).p16().card.make();

// Text building
"제목".text.size(18).bold.make();

// Spacing
16.heightBox, 8.widthBox
```

### Business Number Validation
- External API integration for Korean business number verification
- Required for user registration
- Admin approval workflow after validation

### Order Workflow
1. Product selection (Box/Bulk types with realtime inventory check)
2. Quantity input (including empty tank returns)
3. Delivery date/address selection
4. Price calculation (grade-based, server-side only)
5. PDF generation & email sending (demo mode: local preview only)
6. Push notification to admin (demo mode: disabled)

### Testing Strategy
- Unit tests for Use Cases and business logic (using Dartz Either pattern)
- Widget tests for UI components (ConsumerWidget pattern)
- Integration tests for critical flows (order creation, demo mode)
- Golden tests for UI consistency (40-60 age group accessibility)

## Environment Configuration

### Required Files
- `.env` - Environment variables (Supabase URL, API keys, `IS_DEMO=true`)
- `google-services.json` - Firebase Android config (FCM setup)
- `GoogleService-Info.plist` - Firebase iOS config (FCM setup)
- `.fvmrc` - Flutter version management (3.32.5)

### Supabase Functions
Located in `supabase/functions/`:
- `process-order` - Order processing logic
- `send-notification` - FCM notification sender
- `validate-business-number` - Business validation API

## Common Issues & Solutions

### Build Issues
- Run `fvm flutter clean` and rebuild
- Ensure all code generation is complete
- Check FVM is using correct Flutter version (3.32.5)

### Supabase Connection
- Verify `.env` file exists with correct credentials
- Check network connectivity
- Ensure RLS policies are properly configured

### State Management
- Always dispose providers properly
- Use `ref.invalidate()` for cache clearing
- Handle loading/error states in UI

### VelocityX Compatibility
- VelocityX has been removed due to Flutter 3.32.5 compatibility issues
- **Critical**: Use the compatibility layer in `lib/core/utils/velocity_x_compat.dart`
- Provides VelocityX-like extension methods (.p16(), .text.bold.make(), etc.)
- Import this file when VelocityX syntax is needed
- Never add VelocityX as a dependency - use the compatibility layer

### Demo Mode (Primary Development Mode)
- **Always use demo mode for development**: `--dart-define=IS_DEMO=true`
- Demo mode bypasses Supabase authentication and uses local test data
- Demo accounts (hardcoded):
  - Dealer: `dealer@demo.com` / `demo1234`
  - Regular: `general@demo.com` / `demo1234`
- **Critical**: All Supabase services throw exceptions in demo mode
- Use `SupabaseConfig.isDemoMode` to check mode in all service implementations

## Performance Considerations

1. **Image Caching**: Use `CachedNetworkImage` for all remote images
2. **Pagination**: Implement for order lists (20 items per page)
3. **Offline Support**: Cache critical data using SharedPreferences
4. **State Optimization**: Use `select()` to minimize rebuilds

## Security Best Practices

1. Never expose pricing logic on client
2. All sensitive operations through Supabase Functions
3. Implement proper RLS policies
4. Validate all inputs on both client and server
5. Use environment variables for sensitive configuration

## Critical Development Patterns

### Demo Mode Handling (Mandatory)
All Supabase-dependent services must check demo mode before any operation:
```dart
// Service layer - throw exceptions
if (SupabaseConfig.isDemoMode) {
  throw Exception('데모 모드에서는 사용할 수 없습니다');
}

// Repository layer - return demo data
if (SupabaseConfig.isDemoMode) {
  return Right(mockDemoData);
}
```

### Provider Error Handling
Wrap all provider initialization with demo mode error handling:
```dart
@riverpod
class SomeNotifier extends _$SomeNotifier {
  @override
  SomeState build() {
    try {
      _service = ref.watch(someServiceProvider);
      return const SomeState.initial();
    } catch (e) {
      return SomeState.error('데모 모드에서는 사용할 수 없습니다');
    }
  }
}
```

### UseCase Pattern (Dartz Either)
All Use Cases must return Either<Failure, T> for error handling:
```dart
class SomeUseCase implements UseCase<SomeType, SomeParams> {
  @override
  Future<Either<Failure, SomeType>> call(SomeParams params) async {
    try {
      final result = await repository.someMethod(params);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

### Code Generation Dependencies
Always run code generation after adding:
- `@freezed` classes (entities/models)
- `@riverpod` providers
- `@JsonSerializable` models
```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

## Platform-Specific Notes

### Running on Different Platforms
When developing on different platforms, always navigate to `def_order_app/` first:
```bash
cd def_order_app
# Then run platform-specific commands
fvm flutter run -d chrome --dart-define=IS_DEMO=true
fvm flutter run -d windows --dart-define=IS_DEMO=true
```

## Project-Specific Constraints

### Onboarding System
- Uses ShowcaseView for senior-friendly guided tours
- All onboarding state managed through SharedPreferences
- Target 40-60 age group with enhanced visual cues and animations
- Onboarding keys defined in `features/onboarding/presentation/config/onboarding_keys.dart`

### Real-time Features
- Inventory dashboard with live Supabase subscriptions
- Demo mode simulates realtime updates with local timers
- Critical stock alerts with configurable thresholds

### UI Framework Requirements
- **Never add VelocityX dependency** - use compatibility layer only
- GetWidget components for consistent senior-friendly UI
- Flutter Animate for smooth transitions (40-60 age group appropriate)
- Minimum 16sp font sizes, 48dp touch targets

### Development Workflow
1. Always start with demo mode enabled
2. Run code generation after entity/provider changes
3. Test on multiple devices (mobile, web, desktop)
4. Validate accessibility compliance (WCAG AA)
5. Check senior-friendly UI guidelines compliance