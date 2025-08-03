import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:velocity_x/velocity_x.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

// FCM 백그라운드 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('백그라운드 메시지 처리: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 환경 변수 로드
  await dotenv.load(fileName: '.env');
  
  // Firebase 초기화
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Supabase 초기화
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? AppConstants.baseUrl,
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? AppConstants.anonKey,
  );
  
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
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 임시 스플래시 스크린
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    // TODO: 실제 인증 상태 확인 로직 구현
    // final session = Supabase.instance.client.auth.currentSession;
    // if (session != null) {
    //   // 홈 화면으로 이동
    // } else {
    //   // 로그인 화면으로 이동
    // }
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
            20.heightBox,
            AppConstants.appName.text.white.size(28).bold.make(),
            10.heightBox,
            '요소수 출고 주문관리 시스템'.text.white.size(18).make(),
          ],
        ),
      ),
    );
  }
}