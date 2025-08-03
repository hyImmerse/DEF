import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/supabase_config.dart';
import '../error/exceptions.dart';
import 'package:gotrue/gotrue.dart' as gotrue;

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

class SupabaseService {
  SupabaseClient get client => SupabaseConfig.client;
  
  // Auth helpers
  User? get currentUser => client.auth.currentUser;
  Session? get currentSession => client.auth.currentSession;
  bool get isAuthenticated => currentUser != null;
  
  // Error handling wrapper
  Future<T> handleSupabaseOperation<T>({
    required Future<T> Function() operation,
    String? errorMessage,
  }) async {
    try {
      return await operation();
    } on PostgrestException catch (e) {
      throw ServerException(
        message: errorMessage ?? e.message,
        code: e.code,
      );
    } on gotrue.AuthException catch (e) {
      throw AppAuthException(
        message: errorMessage ?? e.message,
        code: e.statusCode?.toString(),
      );
    } catch (e) {
      throw ServerException(
        message: errorMessage ?? '알 수 없는 오류가 발생했습니다',
      );
    }
  }
  
  // Business number validation via Edge Function
  Future<bool> validateBusinessNumber(String businessNumber) async {
    try {
      final response = await client.functions.invoke(
        'validate-business-number',
        body: {'businessNumber': businessNumber},
      );
      
      // Supabase functions client의 새로운 API
      // error 프로퍼티가 제거되고 status로 체크
      if (response.status != 200) {
        throw ServerException(message: '함수 호출에 실패했습니다');
      }
      
      return response.data['isValid'] as bool;
    } catch (e) {
      throw ServerException(
        message: '사업자번호 검증 중 오류가 발생했습니다',
      );
    }
  }
  
  // Order number generation
  Future<String> generateOrderNumber() async {
    try {
      final response = await client.rpc('generate_order_number').single();
      return response as String;
    } catch (e) {
      throw ServerException(
        message: '주문번호 생성 중 오류가 발생했습니다',
      );
    }
  }
  
  // Inventory check
  Future<bool> checkInventory({
    required String location,
    required String productType,
    required int quantity,
  }) async {
    try {
      final response = await client
          .from('inventory')
          .select('current_quantity')
          .eq('location', location)
          .eq('product_type', productType)
          .single();
      
      final currentQuantity = response['current_quantity'] as int;
      return currentQuantity >= quantity;
    } catch (e) {
      throw ServerException(
        message: '재고 확인 중 오류가 발생했습니다',
      );
    }
  }
  
  // Process order (confirm, ship, complete, cancel)
  Future<Map<String, dynamic>> processOrder({
    required String orderId,
    required String action,
    String? reason,
  }) async {
    try {
      final response = await client.functions.invoke(
        'process-order',
        body: {
          'orderId': orderId,
          'action': action,
          'reason': reason,
        },
      );
      
      // Supabase functions client의 새로운 API
      // error 프로퍼티가 제거되고 status로 체크
      if (response.status != 200) {
        throw ServerException(message: '함수 호출에 실패했습니다');
      }
      
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw ServerException(
        message: '주문 처리 중 오류가 발생했습니다',
      );
    }
  }
  
  // Send notification
  Future<void> sendNotification({
    String? userId,
    List<String>? userIds,
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await client.functions.invoke(
        'send-notification',
        body: {
          'userId': userId,
          'userIds': userIds,
          'title': title,
          'message': message,
          'type': type,
          'data': data,
        },
      );
      
      // Supabase functions client의 새로운 API
      // error 프로퍼티가 제거되고 status로 체크
      if (response.status != 200) {
        throw ServerException(message: '함수 호출에 실패했습니다');
      }
    } catch (e) {
      throw ServerException(
        message: '알림 전송 중 오류가 발생했습니다',
      );
    }
  }
  
  // Realtime subscription helper
  RealtimeChannel subscribeToTable({
    required String table,
    required void Function(PostgresChangePayload) onInsert,
    void Function(PostgresChangePayload)? onUpdate,
    void Function(PostgresChangePayload)? onDelete,
    PostgresChangeFilter? filter,
  }) {
    final channel = client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: table,
          filter: filter,
          callback: onInsert,
        );
    
    if (onUpdate != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: table,
        filter: filter,
        callback: onUpdate,
      );
    }
    
    if (onDelete != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: table,
        filter: filter,
        callback: onDelete,
      );
    }
    
    channel.subscribe();
    
    return channel;
  }
  
  // Unsubscribe from realtime
  Future<void> unsubscribe(RealtimeChannel channel) async {
    await channel.unsubscribe();
  }
  
  // Storage helpers
  String getPublicUrl(String path) {
    return client.storage.from('public').getPublicUrl(path);
  }
  
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required dynamic file,
  }) async {
    try {
      final response = await client.storage
          .from(bucket)
          .upload(path, file);
      
      return response;
    } catch (e) {
      throw ServerException(
        message: '파일 업로드 중 오류가 발생했습니다',
      );
    }
  }
}