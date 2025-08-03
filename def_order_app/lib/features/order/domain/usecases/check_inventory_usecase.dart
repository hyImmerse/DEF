import '../repositories/order_repository.dart';
import '../../data/models/order_model.dart';
import '../../../../core/error/exceptions.dart';

/// 재고 확인 유스케이스
/// 
/// 주문 전 재고 상황을 확인하는 비즈니스 로직을 처리합니다.
/// 박스/벌크별 재고 확인, 예약된 재고 고려, 재고 부족 시 대안 제시 등을 수행합니다.
class CheckInventoryUseCase {
  final OrderRepository _repository;

  CheckInventoryUseCase(this._repository);

  /// 재고 확인 실행
  /// 
  /// [params] 재고 확인에 필요한 매개변수
  /// 
  /// Returns: 재고 정보가 포함된 [InventoryCheckResult]
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [ValidationException] 유효성 검사 실패 시
  Future<InventoryCheckResult> execute(CheckInventoryParams params) async {
    // 1. 입력 매개변수 유효성 검증
    final validationResult = _validateCheckInventoryParams(params);
    if (!validationResult.isValid) {
      throw ValidationException(message: validationResult.errorMessage);
    }

    // 2. 기본 재고 정보 조회
    final inventoryInfo = await _repository.checkInventory(
      productType: params.productType,
      quantity: params.quantity,
    );

    final currentStock = inventoryInfo['currentStock'] as int;
    final reservedStock = inventoryInfo['reservedStock'] as int;
    final availableStock = inventoryInfo['availableStock'] as int;
    final isAvailable = inventoryInfo['available'] as bool;

    // 3. 추가 재고 분석
    final stockLevel = _calculateStockLevel(currentStock, params.productType);
    final recommendations = _generateRecommendations(params, currentStock, availableStock);
    final estimatedRestockDate = _estimateRestockDate(params.productType, currentStock);
    final alternativeOptions = await _getAlternativeOptions(params);

    return InventoryCheckResult(
      productType: params.productType,
      requestedQuantity: params.quantity,
      currentStock: currentStock,
      reservedStock: reservedStock,
      availableStock: availableStock,
      isAvailable: isAvailable,
      stockLevel: stockLevel,
      recommendations: recommendations,
      estimatedRestockDate: estimatedRestockDate,
      alternativeOptions: alternativeOptions,
      lastUpdated: DateTime.now(),
    );
  }

  /// 여러 제품 타입의 재고를 동시에 확인
  /// 
  /// Returns: 각 제품 타입별 재고 정보
  Future<Map<ProductType, InventoryCheckResult>> checkMultipleProducts(
    List<CheckInventoryParams> paramsList,
  ) async {
    final results = <ProductType, InventoryCheckResult>{};

    for (final params in paramsList) {
      try {
        final result = await execute(params);
        results[params.productType] = result;
      } catch (e) {
        // 개별 제품의 재고 확인 실패 시 빈 결과로 처리
        results[params.productType] = InventoryCheckResult.unavailable(
          productType: params.productType,
          requestedQuantity: params.quantity,
        );
      }
    }

    return results;
  }

