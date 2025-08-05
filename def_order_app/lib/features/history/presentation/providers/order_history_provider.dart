import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/services/order_history_service.dart';
import '../../../order/data/models/order_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/demo_auth_provider.dart';
import '../../../order/presentation/providers/demo_order_provider.dart';
import '../../../order/data/repositories/demo_order_repository_impl.dart';

part 'order_history_provider.g.dart';

/// 주문 내역 필터 상태
class OrderHistoryFilterModel {
  final DateTime? startDate;
  final DateTime? endDate;
  final OrderStatus? status;
  final ProductType? productType;
  final DeliveryMethod? deliveryMethod;
  
  const OrderHistoryFilterModel({
    this.startDate,
    this.endDate,
    this.status,
    this.productType,
    this.deliveryMethod,
  });
  
  OrderHistoryFilterModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? status,
    ProductType? productType,
    DeliveryMethod? deliveryMethod,
    bool clearStatus = false,
    bool clearProductType = false,
    bool clearDeliveryMethod = false,
  }) {
    return OrderHistoryFilterModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: clearStatus ? null : (status ?? this.status),
      productType: clearProductType ? null : (productType ?? this.productType),
      deliveryMethod: clearDeliveryMethod ? null : (deliveryMethod ?? this.deliveryMethod),
    );
  }
}

/// 주문 내역 상태
class OrderHistoryState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<OrderModel> orders;
  final OrderStatistics? statistics;
  final bool hasMore;
  final String? error;
  final OrderHistoryFilterModel filter;
  
  const OrderHistoryState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.orders = const [],
    this.statistics,
    this.hasMore = true,
    this.error,
    this.filter = const OrderHistoryFilterModel(),
  });
  
  OrderHistoryState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<OrderModel>? orders,
    OrderStatistics? statistics,
    bool? hasMore,
    String? error,
    OrderHistoryFilterModel? filter,
  }) {
    return OrderHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      orders: orders ?? this.orders,
      statistics: statistics ?? this.statistics,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      filter: filter ?? this.filter,
    );
  }
}

/// 주문 내역 Provider
@riverpod
class OrderHistory extends _$OrderHistory {
  late final OrderHistoryService _service;
  static const int _pageSize = 20;
  
  @override
  OrderHistoryState build() {
    _service = ref.watch(orderHistoryServiceProvider);
    return const OrderHistoryState();
  }
  
