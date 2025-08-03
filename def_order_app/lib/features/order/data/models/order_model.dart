import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/data/models/profile_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    @JsonKey(name: 'order_number') required String orderNumber,
    @JsonKey(name: 'user_id') required String userId,
    required OrderStatus status,
    @JsonKey(name: 'product_type') required ProductType productType,
    required int quantity,
    @JsonKey(name: 'javara_quantity') int? javaraQuantity,
    @JsonKey(name: 'return_tank_quantity') int? returnTankQuantity,
    @JsonKey(name: 'delivery_date') required DateTime deliveryDate,
    @JsonKey(name: 'delivery_method') required DeliveryMethod deliveryMethod,
    @JsonKey(name: 'delivery_address_id') String? deliveryAddressId,
    @JsonKey(name: 'delivery_memo') String? deliveryMemo,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'confirmed_by') String? confirmedBy,
    @JsonKey(name: 'shipped_at') DateTime? shippedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'cancelled_reason') String? cancelledReason,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Relations (JSON에서 제외)
    @JsonKey(includeFromJson: false, includeToJson: false)
    ProfileModel? profile,
    @JsonKey(includeFromJson: false, includeToJson: false)
    DeliveryAddressModel? deliveryAddress,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

enum OrderStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('shipped')
  shipped,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum ProductType {
  @JsonValue('box')
  box,
  @JsonValue('bulk')
  bulk,
}

enum DeliveryMethod {
  @JsonValue('direct_pickup')
  directPickup,
  @JsonValue('delivery')
  delivery,
}

@freezed
class DeliveryAddressModel with _$DeliveryAddressModel {
  const factory DeliveryAddressModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    required String address,
    @JsonKey(name: 'address_detail') String? addressDetail,
    @JsonKey(name: 'postal_code') String? postalCode,
    String? phone,
    @JsonKey(name: 'is_default') bool? isDefault,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _DeliveryAddressModel;

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressModelFromJson(json);
}