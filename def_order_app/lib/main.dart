import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/config/supabase_config.dart';
import 'core/services/navigation_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/notice/presentation/providers/notice_push_handler.dart';
import 'features/home/presentation/screens/home_screen.dart';

// FCM 백그라운드 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('백그라운드 메시지 처리: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 환경 변수 로드
  await dotenv.load(fileName: '.env');
  
  // Firebase 초기화 - 웹이 아닌 경우에만
  if (!kIsWeb) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  
  // Supabase 초기화
  await SupabaseConfig.initialize();
  
  runApp(
    const ProviderScope(
      child: DefOrderApp(),
    ),
  );
}

class DefOrderApp extends StatelessWidget {
  const DefOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      navigatorKey: NavigationService.navigatorKey,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 스플래시 스크린
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final authState = ref.read(authProvider);
    
    if (mounted) {
      if (authState.isAuthenticated && authState.profile != null) {
        // 홈 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        // 로그인 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_shipping,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              AppConstants.appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '요소수 출고 주문관리 시스템',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}