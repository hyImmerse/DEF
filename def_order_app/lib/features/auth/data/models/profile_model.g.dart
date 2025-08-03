// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      id: json['id'] as String,
      businessNumber: json['business_number'] as String,
      businessName: json['business_name'] as String,
      representativeName: json['representative_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      grade: $enumDecode(_$UserGradeEnumMap, json['grade']),
      status: $enumDecode(_$UserStatusEnumMap, json['status']),
      unitPriceBox: (json['unit_price_box'] as num?)?.toDouble(),
      unitPriceBulk: (json['unit_price_bulk'] as num?)?.toDouble(),
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      approvedBy: json['approved_by'] as String?,
      rejectedReason: json['rejected_reason'] as String?,
      lastOrderAt: json['last_order_at'] == null
          ? null
          : DateTime.parse(json['last_order_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_number': instance.businessNumber,
      'business_name': instance.businessName,
      'representative_name': instance.representativeName,
      'phone': instance.phone,
      'email': instance.email,
      'grade': _$UserGradeEnumMap[instance.grade]!,
      'status': _$UserStatusEnumMap[instance.status]!,
      'unit_price_box': instance.unitPriceBox,
      'unit_price_bulk': instance.unitPriceBulk,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'approved_by': instance.approvedBy,
      'rejected_reason': instance.rejectedReason,
      'last_order_at': instance.lastOrderAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$UserGradeEnumMap = {
  UserGrade.dealer: 'dealer',
  UserGrade.general: 'general',
};

const _$UserStatusEnumMap = {
  UserStatus.pending: 'pending',
  UserStatus.approved: 'approved',
  UserStatus.rejected: 'rejected',
  UserStatus.inactive: 'inactive',
};
