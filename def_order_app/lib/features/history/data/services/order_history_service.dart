import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/error/exceptions.dart';
import '../../../order/data/models/order_model.dart';

final orderHistoryServiceProvider = Provider<OrderHistoryService>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return OrderHistoryService(supabaseService);
});

/// 주문 내역 서비스
/// 사용자의 과거 주문 내역 조회 및 거래명세서 관련 기능
class OrderHistoryService {
  final SupabaseService _supabaseService;
  
  OrderHistoryService(this._supabaseService);
  
  /// 주문 내역 목록 조회
  Future<List<OrderModel>> getOrderHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? status,
    ProductType? productType,
    DeliveryMethod? deliveryMethod,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      var query = _supabaseService.client
          .from('orders')
          .select('''
            *,
            profiles (
              id,
              business_number,
              business_name,
              representative_name,
              phone,
              email,
              grade,
              status
            ),
            delivery_addresses (*)
          ''')
          .eq('user_id', userId)
          .neq('status', 'draft'); // 임시저장 제외
      
      // 날짜 필터
      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        // 종료일의 마지막 시간까지 포함
        final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        query = query.lte('created_at', endOfDay.toIso8601String());
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
      
      // 정렬 및 페이징 (마지막에 적용)
      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      
      return (response as List)
          .map((data) => OrderModel.fromJson(data))
          .toList();
    } catch (e) {
      throw ServerException(
        message: '주문 내역을 불러올 수 없습니다',
      );
    }
  }
  
  /// 특정 기간의 주문 통계 조회
  Future<OrderStatistics> getOrderStatistics({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabaseService.client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .neq('status', 'draft')
          .neq('status', 'cancelled');
      
      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        query = query.lte('created_at', endOfDay.toIso8601String());
      }
      
      final response = await query;
      final orders = (response as List)
          .map((data) => OrderModel.fromJson(data))
          .toList();
      
      // 통계 계산
      int totalOrders = orders.length;
      double totalAmount = 0;
      int totalQuantity = 0;
      Map<OrderStatus, int> statusCount = {};
      Map<ProductType, int> productTypeCount = {};
      
      for (final order in orders) {
        totalAmount += order.totalPrice;
        totalQuantity += order.quantity;
        
        statusCount[order.status] = (statusCount[order.status] ?? 0) + 1;
        productTypeCount[order.productType] = 
            (productTypeCount[order.productType] ?? 0) + 1;
      }
      
      return OrderStatistics(
        totalOrders: totalOrders,
        totalAmount: totalAmount,
        totalQuantity: totalQuantity,
        averageOrderValue: totalOrders > 0 ? totalAmount / totalOrders : 0,
        statusCount: statusCount,
        productTypeCount: productTypeCount,
      );
    } catch (e) {
      throw ServerException(
        message: '주문 통계를 불러올 수 없습니다',
      );
    }
  }
  
  /// 거래명세서 PDF URL 조회
  Future<String?> getTransactionStatementUrl(String orderId) async {
    try {
      final response = await _supabaseService.client
          .from('transaction_statements')
          .select('file_url')
          .eq('order_id', orderId)
          .maybeSingle();
      
      if (response == null) return null;
      
      return response['file_url'] as String?;
    } catch (e) {
      throw ServerException(
        message: '거래명세서를 불러올 수 없습니다',
      );
    }
  }
  
  /// 거래명세서 생성 요청
  Future<void> requestTransactionStatement(String orderId) async {
    try {
      await _supabaseService.client.functions.invoke(
        'generate-transaction-statement',
        body: {'orderId': orderId},
      );
    } catch (e) {
      throw ServerException(
        message: '거래명세서 생성 요청에 실패했습니다',
      );
    }
  }
  
  /// 주문 내역 Excel 다운로드 URL 생성
  Future<String> generateExcelDownloadUrl({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _supabaseService.client.functions.invoke(
        'generate-order-history-excel',
        body: {
          'userId': userId,
          'startDate': startDate?.toIso8601String(),
          'endDate': endDate?.toIso8601String(),
        },
      );
      
      if (response.data == null || response.data['url'] == null) {
        throw ServerException(message: 'Excel 파일 생성에 실패했습니다');
      }
      
      return response.data['url'] as String;
    } catch (e) {
      throw ServerException(
        message: 'Excel 다운로드 URL 생성에 실패했습니다',
      );
    }
  }
}

/// 주문 통계 모델
class OrderStatistics {
  final int totalOrders;
  final double totalAmount;
  final int totalQuantity;
  final double averageOrderValue;
  final Map<OrderStatus, int> statusCount;
  final Map<ProductType, int> productTypeCount;
  
  const OrderStatistics({
    required this.totalOrders,
    required this.totalAmount,
    required this.totalQuantity,
    required this.averageOrderValue,
    required this.statusCount,
    required this.productTypeCount,
  });
}