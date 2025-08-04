import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static SupabaseClient? _client;
  
  // 데모 모드 체크
  static bool get isDemoMode => dotenv.env['IS_DEMO'] == 'true';
  
  static SupabaseClient get client {
    if (isDemoMode) {
      throw Exception('데모 모드에서는 Supabase client를 사용할 수 없습니다');
    }
    if (_client == null) {
      throw Exception('Supabase client has not been initialized');
    }
    return _client!;
  }
  
  static Future<void> initialize() async {
    // 데모 모드가 아닌 경우에만 실제 Supabase 초기화
    if (!isDemoMode) {
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL'] ?? '',
        anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          autoRefreshToken: true,
        ),
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: RealtimeLogLevel.info,
        ),
        storageOptions: const StorageClientOptions(
          retryAttempts: 3,
        ),
      );
      
      _client = Supabase.instance.client;
    }
  }
  
  // Auth shortcuts
  static GoTrueClient get auth {
    if (isDemoMode) {
      throw Exception('데모 모드에서는 Supabase auth를 사용할 수 없습니다');
    }
    return client.auth;
  }
  
  // Database shortcuts
  static SupabaseQueryBuilder from(String table) {
    if (isDemoMode) {
      throw Exception('데모 모드에서는 Supabase database를 사용할 수 없습니다');
    }
    return client.from(table);
  }
  
  // Storage shortcuts
  static SupabaseStorageClient get storage {
    if (isDemoMode) {
      throw Exception('데모 모드에서는 Supabase storage를 사용할 수 없습니다');
    }
    return client.storage;
  }
  
  // Realtime shortcuts
  static RealtimeClient get realtime {
    if (isDemoMode) {
      throw Exception('데모 모드에서는 Supabase realtime을 사용할 수 없습니다');
    }
    return client.realtime;
  }
  
  // Functions shortcuts
  static FunctionsClient get functions {
    if (isDemoMode) {
      throw Exception('데모 모드에서는 Supabase functions을 사용할 수 없습니다');
    }
    return client.functions;
  }
}