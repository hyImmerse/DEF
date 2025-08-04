import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/config/supabase_config.dart';
import 'core/services/navigation_service.dart';
import 'core/services/local_storage_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/enhanced_home_screen.dart';
import 'features/notification/presentation/providers/notification_provider.dart';

// FCM 백그라운드 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('백그라운드 메시지 처리: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 환경 변수 로드 (에러 핸들링 추가)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    print('환경 변수 파일을 로드할 수 없습니다. 기본값을 사용합니다: $e');
    // 데모 모드를 기본값으로 설정
    dotenv.env['IS_DEMO'] = 'true';
    dotenv.env['SUPABASE_URL'] = 'https://your-project.supabase.co';
    dotenv.env['SUPABASE_ANON_KEY'] = 'your-anon-key';
  }
  
  // Firebase 초기화 - 웹이 아닌 경우에만
  if (!kIsWeb) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  
  // Supabase 초기화
  await SupabaseConfig.initialize();
  
  // SharedPreferences 초기화
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(
          LocalStorageService(prefs),
        ),
      ],
      child: const DefOrderApp(),
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
    _initialize();
  }
  
  Future<void> _initialize() async {
    // FCM 초기화 (웹이 아닌 경우에만)
    if (!kIsWeb) {
      try {
        await ref.read(fcmInitializationProvider.future);
      } catch (e) {
        print('FCM 초기화 실패: $e');
      }
    }
    
    await _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final authState = ref.read(authProvider);
    
    if (mounted) {
      if (authState.isAuthenticated && authState.profile != null) {
        // 사용자 타입에 따른 주제 구독
        if (!kIsWeb) {
          final userGrade = authState.profile!.grade.name;
          await ref.read(topicSubscriptionProvider.notifier).subscribeToTopic(userGrade);
          await ref.read(topicSubscriptionProvider.notifier).subscribeToTopic('all');
        }
        
        // 홈 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EnhancedHomeScreen()),
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