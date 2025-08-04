import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/repositories/demo_order_repository_impl.dart';
import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'order_provider.g.dart';

// Order Service Provider
@riverpod
OrderService orderService(OrderServiceRef ref) {
  return OrderService();
}

// Order List State
class OrderListState {
  final List<OrderModel> orders;
  final bool isLoading;
  final bool hasMore;
  final Failure? error;
  final OrderStatus? statusFilter;
  final ProductType? productTypeFilter;
  final DeliveryMethod? deliveryMethodFilter;
  final String? searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;

  const OrderListState({
    this.orders = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.statusFilter,
    this.productTypeFilter,
    this.deliveryMethodFilter,
    this.searchQuery,
    this.startDate,
    this.endDate,
  });

  OrderListState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    bool? hasMore,
    Failure? error,
    OrderStatus? statusFilter,
    ProductType? productTypeFilter,
    DeliveryMethod? deliveryMethodFilter,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return OrderListState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      statusFilter: statusFilter ?? this.statusFilter,
      productTypeFilter: productTypeFilter ?? this.productTypeFilter,
      deliveryMethodFilter: deliveryMethodFilter ?? this.deliveryMethodFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

// Order List Notifier
@riverpod
class OrderList extends _$OrderList {
  late final OrderService _orderService;
  static const int _pageSize = 20;

  @override
  OrderListState build() {
    _orderService = ref.watch(orderServiceProvider);
    return const OrderListState();
  }

  // 주문 목록 로드
  Future<void> loadOrders({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final offset = refresh ? 0 : state.orders.length;
      
      final newOrders = await _orderService.getOrders(
        limit: _pageSize,
        offset: offset,
        status: state.statusFilter,
        productType: state.productTypeFilter,
        deliveryMethod: state.deliveryMethodFilter,
        startDate: state.startDate,
        endDate: state.endDate,
        searchQuery: state.searchQuery,
      );

      final orders = refresh 
          ? newOrders 
          : [...state.orders, ...newOrders];

      state = state.copyWith(
        orders: orders,
        isLoading: false,
        hasMore: newOrders.length == _pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapExceptionToFailure(e),
      );
    }
  }

  // 필터 적용
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
    );

