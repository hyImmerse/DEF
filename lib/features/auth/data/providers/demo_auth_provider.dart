import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/auth_user.dart';

enum DemoAccountType {
  dealer,
  general,
}

class DemoAuthState {
  final bool isLoading;
  final AuthUser? user;
  final String? error;
  final bool isDemoMode;

  const DemoAuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isDemoMode = false,
  });

  DemoAuthState copyWith({
    bool? isLoading,
    AuthUser? user,
    String? error,
    bool? isDemoMode,
  }) {
    return DemoAuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
      isDemoMode: isDemoMode ?? this.isDemoMode,
    );
  }
}

class DemoAuthNotifier extends StateNotifier<DemoAuthState> {
  final SupabaseClient _supabase;

  DemoAuthNotifier(this._supabase) : super(const DemoAuthState());

  // 데모 계정 정보
  static const Map<DemoAccountType, Map<String, String>> demoAccounts = {
    DemoAccountType.dealer: {
      'email': 'dealer@demo.com',
      'password': 'demo1234',
      'businessNumber': '123-45-67890',
      'companyName': '데모 대리점',
      'grade': 'dealer',
    },
    DemoAccountType.general: {
      'email': 'general@demo.com',
      'password': 'demo1234',
      'businessNumber': '987-65-43210',
      'companyName': '데모 일반거래처',
      'grade': 'general',
    },
  };

  Future<void> loginWithDemoAccount(DemoAccountType accountType) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final account = demoAccounts[accountType]!;
      
      // 데모 모드 플래그 설정
      const isDemoMode = bool.fromEnvironment('IS_DEMO', defaultValue: false);
      
      if (!isDemoMode) {
        throw Exception('데모 모드가 활성화되지 않았습니다.');
      }

      // Supabase Auth로 로그인
      final response = await _supabase.auth.signInWithPassword(
        email: account['email']!,
        password: account['password']!,
      );

      if (response.user == null) {
        throw Exception('로그인에 실패했습니다.');
      }

      // 사용자 프로필 정보 가져오기
      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      // AuthUser 모델 생성
      final authUser = AuthUser(
        id: response.user!.id,
        email: account['email']!,
        businessNumber: account['businessNumber']!,
        companyName: account['companyName']!,
        grade: account['grade']!,
        status: 'approved',
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        isLoading: false,
        user: authUser,
        isDemoMode: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createDemoAccountIfNotExists() async {
    try {
      const isDemoMode = bool.fromEnvironment('IS_DEMO', defaultValue: false);
      
      if (!isDemoMode) {
        return;
      }

      // 데모 계정이 존재하는지 확인하고 없으면 생성
      for (final entry in demoAccounts.entries) {
        final account = entry.value;
        
        try {
          // 계정이 이미 존재하는지 확인 (profiles 테이블에서 확인)
          final existing = await _supabase
              .from('profiles')
              .select('id')
              .eq('business_number', account['businessNumber']!)
              .maybeSingle();
          
          if (existing == null) {
            // 계정 생성
            final response = await _supabase.auth.signUp(
              email: account['email']!,
              password: account['password']!,
            );

            if (response.user != null) {
              // 프로필 정보 삽입
              await _supabase.from('profiles').insert({
                'id': response.user!.id,
                'business_number': account['businessNumber'],
                'company_name': account['companyName'],
                'grade': account['grade'],
                'status': 'approved',
                'is_demo': true,
              });
            }
          }
        } catch (e) {
          // 이미 존재하는 계정이면 무시
          continue;
        }
      }
    } catch (e) {
      print('데모 계정 생성 중 오류: $e');
    }
  }

  void logout() {
    _supabase.auth.signOut();
    state = const DemoAuthState();
  }
}

// Provider 정의
final demoAuthProvider = StateNotifierProvider<DemoAuthNotifier, DemoAuthState>((ref) {
  final supabase = Supabase.instance.client;
  return DemoAuthNotifier(supabase);
});

// 데모 모드 확인 Provider
final isDemoModeProvider = Provider<bool>((ref) {
  return const bool.fromEnvironment('IS_DEMO', defaultValue: false);
});