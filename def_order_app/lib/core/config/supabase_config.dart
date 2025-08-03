import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static late final SupabaseClient client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
      authOptions: const AuthClientOptions(
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
    
    client = Supabase.instance.client;
  }
  
  // Auth shortcuts
  static GoTrueClient get auth => client.auth;
  
  // Database shortcuts
  static SupabaseQueryBuilder from(String table) => client.from(table);
  
  // Storage shortcuts
  static SupabaseStorageClient get storage => client.storage;
  
  // Realtime shortcuts
  static RealtimeClient get realtime => client.realtime;
  
  // Functions shortcuts
  static FunctionsClient get functions => client.functions;
}