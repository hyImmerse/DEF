import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/order_model.dart';

part 'order_entity.freezed.dart';
part 'order_entity.g.dart';

/// 주문 도메인 엔티티
/// 
/// 비즈니스 로직에서 사용되는 주문 객체입니다.
/// 데이터 모델과는 독립적으로 도메인 규칙을 표현합니다.
@freezed
class OrderEntity with _$OrderEntity {
  const factory OrderEntity({
    required String id,
    required String orderNumber,
    required String userId,
    required OrderStatus status,
    required ProductType productType,
    required int quantity,
    int? javaraQuantity,
    int? returnTankQuantity,
    required DateTime deliveryDate,
    required DeliveryMethod deliveryMethod,
    String? deliveryAddressId,
    String? deliveryMemo,
    required double unitPrice,
    required double totalPrice,
    String? cancelledReason,
    DateTime? confirmedAt,
    String? confirmedBy,
    DateTime? shippedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    
    // 관계 데이터
    UserProfile? userProfile,
    DeliveryAddress? deliveryAddress,
  }) = _OrderEntity;
  
  const OrderEntity._();
  
  /// 모델에서 엔티티로 변환
  factory OrderEntity.fromModel(OrderModel model) {
    return OrderEntity(
      id: model.id,
      orderNumber: model.orderNumber,
      userId: model.userId,
      status: model.status,
      productType: model.productType,
      quantity: model.quantity,
      javaraQuantity: model.javaraQuantity,
      returnTankQuantity: model.returnTankQuantity,
      deliveryDate: model.deliveryDate,
      deliveryMethod: model.deliveryMethod,
      deliveryAddressId: model.deliveryAddressId,
      deliveryMemo: model.deliveryMemo,
      unitPrice: model.unitPrice,
      totalPrice: model.totalPrice,
      cancelledReason: model.cancelledReason,
      confirmedAt: model.confirmedAt,
      confirmedBy: model.confirmedBy,
      shippedAt: model.shippedAt,
      completedAt: model.completedAt,
      cancelledAt: model.cancelledAt,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      userProfile: model.profile != null 
          ? UserProfile.fromJson(model.profile!.toJson())
          : null,
      deliveryAddress: model.deliveryAddress != null
          ? DeliveryAddress.fromJson(model.deliveryAddress!.toJson())
          : null,
    );
  }
  
  /// 비즈니스 규칙: 주문 수정 가능 여부
  bool get canEdit => status == OrderStatus.pending || status == OrderStatus.draft;
  
  /// 비즈니스 규칙: 주문 취소 가능 여부
  bool get canCancel => status == OrderStatus.pending || status == OrderStatus.confirmed;
  
  /// 비즈니스 규칙: 주문 확정 가능 여부
  bool get canConfirm => status == OrderStatus.pending;
  
  /// 비즈니스 규칙: 배송 완료 가능 여부
  bool get canComplete => status == OrderStatus.shipped;
  
  /// 비즈니스 규칙: 배송 시작 가능 여부
  bool get canShip => status == OrderStatus.confirmed;
  
  /// 배송일까지 남은 일수
  int get daysUntilDelivery {
    final now = DateTime.now();
    final difference = deliveryDate.difference(now);
    return difference.inDays;
  }
  
  /// 긴급 배송 여부 (3일 이내)
  bool get isUrgent => daysUntilDelivery <= 3 && daysUntilDelivery >= 0;
  
  /// 배송일 경과 여부
  bool get isOverdue => daysUntilDelivery < 0 && status != OrderStatus.completed;
  
  /// 상태별 진행률 (0.0 ~ 1.0)
  double get progressRate {
    switch (status) {
      case OrderStatus.draft:
        return 0.0;
      case OrderStatus.pending:
        return 0.25;
      case OrderStatus.confirmed:
        return 0.5;
      case OrderStatus.shipped:
        return 0.75;
      case OrderStatus.completed:
        return 1.0;
      case OrderStatus.cancelled:
        return 0.0;
    }
  }
  
  /// 예상 배송비 계산
  double calculateEstimatedShippingCost() {
    // 비즈니스 규칙에 따른 배송비 계산
    if (deliveryMethod == DeliveryMethod.directPickup) {
      return 0;
    }
    
    // 기본 배송비
    double baseCost = 50000;
    
    // 수량에 따른 추가 비용
    if (quantity > 10) {
      baseCost += (quantity - 10) * 5000;
    }
    
    // 긴급 배송 추가 비용
    if (isUrgent) {
      baseCost *= 1.5;
    }
    
    return baseCost;
  }
  
  /// 주문 검증
  ValidationResult validate() {
    final errors = <String, String>{};
    
    // 수량 검증
    if (quantity <= 0) {
      errors['quantity'] = '수량은 1개 이상이어야 합니다';
    }
    
    if (quantity > 1000) {
      errors['quantity'] = '수량은 1000개를 초과할 수 없습니다';
    }
    
    // 자바라 수량 검증
    if (javaraQuantity != null && javaraQuantity! < 0) {
      errors['javaraQuantity'] = '자바라 수량은 0개 이상이어야 합니다';
    }
    
    // 반환 탱크 수량 검증
    if (returnTankQuantity != null && returnTankQuantity! < 0) {
      errors['returnTankQuantity'] = '반환 탱크 수량은 0개 이상이어야 합니다';
    }
    
    // 배송일 검증
    final now = DateTime.now();
    final minDeliveryDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    if (deliveryDate.isBefore(minDeliveryDate)) {
      errors['deliveryDate'] = '배송일은 최소 1일 이후로 설정해야 합니다';
    }
    
    // 배송 방법별 검증
    if (deliveryMethod == DeliveryMethod.delivery && deliveryAddressId == null) {
      errors['deliveryAddress'] = '배송 주소를 선택해주세요';
    }
    
    // 가격 검증
    if (unitPrice <= 0) {
      errors['unitPrice'] = '단가가 설정되지 않았습니다';
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

/// 사용자 프로필 정보
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String businessNumber,
    required String businessName,
    required String representativeName,
    required String phone,
    String? email,
    required String grade,
    required String status,
  }) = _UserProfile;
  
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    businessNumber: json['business_number'] as String,
    businessName: json['business_name'] as String,
    representativeName: json['representative_name'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String?,
    grade: json['grade'] as String,
    status: json['status'] as String,
  );
}

/// 배송 주소 정보
@freezed
class DeliveryAddress with _$DeliveryAddress {
  const factory DeliveryAddress({
    required String id,
    required String name,
    required String address,
    String? addressDetail,
    required String postalCode,
    required String phone,
  }) = _DeliveryAddress;
  
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
    id: json['id'] as String,
    name: json['name'] as String,
    address: json['address'] as String,
    addressDetail: json['address_detail'] as String?,
    postalCode: json['postal_code'] as String,
    phone: json['phone'] as String,
  );
}

/// 검증 결과
@freezed
class ValidationResult with _$ValidationResult {
  const factory ValidationResult({
    required bool isValid,
    required Map<String, String> errors,
  }) = _ValidationResult;
  
  const ValidationResult._();
  
  String? getError(String field) => errors[field];
  
  bool hasError(String field) => errors.containsKey(field);
  
  String get errorMessage {
    if (errors.isEmpty) return '';
    return errors.values.join('\n');
  }
}