  /// 주문 내역 초기 로드
  Future<void> loadOrderHistory() async {
    // 데모 모드 확인
    final isDemoMode = ref.read(isDemoModeProvider);
    
    if (isDemoMode) {
      await _loadDemoOrderHistory();
      return;
    }
    
    final userId = ref.read(authProvider).profile?.id;
    if (userId == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final orders = await _service.getOrderHistory(
        userId: userId,
        startDate: state.filter.startDate,
        endDate: state.filter.endDate,
        status: state.filter.status,
        productType: state.filter.productType,
        deliveryMethod: state.filter.deliveryMethod,
        limit: _pageSize,
        offset: 0,
      );
      
      // 통계도 함께 로드
      final statistics = await _service.getOrderStatistics(
        userId: userId,
        startDate: state.filter.startDate,
        endDate: state.filter.endDate,
      );
      
      state = state.copyWith(
        isLoading: false,
        orders: orders,
        statistics: statistics,
        hasMore: orders.length >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// 데모 모드 주문 내역 로드
  Future<void> _loadDemoOrderHistory() async {
    print('🚀 _loadDemoOrderHistory 시작');
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // 데모 repository에서 직접 필터된 데이터 가져오기
      final demoRepository = ref.read(demoOrderRepositoryProvider);
      
      // DEBUG: 현재 필터 상태 상세 로깅
      print('🔍 === 필터 상태 상세 분석 ===');
      print('   - status: ${state.filter.status} (${state.filter.status?.toString()})');
      print('   - productType: ${state.filter.productType}');
      print('   - deliveryMethod: ${state.filter.deliveryMethod}');
      print('   - startDate: ${state.filter.startDate}');
      print('   - endDate: ${state.filter.endDate}');
      print('=====================================');
      
      final entities = await demoRepository.getOrders(
        status: state.filter.status,
        productType: state.filter.productType,
        deliveryMethod: state.filter.deliveryMethod,
        startDate: state.filter.startDate,
        endDate: state.filter.endDate,
      );
      
      print('📊 Repository에서 반환된 주문 수: ${entities.length}');
      if (entities.isNotEmpty) {
        print('📝 반환된 주문들:');
        for (final entity in entities) {
          print('   - ${entity.orderNumber}: ${entity.status} (${entity.status.toString()})');
        }
      } else {
        print('⚠️ 반환된 주문이 없습니다!');
      }
      
      // Entity를 Model로 변환
      var filteredOrders = entities.map((entity) => OrderModel(
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
        profile: null,
        deliveryAddress: null,
      )).toList();
      
      // 생성일시 기준 내림차순 정렬
      filteredOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      // 데모 통계 생성
      final totalOrders = filteredOrders.length;
      final totalAmount = filteredOrders.fold(0.0, (sum, order) => sum + order.totalPrice);
      final totalQuantity = filteredOrders.fold(0, (sum, order) => sum + order.quantity);
      final averageOrderValue = totalOrders > 0 ? totalAmount / totalOrders : 0.0;
      
      // 상태별 카운트
      final statusCount = <OrderStatus, int>{};
      for (final status in OrderStatus.values) {
        statusCount[status] = filteredOrders.where((o) => o.status == status).length;
      }
      
      // 제품 타입별 카운트
      final productTypeCount = <ProductType, int>{};
      for (final productType in ProductType.values) {
        productTypeCount[productType] = filteredOrders.where((o) => o.productType == productType).length;
      }
      
      final statistics = OrderStatistics(
        totalOrders: totalOrders,
        totalAmount: totalAmount,
        totalQuantity: totalQuantity,
        averageOrderValue: averageOrderValue,
        statusCount: statusCount,
        productTypeCount: productTypeCount,
      );
      
      state = state.copyWith(
        isLoading: false,
        orders: filteredOrders,
        statistics: statistics,
        hasMore: false, // 데모에서는 페이징 없음
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '데모 데이터 로드 실패: ${e.toString()}',
      );
    }
  }
  
  /// 다음 페이지 로드
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    
    final userId = ref.read(authProvider).profile?.id;
    if (userId == null) return;
    
    state = state.copyWith(isLoadingMore: true);
    
    try {
      final orders = await _service.getOrderHistory(
        userId: userId,
        startDate: state.filter.startDate,
        endDate: state.filter.endDate,
        status: state.filter.status,
        productType: state.filter.productType,
        deliveryMethod: state.filter.deliveryMethod,
        limit: _pageSize,
        offset: state.orders.length,
      );
      
      state = state.copyWith(
        isLoadingMore: false,
        orders: [...state.orders, ...orders],
        hasMore: orders.length >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }
  
  /// 필터 업데이트
  void updateFilter(OrderHistoryFilterModel filter) {
    state = state.copyWith(filter: filter);
    loadOrderHistory();
  }
  
  /// 날짜 범위 설정
  void setDateRange(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        startDate: startDate,
        endDate: endDate,
      ),
    );
    loadOrderHistory();
  }
  
  /// 상태 필터 설정
  void setStatusFilter(OrderStatus? status) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        status: status,
        clearStatus: status == null,
      ),
    );
    loadOrderHistory();
  }
  
  /// 제품 타입 필터 설정
  void setProductTypeFilter(ProductType? productType) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        productType: productType,
        clearProductType: productType == null,
      ),
    );
    loadOrderHistory();
  }
  
  /// 배송 방법 필터 설정
  void setDeliveryMethodFilter(DeliveryMethod? deliveryMethod) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        deliveryMethod: deliveryMethod,
        clearDeliveryMethod: deliveryMethod == null,
      ),
    );
    loadOrderHistory();
  }
  
  /// 필터 초기화
  void resetFilter() {
    state = state.copyWith(filter: const OrderHistoryFilterModel());
    loadOrderHistory();
  }
  
  /// 새로고침
  Future<void> refresh() async {
    await loadOrderHistory();
  }
}

/// 거래명세서 Provider
@riverpod
class TransactionStatement extends _$TransactionStatement {
  late final OrderHistoryService _service;
  
  @override
  AsyncValue<String?> build(String orderId) {
    _service = ref.watch(orderHistoryServiceProvider);
    _loadStatementUrl();
    return const AsyncValue.loading();
  }
  
  Future<void> _loadStatementUrl() async {
    state = const AsyncValue.loading();
    
    try {
      final url = await _service.getTransactionStatementUrl(orderId);
      state = AsyncValue.data(url);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> requestStatement() async {
    state = const AsyncValue.loading();
    
    try {
      await _service.requestTransactionStatement(orderId);
      // 생성 요청 후 잠시 대기 후 URL 재조회
      await Future.delayed(const Duration(seconds: 3));
      await _loadStatementUrl();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// Excel 다운로드 Provider
@riverpod
class ExcelDownload extends _$ExcelDownload {
  late final OrderHistoryService _service;
  
  @override
  AsyncValue<String?> build() {
    _service = ref.watch(orderHistoryServiceProvider);
    return const AsyncValue.data(null);
  }
  
  Future<void> generateExcel({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final userId = ref.read(authProvider).profile?.id;
    if (userId == null) return;
    
    state = const AsyncValue.loading();
    
    try {
      final url = await _service.generateExcelDownloadUrl(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      state = AsyncValue.data(url);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}