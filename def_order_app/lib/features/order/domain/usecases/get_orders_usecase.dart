import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import '../../data/models/order_model.dart';
import '../../../../core/error/exceptions.dart';

/// 주문 목록 조회 유스케이스
/// 
/// 사용자의 주문 목록을 조회하는 비즈니스 로직을 처리합니다.
/// 필터링, 정렬, 페이징 등의 기능을 제공합니다.
class GetOrdersUseCase {
  final OrderRepository _repository;

  GetOrdersUseCase(this._repository);

  /// 주문 목록 조회 실행
  /// 
  /// [params] 주문 목록 조회에 필요한 매개변수
  /// 
  /// Returns: [OrderEntity] 리스트와 추가 정보가 포함된 [GetOrdersResult]
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  Future<GetOrdersResult> execute(GetOrdersParams params) async {
    // 1. 입력 매개변수 유효성 검증
    final validationResult = _validateGetOrdersParams(params);
    if (!validationResult.isValid) {
      throw ValidationException(message: validationResult.errorMessage);
    }

    // 2. 주문 목록 조회
    final orders = await _repository.getOrders(
      limit: params.limit,
      offset: params.offset,
      status: params.status,
      productType: params.productType,
      deliveryMethod: params.deliveryMethod,
      startDate: params.startDate,
      endDate: params.endDate,
      searchQuery: params.searchQuery,
    );

    // 3. 추가 정보 계산
    final totalAmount = _calculateTotalAmount(orders);
    final totalQuantity = _calculateTotalQuantity(orders);
    final statusCounts = _calculateStatusCounts(orders);
    final urgentOrdersCount = _calculateUrgentOrdersCount(orders);
    final overdueOrdersCount = _calculateOverdueOrdersCount(orders);

    return GetOrdersResult(
      orders: orders,
      totalCount: orders.length,
      totalAmount: totalAmount,
      totalQuantity: totalQuantity,
      statusCounts: statusCounts,
      urgentOrdersCount: urgentOrdersCount,
      overdueOrdersCount: overdueOrdersCount,
      hasMore: orders.length == (params.limit ?? 20),
    );
  }

  /// 단일 주문 조회 실행
  /// 
  /// [orderId] 조회할 주문 ID
  /// 
  /// Returns: [OrderEntity] 또는 null
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  Future<OrderEntity?> getOrderById(String orderId) async {
    if (orderId.isEmpty) {
      throw ValidationException(message: '주문 ID가 필요합니다.');
    }

    return await _repository.getOrderById(orderId);
  }

