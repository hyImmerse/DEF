import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/profile_model.dart';
import 'auth_provider.dart';

/// 데모 모드 인증 Provider
final demoAuthProvider = Provider<DemoAuthService>((ref) {
  return DemoAuthService();
});

class DemoAuthService {
  // 데모 계정 정보
  static const demoAccounts = {
    'dealer@demo.com': {
      'password': 'demo1234',
      'profile': ProfileModel(
        id: '33333333-3333-3333-3333-333333333333',
        businessNumber: '123-45-67890',
        businessName: '데모 대리점',
        representativeName: '김대리',
        phone: '02-1234-5678',
        email: 'dealer@demo.com',
        grade: UserGrade.dealer,
        status: UserStatus.approved,
        unitPriceBox: null, // 대리점은 통일 가격
        unitPriceBulk: null,
        createdAt: '2025-01-01T00:00:00',
        approvedAt: '2025-01-01T00:00:00',
        lastOrderAt: null,
      ),
    },
    'general@demo.com': {
      'password': 'demo1234',
      'profile': ProfileModel(
        id: '44444444-4444-4444-4444-444444444444',
        businessNumber: '987-65-43210',
        businessName: '데모 일반거래처',
        representativeName: '박일반',
        phone: '031-9876-5432',
        email: 'general@demo.com',
        grade: UserGrade.general,
        status: UserStatus.approved,
        unitPriceBox: 10000.0,
        unitPriceBulk: 900000.0,
        createdAt: '2025-01-01T00:00:00',
        approvedAt: '2025-01-01T00:00:00',
        lastOrderAt: null,
      ),
    },
  };

  /// 데모 로그인 검증
  Future<ProfileModel?> validateDemoLogin(String email, String password) async {
    // 1초 지연으로 실제 API 호출 느낌 연출
    await Future.delayed(const Duration(seconds: 1));
    
    final account = demoAccounts[email];
    if (account != null && account['password'] == password) {
      return account['profile'] as ProfileModel;
    }
    
    return null;
  }

  /// 데모 계정인지 확인
  bool isDemoAccount(String email) {
    return demoAccounts.containsKey(email);
  }
}

/// 데모 모드 확인 Provider
final isDemoModeProvider = Provider<bool>((ref) {
  // 환경 변수 또는 빌드 설정에서 데모 모드 확인
  const isDemoMode = String.fromEnvironment('IS_DEMO', defaultValue: 'true');
  return isDemoMode == 'true';
});