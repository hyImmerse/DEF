import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/update_order_usecase.dart';
import '../../domain/usecases/calculate_price_usecase.dart';
import '../../domain/usecases/check_inventory_usecase.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/models/order_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import 'order_list_provider.dart';

part 'order_form_provider.g.dart';

// UseCase Providers
@riverpod
CreateOrderUseCase createOrderUseCase(CreateOrderUseCaseRef ref) {
  return CreateOrderUseCase(ref.watch(orderRepositoryProvider));
}

@riverpod
UpdateOrderUseCase updateOrderUseCase(UpdateOrderUseCaseRef ref) {
  return UpdateOrderUseCase(ref.watch(orderRepositoryProvider));
}

@riverpod
CalculatePriceUseCase calculatePriceUseCase(CalculatePriceUseCaseRef ref) {
  return CalculatePriceUseCase(ref.watch(orderRepositoryProvider));
}

@riverpod
CheckInventoryUseCase checkInventoryUseCase(CheckInventoryUseCaseRef ref) {
  return CheckInventoryUseCase(ref.watch(orderRepositoryProvider));
}

/// 주문 폼 상태
/// 
/// 주문 생성/수정 폼의 모든 상태를 관리합니다.
/// 폼 데이터, 유효성 검사, 가격 계산, 재고 확인 등을 포함합니다.
class OrderFormState {
  // 기본 정보
  final ProductType productType;
  final int quantity;
  final int? javaraQuantity;
  final int? returnTankQuantity;
  final DateTime deliveryDate;
  final DeliveryMethod deliveryMethod;
  final String? deliveryAddressId;
  final String? deliveryMemo;
  
  // 가격 정보
  final double unitPrice;
  final PriceCalculationResult? priceCalculation;
  
  // 재고 정보
  final InventoryCheckResult? inventoryCheck;
  
  // 상태 관리
  final bool isLoading;
  final bool isSaving;
  final bool isCalculatingPrice;
  final bool isCheckingInventory;
  final Failure? error;
  final ValidationResult? validationResult;
  
  // 수정 모드
  final bool isEditMode;
  final String? editingOrderId;
  final OrderEntity? originalOrder;

  const OrderFormState({
    this.productType = ProductType.box,
    this.quantity = 1,
    this.javaraQuantity,
    this.returnTankQuantity,
    required this.deliveryDate,
    this.deliveryMethod = DeliveryMethod.delivery,
    this.deliveryAddressId,
    this.deliveryMemo,
    this.unitPrice = 0.0,
    this.priceCalculation,
    this.inventoryCheck,
    this.isLoading = false,
    this.isSaving = false,
    this.isCalculatingPrice = false,
    this.isCheckingInventory = false,
    this.error,
    this.validationResult,
    this.isEditMode = false,
    this.editingOrderId,
    this.originalOrder,
  });

  OrderFormState copyWith({
    ProductType? productType,
    int? quantity,
    int? javaraQuantity,
    int? returnTankQuantity,
    DateTime? deliveryDate,
    DeliveryMethod? deliveryMethod,
    String? deliveryAddressId,
    String? deliveryMemo,
    double? unitPrice,
    PriceCalculationResult? priceCalculation,
    InventoryCheckResult? inventoryCheck,
    bool? isLoading,
    bool? isSaving,
    bool? isCalculatingPrice,
    bool? isCheckingInventory,
    Failure? error,
    ValidationResult? validationResult,
    bool? isEditMode,
    String? editingOrderId,
    OrderEntity? originalOrder,
    bool clearError = false,
    bool clearValidation = false,
  }) {
    return OrderFormState(
      productType: productType ?? this.productType,
      quantity: quantity ?? this.quantity,
      javaraQuantity: javaraQuantity ?? this.javaraQuantity,
      returnTankQuantity: returnTankQuantity ?? this.returnTankQuantity,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      deliveryAddressId: deliveryAddressId ?? this.deliveryAddressId,
      deliveryMemo: deliveryMemo ?? this.deliveryMemo,
      unitPrice: unitPrice ?? this.unitPrice,
      priceCalculation: priceCalculation ?? this.priceCalculation,
      inventoryCheck: inventoryCheck ?? this.inventoryCheck,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isCalculatingPrice: isCalculatingPrice ?? this.isCalculatingPrice,
      isCheckingInventory: isCheckingInventory ?? this.isCheckingInventory,
      error: clearError ? null : (error ?? this.error),
      validationResult: clearValidation ? null : (validationResult ?? this.validationResult),
      isEditMode: isEditMode ?? this.isEditMode,
      editingOrderId: editingOrderId ?? this.editingOrderId,
      originalOrder: originalOrder ?? this.originalOrder,
    );
  }

  /// 폼이 유효한지 확인
  bool get isValid {
    return validationResult?.isValid ?? true;
  }

  /// 저장 가능한지 확인
  bool get canSave {
    return isValid && 
           !isLoading && 
           !isSaving && 
           unitPrice > 0 &&
           (inventoryCheck?.isAvailable ?? false);
  }

