import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/profile_model.dart';
import '../../../../core/error/failures.dart';

part 'auth_provider.g.dart';

// Auth 상태 클래스
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final ProfileModel? profile;
  final Failure? error;
  
  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.profile,
    this.error,
  });
  
  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    ProfileModel? profile,
    Failure? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}

// Auth Notifier
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final AuthService _authService;
  
  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);
    
    // Auth 상태 변경 감지
    _authService.authStateChanges.listen((authState) {
      if (authState.session != null) {
        _loadProfile();
      } else {
        state = const AuthState(isAuthenticated: false);
      }
    });
    
    // 초기 상태 설정
    if (_authService.isAuthenticated) {
      _loadProfile();
      return const AuthState(isAuthenticated: true, isLoading: true);
    }
    
    return const AuthState(isAuthenticated: false);
  }
  
  // 프로필 로드
  Future<void> _loadProfile() async {
    try {
      final profile = await _authService.getCurrentProfile();
      if (profile != null) {
        state = AuthState(
          isAuthenticated: true,
          profile: profile,
          isLoading: false,
        );
      }
    } catch (e) {
      state = AuthState(
        isAuthenticated: false,
        isLoading: false,
        error: ServerFailure(message: '프로필 로드 실패'),
      );
    }
  }
  
  // 회원가입
  Future<void> signUp({
    required String businessNumber,
    required String businessName,
    required String representativeName,
    required String phone,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authService.signUp(
        businessNumber: businessNumber,
        businessName: businessName,
        representativeName: representativeName,
        phone: phone,
        email: email,
        password: password,
      );
      
      // 회원가입 후 자동 로그아웃 (승인 대기)
      await _authService.signOut();
      
      state = const AuthState(
        isAuthenticated: false,
        isLoading: false,
      );
    } catch (e) {
      state = AuthState(
        isAuthenticated: false,
        isLoading: false,
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }
  
  // 로그인
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authService.signIn(
        email: email,
        password: password,
      );
      
      await _loadProfile();
    } catch (e) {
      state = AuthState(
        isAuthenticated: false,
        isLoading: false,
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }
  
  // 로그아웃
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _authService.signOut();
      state = const AuthState(
        isAuthenticated: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapExceptionToFailure(e),
      );
    }
  }
  
  // 비밀번호 재설정
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }
  
  // 프로필 업데이트
  Future<void> updateProfile({
    String? phone,
    String? representativeName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authService.updateProfile(
        phone: phone,
        representativeName: representativeName,
      );
      
      await _loadProfile();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapExceptionToFailure(e),
      );
      rethrow;
    }
  }
  
  // 세션 갱신
  Future<void> refreshSession() async {
    try {
      await _authService.refreshSession();
      await _loadProfile();
    } catch (e) {
      state = AuthState(
        isAuthenticated: false,
        isLoading: false,
        error: _mapExceptionToFailure(e),
      );
    }
  }
  
  // FCM 토큰 등록
  Future<void> registerFCMToken(String token, String platform) async {
    await _authService.registerFCMToken(token, platform);
  }
  
  // FCM 토큰 제거
  Future<void> removeFCMToken(String token) async {
    await _authService.removeFCMToken(token);
  }
  
  // 예외를 Failure로 매핑
  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
      );
    } else {
      return UnknownFailure(
        message: exception.toString(),
      );
    }
  }
}

// 편의 Provider들
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(authProvider).isAuthenticated;
}

@riverpod
ProfileModel? currentProfile(CurrentProfileRef ref) {
  return ref.watch(authProvider).profile;
}

@riverpod
bool isDealer(IsDealerRef ref) {
  final profile = ref.watch(currentProfileProvider);
  return profile?.grade == UserGrade.dealer;
}

@riverpod
bool isApprovedUser(IsApprovedUserRef ref) {
  final profile = ref.watch(currentProfileProvider);
  return profile?.status == UserStatus.approved;
}