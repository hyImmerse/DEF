import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

/// 데모 모드용 주문 저장소 구현체
/// SharedPreferences를 사용하여 데이터 지속성 제공
class DemoOrderRepositoryImpl implements OrderRepository {
  static const String _ordersKey = 'demo_orders';
  static const String _dataVersionKey = 'demo_data_version';
  static const int _currentDataVersion = 2; // 데이터 구조 변경 시 증가
  
  // 캐시된 주문 데이터
  List<OrderEntity> _cachedOrders = [];
  bool _isInitialized = false;

  /// SharedPreferences에서 주문 데이터 로드
  Future<void> _initializeIfNeeded() async {
    if (_isInitialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    final currentVersion = prefs.getInt(_dataVersionKey) ?? 0;
    
    // 데이터 버전이 다르면 새로운 샘플 데이터로 재생성
    if (currentVersion != _currentDataVersion) {
      _cachedOrders = _createSampleOrders();
      await _saveOrders();
      await prefs.setInt(_dataVersionKey, _currentDataVersion);
    } else {
      final ordersJson = prefs.getString(_ordersKey);
      
      if (ordersJson != null) {
        try {
          final List<dynamic> ordersList = json.decode(ordersJson);
          _cachedOrders = ordersList
              .map((json) => OrderEntity.fromModel(OrderModel.fromJson(json)))
              .toList();
        } catch (e) {
          // JSON 파싱 에러 시 새로운 샘플 데이터 생성
          _cachedOrders = _createSampleOrders();
          await _saveOrders();
        }
      } else {
        // 첫 실행 시 샘플 데이터 생성
        _cachedOrders = _createSampleOrders();
        await _saveOrders();
      }
    }
    
    _isInitialized = true;
  }

  /// SharedPreferences에 주문 데이터 저장
  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = json.encode(
      _cachedOrders.map((order) => OrderModel(
        id: order.id,
        orderNumber: order.orderNumber,
        userId: order.userId,
        status: order.status,
        productType: order.productType,
        quantity: order.quantity,
        javaraQuantity: order.javaraQuantity,
        returnTankQuantity: order.returnTankQuantity,
        deliveryDate: order.deliveryDate,
        deliveryMethod: order.deliveryMethod,
        deliveryAddressId: order.deliveryAddressId,
        deliveryMemo: order.deliveryMemo,
        unitPrice: order.unitPrice,
        totalPrice: order.totalPrice,
        cancelledReason: order.cancelledReason,
        confirmedAt: order.confirmedAt,
        confirmedBy: order.confirmedBy,
        shippedAt: order.shippedAt,
        completedAt: order.completedAt,
        cancelledAt: order.cancelledAt,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
        profile: null,
        deliveryAddress: null,
      ).toJson()).toList(),
    );
    await prefs.setString(_ordersKey, ordersJson);
  }

