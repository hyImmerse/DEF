import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../models/profile_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return AuthService(supabaseService);
});

class AuthService {
  final SupabaseService _supabaseService;
  
  AuthService(this._supabaseService);
  
  // 현재 사용자 정보
  User? get currentUser => _supabaseService.currentUser;
  Session? get currentSession => _supabaseService.currentSession;
  bool get isAuthenticated => _supabaseService.isAuthenticated;
  
  // 현재 사용자 프로필
  Future<ProfileModel?> getCurrentProfile() async {
    if (!isAuthenticated) return null;
    
    try {
      final response = await _supabaseService.client
          .from('profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();
      
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(
        message: '프로필 정보를 불러올 수 없습니다',
      );
    }
  }
  
  // 사업자번호 검증
  Future<Map<String, dynamic>> validateBusinessNumber(String businessNumber) async {
    try {
      final response = await _supabaseService.client.functions.invoke(
        'validate-business-number',
        body: {'businessNumber': businessNumber},
      );
      
      if (response.error != null) {
        throw ServerException(message: response.error!.message);
      }
      
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw ServerException(
        message: '사업자번호 검증 중 오류가 발생했습니다',
      );
    }
  }
  
  // 회원가입
  Future<AuthResponse> signUp({
    required String businessNumber,
    required String businessName,
    required String representativeName,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      // 1. 사업자번호 검증
      final validation = await validateBusinessNumber(businessNumber);
      if (!validation['isValid']) {
        throw AuthException(
          message: validation['error'] ?? '유효하지 않은 사업자번호입니다',
        );
      }
      
      // 2. Supabase Auth 회원가입
      final response = await _supabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'business_number': businessNumber.replaceAll('-', ''),
          'business_name': businessName,
          'representative_name': representativeName,
          'phone': phone,
        },
      );
      
      if (response.user == null) {
        throw AuthException(message: '회원가입에 실패했습니다');
      }
      
      // 3. 프로필 생성 (trigger로 자동 생성되지만 명시적으로 생성)
      await _supabaseService.client.from('profiles').upsert({
        'id': response.user!.id,
        'business_number': businessNumber.replaceAll('-', ''),
        'business_name': businessName,
        'representative_name': representativeName,
        'phone': phone,
        'email': email,
        'grade': 'general', // 기본값: 일반 거래처
        'status': 'pending', // 관리자 승인 대기
      });
      
      return response;
    } on AuthException catch (e) {
      throw AuthException(
        message: e.message,
        code: e.statusCode?.toString(),
      );
    } catch (e) {
      throw ServerException(
        message: '회원가입 처리 중 오류가 발생했습니다',
      );
    }
  }
  
  // 로그인
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw AuthException(message: '로그인에 실패했습니다');
      }
      
      // 프로필 상태 확인
      final profile = await getCurrentProfile();
      if (profile == null) {
        await signOut();
        throw AuthException(message: '프로필 정보를 찾을 수 없습니다');
      }
      
      // 승인 상태 확인
      if (profile.status == UserStatus.pending) {
        await signOut();
        throw AuthException(
          message: '관리자 승인 대기 중입니다',
          code: 'PENDING_APPROVAL',
        );
      }
      
      if (profile.status == UserStatus.rejected) {
        await signOut();
        throw AuthException(
          message: '가입이 거절되었습니다. 사유: ${profile.rejectedReason ?? "미상"}',
          code: 'REJECTED',
        );
      }
      
      if (profile.status == UserStatus.inactive) {
        await signOut();
        throw AuthException(
          message: '비활성화된 계정입니다',
          code: 'INACTIVE',
        );
      }
      
      return response;
    } on AuthException catch (e) {
      throw AuthException(
        message: e.message,
        code: e.statusCode?.toString(),
      );
    } catch (e) {
      throw ServerException(
        message: '로그인 처리 중 오류가 발생했습니다',
      );
    }
  }
  
  // 로그아웃
  Future<void> signOut() async {
    try {
      await _supabaseService.client.auth.signOut();
    } catch (e) {
      throw ServerException(
        message: '로그아웃 처리 중 오류가 발생했습니다',
      );
    }
  }
  
  // 비밀번호 재설정 요청
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseService.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'deforderapp://reset-password', // 딥링크 설정 필요
      );
    } catch (e) {
      throw ServerException(
        message: '비밀번호 재설정 이메일 발송에 실패했습니다',
      );
    }
  }
  
  // 비밀번호 변경
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabaseService.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw ServerException(
        message: '비밀번호 변경에 실패했습니다',
      );
    }
  }
  
  // 세션 갱신
  Future<void> refreshSession() async {
    try {
      await _supabaseService.client.auth.refreshSession();
    } catch (e) {
      throw AuthException(
        message: '세션 갱신에 실패했습니다',
      );
    }
  }
  
  // Auth 상태 변경 스트림
  Stream<AuthState> get authStateChanges =>
      _supabaseService.client.auth.onAuthStateChange;
  
  // 프로필 업데이트
  Future<void> updateProfile({
    String? phone,
    String? representativeName,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (phone != null) updates['phone'] = phone;
      if (representativeName != null) updates['representative_name'] = representativeName;
      
      if (updates.isEmpty) return;
      
      await _supabaseService.client
          .from('profiles')
          .update(updates)
          .eq('id', currentUser!.id);
    } catch (e) {
      throw ServerException(
        message: '프로필 업데이트에 실패했습니다',
      );
    }
  }
  
  // FCM 토큰 등록
  Future<void> registerFCMToken(String token, String platform) async {
    if (!isAuthenticated) return;
    
    try {
      await _supabaseService.client.from('fcm_tokens').upsert({
        'user_id': currentUser!.id,
        'token': token,
        'platform': platform,
      });
    } catch (e) {
      // FCM 토큰 등록 실패는 무시 (앱 사용에 지장 없음)
      print('FCM token registration failed: $e');
    }
  }
  
  // FCM 토큰 제거
  Future<void> removeFCMToken(String token) async {
    if (!isAuthenticated) return;
    
    try {
      await _supabaseService.client
          .from('fcm_tokens')
          .delete()
          .eq('user_id', currentUser!.id)
          .eq('token', token);
    } catch (e) {
      // FCM 토큰 제거 실패는 무시
      print('FCM token removal failed: $e');
    }
  }
}