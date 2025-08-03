import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import '../../../../core/error/exceptions.dart';
import '../../../notification/data/services/push_notification_service.dart';
import '../../../../core/utils/logger.dart';

/// 주문 저장소 구현체
/// 
/// OrderRepository 인터페이스를 구현하여 Supabase를 통한 주문 데이터 액세스를 제공합니다.
/// OrderService를 사용하여 실제 API 호출을 수행하고, 
/// 도메인 엔티티와 데이터 모델 간의 변환을 처리합니다.
class OrderRepositoryImpl implements OrderRepository {
  final OrderService _orderService;
  final SupabaseClient _client;
  final PushNotificationService _pushNotificationService;

  OrderRepositoryImpl({
    OrderService? orderService,
    PushNotificationService? pushNotificationService,
  }) : _orderService = orderService ?? OrderService(),
        _client = Supabase.instance.client,
        _pushNotificationService = pushNotificationService ?? PushNotificationService();

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
    try {
      final models = await _orderService.getOrders(
        limit: limit,
        offset: offset,
        status: status,
        productType: productType,
        deliveryMethod: deliveryMethod,
        startDate: startDate,
        endDate: endDate,
        searchQuery: searchQuery,
      );

      return models.map((model) => OrderEntity.fromModel(model)).toList();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: '주문 목록 조회 실패: ${e.toString()}');
    }
  }

  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    try {
      final model = await _orderService.getOrderById(orderId);
      return model != null ? OrderEntity.fromModel(model) : null;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: '주문 상세 조회 실패: ${e.toString()}');
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
    try {
      // 재고 확인
      final inventoryCheck = await checkInventory(
        productType: productType,
        quantity: quantity,
      );

      if (!(inventoryCheck['available'] as bool)) {
        throw ValidationException(
          message: '재고가 부족합니다. 현재 재고: ${inventoryCheck['availableStock']}개',
        );
      }

      // 가격 유효성 검증 (사용자 등급별 단가 확인)
      final userPriceInfo = await getUserUnitPrice(productType: productType);
      final expectedUnitPrice = userPriceInfo['unitPrice'] as double;
      
      if ((unitPrice - expectedUnitPrice).abs() > 0.01) {
        throw ValidationException(
          message: '단가가 올바르지 않습니다. 올바른 단가: ${expectedUnitPrice.toStringAsFixed(0)}원',
        );
      }

      final model = await _orderService.createOrder(
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

      return OrderEntity.fromModel(model);
    } catch (e) {
      if (e is ServerException || e is ValidationException || e is AuthException) {
        rethrow;
      }
      throw ServerException(message: '주문 생성 실패: ${e.toString()}');
    }
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
    try {
      // 기존 주문 조회하여 수정 가능 여부 확인
      final existingOrder = await getOrderById(orderId);
      if (existingOrder == null) {
        throw ValidationException(message: '주문을 찾을 수 없습니다.');
      }

      if (!existingOrder.canEdit) {
        throw BusinessRuleException(
          message: '현재 상태(${existingOrder.status.name})에서는 주문을 수정할 수 없습니다.',
        );
      }

      // 수량이나 제품 타입이 변경되는 경우 재고 확인
      if (quantity != null && quantity != existingOrder.quantity ||
          productType != null && productType != existingOrder.productType) {
        final checkProductType = productType ?? existingOrder.productType;
        final checkQuantity = quantity ?? existingOrder.quantity;
        
        final inventoryCheck = await checkInventory(
          productType: checkProductType,
          quantity: checkQuantity,
        );

        if (!(inventoryCheck['available'] as bool)) {
          throw ValidationException(
            message: '재고가 부족합니다. 현재 재고: ${inventoryCheck['availableStock']}개',
          );
        }
      }

      // 단가가 변경되는 경우 유효성 검증
      if (unitPrice != null && unitPrice != existingOrder.unitPrice) {
        final checkProductType = productType ?? existingOrder.productType;
        final userPriceInfo = await getUserUnitPrice(productType: checkProductType);
        final expectedUnitPrice = userPriceInfo['unitPrice'] as double;
        
        if ((unitPrice - expectedUnitPrice).abs() > 0.01) {
          throw ValidationException(
            message: '단가가 올바르지 않습니다. 올바른 단가: ${expectedUnitPrice.toStringAsFixed(0)}원',
          );
        }
      }

      final model = await _orderService.updateOrder(
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

      return OrderEntity.fromModel(model);
    } catch (e) {
      if (e is ServerException || e is ValidationException || e is BusinessRuleException) {
        rethrow;
      }
      throw ServerException(message: '주문 수정 실패: ${e.toString()}');
    }
  }

  @override
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? cancelledReason,
  }) async {
    try {
      // 기존 주문 조회하여 상태 변경 가능 여부 확인
      final existingOrder = await getOrderById(orderId);
      if (existingOrder == null) {
        throw ValidationException(message: '주문을 찾을 수 없습니다.');
      }

      // 비즈니스 규칙 검증
      bool canChangeStatus = false;
      switch (status) {
        case OrderStatus.confirmed:
          canChangeStatus = existingOrder.canConfirm;
          break;
        case OrderStatus.shipped:
          canChangeStatus = existingOrder.canShip;
          break;
        case OrderStatus.completed:
          canChangeStatus = existingOrder.canComplete;
          break;
        case OrderStatus.cancelled:
          canChangeStatus = existingOrder.canCancel;
          if (canChangeStatus && (cancelledReason == null || cancelledReason.isEmpty)) {
            throw ValidationException(message: '취소 사유를 입력해주세요.');
          }
          break;
        default:
          canChangeStatus = false;
      }

      if (!canChangeStatus) {
        throw BusinessRuleException(
          message: '현재 상태(${existingOrder.status.name})에서 ${status.name} 상태로 변경할 수 없습니다.',
        );
      }

      final model = await _orderService.updateOrderStatus(
        orderId: orderId,
        status: status,
        cancelledReason: cancelledReason,
      );

      // 푸시 알림 발송 (실패해도 주문 처리는 계속)
      try {
        await _pushNotificationService.sendOrderStatusNotification(
          userId: existingOrder.userId,
          order: existingOrder,
          newStatus: status,
        );
        logger.i('주문 상태 변경 알림 발송 완료: $orderId');
      } catch (e) {
        logger.e('주문 상태 변경 알림 발송 실패', e);
        // 알림 발송 실패해도 주문 처리는 계속
      }

      return OrderEntity.fromModel(model);
    } catch (e) {
      if (e is ServerException || e is ValidationException || e is BusinessRuleException) {
        rethrow;
      }
      throw ServerException(message: '주문 상태 변경 실패: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    try {
      // 삭제 가능 여부 확인
      final existingOrder = await getOrderById(orderId);
      if (existingOrder == null) {
        throw ValidationException(message: '주문을 찾을 수 없습니다.');
      }

      // 일반적으로 draft 상태만 삭제 가능
      if (existingOrder.status != OrderStatus.draft) {
        throw BusinessRuleException(
          message: '임시저장 상태의 주문만 삭제할 수 있습니다.',
        );
      }

      await _orderService.deleteOrder(orderId);
    } catch (e) {
      if (e is ServerException || e is ValidationException || e is BusinessRuleException) {
        rethrow;
      }
      throw ServerException(message: '주문 삭제 실패: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getOrderStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await _orderService.getOrderStats(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: '주문 통계 조회 실패: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> checkInventory({
    required ProductType productType,
    required int quantity,
  }) async {
    try {
      // 실제 구현에서는 inventory 테이블을 조회해야 함
      // 현재는 임시로 충분한 재고가 있다고 가정
      final response = await _client
          .from('inventory')
          .select('current_stock, reserved_stock')
          .eq('product_type', productType.name)
          .maybeSingle();

      if (response == null) {
        // 재고 정보가 없는 경우 기본값 반환
        return {
          'available': true,
          'currentStock': 1000,
          'reservedStock': 0,
          'availableStock': 1000,
        };
      }

      final currentStock = response['current_stock'] as int;
      final reservedStock = response['reserved_stock'] as int;
      final availableStock = currentStock - reservedStock;

      return {
        'available': availableStock >= quantity,
        'currentStock': currentStock,
        'reservedStock': reservedStock,
        'availableStock': availableStock,
      };
    } catch (e) {
      // 재고 확인 실패 시 안전하게 재고 부족으로 처리
      return {
        'available': false,
        'currentStock': 0,
        'reservedStock': 0,
        'availableStock': 0,
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getUserUnitPrice({
    required ProductType productType,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw const AuthException('로그인이 필요합니다');
      }

      // 사용자 등급 조회
      final userProfile = await _client
          .from('profiles')
          .select('grade')
          .eq('id', userId)
          .single();

      final userGrade = userProfile['grade'] as String;

      // 제품별 기본 단가 조회
      final priceInfo = await _client
          .from('product_prices')
          .select('base_price, dealer_discount_rate, regular_discount_rate')
          .eq('product_type', productType.name)
          .single();

      final basePrice = (priceInfo['base_price'] as num).toDouble();
      double discountRate = 0.0;
      String grade = userGrade;

      // 등급별 할인율 적용
      switch (userGrade) {
        case 'dealer':
        case 'agent':
          discountRate = (priceInfo['dealer_discount_rate'] as num).toDouble();
          break;
        case 'regular':
        default:
          discountRate = (priceInfo['regular_discount_rate'] as num).toDouble();
          grade = 'regular';
          break;
      }

      final unitPrice = basePrice * (1 - discountRate / 100);

      return {
        'unitPrice': unitPrice,
        'grade': grade,
        'discountRate': discountRate,
        'basePrice': basePrice,
      };
    } catch (e) {
      // 가격 정보 조회 실패 시 기본값 반환
      final defaultPrice = productType == ProductType.box ? 50000.0 : 45000.0;
      return {
        'unitPrice': defaultPrice,
        'grade': 'regular',
        'discountRate': 0.0,
        'basePrice': defaultPrice,
      };
    }
  }
}