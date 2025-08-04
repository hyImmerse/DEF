// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserImpl _$$AuthUserImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      businessNumber: json['businessNumber'] as String,
      companyName: json['companyName'] as String,
      grade: json['grade'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isDemo: json['isDemo'] as bool? ?? false,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      addressDetail: json['addressDetail'] as String?,
    );

Map<String, dynamic> _$$AuthUserImplToJson(_$AuthUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'businessNumber': instance.businessNumber,
      'companyName': instance.companyName,
      'grade': instance.grade,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isDemo': instance.isDemo,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'addressDetail': instance.addressDetail,
    };