import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String email,
    required String businessNumber,
    required String companyName,
    required String grade, // 'dealer' or 'general'
    required String status, // 'pending', 'approved', 'rejected', 'inactive'
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool isDemo,
    String? phoneNumber,
    String? address,
    String? addressDetail,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}