  /// 입력 매개변수 유효성 검증
  ValidationResult _validateGetOrdersParams(GetOrdersParams params) {
    final errors = <String, String>{};

    // 페이징 매개변수 검증
    if (params.limit != null && params.limit! <= 0) {
      errors['limit'] = 'limit은 1 이상이어야 합니다';
    }
    if (params.limit != null && params.limit! > 100) {
      errors['limit'] = 'limit은 100 이하여야 합니다';
    }
    if (params.offset != null && params.offset! < 0) {
      errors['offset'] = 'offset은 0 이상이어야 합니다';
    }

    // 날짜 범위 검증
    if (params.startDate != null && params.endDate != null) {
      if (params.startDate!.isAfter(params.endDate!)) {
        errors['dateRange'] = '시작 날짜는 종료 날짜보다 이전이어야 합니다';
      }
      
      // 조회 기간이 너무 긴 경우 제한
      final daysDifference = params.endDate!.difference(params.startDate!).inDays;
      if (daysDifference > 365) {
        errors['dateRange'] = '조회 기간은 1년을 초과할 수 없습니다';
      }
    }

    // 검색어 검증
    if (params.searchQuery != null && params.searchQuery!.length > 100) {
      errors['searchQuery'] = '검색어는 100자를 초과할 수 없습니다';
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// 총 주문 금액 계산
  double _calculateTotalAmount(List<OrderEntity> orders) {
    return orders.fold(0.0, (sum, order) => sum + order.totalPrice);
  }

  /// 총 주문 수량 계산
  int _calculateTotalQuantity(List<OrderEntity> orders) {
    return orders.fold(0, (sum, order) => sum + order.quantity);
  }

  /// 상태별 주문 개수 계산
  Map<OrderStatus, int> _calculateStatusCounts(List<OrderEntity> orders) {
    final counts = <OrderStatus, int>{};
    
    for (final order in orders) {
      counts[order.status] = (counts[order.status] ?? 0) + 1;
    }
    
    return counts;
  }

  /// 긴급 주문 개수 계산 (3일 이내 배송)
  int _calculateUrgentOrdersCount(List<OrderEntity> orders) {
    return orders.where((order) => order.isUrgent).length;
  }

  /// 배송일 경과 주문 개수 계산
  int _calculateOverdueOrdersCount(List<OrderEntity> orders) {
    return orders.where((order) => order.isOverdue).length;
  }
}

/// 주문 목록 조회 매개변수
class GetOrdersParams {
  final int? limit;
  final int? offset;
  final OrderStatus? status;
  final ProductType? productType;
  final DeliveryMethod? deliveryMethod;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  const GetOrdersParams({
    this.limit = 20,
    this.offset = 0,
    this.status,
    this.productType,
    this.deliveryMethod,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  /// 페이지 번호 계산 (1부터 시작)
  int get pageNumber {
    if (offset == null || limit == null || limit == 0) return 1;
    return (offset! ~/ limit!) + 1;
  }

  /// 필터가 적용되었는지 확인
  bool get hasFilters {
    return status != null ||
           productType != null ||
           deliveryMethod != null ||
           startDate != null ||
           endDate != null ||
           (searchQuery != null && searchQuery!.isNotEmpty);
  }

  /// 기본 필터 조건 적용
  GetOrdersParams withDefaultFilters() {
    return GetOrdersParams(
      limit: limit,
      offset: offset,
      status: status,
      productType: productType,
      deliveryMethod: deliveryMethod,
      startDate: startDate ?? DateTime.now().subtract(const Duration(days: 30)), // 기본 30일
      endDate: endDate ?? DateTime.now(),
      searchQuery: searchQuery,
    );
  }

  /// 페이지 번호로 offset 계산
  GetOrdersParams withPage(int page) {
    final newOffset = (page - 1) * (limit ?? 20);
    return GetOrdersParams(
      limit: limit,
      offset: newOffset,
      status: status,
      productType: productType,
      deliveryMethod: deliveryMethod,
      startDate: startDate,
      endDate: endDate,
      searchQuery: searchQuery,
    );
  }

  @override
  String toString() {
    return 'GetOrdersParams('
        'limit: $limit, '
        'offset: $offset, '
        'status: $status, '
        'productType: $productType, '
        'deliveryMethod: $deliveryMethod, '
        'startDate: $startDate, '
        'endDate: $endDate, '
        'searchQuery: $searchQuery)';
  }
}

/// 주문 목록 조회 결과
class GetOrdersResult {
  final List<OrderEntity> orders;
  final int totalCount;
  final double totalAmount;
  final int totalQuantity;
  final Map<OrderStatus, int> statusCounts;
  final int urgentOrdersCount;
  final int overdueOrdersCount;
  final bool hasMore;

  const GetOrdersResult({
    required this.orders,
    required this.totalCount,
    required this.totalAmount,
    required this.totalQuantity,
    required this.statusCounts,
    required this.urgentOrdersCount,
    required this.overdueOrdersCount,
    required this.hasMore,
  });

  /// 빈 결과 생성
  factory GetOrdersResult.empty() {
    return const GetOrdersResult(
      orders: [],
      totalCount: 0,
      totalAmount: 0.0,
      totalQuantity: 0,
      statusCounts: {},
      urgentOrdersCount: 0,
      overdueOrdersCount: 0,
      hasMore: false,
    );
  }

  /// 평균 주문 금액
  double get averageOrderAmount {
    return totalCount > 0 ? totalAmount / totalCount : 0.0;
  }

  /// 평균 주문 수량
  double get averageOrderQuantity {
    return totalCount > 0 ? totalQuantity / totalCount : 0.0;
  }

  /// 특정 상태의 주문 개수
  int getStatusCount(OrderStatus status) {
    return statusCounts[status] ?? 0;
  }

  /// 주의가 필요한 주문 여부
  bool get hasOrdersNeedingAttention {
    return urgentOrdersCount > 0 || overdueOrdersCount > 0;
  }

  @override
  String toString() {
    return 'GetOrdersResult('
        'totalCount: $totalCount, '
        'totalAmount: $totalAmount, '
        'totalQuantity: $totalQuantity, '
        'urgentOrdersCount: $urgentOrdersCount, '
        'overdueOrdersCount: $overdueOrdersCount, '
        'hasMore: $hasMore)';
  }
}