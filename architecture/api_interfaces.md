# API 인터페이스 및 데이터 플로우 설계

## 1. API 아키텍처 개요

### 기술 스택
- **백엔드**: Supabase (PostgreSQL + Realtime + Auth + Storage)
- **API 통신**: Supabase Client SDK
- **실시간 통신**: Supabase Realtime
- **파일 저장**: Supabase Storage
- **외부 API**: 사업자번호 검증, FCM, 이메일 발송

### API 계층 구조
```
Flutter App
    ↓
Repository Interface (Domain Layer)
    ↓
Repository Implementation (Data Layer)
    ↓
Data Source (Remote/Local)
    ↓
Supabase Client / External APIs
```

## 2. 주요 API 인터페이스

### 2.1 인증 API

```dart
// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  // 로그인
  Future<Either<Failure, User>> loginWithBusinessNumber({
    required String businessNumber,
    required String password,
  });
  
  // 회원가입
  Future<Either<Failure, User>> register({
    required String businessNumber,
    required String businessName,
    required String representativeName,
    required String phone,
    required String email,
    required String password,
    required UserGrade grade,
  });
  
  // 사업자번호 검증
  Future<Either<Failure, BusinessInfo>> verifyBusinessNumber(String businessNumber);
  
  // 비밀번호 재설정
  Future<Either<Failure, void>> resetPassword(String email);
  
  // 로그아웃
  Future<Either<Failure, void>> logout();
  
  // 현재 사용자 조회
  Future<Either<Failure, User?>> getCurrentUser();
  
  // 사용자 상태 스트림
  Stream<User?> get authStateChanges;
}
```

### 2.2 주문 관리 API

```dart
// domain/repositories/order_repository.dart
abstract class OrderRepository {
  // 주문 생성
  Future<Either<Failure, Order>> createOrder({
    required ProductType productType,
    required int quantity,
    required int javaraQuantity,
    required int returnTankQuantity,
    required DateTime deliveryDate,
    required DeliveryMethod deliveryMethod,
    required String? deliveryAddressId,
    required String? deliveryMemo,
  });
  
  // 주문 목록 조회
  Future<Either<Failure, List<Order>>> getOrders({
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? status,
    int? limit,
    int? offset,
  });
  
  // 주문 상세 조회
  Future<Either<Failure, Order>> getOrderById(String orderId);
  
  // 주문 수정 (대기 상태만)
  Future<Either<Failure, Order>> updateOrder({
    required String orderId,
    required Map<String, dynamic> updates,
  });
  
  // 주문 취소
  Future<Either<Failure, void>> cancelOrder({
    required String orderId,
    required String reason,
  });
  
  // 주문 상태 실시간 구독
  Stream<Order> subscribeToOrderUpdates(String orderId);
  
  // 가격 계산
  Future<Either<Failure, PriceCalculation>> calculatePrice({
    required ProductType productType,
    required int quantity,
  });
}
```

### 2.3 거래명세서 API

```dart
// domain/repositories/invoice_repository.dart
abstract class InvoiceRepository {
  // 거래명세서 조회
  Future<Either<Failure, Invoice>> getInvoice(String orderId);
  
  // PDF 생성
  Future<Either<Failure, String>> generateInvoicePdf(String orderId);
  
  // PDF 다운로드
  Future<Either<Failure, Uint8List>> downloadInvoicePdf(String invoiceId);
  
  // 이메일 발송
  Future<Either<Failure, void>> sendInvoiceEmail({
    required String invoiceId,
    required String email,
  });
}
```

### 2.4 재고 관리 API

```dart
// domain/repositories/inventory_repository.dart
abstract class InventoryRepository {
  // 재고 확인
  Future<Either<Failure, InventoryStatus>> checkInventory({
    required String location,
    required ProductType productType,
  });
  
  // 재고 목록
  Future<Either<Failure, List<Inventory>>> getInventoryList();
  
  // 재고 실시간 구독
  Stream<Inventory> subscribeToInventoryUpdates();
}
```

### 2.5 알림 API