  /// 샘플 주문 데이터 생성
  List<OrderEntity> _createSampleOrders() {
    final now = DateTime.now();
    return [
      // 임시저장 상태 주문
      OrderEntity(
        id: 'DEMO20250805-003',
        orderNumber: 'DEMO20250805-003',
        userId: 'demo_user',
        productType: ProductType.box,
        quantity: 3,
        javaraQuantity: null,
        returnTankQuantity: null,
        unitPrice: 9500.0,
        totalPrice: 28500.0,
        status: OrderStatus.draft,
        deliveryMethod: DeliveryMethod.directPickup,
        deliveryDate: now.add(const Duration(days: 5)),
        deliveryAddressId: 'demo_address_3',
        deliveryMemo: null,
        cancelledReason: null,
        confirmedAt: null,
        confirmedBy: null,
        shippedAt: null,
        completedAt: null,
        cancelledAt: null,
        createdAt: DateTime(now.year, now.month, now.day),
        updatedAt: DateTime(now.year, now.month, now.day),
        userProfile: null,
        deliveryAddress: null,
      ),
      // 주문대기 상태 주문
      OrderEntity(
        id: 'DEMO20250805-001',
        orderNumber: 'DEMO20250805-001',
        userId: 'demo_user',
        productType: ProductType.box,
        quantity: 100,
        javaraQuantity: 5,
        returnTankQuantity: null,
        unitPrice: 10000.0,
        totalPrice: 1000000.0,
        status: OrderStatus.pending,
        deliveryMethod: DeliveryMethod.directPickup,
        deliveryDate: now.add(const Duration(days: 3)),
        deliveryAddressId: 'demo_address_1',
        deliveryMemo: '본사 창고로 픽업 예정',
        cancelledReason: null,
        confirmedAt: null,
        confirmedBy: null,
        shippedAt: null,
        completedAt: null,
        cancelledAt: null,
        createdAt: DateTime(now.year, now.month, now.day),
        updatedAt: DateTime(now.year, now.month, now.day),
        userProfile: null,
        deliveryAddress: null,
      ),
      // 주문확정 상태 주문
      OrderEntity(
        id: 'DEMO20250804-002', 
        orderNumber: 'DEMO20250804-002',
        userId: 'demo_user',
        productType: ProductType.bulk,
        quantity: 50,
        javaraQuantity: null,
        returnTankQuantity: 0,
        unitPrice: 20000.0,
        totalPrice: 1000000.0,
        status: OrderStatus.confirmed,
        deliveryMethod: DeliveryMethod.delivery,
        deliveryDate: now.add(const Duration(days: 1)),
        deliveryAddressId: 'demo_address_2',
        deliveryMemo: '지점 창고 배송',
        cancelledReason: null,
        confirmedAt: now.subtract(const Duration(hours: 12)),
        confirmedBy: 'admin',
        shippedAt: null,
        completedAt: null,
        cancelledAt: null,
        createdAt: DateTime(now.year, now.month, now.day - 1),
        updatedAt: now.subtract(const Duration(hours: 12)),
        userProfile: null,
        deliveryAddress: null,
      ),
      // 출고완료 상태 주문
      OrderEntity(
        id: 'DEMO20250803-001',
        orderNumber: 'DEMO20250803-001',
        userId: 'demo_user',
        productType: ProductType.box,
        quantity: 20,
        javaraQuantity: 1,
        returnTankQuantity: null,
        unitPrice: 9500.0,
        totalPrice: 190000.0,
        status: OrderStatus.shipped,
        deliveryMethod: DeliveryMethod.delivery,
        deliveryDate: DateTime(now.year, now.month, now.day - 2),
        deliveryAddressId: 'demo_address_4',
        deliveryMemo: '정문 앞 하차',
        cancelledReason: null,
        confirmedAt: now.subtract(const Duration(days: 3, hours: 2)),
        confirmedBy: 'admin',
        shippedAt: now.subtract(const Duration(days: 2, hours: 10)),
        completedAt: null,
        cancelledAt: null,
        createdAt: DateTime(now.year, now.month, now.day - 3),
        updatedAt: now.subtract(const Duration(days: 2, hours: 10)),
        userProfile: null,
        deliveryAddress: null,
      ),
      // 배송완료 상태 주문
      OrderEntity(
        id: 'DEMO20250802-001',
        orderNumber: 'DEMO20250802-001',
        userId: 'demo_user',
        productType: ProductType.bulk,
        quantity: 100,
        javaraQuantity: null,
        returnTankQuantity: 2,
        unitPrice: 18000.0,
        totalPrice: 1800000.0,
        status: OrderStatus.completed,
        deliveryMethod: DeliveryMethod.delivery,
        deliveryDate: DateTime(now.year, now.month, now.day - 3),
        deliveryAddressId: 'demo_address_5',
        deliveryMemo: '창고 직접 배송',
        cancelledReason: null,
        confirmedAt: now.subtract(const Duration(days: 4, hours: 2)),
        confirmedBy: 'admin',
        shippedAt: now.subtract(const Duration(days: 3, hours: 8)),
        completedAt: now.subtract(const Duration(days: 3, hours: 2)),
        cancelledAt: null,
        createdAt: DateTime(now.year, now.month, now.day - 4),
        updatedAt: now.subtract(const Duration(days: 3, hours: 2)),
        userProfile: null,
        deliveryAddress: null,
      ),
      // 주문취소 상태 주문
      OrderEntity(
        id: 'DEMO20250801-001',
        orderNumber: 'DEMO20250801-001',
        userId: 'demo_user',
        productType: ProductType.box,
        quantity: 15,
        javaraQuantity: null,
        returnTankQuantity: null,
        unitPrice: 9800.0,
        totalPrice: 147000.0,
        status: OrderStatus.cancelled,
        deliveryMethod: DeliveryMethod.directPickup,
        deliveryDate: DateTime(now.year, now.month, now.day - 4),
        deliveryAddressId: 'demo_address_6',
        deliveryMemo: '직접 픽업 예정',
        cancelledReason: '고객 요청으로 인한 취소',
        confirmedAt: null,
        confirmedBy: null,
        shippedAt: null,
        completedAt: null,
        cancelledAt: now.subtract(const Duration(days: 4, hours: 6)),
        createdAt: DateTime(now.year, now.month, now.day - 5),
        updatedAt: now.subtract(const Duration(days: 4, hours: 6)),
        userProfile: null,
        deliveryAddress: null,
      ),
    ];
  }

