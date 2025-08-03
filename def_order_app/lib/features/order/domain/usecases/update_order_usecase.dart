import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import '../../data/models/order_model.dart';
import '../../../../core/error/exceptions.dart';

/// 주문 수정 유스케이스
/// 
/// 기존 주문의 정보를 수정하는 비즈니스 로직을 처리합니다.
/// 수정 가능 상태 확인, 재고 검증, 가격 검증 등을 수행합니다.
class UpdateOrderUseCase {
  final OrderRepository _repository;

  UpdateOrderUseCase(this._repository);

  /// 주문 수정 실행
  /// 
  /// [params] 주문 수정에 필요한 매개변수
  /// 
  /// Returns: 수정된 [OrderEntity]
  /// Throws: [ValidationException] 유효성 검사 실패 시
  /// Throws: [BusinessRuleException] 비즈니스 규칙 위반 시
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  Future<OrderEntity> execute(UpdateOrderParams params) async {
    // 1. 기존 주문 조회
    final existingOrder = await _repository.getOrderById(params.orderId);
    if (existingOrder == null) {
      throw ValidationException(message: '주문을 찾을 수 없습니다.');
    }

    // 2. 수정 가능 상태 확인
    if (!existingOrder.canEdit) {
      throw BusinessRuleException(
        message: '현재 상태(${existingOrder.status.name})에서는 주문을 수정할 수 없습니다.',
      );
    }

    // 3. 입력 데이터 유효성 검증
    final validationResult = _validateUpdateOrderParams(params, existingOrder);
    if (!validationResult.isValid) {
      throw ValidationException(message: validationResult.errorMessage);
    }

    // 4. 비즈니스 규칙 검증
    await _validateBusinessRules(params, existingOrder);

    // 5. 주문 수정
    final updatedOrder = await _repository.updateOrder(
      orderId: params.orderId,
      productType: params.productType,
      quantity: params.quantity,
      javaraQuantity: params.javaraQuantity,
      returnTankQuantity: params.returnTankQuantity,
      deliveryDate: params.deliveryDate,
      deliveryMethod: params.deliveryMethod,
      deliveryAddressId: params.deliveryAddressId,
      deliveryMemo: params.deliveryMemo,
      unitPrice: params.unitPrice,
    );

    return updatedOrder;
  }