    await loadOrders(refresh: true);
  }

  // 필터 초기화
  Future<void> clearFilters() async {
    state = const OrderListState();
    await loadOrders(refresh: true);
  }

  // 주문 상태 업데이트
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? cancelledReason,
  }) async {
    try {
      final updatedOrder = await _orderService.updateOrderStatus(
        orderId: orderId,
        status: status,
        cancelledReason: cancelledReason,
      );

      // 로컬 상태 업데이트
      final updatedOrders = state.orders.map((order) {
        return order.id == orderId ? updatedOrder : order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
    } catch (e) {
      state = state.copyWith(
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }

  // 주문 삭제
  Future<void> deleteOrder(String orderId) async {
    try {
      await _orderService.deleteOrder(orderId);

      // 로컬 상태에서 제거
      final updatedOrders = state.orders
          .where((order) => order.id != orderId)
          .toList();

      state = state.copyWith(orders: updatedOrders);
    } catch (e) {
      state = state.copyWith(
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }

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
    } else {
      return UnknownFailure(
        message: exception.toString(),
      );
    }
  }
}

// Order Detail State
class OrderDetailState {
  final OrderModel? order;
  final bool isLoading;
  final Failure? error;

  const OrderDetailState({
    this.order,
    this.isLoading = false,
    this.error,
  });

  OrderDetailState copyWith({
    OrderModel? order,
    bool? isLoading,
    Failure? error,
  }) {
    return OrderDetailState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Order Detail Notifier
@riverpod
class OrderDetail extends _$OrderDetail {
  late final OrderService _orderService;

  @override
  OrderDetailState build(String orderId) {
    _orderService = ref.watch(orderServiceProvider);
    loadOrder();
    return const OrderDetailState(isLoading: true);
  }

  Future<void> loadOrder() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final order = await _orderService.getOrderById(orderId);
      state = state.copyWith(
        order: order,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapExceptionToFailure(e),
      );
    }
  }

  Future<void> updateOrder({
    ProductType? productType,
    int? quantity,
    int? javaraQuantity,
    int? returnTankQuantity,
    DateTime? deliveryDate,
    DeliveryMethod? deliveryMethod,
    String? deliveryAddressId,
    String? deliveryMemo,
    double? unitPrice,
  }) async {
    try {
      final updatedOrder = await _orderService.updateOrder(
        orderId: orderId,
        productType: productType,
        quantity: quantity,
        javaraQuantity: javaraQuantity,
        returnTankQuantity: returnTankQuantity,
        deliveryDate: deliveryDate,
        deliveryMethod: deliveryMethod,
        deliveryAddressId: deliveryAddressId,
        deliveryMemo: deliveryMemo,
        unitPrice: unitPrice,
      );

      state = state.copyWith(order: updatedOrder);
    } catch (e) {
      state = state.copyWith(
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }

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
    } else {
      return UnknownFailure(
        message: exception.toString(),
      );
    }
  }
}

// Order Creation State
class OrderCreationState {
  final bool isLoading;
  final Failure? error;
  final OrderModel? createdOrder;

  const OrderCreationState({
    this.isLoading = false,
    this.error,
    this.createdOrder,
  });

  OrderCreationState copyWith({
    bool? isLoading,
    Failure? error,
    OrderModel? createdOrder,
  }) {
    return OrderCreationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      createdOrder: createdOrder ?? this.createdOrder,
    );
  }
}

// Order Creation Notifier
@riverpod
class OrderCreation extends _$OrderCreation {
  late final OrderService _orderService;

  @override
  OrderCreationState build() {
    _orderService = ref.watch(orderServiceProvider);
    return const OrderCreationState();
  }

  Future<OrderModel> createOrder({
    required ProductType productType,
    required int quantity,
    int? javaraQuantity,
    int? returnTankQuantity,
    required DateTime deliveryDate,
    required DeliveryMethod deliveryMethod,
    String? deliveryAddressId,
    String? deliveryMemo,
    required double unitPrice,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final order = await _orderService.createOrder(
        productType: productType,
        quantity: quantity,
        javaraQuantity: javaraQuantity,
        returnTankQuantity: returnTankQuantity,
        deliveryDate: deliveryDate,
        deliveryMethod: deliveryMethod,
        deliveryAddressId: deliveryAddressId,
        deliveryMemo: deliveryMemo,
        unitPrice: unitPrice,
      );

      state = state.copyWith(
        isLoading: false,
        createdOrder: order,
      );

      // 주문 목록 새로고침
      ref.invalidate(orderListProvider);

      return order;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }

  void reset() {
    state = const OrderCreationState();
  }

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
    } else {
      return UnknownFailure(
        message: exception.toString(),
      );
    }
  }
}

// Order Statistics State
class OrderStatsState {
  final Map<String, dynamic>? stats;
  final bool isLoading;
  final Failure? error;

  const OrderStatsState({
    this.stats,
    this.isLoading = false,
    this.error,
  });

  OrderStatsState copyWith({
    Map<String, dynamic>? stats,
    bool? isLoading,
    Failure? error,
  }) {
    return OrderStatsState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Order Statistics Notifier
@riverpod
class OrderStats extends _$OrderStats {
  late final OrderService _orderService;

  @override
  OrderStatsState build({DateTime? startDate, DateTime? endDate}) {
    _orderService = ref.watch(orderServiceProvider);
    loadStats();
    return const OrderStatsState(isLoading: true);
  }

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final stats = await _orderService.getOrderStats(
        startDate: startDate,
        endDate: endDate,
      );

      state = state.copyWith(
        stats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapExceptionToFailure(e),
      );
    }
  }

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
    } else {
      return UnknownFailure(
        message: exception.toString(),
      );
    }
  }
}