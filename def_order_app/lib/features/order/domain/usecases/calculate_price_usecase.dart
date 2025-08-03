import '../repositories/order_repository.dart';
import '../../data/models/order_model.dart';
import '../../../../core/error/exceptions.dart';

/// 가격 계산 유스케이스
/// 
/// 주문의 가격을 계산하는 비즈니스 로직을 처리합니다.
/// 사용자 등급별 단가, 배송비, 할인 등을 고려하여 최종 가격을 계산합니다.
class CalculatePriceUseCase {
  final OrderRepository _repository;

  CalculatePriceUseCase(this._repository);

  /// 가격 계산 실행
  /// 
  /// [params] 가격 계산에 필요한 매개변수
  /// 
  /// Returns: 계산된 가격 정보가 포함된 [PriceCalculationResult]
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  /// Throws: [ValidationException] 유효성 검사 실패 시
  Future<PriceCalculationResult> execute(CalculatePriceParams params) async {
    // 1. 입력 매개변수 유효성 검증
    final validationResult = _validateCalculatePriceParams(params);
    if (!validationResult.isValid) {
      throw ValidationException(message: validationResult.errorMessage);
    }

    // 2. 사용자별 단가 조회
    final priceInfo = await _repository.getUserUnitPrice(
      productType: params.productType,
    );

    final unitPrice = priceInfo['unitPrice'] as double;
    final userGrade = priceInfo['grade'] as String;
    final discountRate = priceInfo['discountRate'] as double;
    final basePrice = priceInfo['basePrice'] as double;

    // 3. 기본 금액 계산
    final subtotal = unitPrice * params.quantity;

    // 4. 배송비 계산
    final shippingCost = _calculateShippingCost(params);

    // 5. 추가 비용 계산
    final additionalCosts = _calculateAdditionalCosts(params);

    // 6. 할인 계산
    final discounts = _calculateDiscounts(params, subtotal);

    // 7. 최종 금액 계산
    final totalBeforeDiscount = subtotal + shippingCost + additionalCosts.total;
    final totalDiscount = discounts.total;
    final finalTotal = totalBeforeDiscount - totalDiscount;

    return PriceCalculationResult(
      unitPrice: unitPrice,
      basePrice: basePrice,
      quantity: params.quantity,
      subtotal: subtotal,
      shippingCost: shippingCost,
      additionalCosts: additionalCosts,
      discounts: discounts,
      totalBeforeDiscount: totalBeforeDiscount,
      totalDiscount: totalDiscount,
      finalTotal: finalTotal,
      userGrade: userGrade,
      gradeDiscountRate: discountRate,
      isUrgentDelivery: _isUrgentDelivery(params.deliveryDate),
      isWeekendDelivery: _isWeekendDelivery(params.deliveryDate),
    );
  }

  /// 입력 매개변수 유효성 검증
  ValidationResult _validateCalculatePriceParams(CalculatePriceParams params) {
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

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// 배송비 계산
  double _calculateShippingCost(CalculatePriceParams params) {
    // 자가수거인 경우 배송비 없음
    if (params.deliveryMethod == DeliveryMethod.directPickup) {
      return 0.0;
    }

    // 기본 배송비
    double shippingCost = 50000.0;

    // 수량에 따른 추가 배송비
    if (params.quantity > 10) {
      shippingCost += (params.quantity - 10) * 5000.0;
    }

    // 긴급 배송 추가 비용 (3일 이내)
    if (_isUrgentDelivery(params.deliveryDate)) {
      shippingCost *= 1.5; // 50% 추가
    }

    // 주말 배송 추가 비용
    if (_isWeekendDelivery(params.deliveryDate)) {
      shippingCost += 20000.0; // 2만원 추가
    }

    return shippingCost;
  }

  /// 추가 비용 계산
  AdditionalCosts _calculateAdditionalCosts(CalculatePriceParams params) {
    double javaraFee = 0.0;
    double handlingFee = 0.0;
    double urgencyFee = 0.0;

    // 자바라 수수료
    if (params.javaraQuantity != null && params.javaraQuantity! > 0) {
      javaraFee = params.javaraQuantity! * 3000.0; // 자바라당 3천원
    }

    // 대량 주문 처리 수수료
    if (params.quantity > 50) {
      handlingFee = params.quantity * 1000.0; // 개당 1천원
    }

    // 긴급 처리 수수료
    if (_isUrgentDelivery(params.deliveryDate)) {
      urgencyFee = params.quantity * 2000.0; // 개당 2천원
    }

    return AdditionalCosts(
      javaraFee: javaraFee,
      handlingFee: handlingFee,
      urgencyFee: urgencyFee,
    );
  }

  /// 할인 계산
  Discounts _calculateDiscounts(CalculatePriceParams params, double subtotal) {
    double volumeDiscount = 0.0;
    double loyaltyDiscount = 0.0;
    double promotionDiscount = 0.0;

    // 대량 주문 할인 (100개 이상)
    if (params.quantity >= 100) {
      volumeDiscount = subtotal * 0.05; // 5% 할인
    } else if (params.quantity >= 50) {
      volumeDiscount = subtotal * 0.03; // 3% 할인
    }

    // 충성 고객 할인 (추후 구현)
    // loyaltyDiscount = _calculateLoyaltyDiscount(subtotal);

    // 프로모션 할인 (추후 구현)
    // promotionDiscount = _calculatePromotionDiscount(subtotal);

    return Discounts(
      volumeDiscount: volumeDiscount,
      loyaltyDiscount: loyaltyDiscount,
      promotionDiscount: promotionDiscount,
    );
  }

  /// 긴급 배송 여부 확인 (3일 이내)
  bool _isUrgentDelivery(DateTime deliveryDate) {
    final now = DateTime.now();
    final difference = deliveryDate.difference(now);
    return difference.inDays <= 3 && difference.inDays >= 0;
  }

  /// 주말 배송 여부 확인
  bool _isWeekendDelivery(DateTime deliveryDate) {
    return deliveryDate.weekday == DateTime.saturday || 
           deliveryDate.weekday == DateTime.sunday;
  }
}

/// 가격 계산 매개변수
class CalculatePriceParams {
  final ProductType productType;
  final int quantity;
  final int? javaraQuantity;
  final int? returnTankQuantity;
  final DateTime deliveryDate;
  final DeliveryMethod deliveryMethod;

