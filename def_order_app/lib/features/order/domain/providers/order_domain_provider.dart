import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/providers/base_notifiers.dart';
import '../../../../core/providers/error_handler.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/utils/logger.dart';
import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/repositories/demo_order_repository_impl.dart';
import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';
import '../usecases/create_order_usecase.dart';
import '../usecases/update_order_usecase.dart';
import '../usecases/get_orders_usecase.dart';
import '../usecases/calculate_order_price_usecase.dart';
import '../usecases/generate_pdf_usecase.dart';
import '../usecases/send_email_usecase.dart';
import '../usecases/process_transaction_statement_usecase.dart';
import '../../data/services/pdf_service.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/email_service.dart';

part 'order_domain_provider.g.dart';

/// 주문 도메인 상태
class OrderDomainState extends BasePaginatedState<OrderEntity> {
  final Map<String, OrderEntity> orderCache;
  final OrderFilters filters;
  final OrderSortOption sortOption;
  
  const OrderDomainState({
    List<OrderEntity>? data,
    bool isLoading = false,
    super.error,
    super.hasMore = true,
    super.currentPage = 0,
    super.pageSize = 20,
    this.orderCache = const {},
    this.filters = const OrderFilters(),
    this.sortOption = OrderSortOption.createdAtDesc,
  }) : super(data: data, isLoading: isLoading);
  
