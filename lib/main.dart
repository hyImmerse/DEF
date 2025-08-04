import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/env_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/providers/demo_auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase 초기화
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );

  // SharedPreferences 초기화
  await SharedPreferences.getInstance();

  runApp(
    const ProviderScope(
      child: DEFOrderApp(),
    ),
  );
}

class DEFOrderApp extends ConsumerStatefulWidget {
  const DEFOrderApp({super.key});

  @override
  ConsumerState<DEFOrderApp> createState() => _DEFOrderAppState();
}

class _DEFOrderAppState extends ConsumerState<DEFOrderApp> {
  @override
  void initState() {
    super.initState();
    // 데모 모드인 경우 데모 계정 생성
    _initializeDemoMode();
  }

  Future<void> _initializeDemoMode() async {
    const isDemoMode = bool.fromEnvironment('IS_DEMO', defaultValue: false);
    if (isDemoMode) {
      await ref.read(demoAuthProvider.notifier).createDemoAccountIfNotExists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEF 요소수 주문관리',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // 로그인 화면으로 시작
    );
  }
}