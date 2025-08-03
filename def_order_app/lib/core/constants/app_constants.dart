class AppConstants {
  // App Info
  static const String appName = '요소수 주문관리';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String baseUrl = 'https://your-project.supabase.co';
  static const String anonKey = 'your-anon-key';
  
  // Storage Keys
  static const String keyToken = 'auth_token';
  static const String keyUser = 'user_data';
  static const String keyCompany = 'company_data';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double largeFontSize = 18.0; // 40-60대 사용자를 위한 큰 폰트
  
  // Order Status
  static const Map<String, String> orderStatusMap = {
    'draft': '임시저장',
    'pending': '주문대기',
    'confirmed': '주문확정',
    'shipped': '배송중',
    'completed': '완료',
    'cancelled': '취소',
  };
  
  // User Grade
  static const Map<String, String> userGradeMap = {
    'dealer': '딜러',
    'general': '일반',
  };
}