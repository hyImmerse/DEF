import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import '../../data/models/order_model.dart';
import '../../../../core/error/exceptions.dart';

/// 주문 생성 유스케이스
/// 
/// 새로운 주문을 생성하는 비즈니스 로직을 처리합니다.
/// 주문 데이터 유효성 검증, 재고 확인, 가격 계산 등을 수행합니다.
class CreateOrderUseCase {
  final OrderRepository _repository;

  CreateOrderUseCase(this._repository);

  /// 주문 생성 실행
  /// 
  /// [params] 주문 생성에 필요한 매개변수
  /// 
  /// Returns: 생성된 [OrderEntity]
  /// Throws: [ValidationException] 유효성 검사 실패 시
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  Future<OrderEntity> execute(CreateOrderParams params) async {
    // 1. 입력 데이터 유효성 검증
    final validationResult = _validateCreateOrderParams(params);
    if (!validationResult.isValid) {
      throw ValidationException(message: validationResult.errorMessage);
    }

    // 2. 비즈니스 규칙 검증
    await _validateBusinessRules(params);

    // 3. 주문 생성
    final orderEntity = await _repository.createOrder(
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

    return orderEntity;
  }

  /// 입력 매개변수 유효성 검증
  ValidationResult _validateCreateOrderParams(CreateOrderParams params) {
    final errors = <String, String>{};

    // 수량 검증
    if (params.quantity <= 0) {
      errors['quantity'] = '수량은 1개 이상이어야 합니다';
    }
    if (params.quantity > 1000) {
      errors['quantity'] = '수량은 1000개를 초과할 수 없습니다';
    }

    // 자바라 수량 검증
    if (params.javaraQuantity != null && params.javaraQuantity! < 0) {
      errors['javaraQuantity'] = '자바라 수량은 0개 이상이어야 합니다';
    }

    // 반환 탱크 수량 검증
    if (params.returnTankQuantity != null && params.returnTankQuantity! < 0) {
      errors['returnTankQuantity'] = '반환 탱크 수량은 0개 이상이어야 합니다';
    }

    // 배송일 검증
    final now = DateTime.now();
    final minDeliveryDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    if (params.deliveryDate.isBefore(minDeliveryDate)) {
      errors['deliveryDate'] = '배송일은 최소 1일 이후로 설정해야 합니다';
    }

    // 배송 방법별 검증
    if (params.deliveryMethod == DeliveryMethod.delivery && 
        (params.deliveryAddressId == null || params.deliveryAddressId!.isEmpty)) {
      errors['deliveryAddress'] = '배송 주소를 선택해주세요';
    }

    // 단가 검증
    if (params.unitPrice <= 0) {
      errors['unitPrice'] = '단가가 설정되지 않았습니다';
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// 비즈니스 규칙 검증
  Future<void> _validateBusinessRules(CreateOrderParams params) async {
    // 재고 확인
    final inventoryInfo = await _repository.checkInventory(
      productType: params.productType,
      quantity: params.quantity,
    );

    if (!(inventoryInfo['available'] as bool)) {
      throw ValidationException(
        message: '재고가 부족합니다. 현재 재고: ${inventoryInfo['availableStock']}개',
      );
    }

    // 사용자별 단가 확인
    final priceInfo = await _repository.getUserUnitPrice(
      productType: params.productType,
    );

    final expectedUnitPrice = priceInfo['unitPrice'] as double;
    if ((params.unitPrice - expectedUnitPrice).abs() > 0.01) {
      throw ValidationException(
        message: '단가가 올바르지 않습니다. 올바른 단가: ${expectedUnitPrice.toStringAsFixed(0)}원',
      );
    }

    // 주말/공휴일 배송일 체크 (추가 비즈니스 규칙)
    if (_isWeekend(params.deliveryDate)) {
      // 주말 배송은 경고만 하고 허용
      // 실제로는 추가 배송비가 발생할 수 있음을 알림
    }

    // 긴급 배송 체크 (3일 이내)
    final daysUntilDelivery = params.deliveryDate.difference(DateTime.now()).inDays;
    if (daysUntilDelivery <= 3 && daysUntilDelivery >= 0) {
      // 긴급 배송의 경우 추가 배송비 발생 가능성 체크
      // 실제로는 사용자에게 확인을 받아야 할 수 있음
    }
  }

  /// 주말 여부 확인
  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }
}

/// 주문 생성 매개변수
class CreateOrderParams {
  final ProductType productType;
  final int quantity;
  final int? javaraQuantity;
  final int? returnTankQuantity;
  final DateTime deliveryDate;
  final DeliveryMethod deliveryMethod;
  final String? deliveryAddressId;
  final String? deliveryMemo;
  final double unitPrice;

  const CreateOrderParams({
    required this.productType,
    required this.quantity,
    this.javaraQuantity,
    this.returnTankQuantity,
    required this.deliveryDate,
    required this.deliveryMethod,
    this.deliveryAddressId,
    this.deliveryMemo,
    required this.unitPrice,
  });

  /// 총 금액 계산
  double get totalPrice => unitPrice * quantity;

  /// 배송일까지 남은 일수
  int get daysUntilDelivery {
    final now = DateTime.now();
    final difference = deliveryDate.difference(now);
    return difference.inDays;
  }

  /// 긴급 배송 여부 (3일 이내)
  bool get isUrgent => daysUntilDelivery <= 3 && daysUntilDelivery >= 0;

  @override
  String toString() {
    return 'CreateOrderParams('
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