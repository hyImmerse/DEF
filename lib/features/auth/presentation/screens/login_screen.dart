import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';

import '../../data/providers/demo_auth_provider.dart';
import '../../data/services/auth_service.dart';
import '../../../home/presentation/screens/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDemoLogin(DemoAccountType accountType) async {
    setState(() => _isLoading = true);

    try {
      await ref.read(demoAuthProvider.notifier).loginWithDemoAccount(accountType);
      
      final demoState = ref.read(demoAuthProvider);
      if (demoState.user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (demoState.error != null) {
        throw Exception(demoState.error);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDemoMode = ref.watch(isDemoModeProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // 로고 영역
              Icon(
                Icons.local_shipping,
                size: 80,
                color: Theme.of(context).primaryColor,
              ).centered(),
              const SizedBox(height: 24),
              "DEF 요소수"
                  .text
                  .headline4(context)
                  .bold
                  .color(Theme.of(context).primaryColor)
                  .make()
                  .centered(),
              const SizedBox(height: 8),
              "주문관리 시스템"
                  .text
                  .xl2
                  .gray600
                  .make()
                  .centered(),
              const SizedBox(height: 48),

              // 데모 모드 버튼 (데모 환경에서만 표시)
              if (isDemoMode) ...[
                GFCard(
                  elevation: 8,
                  color: Colors.blue.shade50,
                  padding: const EdgeInsets.all(20),
                  content: Column(
                    children: [
                      "🚀 데모 시작하기"
                          .text
                          .xl3
                          .bold
                          .color(Theme.of(context).primaryColor)
                          .make()
                          .centered(),
                      const SizedBox(height: 16),
                      "회원가입 없이 바로 체험해보세요!"
                          .text
                          .xl
                          .gray700
                          .make()
                          .centered(),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: GFButton(
                              onPressed: _isLoading 
                                  ? null 
                                  : () => _handleDemoLogin(DemoAccountType.dealer),
                              text: "대리점 데모",
                              size: GFSize.LARGE,
                              fullWidthButton: true,
                              color: Theme.of(context).primaryColor,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.store, size: 24),
                                  const SizedBox(width: 8),
                                  "대리점 데모".text.xl.white.bold.make(),
                                ],
                              ),
                            ).p4(),
                          ),
                          Expanded(
                            child: GFButton(
                              onPressed: _isLoading 
                                  ? null 
                                  : () => _handleDemoLogin(DemoAccountType.general),
                              text: "일반 거래처 데모",
                              size: GFSize.LARGE,
                              fullWidthButton: true,
                              color: Colors.green,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.business, size: 24),
                                  const SizedBox(width: 8),
                                  "일반 거래처".text.xl.white.bold.make(),
                                ],
                              ),
                            ).p4(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                GFTypography(
                  text: "또는 계정으로 로그인",
                  type: GFTypographyType.typo5,
                  dividerColor: Colors.grey.shade400,
                  dividerWidth: 100,
                ),
                const SizedBox(height: 32),
              ],

              // 로그인 폼
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: '이메일',
                        hintText: 'example@company.com',
                        prefixIcon: Icon(Icons.email_outlined, size: 28),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이메일을 입력해주세요';
                        }
                        if (!value.contains('@')) {
                          return '올바른 이메일 형식이 아닙니다';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        prefixIcon: const Icon(Icons.lock_outline, size: 28),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword 
                                ? Icons.visibility_outlined 
                                : Icons.visibility_off_outlined,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        }
                        if (value.length < 6) {
                          return '비밀번호는 6자 이상이어야 합니다';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    GFButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      text: _isLoading ? '로그인 중...' : '로그인',
                      size: GFSize.LARGE,
                      fullWidthButton: true,
                      color: Theme.of(context).primaryColor,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            // TODO: 비밀번호 찾기 화면으로 이동
                          },
                          child: "비밀번호 찾기".text.lg.gray600.make(),
                        ),
                        "|".text.lg.gray400.make().px12(),
                        TextButton(
                          onPressed: () {
                            // TODO: 회원가입 화면으로 이동
                          },
                          child: "회원가입".text.lg.gray600.make(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}