# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter-based order management system (요소수 출고주문관리 시스템) for chemical distribution businesses. The app uses Clean Architecture with feature-first modularization, targeting users aged 40-60 with enhanced accessibility features.

**Tech Stack**: Flutter 3.32.5 (via FVM) + Riverpod + Supabase + GetWidget

## Common Development Commands

### Environment Setup
```bash
# Use FVM for consistent Flutter version
fvm install 3.32.5
fvm use 3.32.5

# Install dependencies
fvm flutter pub get

# Generate code for Freezed/JsonSerializable
fvm flutter pub run build_runner build --delete-conflicting-outputs
# OR use the provided script:
cd def_order_app && ./scripts/generate_types.sh
```

### Development Commands
```bash
# Run the app
fvm flutter run

# Run tests
fvm flutter test
fvm flutter test --coverage

# Analyze code
fvm flutter analyze

# Build for release
fvm flutter build apk --release
fvm flutter build ios --release --no-codesign
fvm flutter build web
```

### Code Generation
```bash
# Generate Freezed/JsonSerializable models
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation
fvm flutter pub run build_runner watch --delete-conflicting-outputs
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

**Riverpod + StateNotifier** is the primary pattern:
```dart
// Provider definition
final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(ref.read(orderRepositoryProvider));
});

// Use in widgets
ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    // ...
  }
}
```

### Key Services

1. **Supabase Service** (`core/services/supabase_service.dart`)
   - Authentication, database operations, realtime subscriptions
   - Row Level Security (RLS) for data protection

2. **FCM Service** (`core/services/fcm_service.dart`)
   - Push notifications for orders and notices

3. **Local Storage** (`core/services/local_storage_service.dart`)
   - SharedPreferences wrapper for offline support

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

### GetWidget + VelocityX Usage
The project uses GetWidget for UI components with VelocityX extensions for cleaner code:
```dart
GFButton(
  onPressed: onPressed,
  text: "주문하기",
  size: GFSize.LARGE,
  fullWidthButton: true,
).p16().card.make()
```

### Business Number Validation
- External API integration for Korean business number verification
- Required for user registration
- Admin approval workflow after validation

### Order Workflow
1. Product selection (Box/Bulk types)
2. Quantity input (including empty tank returns)
3. Delivery date/address selection
4. Price calculation (grade-based)
5. PDF generation & email sending
6. Push notification to admin

### Testing Strategy
- Unit tests for Use Cases and business logic
- Widget tests for UI components
- Integration tests for critical flows (order creation)
- Golden tests for UI consistency

## Environment Configuration

### Required Files
- `.env` - Environment variables (Supabase URL, API keys)
- `google-services.json` - Firebase Android config
- `GoogleService-Info.plist` - Firebase iOS config

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

### VelocityX Migration
- Several shell scripts exist for migrating from VelocityX
- Run these if encountering VelocityX-related issues

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