  /// 입력 매개변수 유효성 검증
  ValidationResult _validateUpdateOrderParams(
    UpdateOrderParams params,
    OrderEntity existingOrder,
  ) {
    final errors = <String, String>{};

    // 수량 검증 (변경되는 경우만)
    if (params.quantity != null) {
      if (params.quantity! <= 0) {
        errors['quantity'] = '수량은 1개 이상이어야 합니다';
      }
      if (params.quantity! > 1000) {
        errors['quantity'] = '수량은 1000개를 초과할 수 없습니다';
      }
    }

    // 자바라 수량 검증
    if (params.javaraQuantity != null && params.javaraQuantity! < 0) {
      errors['javaraQuantity'] = '자바라 수량은 0개 이상이어야 합니다';
    }

    // 반환 탱크 수량 검증
    if (params.returnTankQuantity != null && params.returnTankQuantity! < 0) {
      errors['returnTankQuantity'] = '반환 탱크 수량은 0개 이상이어야 합니다';
    }

    // 배송일 검증 (변경되는 경우만)
    if (params.deliveryDate != null) {
      final now = DateTime.now();
      final minDeliveryDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
      if (params.deliveryDate!.isBefore(minDeliveryDate)) {
        errors['deliveryDate'] = '배송일은 최소 1일 이후로 설정해야 합니다';
      }
    }

    // 배송 방법별 검증
    final finalDeliveryMethod = params.deliveryMethod ?? existingOrder.deliveryMethod;
    final finalDeliveryAddressId = params.deliveryAddressId ?? existingOrder.deliveryAddressId;
    
    if (finalDeliveryMethod == DeliveryMethod.delivery && 
        (finalDeliveryAddressId == null || finalDeliveryAddressId.isEmpty)) {
      errors['deliveryAddress'] = '배송 주소를 선택해주세요';
    }

    // 단가 검증 (변경되는 경우만)
    if (params.unitPrice != null && params.unitPrice! <= 0) {
      errors['unitPrice'] = '단가가 설정되지 않았습니다';
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// 비즈니스 규칙 검증
  Future<void> _validateBusinessRules(
    UpdateOrderParams params,
    OrderEntity existingOrder,
  ) async {
    // 재고 확인 (수량이나 제품 타입이 변경되는 경우)
    if (params.quantity != null && params.quantity != existingOrder.quantity ||
        params.productType != null && params.productType != existingOrder.productType) {
      
      final finalProductType = params.productType ?? existingOrder.productType;
      final finalQuantity = params.quantity ?? existingOrder.quantity;
      
      final inventoryInfo = await _repository.checkInventory(
        productType: finalProductType,
        quantity: finalQuantity,
      );

      if (!(inventoryInfo['available'] as bool)) {
        throw ValidationException(
          message: '재고가 부족합니다. 현재 재고: ${inventoryInfo['availableStock']}개',
        );
      }
    }

    // 사용자별 단가 확인 (단가나 제품 타입이 변경되는 경우)
    if (params.unitPrice != null || params.productType != null) {
      final finalProductType = params.productType ?? existingOrder.productType;
      final finalUnitPrice = params.unitPrice ?? existingOrder.unitPrice;
      
      final priceInfo = await _repository.getUserUnitPrice(
        productType: finalProductType,
      );

      final expectedUnitPrice = priceInfo['unitPrice'] as double;
      if ((finalUnitPrice - expectedUnitPrice).abs() > 0.01) {
        throw ValidationException(
          message: '단가가 올바르지 않습니다. 올바른 단가: ${expectedUnitPrice.toStringAsFixed(0)}원',
        );
      }
    }

    // 배송일 변경 시 추가 검증
    if (params.deliveryDate != null) {
      final finalDeliveryDate = params.deliveryDate!;
      
      // 주말/공휴일 배송일 체크
      if (_isWeekend(finalDeliveryDate)) {
        // 주말 배송은 경고만 하고 허용
      }

      // 긴급 배송 체크 (3일 이내)
      final daysUntilDelivery = finalDeliveryDate.difference(DateTime.now()).inDays;
      if (daysUntilDelivery <= 3 && daysUntilDelivery >= 0) {
        // 긴급 배송의 경우 추가 배송비 발생 가능성 체크
      }
    }

    // 배송 방법 변경 시 추가 검증
    if (params.deliveryMethod != null && 
        params.deliveryMethod != existingOrder.deliveryMethod) {
      // 배송 방법 변경에 따른 추가 비용이나 제약사항 확인
      // 예: 자가수거에서 배송으로 변경 시 배송비 추가
    }
  }

  /// 주말 여부 확인
  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }
}

/// 주문 수정 매개변수
class UpdateOrderParams {
  final String orderId;
  final ProductType? productType;
  final int? quantity;
  final int? javaraQuantity;
  final int? returnTankQuantity;
  final DateTime? deliveryDate;
  final DeliveryMethod? deliveryMethod;
  final String? deliveryAddressId;
  final String? deliveryMemo;
  final double? unitPrice;

  const UpdateOrderParams({
    required this.orderId,
    this.productType,
    this.quantity,
    this.javaraQuantity,
    this.returnTankQuantity,
    this.deliveryDate,
    this.deliveryMethod,
    this.deliveryAddressId,
    this.deliveryMemo,
    this.unitPrice,
  });

  /// 수정 사항이 있는지 확인
  bool get hasChanges {
    return productType != null ||
           quantity != null ||
           javaraQuantity != null ||
           returnTankQuantity != null ||
           deliveryDate != null ||
           deliveryMethod != null ||
           deliveryAddressId != null ||
           deliveryMemo != null ||
           unitPrice != null;
  }

  /// 총 금액 계산 (수량과 단가가 모두 제공된 경우)
  double? get totalPrice {
    if (quantity != null && unitPrice != null) {
      return unitPrice! * quantity!;
    }
    return null;
  }

  @override
  String toString() {
    return 'UpdateOrderParams('
        'orderId: $orderId, '
        'productType: $productType, '
        'quantity: $quantity, '
        'javaraQuantity: $javaraQuantity, '
        'returnTankQuantity: $returnTankQuantity, '
        'deliveryDate: $deliveryDate, '
        'deliveryMethod: $deliveryMethod, '
        'deliveryAddressId: $deliveryAddressId, '
        'deliveryMemo: $deliveryMemo, '
        'unitPrice: $unitPrice)';
  }
}