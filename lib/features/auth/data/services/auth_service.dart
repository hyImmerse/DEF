import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/auth_user.dart';
import '../providers/demo_auth_provider.dart';

class AuthService {
  final SupabaseClient _supabase;
  final Ref _ref;

  AuthService(this._supabase, this._ref);

  // 현재 로그인된 사용자 가져오기
  AuthUser? get currentUser {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    // 데모 모드인 경우 데모 사용자 정보 반환
    final demoState = _ref.read(demoAuthProvider);
    if (demoState.isDemoMode && demoState.user != null) {
      return demoState.user;
    }

    // 실제 사용자 정보는 프로필에서 가져와야 함
    // TODO: 실제 구현 시 프로필 정보 조회
    return null;
  }

  // 로그인
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('로그인에 실패했습니다.');
    }

    // 프로필 정보 가져오기
    final profileData = await _supabase
        .from('profiles')
        .select()
        .eq('id', response.user!.id)
        .single();

    return AuthUser(
      id: response.user!.id,
      email: email,
      businessNumber: profileData['business_number'],
      companyName: profileData['company_name'],
      grade: profileData['grade'],
      status: profileData['status'],
      createdAt: DateTime.parse(profileData['created_at']),
      updatedAt: profileData['updated_at'] != null
          ? DateTime.parse(profileData['updated_at'])
          : null,
      isDemo: profileData['is_demo'] ?? false,
      phoneNumber: profileData['phone_number'],
      address: profileData['address'],
      addressDetail: profileData['address_detail'],
    );
  }

  // 회원가입
  Future<AuthUser> signUp({
    required String email,
    required String password,
    required String businessNumber,
    required String companyName,
    String? phoneNumber,
    String? address,
    String? addressDetail,
  }) async {
    // 사업자번호 중복 확인
    final existing = await _supabase
        .from('profiles')
        .select('id')
        .eq('business_number', businessNumber)
        .maybeSingle();

    if (existing != null) {
      throw Exception('이미 등록된 사업자번호입니다.');
    }

    // 회원가입
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('회원가입에 실패했습니다.');
    }

    // 프로필 정보 저장
    await _supabase.from('profiles').insert({
      'id': response.user!.id,
      'business_number': businessNumber,
      'company_name': companyName,
      'grade': 'general', // 기본값은 일반 거래처
      'status': 'pending', // 관리자 승인 대기
      'phone_number': phoneNumber,
      'address': address,
      'address_detail': addressDetail,
      'is_demo': false,
    });

    return AuthUser(
      id: response.user!.id,
      email: email,
      businessNumber: businessNumber,
      companyName: companyName,
      grade: 'general',
      status: 'pending',
      createdAt: DateTime.now(),
      phoneNumber: phoneNumber,
      address: address,
      addressDetail: addressDetail,
    );
  }

  // 로그아웃
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // 비밀번호 재설정 이메일 발송
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // 사업자번호 검증 (간단한 형식 검증)
  bool validateBusinessNumber(String businessNumber) {
    // 형식: 123-45-67890
    final regex = RegExp(r'^\d{3}-\d{2}-\d{5}$');
    return regex.hasMatch(businessNumber);
  }
}

// Provider 정의
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = Supabase.instance.client;
  return AuthService(supabase, ref);
});