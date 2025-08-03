import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../../data/models/order_model.dart';
import '../repositories/order_repository.dart';

/// 가격 계산 파라미터
class CalculatePriceParams {
  final ProductType productType;
  final int quantity;
  final bool isUrgent;
  final bool isWeekendDelivery;
  final DateTime? deliveryDate;

  const CalculatePriceParams({
    required this.productType,
    required this.quantity,
    this.isUrgent = false,
    this.isWeekendDelivery = false,
    this.deliveryDate,
  });
}

/// 주문 가격 계산 UseCase
class CalculateOrderPriceUseCase implements UseCase<double, CalculatePriceParams> {
  final OrderRepository repository;

  CalculateOrderPriceUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(CalculatePriceParams params) async {
    try {
      // 사용자 등급별 단가 조회
      final priceInfo = await repository.getUserUnitPrice(
        productType: params.productType,
      );
      
      final unitPrice = priceInfo['unitPrice'] as double;
      
      // 기본 가격 계산
      double totalPrice = unitPrice * params.quantity;
      
      // 긴급배송 수수료 (10%)
      if (params.isUrgent) {
        totalPrice *= 1.1;
      }
      
      // 주말배송 수수료 (5%)
      if (params.isWeekendDelivery) {
        totalPrice *= 1.05;
      }
      
      // 대량주문 할인 (100개 이상 5%, 500개 이상 10%)
      if (params.quantity >= 500) {
        totalPrice *= 0.9;
      } else if (params.quantity >= 100) {
        totalPrice *= 0.95;
      }
      
      return Right(totalPrice);
    } catch (e) {
      return Left(ServerFailure('가격 계산 중 오류가 발생했습니다'));
    }
  }
}