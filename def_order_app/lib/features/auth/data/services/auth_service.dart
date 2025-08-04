import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/error/exceptions.dart';
import 'package:gotrue/gotrue.dart' as gotrue;
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
  User? get currentUser {
    if (SupabaseConfig.isDemoMode) return null;
    return _supabaseService.currentUser;
  }
  
  Session? get currentSession {
    if (SupabaseConfig.isDemoMode) return null;
    return _supabaseService.currentSession;
  }
  
  bool get isAuthenticated {
    if (SupabaseConfig.isDemoMode) return false;
    return _supabaseService.isAuthenticated;
  }
  
  // 현재 사용자 프로필
  Future<ProfileModel?> getCurrentProfile() async {
    if (SupabaseConfig.isDemoMode) return null;
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
    if (SupabaseConfig.isDemoMode) {
      // 데모 모드에서는 데모 사업자번호만 유효
      if (businessNumber == '123-45-67890' || businessNumber == '987-65-43210') {
        return {'isValid': true, 'businessName': '데모 회사'};
      }
      return {'isValid': false, 'error': '데모 모드에서는 등록된 데모 사업자번호만 사용할 수 있습니다'};
    }
    
    try {
      final response = await _supabaseService.client.functions.invoke(
        'validate-business-number',
        body: {'businessNumber': businessNumber},
      );
      
      if (response.status != 200) {
        throw ServerException(message: '함수 호출에 실패했습니다');
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
    if (SupabaseConfig.isDemoMode) {
      throw AppAuthException(
        message: '데모 모드에서는 회원가입을 사용할 수 없습니다',
        code: 'DEMO_MODE_NOT_SUPPORTED',
      );
    }
    
    try {
      // 1. 사업자번호 검증
      final validation = await validateBusinessNumber(businessNumber);
      if (!validation['isValid']) {
        throw AppAuthException(
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
        throw AppAuthException(message: '회원가입에 실패했습니다');
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
    } on gotrue.AuthException catch (e) {
      throw AppAuthException(
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
    if (SupabaseConfig.isDemoMode) {
      throw AppAuthException(
        message: '데모 모드에서는 실제 로그인을 사용할 수 없습니다',
        code: 'DEMO_MODE_NOT_SUPPORTED',
      );
    }
    
    try {
      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw AppAuthException(message: '로그인에 실패했습니다');
      }
      
      // 프로필 상태 확인
      final profile = await getCurrentProfile();
      if (profile == null) {
        await signOut();
        throw AppAuthException(message: '프로필 정보를 찾을 수 없습니다');
      }
      
      // 승인 상태 확인
      if (profile.status == UserStatus.pending) {
        await signOut();
        throw AppAuthException(
          message: '관리자 승인 대기 중입니다',
          code: 'PENDING_APPROVAL',
        );
      }
      
      if (profile.status == UserStatus.rejected) {
        await signOut();
        throw AppAuthException(
          message: '가입이 거절되었습니다. 사유: ${profile.rejectedReason ?? "미상"}',
          code: 'REJECTED',
        );
      }
      
      if (profile.status == UserStatus.inactive) {
        await signOut();
        throw AppAuthException(
          message: '비활성화된 계정입니다',
          code: 'INACTIVE',
        );
      }
      
      return response;
    } on gotrue.AuthException catch (e) {
      throw AppAuthException(
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
    if (SupabaseConfig.isDemoMode) return;
    
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
    if (SupabaseConfig.isDemoMode) {
      throw AppAuthException(
        message: '데모 모드에서는 비밀번호 재설정을 사용할 수 없습니다',
        code: 'DEMO_MODE_NOT_SUPPORTED',
      );
    }
    
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
      throw AppAuthException(
        message: '세션 갱신에 실패했습니다',
      );
    }
  }
  
  // Auth 상태 변경 스트림
  Stream<AuthState> get authStateChanges {
    // 데모 모드에서는 빈 스트림 반환
    if (SupabaseConfig.isDemoMode) {
      return const Stream.empty();
    }
    return _supabaseService.client.auth.onAuthStateChange;
  }
  
  // 프로필 업데이트
  Future<void> updateProfile({
    String? phone,
    String? representativeName,
  }) async {
    if (SupabaseConfig.isDemoMode) return;
    
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
    if (SupabaseConfig.isDemoMode) return;
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
    if (SupabaseConfig.isDemoMode) return;
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
  
  // 사업자번호로 이메일 조회
  Future<String?> getEmailByBusinessNumber(String businessNumber) async {
    if (SupabaseConfig.isDemoMode) {
      // 데모 모드에서는 데모 계정 검색
      if (businessNumber == '123-45-67890') return 'dealer@demo.com';
      if (businessNumber == '987-65-43210') return 'general@demo.com';
      return null;
    }
    
    try {
      final cleanedNumber = businessNumber.replaceAll('-', '');
      
      final response = await _supabaseService.client
          .from('profiles')
          .select('email')
          .eq('business_number', cleanedNumber)
          .maybeSingle();
      
      if (response == null) return null;
      
      return response['email'] as String?;
    } catch (e) {
      throw ServerException(
        message: '사업자번호 조회에 실패했습니다',
      );
    }
  }
}