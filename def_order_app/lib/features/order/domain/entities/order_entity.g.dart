// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      businessNumber: json['businessNumber'] as String,
      businessName: json['businessName'] as String,
      representativeName: json['representativeName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      grade: json['grade'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessNumber': instance.businessNumber,
      'businessName': instance.businessName,
      'representativeName': instance.representativeName,
      'phone': instance.phone,
      'email': instance.email,
      'grade': instance.grade,
      'status': instance.status,
    };

_$DeliveryAddressImpl _$$DeliveryAddressImplFromJson(
  Map<String, dynamic> json,
) => _$DeliveryAddressImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  addressDetail: json['addressDetail'] as String?,
  postalCode: json['postalCode'] as String,
  phone: json['phone'] as String,
);

Map<String, dynamic> _$$DeliveryAddressImplToJson(
  _$DeliveryAddressImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'addressDetail': instance.addressDetail,
  'postalCode': instance.postalCode,
  'phone': instance.phone,
};