  /// 입력 매개변수 유효성 검증
  ValidationResult _validateCheckInventoryParams(CheckInventoryParams params) {
    final errors = <String, String>{};

    // 수량 검증
    if (params.quantity <= 0) {
      errors['quantity'] = '수량은 1개 이상이어야 합니다';
    }
    if (params.quantity > 1000) {
      errors['quantity'] = '수량은 1000개를 초과할 수 없습니다';
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// 재고 수준 계산
  StockLevel _calculateStockLevel(int currentStock, ProductType productType) {
    // 제품 타입별 기준 재고량
    final baseStockThreshold = productType == ProductType.box ? 100 : 200;
    
    if (currentStock <= 0) {
      return StockLevel.outOfStock;
    } else if (currentStock <= baseStockThreshold * 0.1) {
      return StockLevel.critical;
    } else if (currentStock <= baseStockThreshold * 0.3) {
      return StockLevel.low;
    } else if (currentStock <= baseStockThreshold * 0.7) {
      return StockLevel.medium;
    } else {
      return StockLevel.high;
    }
  }

  /// 추천 사항 생성
  List<String> _generateRecommendations(
    CheckInventoryParams params,
    int currentStock,
    int availableStock,
  ) {
    final recommendations = <String>[];

    if (availableStock < params.quantity) {
      recommendations.add('요청 수량이 재고를 초과합니다. 현재 주문 가능: ${availableStock}개');
      
      if (availableStock > 0) {
        recommendations.add('${availableStock}개로 주문 수량을 조정하시겠습니까?');
      }
    } else if (availableStock < params.quantity * 2) {
      recommendations.add('재고가 부족할 수 있습니다. 미리 주문하시는 것을 권장합니다.');
    }

    // 제품 타입별 추천
    if (params.productType == ProductType.box) {
      if (params.quantity >= 50) {
        recommendations.add('대량 주문입니다. 벌크 제품도 고려해보세요.');
      }
    } else if (params.productType == ProductType.bulk) {
      if (params.quantity <= 10) {
        recommendations.add('소량 주문입니다. 박스 제품이 더 효율적일 수 있습니다.');
      }
    }

    return recommendations;
  }

  /// 재입고 예상 날짜 계산
  DateTime? _estimateRestockDate(ProductType productType, int currentStock) {
    // 재고가 충분한 경우 재입고 날짜 불필요
    final baseStockThreshold = productType == ProductType.box ? 100 : 200;
    if (currentStock > baseStockThreshold * 0.5) {
      return null;
    }

    // 제품 타입별 재입고 주기 (실제로는 데이터베이스에서 조회해야 함)
    final restockInterval = productType == ProductType.box ? 7 : 14; // 박스: 1주일, 벌크: 2주일
    
    return DateTime.now().add(Duration(days: restockInterval));
  }

  /// 대안 옵션 조회
  Future<List<AlternativeOption>> _getAlternativeOptions(
    CheckInventoryParams params,
  ) async {
    final alternatives = <AlternativeOption>[];

    try {
      // 다른 제품 타입의 재고 확인
      final alternativeProductType = params.productType == ProductType.box 
          ? ProductType.bulk 
          : ProductType.box;

      final alternativeInventory = await _repository.checkInventory(
        productType: alternativeProductType,
        quantity: params.quantity,
      );

      if (alternativeInventory['available'] as bool) {
        final alternativePriceInfo = await _repository.getUserUnitPrice(
          productType: alternativeProductType,
        );

        alternatives.add(AlternativeOption(
          productType: alternativeProductType,
          availableQuantity: alternativeInventory['availableStock'] as int,
          unitPrice: alternativePriceInfo['unitPrice'] as double,
          description: '${alternativeProductType.name} 제품으로 대체',
        ));
      }

      // 분할 배송 옵션
      final currentAvailable = await _repository.checkInventory(
        productType: params.productType,
        quantity: 1, // 최소 수량으로 확인
      );

      final availableNow = currentAvailable['availableStock'] as int;
      if (availableNow > 0 && availableNow < params.quantity) {
        alternatives.add(AlternativeOption(
          productType: params.productType,
          availableQuantity: availableNow,
          unitPrice: 0, // 동일 제품이므로 가격 변동 없음
          description: '분할 배송: 현재 ${availableNow}개, 나머지는 재입고 후 배송',
        ));
      }
    } catch (e) {
      // 대안 옵션 조회 실패 시 빈 목록 반환
    }

    return alternatives;
  }
}

/// 재고 확인 매개변수
class CheckInventoryParams {
  final ProductType productType;
  final int quantity;

  const CheckInventoryParams({
    required this.productType,
    required this.quantity,
  });

  @override
  String toString() {
    return 'CheckInventoryParams(productType: $productType, quantity: $quantity)';
  }
}

/// 재고 수준
enum StockLevel {
  outOfStock,
  critical,
  low,
  medium,
  high,
}

extension StockLevelExtension on StockLevel {
  String get displayName {
    switch (this) {
      case StockLevel.outOfStock:
        return '품절';
      case StockLevel.critical:
        return '위험';
      case StockLevel.low:
        return '부족';
      case StockLevel.medium:
        return '보통';
      case StockLevel.high:
        return '충분';
    }
  }

  String get description {
    switch (this) {
      case StockLevel.outOfStock:
        return '재고가 없습니다';
      case StockLevel.critical:
        return '재고가 매우 부족합니다';
      case StockLevel.low:
        return '재고가 부족합니다';
      case StockLevel.medium:
        return '재고가 보통입니다';
      case StockLevel.high:
        return '재고가 충분합니다';
    }
  }
}

/// 대안 옵션
class AlternativeOption {
  final ProductType productType;
  final int availableQuantity;
  final double unitPrice;
  final String description;

  const AlternativeOption({
    required this.productType,
    required this.availableQuantity,
    required this.unitPrice,
    required this.description,
  });

  @override
  String toString() {
    return 'AlternativeOption(productType: $productType, availableQuantity: $availableQuantity, description: $description)';
  }
}

/// 재고 확인 결과
class InventoryCheckResult {
  final ProductType productType;
  final int requestedQuantity;
  final int currentStock;
  final int reservedStock;
  final int availableStock;
  final bool isAvailable;
  final StockLevel stockLevel;
  final List<String> recommendations;
  final DateTime? estimatedRestockDate;
  final List<AlternativeOption> alternativeOptions;
  final DateTime lastUpdated;

  const InventoryCheckResult({
    required this.productType,
    required this.requestedQuantity,
    required this.currentStock,
    required this.reservedStock,
    required this.availableStock,
    required this.isAvailable,
    required this.stockLevel,
    required this.recommendations,
    this.estimatedRestockDate,
    required this.alternativeOptions,
    required this.lastUpdated,
  });

  /// 재고 부족 시 사용할 팩토리 생성자
  factory InventoryCheckResult.unavailable({
    required ProductType productType,
    required int requestedQuantity,
  }) {
    return InventoryCheckResult(
      productType: productType,
      requestedQuantity: requestedQuantity,
      currentStock: 0,
      reservedStock: 0,
      availableStock: 0,
      isAvailable: false,
      stockLevel: StockLevel.outOfStock,
      recommendations: ['재고 정보를 확인할 수 없습니다.'],
      alternativeOptions: [],
      lastUpdated: DateTime.now(),
    );
  }

  /// 부분 주문 가능 여부
  bool get canPartialOrder => availableStock > 0 && availableStock < requestedQuantity;

  /// 재고 충족률 (0.0 ~ 1.0)
  double get fulfillmentRate {
    if (requestedQuantity <= 0) return 0.0;
    return (availableStock / requestedQuantity).clamp(0.0, 1.0);
  }

  /// 부족한 수량
  int get shortfallQuantity {
    return requestedQuantity > availableStock ? requestedQuantity - availableStock : 0;
  }

  @override
  String toString() {
    return 'InventoryCheckResult('
        'productType: $productType, '
        'requestedQuantity: $requestedQuantity, '
        'availableStock: $availableStock, '
        'isAvailable: $isAvailable, '
        'stockLevel: $stockLevel)';
  }
}