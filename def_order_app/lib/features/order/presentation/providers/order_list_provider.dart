import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/models/order_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';

part 'order_list_provider.g.dart';

// Repository Provider
@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepositoryImpl();
}

// Get Orders UseCase Provider
@riverpod
GetOrdersUseCase getOrdersUseCase(GetOrdersUseCaseRef ref) {
  return GetOrdersUseCase(ref.watch(orderRepositoryProvider));
}

/// 주문 목록 상태
/// 
/// 주문 목록과 관련된 모든 상태를 관리합니다.
/// 필터링, 페이징, 로딩 상태, 에러 처리 등을 포함합니다.
class OrderListState {
  final List<OrderEntity> orders;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? error;
  
  // 필터 옵션
  final OrderStatus? statusFilter;
  final ProductType? productTypeFilter;
  final DeliveryMethod? deliveryMethodFilter;
  final String? searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  
  // 통계 정보
  final double totalAmount;
  final int totalQuantity;
  final Map<OrderStatus, int> statusCounts;
  final int urgentOrdersCount;
  final int overdueOrdersCount;
  
  // 페이징
  final int currentPage;
  final int totalCount;

  const OrderListState({
    this.orders = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.statusFilter,
    this.productTypeFilter,
    this.deliveryMethodFilter,
    this.searchQuery,
    this.startDate,
    this.endDate,
    this.totalAmount = 0.0,
    this.totalQuantity = 0,
    this.statusCounts = const {},
    this.urgentOrdersCount = 0,
    this.overdueOrdersCount = 0,
    this.currentPage = 0,
    this.totalCount = 0,
  });

  OrderListState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Failure? error,
    OrderStatus? statusFilter,
    ProductType? productTypeFilter,
    DeliveryMethod? deliveryMethodFilter,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    double? totalAmount,
    int? totalQuantity,
    Map<OrderStatus, int>? statusCounts,
    int? urgentOrdersCount,
    int? overdueOrdersCount,
    int? currentPage,
    int? totalCount,
    bool clearError = false,
  }) {
    return OrderListState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      statusFilter: statusFilter ?? this.statusFilter,
      productTypeFilter: productTypeFilter ?? this.productTypeFilter,
      deliveryMethodFilter: deliveryMethodFilter ?? this.deliveryMethodFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalAmount: totalAmount ?? this.totalAmount,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      statusCounts: statusCounts ?? this.statusCounts,
      urgentOrdersCount: urgentOrdersCount ?? this.urgentOrdersCount,
      overdueOrdersCount: overdueOrdersCount ?? this.overdueOrdersCount,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  /// 필터가 적용되었는지 확인
  bool get hasFilters {
    return statusFilter != null ||
           productTypeFilter != null ||
           deliveryMethodFilter != null ||
           (searchQuery != null && searchQuery!.isNotEmpty) ||
           startDate != null ||
           endDate != null;
  }

  /// 주의가 필요한 주문이 있는지 확인
  bool get hasOrdersNeedingAttention {
    return urgentOrdersCount > 0 || overdueOrdersCount > 0;
  }

  /// 평균 주문 금액
  double get averageOrderAmount {
    return orders.isNotEmpty ? totalAmount / orders.length : 0.0;
  }

  /// 특정 상태의 주문 개수
  int getStatusCount(OrderStatus status) {
    return statusCounts[status] ?? 0;
  }
}

/// 주문 목록 노티파이어
/// 
/// 주문 목록의 상태를 관리하고 비즈니스 로직을 처리합니다.
/// Clean Architecture 패턴에 따라 UseCase를 통해 도메인 로직을 실행합니다.
@riverpod
class OrderList extends _$OrderList {
  late final GetOrdersUseCase _getOrdersUseCase;
  static const int _pageSize = 20;