  OrderDomainState copyWith({
    List<OrderEntity>? data,
    bool? isLoading,
    Failure? error,
    bool? hasMore,
    int? currentPage,
    int? pageSize,
    Map<String, OrderEntity>? orderCache,
    OrderFilters? filters,
    OrderSortOption? sortOption,
  }) {
    return OrderDomainState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      orderCache: orderCache ?? this.orderCache,
      filters: filters ?? this.filters,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

/// 주문 필터 옵션
class OrderFilters {
  final OrderStatus? status;
  final ProductType? productType;
  final DeliveryMethod? deliveryMethod;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;
  
  const OrderFilters({
    this.status,
    this.productType,
    this.deliveryMethod,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });
  
  OrderFilters copyWith({
    OrderStatus? status,
    ProductType? productType,
    DeliveryMethod? deliveryMethod,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    return OrderFilters(
      status: status ?? this.status,
      productType: productType ?? this.productType,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'status': status?.name,
      'productType': productType?.name,
      'deliveryMethod': deliveryMethod?.name,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'searchQuery': searchQuery,
    };
  }
}

/// 주문 정렬 옵션
enum OrderSortOption {
  createdAtDesc,
  createdAtAsc,
  deliveryDateDesc,
  deliveryDateAsc,
  totalPriceDesc,
  totalPriceAsc,
}

/// 주문 도메인 Provider
@riverpod
class OrderDomain extends _$OrderDomain {
  
  late final OrderRepository _repository;
  late final GetOrdersUseCase _getOrdersUseCase;
  late final CreateOrderUseCase _createOrderUseCase;
  late final UpdateOrderUseCase _updateOrderUseCase;
  late final CalculateOrderPriceUseCase _calculatePriceUseCase;
  
  Logger get logger => ref.read(loggerProvider);
  
  /// Cache for storing data
  final Map<String, dynamic> _cache = <String, dynamic>{};
  
  /// Get data from cache
  T? getFromCache<T>(String key) {
    return _cache[key] as T?;
  }
  
  /// Save data to cache
  void saveToCache<T>(String key, T data) {
    _cache[key] = data;
  }
  
  /// Invalidate cache
  void invalidateCache() {
    _cache.clear();
  }
  
  /// Merge pages for pagination
  List<T> mergePages<T>(List<T> existing, List<T> newItems, {bool refresh = false}) {
    if (refresh) {
      return newItems;
    }
    return [...existing, ...newItems];
  }
  
  /// Map exception to failure
  Failure mapExceptionToFailure(dynamic exception) {
    logger.e('Exception occurred', exception);
    
    if (exception is AppAuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        errors: exception.errors ?? {},
      );
    } else if (exception is PostgrestException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
      );
    } else {
      return UnknownFailure(
        message: exception.toString(),
      );
    }
  }
  
  @override
  OrderDomainState build() {
    _repository = ref.watch(orderRepositoryProvider);
    _getOrdersUseCase = ref.watch(getOrdersUseCaseProvider);
    _createOrderUseCase = ref.watch(createOrderUseCaseProvider);
    _updateOrderUseCase = ref.watch(updateOrderUseCaseProvider);
    _calculatePriceUseCase = ref.watch(calculateOrderPriceUseCaseProvider);
    
    // 초기 데이터 로드
    loadOrders();
    
    return const OrderDomainState(isLoading: true);
  }
  
  /// 주문 목록 로드
  Future<void> loadOrders({bool refresh = false}) async {
    if (!refresh && state.isLoading) return;
    
    state = state.copyWith(
      isLoading: true,
      error: null,
    );
    
    try {
      // 캐시 확인
      final cacheKey = 'orders_${state.filters.toMap()}';
      if (!refresh) {
        final cached = getFromCache(cacheKey);
        if (cached != null) {
          state = state.copyWith(
            data: cached,
            isLoading: false,
          );
          return;
        }
      }
      
      final page = refresh ? 0 : state.currentPage;
      final result = await _getOrdersUseCase.execute(
        GetOrdersParams(
          offset: page * state.pageSize,
          limit: state.pageSize,
          status: state.filters.status,
          productType: state.filters.productType,
          deliveryMethod: state.filters.deliveryMethod,
          startDate: state.filters.startDate,
          endDate: state.filters.endDate,
          searchQuery: state.filters.searchQuery,
        ),
      );
      
      final mergedOrders = mergePages(
        state.items,
        result.orders,
        refresh: refresh,
      );
      
      // 캐시 업데이트
      final updatedCache = Map<String, OrderEntity>.from(state.orderCache);
      for (final order in result.orders) {
        updatedCache[order.id] = order;
      }
      
      state = state.copyWith(
        data: mergedOrders,
        isLoading: false,
        hasMore: result.hasMore,
        currentPage: page + 1,
        orderCache: updatedCache,
      );
      
      // 캐시 저장
      saveToCache(cacheKey, mergedOrders);
    } catch (e, stackTrace) {
      final failure = mapExceptionToFailure(e);
      state = state.copyWith(
        isLoading: false,
        error: failure,
      );
      
      logger.e('Error in loadOrders', e, stackTrace);
    }
  }
  
  /// 다음 페이지 로드 - Override from mixin
  @override
  Future<List<OrderEntity>> loadNextPage({
    required int offset,
    required int limit,
    required Future<List<OrderEntity>> Function(int offset, int limit) fetcher,
  }) async {
    if (!state.canLoadMore) return [];
    return await fetcher(offset, limit);
  }
  
  /// 다음 페이지 로드 - Convenience method
  Future<void> loadMoreOrders() async {
    if (!state.canLoadMore) return;
    await loadOrders();
  }
  
  /// 필터 적용
  Future<void> applyFilters(OrderFilters filters) async {
    state = state.copyWith(filters: filters);
    await loadOrders(refresh: true);
  }
  
  /// 정렬 옵션 변경
  Future<void> changeSortOption(OrderSortOption option) async {
    state = state.copyWith(sortOption: option);
    await loadOrders(refresh: true);
  }
  
  /// 검색
  Future<void> search(String query) async {
    state = state.copyWith(
      filters: state.filters.copyWith(searchQuery: query),
    );
    await loadOrders(refresh: true);
  }
  
  /// 주문 생성
  Future<OrderEntity> createOrder(CreateOrderParams params) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final order = await _createOrderUseCase.execute(params);
      
      // 캐시 업데이트
      final updatedCache = Map<String, OrderEntity>.from(state.orderCache);
      updatedCache[order.id] = order;
      
      // 목록 맨 앞에 추가
      final updatedOrders = [order, ...state.items];
      
      state = state.copyWith(
        data: updatedOrders,
        isLoading: false,
        orderCache: updatedCache,
      );
      
      // 캐시 무효화
      invalidateCache();
      
      return order;
    } catch (e, stackTrace) {
      final failure = mapExceptionToFailure(e);
      state = state.copyWith(
        isLoading: false,
        error: failure,
      );
      
      logger.e('Error in createOrder', e, stackTrace);
      
      rethrow;
    }
  }
  
  /// 주문 수정
  Future<OrderEntity> updateOrder(UpdateOrderParams params) async {
    try {
      final order = await _updateOrderUseCase.execute(params);
      
      // 캐시 업데이트
      final updatedCache = Map<String, OrderEntity>.from(state.orderCache);
      updatedCache[order.id] = order;
      
      // 목록 업데이트
      final updatedOrders = state.items.map((o) {
        return o.id == order.id ? order : o;
      }).toList();
      
      state = state.copyWith(
        data: updatedOrders,
        orderCache: updatedCache,
      );
      
      // 캐시 무효화
      invalidateCache();
      
      return order;
    } catch (e, stackTrace) {
      logger.e('Error in updateOrder', e, stackTrace);
      
      rethrow;
    }
  }
  
  /// 주문 상세 조회 (캐시 우선)
  Future<OrderEntity?> getOrderById(String orderId) async {
    // 캐시 확인
    if (state.orderCache.containsKey(orderId)) {
      return state.orderCache[orderId];
    }
    
    try {
      final order = await _repository.getOrderById(orderId);
      
      if (order != null) {
        // 캐시 업데이트
        final updatedCache = Map<String, OrderEntity>.from(state.orderCache);
        updatedCache[orderId] = order;
        
        state = state.copyWith(orderCache: updatedCache);
      }
      
      return order;
    } catch (e, stackTrace) {
      logger.e('Error in getOrderById', e, stackTrace);
      
      return null;
    }
  }
  
  /// 가격 계산
  Future<double> calculatePrice(CalculatePriceParams params) async {
    try {
      final result = await _calculatePriceUseCase.call(params);
      
      return result.fold(
        (failure) => throw failure,
        (price) => price,
      );
    } catch (e, stackTrace) {
      logger.e('Error in calculatePrice', e, stackTrace);
      
      rethrow;
    }
  }
  
  /// 주문 상태별 개수
  Map<OrderStatus, int> get orderCountByStatus {
    final counts = <OrderStatus, int>{};
    
    for (final order in state.items) {
      counts[order.status] = (counts[order.status] ?? 0) + 1;
    }
    
    return counts;
  }
  
  /// 오늘의 주문 개수
  int get todayOrderCount {
    final today = DateTime.now();
    return state.items.where((order) {
      return order.createdAt.year == today.year &&
             order.createdAt.month == today.month &&
             order.createdAt.day == today.day;
    }).length;
  }
  
  /// 대기 중인 주문 개수
  int get pendingOrderCount {
    return state.items.where((order) => order.status == OrderStatus.pending).length;
  }
}

