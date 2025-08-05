import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/order_entity.dart';
import '../../data/repositories/demo_order_repository_impl.dart';
import '../../data/models/order_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';

part 'demo_order_provider.g.dart';

// 데모 Order Repository Provider
final demoOrderRepositoryProvider = Provider<DemoOrderRepositoryImpl>((ref) {
  return DemoOrderRepositoryImpl();
});

// 데모 Order List State
class DemoOrderListState {
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

  const DemoOrderListState({
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

  DemoOrderListState copyWith({
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
    return DemoOrderListState(
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

// 데모 Order List Notifier
@riverpod
class DemoOrderList extends _$DemoOrderList {
  DemoOrderRepositoryImpl? _repository;
  static const int _pageSize = 20;

  DemoOrderRepositoryImpl get repository {
    _repository ??= ref.watch(demoOrderRepositoryProvider);
    return _repository!;
  }

  @override
  DemoOrderListState build() {
    // 초기 데이터 로드
    Future.microtask(() => loadOrders(refresh: true));
    return const DemoOrderListState();
  }

  Future<void> loadOrders({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final offset = refresh ? 0 : state.orders.length;
      
      final entities = await repository.getOrders(
        limit: _pageSize,
        offset: offset,
        status: state.statusFilter,
        productType: state.productTypeFilter,
        deliveryMethod: state.deliveryMethodFilter,
        startDate: state.startDate,
        endDate: state.endDate,
        searchQuery: state.searchQuery,
      );

      // Entity를 Model로 변환
      final newOrders = entities.map((entity) => OrderModel(
        id: entity.id,
        orderNumber: entity.orderNumber,
        userId: entity.userId,
        status: entity.status,
        productType: entity.productType,
        quantity: entity.quantity,
        javaraQuantity: entity.javaraQuantity,
        returnTankQuantity: entity.returnTankQuantity,
        deliveryDate: entity.deliveryDate,
        deliveryMethod: entity.deliveryMethod,
        deliveryAddressId: entity.deliveryAddressId,
        deliveryMemo: entity.deliveryMemo,
        unitPrice: entity.unitPrice,
        totalPrice: entity.totalPrice,
        cancelledReason: entity.cancelledReason,
        confirmedAt: entity.confirmedAt,
        confirmedBy: entity.confirmedBy,
        shippedAt: entity.shippedAt,
        completedAt: entity.completedAt,
        cancelledAt: entity.cancelledAt,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      )).toList();

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

  Future<void> clearFilters() async {
    state = const DemoOrderListState();
    await loadOrders(refresh: true);
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? cancelledReason,
  }) async {
    try {
      final updatedEntity = await repository.updateOrderStatus(
        orderId: orderId,
        status: status,
        cancelledReason: cancelledReason,
      );

      // Entity를 Model로 변환
      final updatedOrder = OrderModel(
        id: updatedEntity.id,
        orderNumber: updatedEntity.orderNumber,
        userId: updatedEntity.userId,
        status: updatedEntity.status,
        productType: updatedEntity.productType,
        quantity: updatedEntity.quantity,
        javaraQuantity: updatedEntity.javaraQuantity,
        returnTankQuantity: updatedEntity.returnTankQuantity,
        deliveryDate: updatedEntity.deliveryDate,
        deliveryMethod: updatedEntity.deliveryMethod,
        deliveryAddressId: updatedEntity.deliveryAddressId,
        deliveryMemo: updatedEntity.deliveryMemo,
        unitPrice: updatedEntity.unitPrice,
        totalPrice: updatedEntity.totalPrice,
        cancelledReason: updatedEntity.cancelledReason,
        confirmedAt: updatedEntity.confirmedAt,
        confirmedBy: updatedEntity.confirmedBy,
        shippedAt: updatedEntity.shippedAt,
        completedAt: updatedEntity.completedAt,
        cancelledAt: updatedEntity.cancelledAt,
        createdAt: updatedEntity.createdAt,
        updatedAt: updatedEntity.updatedAt,
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

  Future<void> deleteOrder(String orderId) async {
    try {
      await repository.deleteOrder(orderId);

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

// 데모 Order Creation Notifier
@riverpod
class DemoOrderCreation extends _$DemoOrderCreation {
  DemoOrderRepositoryImpl? _repository;

  DemoOrderRepositoryImpl get repository {
    _repository ??= ref.watch(demoOrderRepositoryProvider);
    return _repository!;
  }

  @override
  OrderCreationState build() {
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
      final entity = await repository.createOrder(
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

      // Entity를 Model로 변환
      final order = OrderModel(
        id: entity.id,
        orderNumber: entity.orderNumber,
        userId: entity.userId,
        status: entity.status,
        productType: entity.productType,
        quantity: entity.quantity,
        javaraQuantity: entity.javaraQuantity,
        returnTankQuantity: entity.returnTankQuantity,
        deliveryDate: entity.deliveryDate,
        deliveryMethod: entity.deliveryMethod,
        deliveryAddressId: entity.deliveryAddressId,
        deliveryMemo: entity.deliveryMemo,
        unitPrice: entity.unitPrice,
        totalPrice: entity.totalPrice,
        cancelledReason: entity.cancelledReason,
        confirmedAt: entity.confirmedAt,
        confirmedBy: entity.confirmedBy,
        shippedAt: entity.shippedAt,
        completedAt: entity.completedAt,
        cancelledAt: entity.cancelledAt,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

      state = state.copyWith(
        isLoading: false,
        createdOrder: order,
      );

      // 주문 목록 새로고침
      ref.invalidate(demoOrderListProvider);

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

// Order Creation State (재사용)
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

// 데모 Order Detail State
class DemoOrderDetailState {
  final OrderModel? order;
  final bool isLoading;
  final Failure? error;

  const DemoOrderDetailState({
    this.order,
    this.isLoading = false,
    this.error,
  });

  DemoOrderDetailState copyWith({
    OrderModel? order,
    bool? isLoading,
    Failure? error,
  }) {
    return DemoOrderDetailState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// 데모 Order Detail Notifier
@riverpod
class DemoOrderDetail extends _$DemoOrderDetail {
  DemoOrderRepositoryImpl? _repository;

  DemoOrderRepositoryImpl get repository {
    _repository ??= ref.watch(demoOrderRepositoryProvider);
    return _repository!;
  }

  @override
  DemoOrderDetailState build(String orderId) {
    // 다음 이벤트 루프에서 데이터 로드 시작
    Future.microtask(() => loadOrder());
    return const DemoOrderDetailState(isLoading: true);
  }

  Future<void> loadOrder() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final entity = await repository.getOrderById(orderId);
      
      if (entity == null) {
        state = state.copyWith(
          isLoading: false,
          error: UnknownFailure(message: '주문을 찾을 수 없습니다'),
        );
        return;
      }
      
      // Entity를 Model로 변환
      final order = OrderModel(
        id: entity.id,
        orderNumber: entity.orderNumber,
        userId: entity.userId,
        status: entity.status,
        productType: entity.productType,
        quantity: entity.quantity,
        javaraQuantity: entity.javaraQuantity,
        returnTankQuantity: entity.returnTankQuantity,
        deliveryDate: entity.deliveryDate,
        deliveryMethod: entity.deliveryMethod,
        deliveryAddressId: entity.deliveryAddressId,
        deliveryMemo: entity.deliveryMemo,
        unitPrice: entity.unitPrice,
        totalPrice: entity.totalPrice,
        cancelledReason: entity.cancelledReason,
        confirmedAt: entity.confirmedAt,
        confirmedBy: entity.confirmedBy,
        shippedAt: entity.shippedAt,
        completedAt: entity.completedAt,
        cancelledAt: entity.cancelledAt,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

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
      final updatedEntity = await repository.updateOrder(
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

      // Entity를 Model로 변환
      final updatedOrder = OrderModel(
        id: updatedEntity.id,
        orderNumber: updatedEntity.orderNumber,
        userId: updatedEntity.userId,
        status: updatedEntity.status,
        productType: updatedEntity.productType,
        quantity: updatedEntity.quantity,
        javaraQuantity: updatedEntity.javaraQuantity,
        returnTankQuantity: updatedEntity.returnTankQuantity,
        deliveryDate: updatedEntity.deliveryDate,
        deliveryMethod: updatedEntity.deliveryMethod,
        deliveryAddressId: updatedEntity.deliveryAddressId,
        deliveryMemo: updatedEntity.deliveryMemo,
        unitPrice: updatedEntity.unitPrice,
        totalPrice: updatedEntity.totalPrice,
        cancelledReason: updatedEntity.cancelledReason,
        confirmedAt: updatedEntity.confirmedAt,
        confirmedBy: updatedEntity.confirmedBy,
        shippedAt: updatedEntity.shippedAt,
        completedAt: updatedEntity.completedAt,
        cancelledAt: updatedEntity.cancelledAt,
        createdAt: updatedEntity.createdAt,
        updatedAt: updatedEntity.updatedAt,
      );

      state = state.copyWith(order: updatedOrder);

      // 주문 목록도 새로고침
      ref.invalidate(demoOrderListProvider);
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