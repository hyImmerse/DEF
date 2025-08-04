import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/order_model.dart';
import '../../domain/providers/order_domain_provider.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

part 'order_notifier.freezed.dart';

/// 주문 상태
@freezed
class OrderState with _$OrderState {
  const factory OrderState({
    @Default([]) List<OrderModel> orders,
    @Default(false) bool isLoading,
    @Default(false) bool isCreating,
    Failure? error,
    OrderModel? selectedOrder,
  }) = _OrderState;
}

/// 주문 Notifier
class OrderNotifier extends StateNotifier<OrderState> {
  final Ref ref;
  
  OrderNotifier(this.ref) : super(const OrderState());
  
  /// 주문 목록 조회
  Future<void> getOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final getOrdersUseCase = ref.read(getOrdersUseCaseProvider);
      final result = await getOrdersUseCase.execute(
        GetOrdersParams(
          limit: 20,
          offset: 0,
        ),
      );
      
      state = state.copyWith(
        isLoading: false,
        orders: result.orders.map((e) => OrderModelX.fromEntity(e)).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ServerFailure(message: '주문 목록을 불러오는데 실패했습니다'),
      );
    }
  }
  
  /// 주문 생성
  Future<void> createOrder({
    required ProductType productType,
    required int quantity,
    int? emptyTankReturn,
    required DateTime deliveryDate,
    String? deliveryAddress,
    String? note,
  }) async {
    state = state.copyWith(isCreating: true, error: null);
    
    try {
      final createOrderUseCase = ref.read(createOrderUseCaseProvider);
      final result = await createOrderUseCase.execute(
        CreateOrderParams(
          productType: productType,
          quantity: quantity,
          returnTankQuantity: emptyTankReturn,
          deliveryDate: deliveryDate,
          deliveryMethod: DeliveryMethod.delivery,
          deliveryAddressId: null, // TODO: 주소 ID 처리
          deliveryMemo: note,
          unitPrice: 0, // TODO: 가격 계산 로직 추가
        ),
      );
      
      state = state.copyWith(
        isCreating: false,
        orders: [OrderModelX.fromEntity(result), ...state.orders],
      );
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: ServerFailure(message: '주문 생성에 실패했습니다'),
      );
    }
  }
  
  /// 주문 상세 선택
  void selectOrder(OrderModel order) {
    state = state.copyWith(selectedOrder: order);
  }
  
  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// 주문 Provider
final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(ref);
});

/// OrderModel 확장
extension OrderModelX on OrderModel {
  static OrderModel fromEntity(dynamic entity) {
    return OrderModel(
      id: entity.id,
      orderNumber: entity.orderNumber,
      userId: entity.userId,
      status: entity.status,
      productType: entity.productType,
      quantity: entity.quantity,
      javaraQuantity: entity.javaraQuantity,
      returnTankQuantity: entity.returnTankQuantity,
      deliveryDate: entity.deliveryDate,
      deliveryMethod: entity.deliveryMethod,
      deliveryAddressId: entity.deliveryAddressId,
      deliveryMemo: entity.deliveryMemo,
      unitPrice: entity.unitPrice,
      totalPrice: entity.totalPrice,
      confirmedAt: entity.confirmedAt,
      confirmedBy: entity.confirmedBy,
      shippedAt: entity.shippedAt,
      completedAt: entity.completedAt,
      cancelledAt: entity.cancelledAt,
      cancelledReason: entity.cancelledReason,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}