import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';

/// 주문 관련 API 서비스
class OrderService {
  final SupabaseService _supabaseService;
  final SupabaseClient _client;

  OrderService({
    SupabaseService? supabaseService,
  }) : _supabaseService = supabaseService ?? SupabaseService(),
        _client = Supabase.instance.client;

  /// 주문 목록 조회 (필터링 및 페이징 지원)
  Future<List<OrderModel>> getOrders({
    int? limit = 20,
    int? offset = 0,
    OrderStatus? status,
    ProductType? productType,
    DeliveryMethod? deliveryMethod,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) async {
    try {
      var query = _client
          .from('orders')
          .select('''
            *,
            profiles!orders_user_id_fkey(
              id,
              business_name,
              representative_name,
              phone,
              email
            ),
            delivery_addresses!orders_delivery_address_id_fkey(
              id,
              name,
              address,
              address_detail,
              postal_code,
              phone
            )
          ''');

      // 현재 사용자의 주문만 조회
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
        query = query.eq('user_id', userId);
      }

      // 상태 필터
      if (status != null) {
        query = query.eq('status', status.name);
      }

      // 제품 타입 필터
      if (productType != null) {
        query = query.eq('product_type', productType.name);
      }

      // 배송 방법 필터
      if (deliveryMethod != null) {
        query = query.eq('delivery_method', deliveryMethod.name);
      }

      // 날짜 범위 필터
      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      // 검색 쿼리
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('order_number.ilike.%$searchQuery%,'
            'delivery_memo.ilike.%$searchQuery%');
      }

      // 정렬 및 페이징을 한번에 처리
      final finalQuery = query.order('created_at', ascending: false);
      
      // 페이징 적용
      dynamic paginatedQuery;
      if (offset != null && limit != null) {
        paginatedQuery = finalQuery.range(offset, offset + limit - 1);
      } else if (limit != null) {
        paginatedQuery = finalQuery.limit(limit);
      } else {
        paginatedQuery = finalQuery;
      }

      final response = await paginatedQuery;
      
      return (response as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: '주문 목록 조회 실패: ${e.toString()}');
    }
  }

  /// 주문 상세 조회
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await _client
          .from('orders')
          .select('''
            *,
            profiles!orders_user_id_fkey(
              id,
              business_name,
              representative_name,
              phone,
              email,
              grade,
              status
            ),
            delivery_addresses!orders_delivery_address_id_fkey(
              id,
              name,
              address,
              address_detail,
              postal_code,
              phone
            )
          ''')
          .eq('id', orderId)
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST116') {
        return null; // 주문을 찾을 수 없음
      }
      throw ServerException(message: '주문 상세 조회 실패: ${e.toString()}');
    }
  }

  /// 새 주문 생성
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
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw const AuthException('로그인이 필요합니다');
      }

      final totalPrice = unitPrice * quantity;
      final orderNumber = await _generateOrderNumber();

      final orderData = {
        'order_number': orderNumber,
        'user_id': userId,
        'status': OrderStatus.draft.name,
        'product_type': productType.name,
        'quantity': quantity,
        'javara_quantity': javaraQuantity,
        'return_tank_quantity': returnTankQuantity,
        'delivery_date': deliveryDate.toIso8601String(),
        'delivery_method': deliveryMethod.name,
        'delivery_address_id': deliveryAddressId,
        'delivery_memo': deliveryMemo,
        'unit_price': unitPrice,
        'total_price': totalPrice,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('orders')
          .insert(orderData)
          .select()
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: '주문 생성 실패: ${e.toString()}');
    }
  }

  /// 주문 수정
  Future<OrderModel> updateOrder({
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
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (productType != null) updateData['product_type'] = productType.name;
      if (quantity != null) updateData['quantity'] = quantity;
      if (javaraQuantity != null) updateData['javara_quantity'] = javaraQuantity;
      if (returnTankQuantity != null) updateData['return_tank_quantity'] = returnTankQuantity;
      if (deliveryDate != null) updateData['delivery_date'] = deliveryDate.toIso8601String();
      if (deliveryMethod != null) updateData['delivery_method'] = deliveryMethod.name;
      if (deliveryAddressId != null) updateData['delivery_address_id'] = deliveryAddressId;
      if (deliveryMemo != null) updateData['delivery_memo'] = deliveryMemo;
      if (unitPrice != null) {
        updateData['unit_price'] = unitPrice;
        // 수량이 변경되었다면 총 가격도 업데이트
        if (quantity != null) {
          updateData['total_price'] = unitPrice * quantity;
        }
      }

      final response = await _client
          .from('orders')
          .update(updateData)
          .eq('id', orderId)
          .select()
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: '주문 수정 실패: ${e.toString()}');
    }
  }

  /// 주문 상태 변경
  Future<OrderModel> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? cancelledReason,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // 상태에 따른 타임스탬프 설정
      switch (status) {
        case OrderStatus.confirmed:
          updateData['confirmed_at'] = DateTime.now().toIso8601String();
          updateData['confirmed_by'] = _client.auth.currentUser?.id;
          break;
        case OrderStatus.shipped:
          updateData['shipped_at'] = DateTime.now().toIso8601String();
          break;
        case OrderStatus.completed:
          updateData['completed_at'] = DateTime.now().toIso8601String();
          break;
        case OrderStatus.cancelled:
          updateData['cancelled_at'] = DateTime.now().toIso8601String();
          updateData['cancelled_reason'] = cancelledReason;
          break;
        default:
          break;
      }

      final response = await _client
          .from('orders')
          .update(updateData)
          .eq('id', orderId)
          .select()
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: '주문 상태 변경 실패: ${e.toString()}');
    }
  }

  /// 주문 삭제
  Future<void> deleteOrder(String orderId) async {
    try {
      await _client
          .from('orders')
          .delete()
          .eq('id', orderId);
    } catch (e) {
      throw ServerException(message: '주문 삭제 실패: ${e.toString()}');
    }
  }

  /// 주문 통계 조회
  Future<Map<String, dynamic>> getOrderStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw const AuthException('로그인이 필요합니다');
      }

      var query = _client
          .from('orders')
          .select('status, total_price, quantity')
          .eq('user_id', userId);

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      final response = await query;
      final orders = response as List;

      // 통계 계산
      int totalOrders = orders.length;
      double totalAmount = 0;
      int totalQuantity = 0;
      Map<String, int> statusCount = {};

      for (final order in orders) {
        totalAmount += (order['total_price'] as num).toDouble();
        totalQuantity += (order['quantity'] as int);
        
        final status = order['status'] as String;
        statusCount[status] = (statusCount[status] ?? 0) + 1;
      }

      return {
        'total_orders': totalOrders,
        'total_amount': totalAmount,
        'total_quantity': totalQuantity,
        'status_count': statusCount,
      };
    } catch (e) {
      throw ServerException(message: '주문 통계 조회 실패: ${e.toString()}');
    }
  }

  /// 주문번호 생성
  Future<String> _generateOrderNumber() async {
    final now = DateTime.now();
    final datePrefix = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    
    // 오늘 날짜로 시작하는 주문 개수 조회
    final result = await _client
        .from('orders')
        .select('id')
        .like('order_number', '$datePrefix%');

    final orderCount = result.length + 1;
    
    return '$datePrefix${orderCount.toString().padLeft(4, '0')}';
  }
}