  /// 총 금액
  double get totalPrice => unitPrice * quantity;

  /// 변경사항이 있는지 확인 (수정 모드에서)
  bool get hasChanges {
    if (!isEditMode || originalOrder == null) return true;
    
    return productType != originalOrder!.productType ||
           quantity != originalOrder!.quantity ||
           javaraQuantity != originalOrder!.javaraQuantity ||
           returnTankQuantity != originalOrder!.returnTankQuantity ||
           deliveryDate != originalOrder!.deliveryDate ||
           deliveryMethod != originalOrder!.deliveryMethod ||
           deliveryAddressId != originalOrder!.deliveryAddressId ||
           deliveryMemo != originalOrder!.deliveryMemo ||
           unitPrice != originalOrder!.unitPrice;
  }
}

/// 주문 폼 노티파이어
/// 
/// 주문 생성/수정 폼의 상태를 관리하고 비즈니스 로직을 처리합니다.
/// UseCase를 통해 도메인 로직을 실행하고 실시간 유효성 검사를 제공합니다.
@riverpod
class OrderForm extends _$OrderForm {
  late final CreateOrderUseCase _createOrderUseCase;
  late final UpdateOrderUseCase _updateOrderUseCase;
  late final CalculatePriceUseCase _calculatePriceUseCase;
  late final CheckInventoryUseCase _checkInventoryUseCase;

  @override
  OrderFormState build() {
    _createOrderUseCase = ref.watch(createOrderUseCaseProvider);
    _updateOrderUseCase = ref.watch(updateOrderUseCaseProvider);
    _calculatePriceUseCase = ref.watch(calculatePriceUseCaseProvider);
    _checkInventoryUseCase = ref.watch(checkInventoryUseCaseProvider);
    
    // 기본 배송일을 내일로 설정
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    
    return OrderFormState(
      deliveryDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
    );
  }

  /// 수정 모드로 초기화
  /// 
  /// 기존 주문 정보로 폼을 초기화합니다.
  Future<void> initializeForEdit(OrderEntity order) async {
    state = OrderFormState(
      productType: order.productType,
      quantity: order.quantity,
      javaraQuantity: order.javaraQuantity,
      returnTankQuantity: order.returnTankQuantity,
      deliveryDate: order.deliveryDate,
      deliveryMethod: order.deliveryMethod,
      deliveryAddressId: order.deliveryAddressId,
      deliveryMemo: order.deliveryMemo,
      unitPrice: order.unitPrice,
      isEditMode: true,
      editingOrderId: order.id,
      originalOrder: order,
    );

    // 초기 가격 계산 및 재고 확인
    await _calculatePriceAndCheckInventory();
  }

  /// 제품 타입 변경
  Future<void> setProductType(ProductType productType) async {
    if (state.productType == productType) return;

    state = state.copyWith(
      productType: productType,
      clearError: true,
    );

    await _calculatePriceAndCheckInventory();
  }

  /// 수량 변경
  Future<void> setQuantity(int quantity) async {
    if (state.quantity == quantity) return;

    state = state.copyWith(
      quantity: quantity,
      clearError: true,
    );

    await _calculatePriceAndCheckInventory();
  }

  /// 자바라 수량 변경
  void setJavaraQuantity(int? quantity) {
    state = state.copyWith(
      javaraQuantity: quantity,
      clearError: true,
    );
  }

  /// 반납통 수량 변경
  void setReturnTankQuantity(int? quantity) {
    state = state.copyWith(
      returnTankQuantity: quantity,
      clearError: true,
    );
  }

  /// 배송일 변경
  Future<void> setDeliveryDate(DateTime date) async {
    if (state.deliveryDate == date) return;

    state = state.copyWith(
      deliveryDate: date,
      clearError: true,
    );

    await _calculatePriceAndCheckInventory();
  }

  /// 배송 방법 변경
  Future<void> setDeliveryMethod(DeliveryMethod method) async {
    if (state.deliveryMethod == method) return;

    state = state.copyWith(
      deliveryMethod: method,
      deliveryAddressId: method == DeliveryMethod.directPickup ? null : state.deliveryAddressId,
      clearError: true,
    );

    await _calculatePriceAndCheckInventory();
  }

  /// 배송 주소 변경
  void setDeliveryAddressId(String? addressId) {
    state = state.copyWith(
      deliveryAddressId: addressId,
      clearError: true,
    );
  }

  /// 배송 메모 변경
  void setDeliveryMemo(String? memo) {
    state = state.copyWith(
      deliveryMemo: memo,
      clearError: true,
    );
  }

  /// 가격 계산 및 재고 확인
  /// 
  /// 현재 폼 데이터를 기반으로 가격을 계산하고 재고를 확인합니다.
  Future<void> _calculatePriceAndCheckInventory() async {
    // 필수 정보가 없으면 계산하지 않음
    if (state.quantity <= 0) return;

    // 가격 계산
    await _calculatePrice();
    
    // 재고 확인
    await _checkInventory();
  }