```dart
// domain/repositories/notification_repository.dart
abstract class NotificationRepository {
  // 알림 목록
  Future<Either<Failure, List<Notification>>> getNotifications({
    bool? unreadOnly,
    int? limit,
  });
  
  // 알림 읽음 처리
  Future<Either<Failure, void>> markAsRead(String notificationId);
  
  // FCM 토큰 등록
  Future<Either<Failure, void>> registerFcmToken(String token);
  
  // 실시간 알림 구독
  Stream<Notification> subscribeToNotifications();
}
```

## 3. 데이터 플로우

### 3.1 주문 생성 플로우
```
1. User → OrderCreatePage (UI)
2. OrderFormProvider (State) → Validation
3. CreateOrderUseCase (Domain)
4. OrderRepository (Domain Interface)
5. OrderRepositoryImpl (Data)
6. OrderRemoteDataSource → Supabase
7. Supabase → Database Transaction
   - Order 생성
   - Inventory 차감
   - Notification 생성
8. Response → UI Update
9. Realtime → Push Notification
```

### 3.2 실시간 업데이트 플로우
```
1. Supabase Realtime → WebSocket
2. SupabaseClient → Stream
3. Repository → Stream Transformation
4. Provider → State Update
5. UI → Automatic Rebuild
```

### 3.3 오프라인 지원 플로우
```
1. Network Check
2. If Offline:
   - Save to Local Database (Drift/Isar)
   - Queue for Sync
3. If Online:
   - Sync Queue Processing
   - Conflict Resolution
   - Update Local Cache
```

## 4. Supabase 클라이언트 설정

```dart
// config/supabase_config.dart
class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_URL';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authCallbackUrlHostname: 'login-callback',
      debug: kDebugMode,
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
```

## 5. 에러 처리 전략

### 5.1 에러 타입 정의
```dart
// core/errors/failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('네트워크 연결을 확인해주세요');
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class PermissionFailure extends Failure {
  const PermissionFailure() : super('권한이 없습니다');
}
```

### 5.2 에러 처리 예시
```dart
// data/repositories/order_repository_impl.dart
class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<Either<Failure, Order>> createOrder(...) async {
    try {
      // 네트워크 체크
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure());
      }
      
      // 재고 확인
      final hasStock = await _checkInventory(...);
      if (!hasStock) {
        return Left(ValidationFailure('재고가 부족합니다'));
      }
      
      // 주문 생성
      final response = await _supabase
          .from('orders')
          .insert(orderData)
          .select()
          .single();
          
      return Right(OrderModel.fromJson(response));
      
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('주문 생성 중 오류가 발생했습니다'));
    }
  }
}
```

## 6. 보안 고려사항

### 6.1 단가 정보 보안
- RLS(Row Level Security)로 사용자별 접근 제어
- 단가 정보는 서버에서만 계산
- 클라이언트에 최소한의 정보만 노출

### 6.2 API 보안
- Supabase JWT 토큰 인증
- API Rate Limiting
- Request Signing for External APIs

### 6.3 데이터 암호화
- HTTPS/WSS 통신
- 민감 정보 암호화 저장
- 로컬 캐시 암호화

## 7. 성능 최적화

### 7.1 캐싱 전략
```dart
// 메모리 캐시
final orderCache = <String, Order>{};

// 로컬 DB 캐시
class LocalCacheManager {
  Future<void> cacheOrders(List<Order> orders);
  Future<List<Order>> getCachedOrders();
}
```

### 7.2 페이지네이션
```dart
// 무한 스크롤 구현
final ordersProvider = StateNotifierProvider<OrderListNotifier, AsyncValue<List<Order>>>((ref) {
  return OrderListNotifier(ref.read);
});

class OrderListNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  int _page = 0;
  final int _limit = 20;
  bool _hasMore = true;
  
  Future<void> loadMore() async {
    if (!_hasMore) return;
    
    final result = await _repository.getOrders(
      limit: _limit,
      offset: _page * _limit,
    );
    
    // Update state...
  }
}
```

### 7.3 이미지 최적화
- Supabase Storage Transform 활용
- 썸네일 자동 생성
- WebP 포맷 지원

## 8. 모니터링 및 로깅

### 8.1 API 모니터링
- Request/Response 로깅
- 에러 추적 (Sentry/Firebase Crashlytics)
- 성능 메트릭스

### 8.2 사용자 행동 분석
- Firebase Analytics
- 커스텀 이벤트 추적
- 퍼널 분석