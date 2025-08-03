// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      userId: json['user_id'] as String,
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      productType: $enumDecode(_$ProductTypeEnumMap, json['product_type']),
      quantity: (json['quantity'] as num).toInt(),
      javaraQuantity: (json['javara_quantity'] as num?)?.toInt(),
      returnTankQuantity: (json['return_tank_quantity'] as num?)?.toInt(),
      deliveryDate: DateTime.parse(json['delivery_date'] as String),
      deliveryMethod: $enumDecode(
        _$DeliveryMethodEnumMap,
        json['delivery_method'],
      ),
      deliveryAddressId: json['delivery_address_id'] as String?,
      deliveryMemo: json['delivery_memo'] as String?,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
      confirmedBy: json['confirmed_by'] as String?,
      shippedAt: json['shipped_at'] == null
          ? null
          : DateTime.parse(json['shipped_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
      cancelledReason: json['cancelled_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'user_id': instance.userId,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'product_type': _$ProductTypeEnumMap[instance.productType]!,
      'quantity': instance.quantity,
      'javara_quantity': instance.javaraQuantity,
      'return_tank_quantity': instance.returnTankQuantity,
      'delivery_date': instance.deliveryDate.toIso8601String(),
      'delivery_method': _$DeliveryMethodEnumMap[instance.deliveryMethod]!,
      'delivery_address_id': instance.deliveryAddressId,
      'delivery_memo': instance.deliveryMemo,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'confirmed_by': instance.confirmedBy,
      'shipped_at': instance.shippedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'cancelled_reason': instance.cancelledReason,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.draft: 'draft',
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.shipped: 'shipped',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};

const _$ProductTypeEnumMap = {ProductType.box: 'box', ProductType.bulk: 'bulk'};

const _$DeliveryMethodEnumMap = {
  DeliveryMethod.directPickup: 'direct_pickup',
  DeliveryMethod.delivery: 'delivery',
};

_$DeliveryAddressModelImpl _$$DeliveryAddressModelImplFromJson(
  Map<String, dynamic> json,
) => _$DeliveryAddressModelImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  addressDetail: json['address_detail'] as String?,
  postalCode: json['postal_code'] as String?,
  phone: json['phone'] as String?,
  isDefault: json['is_default'] as bool?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$DeliveryAddressModelImplToJson(
  _$DeliveryAddressModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'name': instance.name,
  'address': instance.address,
  'address_detail': instance.addressDetail,
  'postal_code': instance.postalCode,
  'phone': instance.phone,
  'is_default': instance.isDefault,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