  @override
  Future<List<OrderEntity>> getOrders({
    int? limit,
    int? offset,
    OrderStatus? status,
    ProductType? productType,
    DeliveryMethod? deliveryMethod,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 100));
    
    var filteredOrders = _cachedOrders;
    
    if (status != null) {
      filteredOrders = filteredOrders.where((order) => order.status == status).toList();
    }
    
    if (productType != null) {
      filteredOrders = filteredOrders.where((order) => order.productType == productType).toList();
    }
    
    if (deliveryMethod != null) {
      filteredOrders = filteredOrders.where((order) => order.deliveryMethod == deliveryMethod).toList();
    }
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredOrders = filteredOrders.where((order) => 
        order.orderNumber.toLowerCase().contains(searchQuery.toLowerCase()) ||
        (order.deliveryMemo?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
      ).toList();
    }
    
    // 페이징 적용
    final start = offset ?? 0;
    final end = start + (limit ?? 20);
    
    return filteredOrders.skip(start).take(end - start).toList();
  }

  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      return _cachedOrders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<OrderEntity> createOrder({
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
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 100));
    
    final now = DateTime.now();
    final totalPrice = unitPrice * quantity;
    
    final newOrder = OrderEntity(
      id: 'demo_${now.millisecondsSinceEpoch}',
      orderNumber: 'DEMO${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${(_cachedOrders.length + 1).toString().padLeft(3, '0')}',
      userId: 'demo_user',
      productType: productType,
      quantity: quantity,
      javaraQuantity: javaraQuantity,
      returnTankQuantity: returnTankQuantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      status: OrderStatus.draft,
      deliveryMethod: deliveryMethod,
      deliveryDate: deliveryDate,
      deliveryAddressId: deliveryAddressId,
      deliveryMemo: deliveryMemo,
      cancelledReason: null,
      confirmedAt: null,
      confirmedBy: null,
      shippedAt: null,
      completedAt: null,
      cancelledAt: null,
      createdAt: now,
      updatedAt: now,
      userProfile: null,
      deliveryAddress: null,
    );
    
    _cachedOrders.insert(0, newOrder);
    await _saveOrders();
    return newOrder;
  }

  @override
  Future<OrderEntity> updateOrder({
    required String orderId,
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
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 100));
    
    final index = _cachedOrders.indexWhere((order) => order.id == orderId);
    if (index == -1) {
      throw Exception('주문을 찾을 수 없습니다');
    }
    
    final currentOrder = _cachedOrders[index];
    final newQuantity = quantity ?? currentOrder.quantity;
    final newUnitPrice = unitPrice ?? currentOrder.unitPrice;
    
    final updatedOrder = currentOrder.copyWith(
      productType: productType ?? currentOrder.productType,
      quantity: newQuantity,
      javaraQuantity: javaraQuantity ?? currentOrder.javaraQuantity,
      returnTankQuantity: returnTankQuantity ?? currentOrder.returnTankQuantity,
      deliveryDate: deliveryDate ?? currentOrder.deliveryDate,
      deliveryMethod: deliveryMethod ?? currentOrder.deliveryMethod,
      deliveryAddressId: deliveryAddressId ?? currentOrder.deliveryAddressId,
      deliveryMemo: deliveryMemo ?? currentOrder.deliveryMemo,
      unitPrice: newUnitPrice,
      totalPrice: newUnitPrice * newQuantity,
      updatedAt: DateTime.now(),
    );
    
    _cachedOrders[index] = updatedOrder;
    await _saveOrders();
    return updatedOrder;
  }

  @override
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? cancelledReason,
  }) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 100));
    
    final index = _cachedOrders.indexWhere((order) => order.id == orderId);
    if (index == -1) {
      throw Exception('주문을 찾을 수 없습니다');
    }
    
    final now = DateTime.now();
    final currentOrder = _cachedOrders[index];
    
    final updatedOrder = currentOrder.copyWith(
      status: status,
      updatedAt: now,
      confirmedAt: status == OrderStatus.confirmed ? now : currentOrder.confirmedAt,
      confirmedBy: status == OrderStatus.confirmed ? 'demo_admin' : currentOrder.confirmedBy,
      shippedAt: status == OrderStatus.shipped ? now : currentOrder.shippedAt,
      completedAt: status == OrderStatus.completed ? now : currentOrder.completedAt,
      cancelledAt: status == OrderStatus.cancelled ? now : currentOrder.cancelledAt,
      cancelledReason: status == OrderStatus.cancelled ? cancelledReason : currentOrder.cancelledReason,
    );
    
    _cachedOrders[index] = updatedOrder;
    await _saveOrders();
    return updatedOrder;
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 100));
    _cachedOrders.removeWhere((order) => order.id == orderId);
    await _saveOrders();
  }

  @override
  Future<Map<String, dynamic>> getOrderStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 100));
    
    return {
      'totalOrders': _cachedOrders.length,
      'totalAmount': _cachedOrders.fold(0.0, (sum, order) => sum + order.totalPrice),
      'draftOrders': _cachedOrders.where((o) => o.status == OrderStatus.draft).length,
      'pendingOrders': _cachedOrders.where((o) => o.status == OrderStatus.pending).length,
      'confirmedOrders': _cachedOrders.where((o) => o.status == OrderStatus.confirmed).length,
      'shippedOrders': _cachedOrders.where((o) => o.status == OrderStatus.shipped).length,
      'completedOrders': _cachedOrders.where((o) => o.status == OrderStatus.completed).length,
      'cancelledOrders': _cachedOrders.where((o) => o.status == OrderStatus.cancelled).length,
    };
  }

  @override
  Future<Map<String, dynamic>> getOrderStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await getOrderStatistics(startDate: startDate, endDate: endDate);
  }

  @override
  Future<Map<String, dynamic>> checkInventory({
    required ProductType productType,
    required int quantity,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // 데모 모드에서는 항상 재고 충분
    return {
      'available': true,
      'currentStock': quantity * 10, // 요청량의 10배로 설정
      'requestedQuantity': quantity,
    };
  }

  @override
  Future<Map<String, dynamic>> getUserUnitPrice({
    required String userId,
    required ProductType productType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // 데모 모드 가격
    final price = productType == ProductType.box ? 10000.0 : 900000.0;
    
    return {
      'unitPrice': price,
      'productType': productType.name,
      'userId': userId,
    };
  }

  @override
  Future<void> syncOfflineOrders() async {
    // 데모 모드에서는 동기화 불필요
    await Future.delayed(const Duration(milliseconds: 100));
  }
}