  const CalculatePriceParams({
    required this.productType,
    required this.quantity,
    this.javaraQuantity,
    this.returnTankQuantity,
    required this.deliveryDate,
    required this.deliveryMethod,
  });

  @override
  String toString() {
    return 'CalculatePriceParams('
        'productType: $productType, '
        'quantity: $quantity, '
        'javaraQuantity: $javaraQuantity, '
        'returnTankQuantity: $returnTankQuantity, '
        'deliveryDate: $deliveryDate, '
        'deliveryMethod: $deliveryMethod)';
  }
}

/// 추가 비용 정보
class AdditionalCosts {
  final double javaraFee;
  final double handlingFee;
  final double urgencyFee;

  const AdditionalCosts({
    required this.javaraFee,
    required this.handlingFee,
    required this.urgencyFee,
  });

  double get total => javaraFee + handlingFee + urgencyFee;

  @override
  String toString() {
    return 'AdditionalCosts(javaraFee: $javaraFee, handlingFee: $handlingFee, urgencyFee: $urgencyFee)';
  }
}

/// 할인 정보
class Discounts {
  final double volumeDiscount;
  final double loyaltyDiscount;
  final double promotionDiscount;

  const Discounts({
    required this.volumeDiscount,
    required this.loyaltyDiscount,
    required this.promotionDiscount,
  });

  double get total => volumeDiscount + loyaltyDiscount + promotionDiscount;

  @override
  String toString() {
    return 'Discounts(volumeDiscount: $volumeDiscount, loyaltyDiscount: $loyaltyDiscount, promotionDiscount: $promotionDiscount)';
  }
}

/// 가격 계산 결과
class PriceCalculationResult {
  final double unitPrice;
  final double basePrice;
  final int quantity;
  final double subtotal;
  final double shippingCost;
  final AdditionalCosts additionalCosts;
  final Discounts discounts;
  final double totalBeforeDiscount;
  final double totalDiscount;
  final double finalTotal;
  final String userGrade;
  final double gradeDiscountRate;
  final bool isUrgentDelivery;
  final bool isWeekendDelivery;

  const PriceCalculationResult({
    required this.unitPrice,
    required this.basePrice,
    required this.quantity,
    required this.subtotal,
    required this.shippingCost,
    required this.additionalCosts,
    required this.discounts,
    required this.totalBeforeDiscount,
    required this.totalDiscount,
    required this.finalTotal,
    required this.userGrade,
    required this.gradeDiscountRate,
    required this.isUrgentDelivery,
    required this.isWeekendDelivery,
  });

  /// 등급 할인 금액
  double get gradeDiscountAmount => basePrice * quantity * (gradeDiscountRate / 100);

  /// 총 절약 금액 (등급 할인 + 추가 할인)
  double get totalSavings => gradeDiscountAmount + totalDiscount;

  @override
  String toString() {
    return 'PriceCalculationResult('
        'unitPrice: $unitPrice, '
        'quantity: $quantity, '
        'subtotal: $subtotal, '
        'shippingCost: $shippingCost, '
        'finalTotal: $finalTotal, '
        'userGrade: $userGrade, '
        'isUrgentDelivery: $isUrgentDelivery, '
        'isWeekendDelivery: $isWeekendDelivery)';
  }
}