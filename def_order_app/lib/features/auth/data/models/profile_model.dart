import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    @JsonKey(name: 'business_number') required String businessNumber,
    @JsonKey(name: 'business_name') required String businessName,
    @JsonKey(name: 'representative_name') required String representativeName,
    required String phone,
    required String email,
    required UserGrade grade,
    required UserStatus status,
    @JsonKey(name: 'unit_price_box') double? unitPriceBox,
    @JsonKey(name: 'unit_price_bulk') double? unitPriceBulk,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
    @JsonKey(name: 'approved_by') String? approvedBy,
    @JsonKey(name: 'rejected_reason') String? rejectedReason,
    @JsonKey(name: 'last_order_at') DateTime? lastOrderAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

enum UserGrade {
  @JsonValue('dealer')
  dealer,
  @JsonValue('general')
  general,
}

enum UserStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('inactive')
  inactive,
}