/// Service Provider
@riverpod
OrderService orderService(OrderServiceRef ref) {
  // 데모 모드에서는 OrderService를 사용하지 않으므로 더미 인스턴스 반환
  final isDemoMode = dotenv.env['IS_DEMO'] == 'true';
  if (isDemoMode) {
    throw Exception('데모 모드에서는 OrderService를 사용할 수 없습니다');
  }
  return OrderService();
}

/// Repository Provider
@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  // 데모 모드 체크
  final isDemoMode = dotenv.env['IS_DEMO'] == 'true';
  
  if (isDemoMode) {
    return DemoOrderRepositoryImpl();
  } else {
    final orderService = ref.watch(orderServiceProvider);
    return OrderRepositoryImpl(orderService: orderService);
  }
}

/// UseCase Providers
@riverpod
GetOrdersUseCase getOrdersUseCase(GetOrdersUseCaseRef ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetOrdersUseCase(repository);
}

@riverpod
CreateOrderUseCase createOrderUseCase(CreateOrderUseCaseRef ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CreateOrderUseCase(repository);
}

@riverpod
UpdateOrderUseCase updateOrderUseCase(UpdateOrderUseCaseRef ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return UpdateOrderUseCase(repository);
}

@riverpod
CalculateOrderPriceUseCase calculateOrderPriceUseCase(CalculateOrderPriceUseCaseRef ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CalculateOrderPriceUseCase(repository);
}

/// Convenience Providers
@riverpod
int pendingOrderCount(PendingOrderCountRef ref) {
  final orderDomain = ref.watch(orderDomainProvider);
  return orderDomain.items.where((order) => order.status == OrderStatus.pending).length;
}

@riverpod
int todayOrderCount(TodayOrderCountRef ref) {
  final orderDomain = ref.watch(orderDomainProvider);
  final today = DateTime.now();
  return orderDomain.items.where((order) {
    return order.createdAt.year == today.year &&
           order.createdAt.month == today.month &&
           order.createdAt.day == today.day;
  }).length;
}

@riverpod
Map<OrderStatus, int> orderCountByStatus(OrderCountByStatusRef ref) {
  final orderDomain = ref.watch(orderDomainProvider);
  final counts = <OrderStatus, int>{};
  
  for (final order in orderDomain.items) {
    counts[order.status] = (counts[order.status] ?? 0) + 1;
  }
  
  return counts;
}

/// PDF 및 이메일 관련 Providers
@riverpod
PdfService pdfService(PdfServiceRef ref) {
  return PdfService();
}

@riverpod
StorageService storageService(StorageServiceRef ref) {
  return StorageService();
}

@riverpod
EmailService emailService(EmailServiceRef ref) {
  return EmailService();
}

@riverpod
GeneratePdfUseCase generatePdfUseCase(GeneratePdfUseCaseRef ref) {
  final repository = ref.watch(orderRepositoryProvider);
  final pdfService = ref.watch(pdfServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return GeneratePdfUseCase(
    repository: repository,
    pdfService: pdfService,
    storageService: storageService,
  );
}

@riverpod
SendEmailUseCase sendEmailUseCase(SendEmailUseCaseRef ref) {
  final repository = ref.watch(orderRepositoryProvider);
  final emailService = ref.watch(emailServiceProvider);
  return SendEmailUseCase(
    repository: repository,
    emailService: emailService,
  );
}

@riverpod
ProcessTransactionStatementUseCase processTransactionStatementUseCase(
  ProcessTransactionStatementUseCaseRef ref,
) {
  final repository = ref.watch(orderRepositoryProvider);
  final generatePdfUseCase = ref.watch(generatePdfUseCaseProvider);
  final sendEmailUseCase = ref.watch(sendEmailUseCaseProvider);
  return ProcessTransactionStatementUseCase(
    repository: repository,
    generatePdfUseCase: generatePdfUseCase,
    sendEmailUseCase: sendEmailUseCase,
  );
}