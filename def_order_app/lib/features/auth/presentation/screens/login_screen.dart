import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      await ref.read(authProvider.notifier).signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // 로그인 성공 시 홈으로 이동
      if (mounted) {
        // TODO: Navigate to home
      }
    } catch (e) {
      if (mounted) {
        String message = '로그인에 실패했습니다';
        
        if (e.toString().contains('PENDING_APPROVAL')) {
          message = '관리자 승인 대기 중입니다';
        } else if (e.toString().contains('REJECTED')) {
          message = '가입이 거절되었습니다';
        } else if (e.toString().contains('INACTIVE')) {
          message = '비활성화된 계정입니다';
        } else if (e.toString().contains('Invalid login credentials')) {
          message = '이메일 또는 비밀번호가 올바르지 않습니다';
        }
        
        GFToast.showToast(
          message,
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.errorColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
          toastDuration: 3,
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                
                // 로고 및 타이틀
                Center(
                  child: Icon(
                    Icons.local_shipping,
                    size: 80,
                    color: AppTheme.primaryColor,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Center(
                  child: Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Center(
                  child: Text(
                    '요소수 출고 주문관리 시스템',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // 이메일 입력
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: '이메일',
                    hintText: 'example@company.com',
                    prefixIcon: Icon(Icons.email_outlined, size: 24),
                  ),
                  validator: Validators.validateEmail,
                  textInputAction: TextInputAction.next,
                ),
                
                const SizedBox(height: 24),
                
                // 비밀번호 입력
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    prefixIcon: const Icon(Icons.lock_outline, size: 24),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible 
                          ? Icons.visibility_off 
                          : Icons.visibility,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                ),
                
                const SizedBox(height: 16),
                
                // 비밀번호 찾기
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      '비밀번호를 잊으셨나요?',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 로그인 버튼
                GFButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  text: authState.isLoading ? '로그인 중...' : '로그인',
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  size: 56,
                  fullWidthButton: true,
                  color: AppTheme.primaryColor,
                  disabledColor: Colors.grey[400]!,
                  shape: GFButtonShape.pills,
                ),
                
                const SizedBox(height: 32),
                
                // 회원가입 안내
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '아직 계정이 없으신가요?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // 안내 메시지
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '안내사항',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700]!,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '• 사업자번호로 회원가입이 필요합니다',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[700]!,
                              ),
                            ),
                            Text(
                              '• 가입 후 관리자 승인이 필요합니다',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[700]!,
                              ),
                            ),
                            Text(
                              '• 승인 완료 시 로그인 가능합니다',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[700]!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}