  /// 가격 계산
  Future<void> _calculatePrice() async {
    state = state.copyWith(isCalculatingPrice: true);

    try {
      final params = CalculatePriceParams(
        productType: state.productType,
        quantity: state.quantity,
        javaraQuantity: state.javaraQuantity,
        returnTankQuantity: state.returnTankQuantity,
        deliveryDate: state.deliveryDate,
        deliveryMethod: state.deliveryMethod,
      );

      final result = await _calculatePriceUseCase.execute(params);

      state = state.copyWith(
        unitPrice: result.unitPrice,
        priceCalculation: result,
        isCalculatingPrice: false,
      );
    } catch (e) {
      state = state.copyWith(
        isCalculatingPrice: false,
        error: _mapExceptionToFailure(e),
      );
    }
  }

  /// 재고 확인
  Future<void> _checkInventory() async {
    state = state.copyWith(isCheckingInventory: true);

    try {
      final params = CheckInventoryParams(
        productType: state.productType,
        quantity: state.quantity,
      );

      final result = await _checkInventoryUseCase.execute(params);

      state = state.copyWith(
        inventoryCheck: result,
        isCheckingInventory: false,
      );
    } catch (e) {
      state = state.copyWith(
        isCheckingInventory: false,
        error: _mapExceptionToFailure(e),
      );
    }
  }

  /// 폼 유효성 검사
  void validateForm() {
    final params = state.isEditMode
        ? UpdateOrderParams(
            orderId: state.editingOrderId!,
            productType: state.productType,
            quantity: state.quantity,
            javaraQuantity: state.javaraQuantity,
            returnTankQuantity: state.returnTankQuantity,
            deliveryDate: state.deliveryDate,
            deliveryMethod: state.deliveryMethod,
            deliveryAddressId: state.deliveryAddressId,
            deliveryMemo: state.deliveryMemo,
            unitPrice: state.unitPrice,
          )
        : CreateOrderParams(
            productType: state.productType,
            quantity: state.quantity,
            javaraQuantity: state.javaraQuantity,
            returnTankQuantity: state.returnTankQuantity,
            deliveryDate: state.deliveryDate,
            deliveryMethod: state.deliveryMethod,
            deliveryAddressId: state.deliveryAddressId,
            deliveryMemo: state.deliveryMemo,
            unitPrice: state.unitPrice,
          );

    final validationResult = _validateParams(params);
    
    state = state.copyWith(validationResult: validationResult);
  }

  /// 주문 생성
  Future<OrderEntity> createOrder() async {
    validateForm();
    
    if (!state.isValid) {
      throw ValidationException(
        message: state.validationResult!.errorMessage,
      );
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final params = CreateOrderParams(
        productType: state.productType,
        quantity: state.quantity,
        javaraQuantity: state.javaraQuantity,
        returnTankQuantity: state.returnTankQuantity,
        deliveryDate: state.deliveryDate,
        deliveryMethod: state.deliveryMethod,
        deliveryAddressId: state.deliveryAddressId,
        deliveryMemo: state.deliveryMemo,
        unitPrice: state.unitPrice,
      );

      final order = await _createOrderUseCase.execute(params);

      state = state.copyWith(isSaving: false);

      // 주문 목록 새로고침
      ref.invalidate(orderListProvider);

      return order;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }

  /// 주문 수정
  Future<OrderEntity> updateOrder() async {
    if (!state.isEditMode || state.editingOrderId == null) {
      throw ValidationException(message: '수정 모드가 아닙니다.');
    }

    validateForm();
    
    if (!state.isValid) {
      throw ValidationException(
        message: state.validationResult!.errorMessage,
      );
    }

    if (!state.hasChanges) {
      throw ValidationException(message: '변경사항이 없습니다.');
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final params = UpdateOrderParams(
        orderId: state.editingOrderId!,
        productType: state.productType,
        quantity: state.quantity,
        javaraQuantity: state.javaraQuantity,
        returnTankQuantity: state.returnTankQuantity,
        deliveryDate: state.deliveryDate,
        deliveryMethod: state.deliveryMethod,
        deliveryAddressId: state.deliveryAddressId,
        deliveryMemo: state.deliveryMemo,
        unitPrice: state.unitPrice,
      );

      final order = await _updateOrderUseCase.execute(params);

      state = state.copyWith(isSaving: false);

      // 주문 목록 새로고침
      ref.invalidate(orderListProvider);

      return order;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }

  /// 폼 초기화
  void reset() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    
    state = OrderFormState(
      deliveryDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
    );
  }

  /// 매개변수 유효성 검사
  ValidationResult _validateParams(dynamic params) {
    final errors = <String, String>{};

    if (params is CreateOrderParams) {
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
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// 예외를 Failure로 변환
  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is BusinessRuleException) {
      return BusinessRuleFailure(
        message: exception.message,
        code: exception.code,
      );
    } else {
      return UnknownFailure(
        message: exception.toString(),
      );
    }
  }
}