  @override
  OrderListState build() {
    _getOrdersUseCase = ref.watch(getOrdersUseCaseProvider);
    
    // 초기 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadOrders();
    });
    
    return const OrderListState();
  }

  /// 주문 목록 로드
  /// 
  /// [refresh] true인 경우 기존 목록을 비우고 처음부터 로드
  /// [loadMore] true인 경우 다음 페이지를 추가로 로드
  Future<void> loadOrders({
    bool refresh = false,
    bool loadMore = false,
  }) async {
    // 중복 로딩 방지
    if (state.isLoading || (loadMore && state.isLoadingMore)) return;
    
    // 더 불러올 데이터가 없는 경우
    if (loadMore && !state.hasMore) return;

    // 로딩 상태 설정
    state = state.copyWith(
      isLoading: !loadMore,
      isLoadingMore: loadMore,
      clearError: true,
    );

    try {
      // 페이지 계산
      final offset = refresh || !loadMore ? 0 : state.orders.length;
      final currentPage = refresh ? 0 : (loadMore ? state.currentPage + 1 : 0);

      // UseCase 실행
      final params = GetOrdersParams(
        limit: _pageSize,
        offset: offset,
        status: state.statusFilter,
        productType: state.productTypeFilter,
        deliveryMethod: state.deliveryMethodFilter,
        startDate: state.startDate,
        endDate: state.endDate,
        searchQuery: state.searchQuery,
      );

      final result = await _getOrdersUseCase.execute(params);

      // 주문 목록 업데이트
      final updatedOrders = refresh || !loadMore
          ? result.orders
          : [...state.orders, ...result.orders];

      state = state.copyWith(
        orders: updatedOrders,
        isLoading: false,
        isLoadingMore: false,
        hasMore: result.hasMore,
        totalAmount: result.totalAmount,
        totalQuantity: result.totalQuantity,
        statusCounts: result.statusCounts,
        urgentOrdersCount: result.urgentOrdersCount,
        overdueOrdersCount: result.overdueOrdersCount,
        currentPage: currentPage,
        totalCount: result.totalCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: _mapExceptionToFailure(e),
      );
    }
  }

  /// 필터 적용
  /// 
  /// 새로운 필터 조건을 적용하고 주문 목록을 다시 로드합니다.
  Future<void> applyFilters({
    OrderStatus? statusFilter,
    ProductType? productTypeFilter,
    DeliveryMethod? deliveryMethodFilter,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(
      statusFilter: statusFilter,
      productTypeFilter: productTypeFilter,
      deliveryMethodFilter: deliveryMethodFilter,
      searchQuery: searchQuery,
      startDate: startDate,
      endDate: endDate,
      currentPage: 0,
    );

    await loadOrders(refresh: true);
  }

  /// 필터 초기화
  /// 
  /// 모든 필터를 제거하고 기본 주문 목록을 로드합니다.
  Future<void> clearFilters() async {
    state = state.copyWith(
      statusFilter: null,
      productTypeFilter: null,
      deliveryMethodFilter: null,
      searchQuery: null,
      startDate: null,
      endDate: null,
      currentPage: 0,
    );

    await loadOrders(refresh: true);
  }

  /// 검색어 설정
  /// 
  /// 검색어를 설정하고 주문 목록을 다시 로드합니다.
  Future<void> search(String query) async {
    state = state.copyWith(
      searchQuery: query.isEmpty ? null : query,
      currentPage: 0,
    );

    await loadOrders(refresh: true);
  }

  /// 날짜 범위 설정
  /// 
  /// 조회할 날짜 범위를 설정하고 주문 목록을 다시 로드합니다.
  Future<void> setDateRange(DateTime? startDate, DateTime? endDate) async {
    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
      currentPage: 0,
    );

    await loadOrders(refresh: true);
  }

  /// 주문 상태 업데이트
  /// 
  /// 특정 주문의 상태를 변경하고 로컬 상태를 업데이트합니다.
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? cancelledReason,
  }) async {
    try {
      final repository = ref.read(orderRepositoryProvider);
      final updatedOrder = await repository.updateOrderStatus(
        orderId: orderId,
        status: status,
        cancelledReason: cancelledReason,
      );

      // 로컬 상태 업데이트
      final updatedOrders = state.orders.map((order) {
        return order.id == orderId ? updatedOrder : order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
      
      // 통계 재계산
      await _recalculateStats();
    } catch (e) {
      state = state.copyWith(
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }

  /// 주문 삭제
  /// 
  /// 주문을 삭제하고 목록에서 제거합니다.
  Future<void> deleteOrder(String orderId) async {
    try {
      final repository = ref.read(orderRepositoryProvider);
      await repository.deleteOrder(orderId);

      // 로컬 상태에서 제거
      final updatedOrders = state.orders
          .where((order) => order.id != orderId)
          .toList();

      state = state.copyWith(orders: updatedOrders);
      
      // 통계 재계산
      await _recalculateStats();
    } catch (e) {
      state = state.copyWith(
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }

  /// 다음 페이지 로드
  /// 
  /// 무한 스크롤을 위한 다음 페이지 로드입니다.
  Future<void> loadNextPage() async {
    await loadOrders(loadMore: true);
  }

  /// 새로고침
  /// 
  /// 현재 필터 조건으로 주문 목록을 새로고침합니다.
  Future<void> refresh() async {
    await loadOrders(refresh: true);
  }

  /// 통계 재계산
  /// 
  /// 현재 주문 목록을 기반으로 통계를 다시 계산합니다.
  Future<void> _recalculateStats() async {
    final orders = state.orders;
    
    final totalAmount = orders.fold(0.0, (sum, order) => sum + order.totalPrice);
    final totalQuantity = orders.fold(0, (sum, order) => sum + order.quantity);
    
    final statusCounts = <OrderStatus, int>{};
    int urgentCount = 0;
    int overdueCount = 0;
    
    for (final order in orders) {
      statusCounts[order.status] = (statusCounts[order.status] ?? 0) + 1;
      if (order.isUrgent) urgentCount++;
      if (order.isOverdue) overdueCount++;
    }
    
    state = state.copyWith(
      totalAmount: totalAmount,
      totalQuantity: totalQuantity,
      statusCounts: statusCounts,
      urgentOrdersCount: urgentCount,
      overdueOrdersCount: overdueCount,
    );
  }

  /// 예외를 Failure로 변환
  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is BusinessRuleException) {
      return BusinessRuleFailure(
        message: exception.message,
        code: exception.code,
      );
    } else {
      return UnknownFailure(
        message: exception.toString(),
      );
    }
  }
}

// 편의성을 위한 특정 상태 주문 목록 provider들
@riverpod
Future<List<OrderEntity>> pendingOrders(PendingOrdersRef ref) async {
  final orderList = ref.watch(orderListProvider);
  return orderList.orders
      .where((order) => order.status == OrderStatus.pending)
      .toList();
}

@riverpod
Future<List<OrderEntity>> urgentOrders(UrgentOrdersRef ref) async {
  final orderList = ref.watch(orderListProvider);
  return orderList.orders.where((order) => order.isUrgent).toList();
}

@riverpod
Future<List<OrderEntity>> overdueOrders(OverdueOrdersRef ref) async {
  final orderList = ref.watch(orderListProvider);
  return orderList.orders.where((order) => order.isOverdue).toList();
}