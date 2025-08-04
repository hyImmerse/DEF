class EnvConfig {
  // Supabase 설정
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  // 데모 모드 설정
  static const bool isDemoMode = bool.fromEnvironment(
    'IS_DEMO',
    defaultValue: false,
  );

  // API 설정
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.defcompany.com',
  );

  // Firebase 설정 (FCM)
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'def-order-demo',
  );
}