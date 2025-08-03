import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await ref.read(authProvider.notifier).resetPassword(
        _emailController.text.trim(),
      );
      
      setState(() {
        _emailSent = true;
      });
    } catch (e) {
      if (mounted) {
        GFToast.showToast(
          '비밀번호 재설정 이메일 발송에 실패했습니다',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppTheme.errorColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('비밀번호 재설정'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _emailSent ? _buildSuccessContent() : _buildFormContent(),
      ),
    );
  }
  
  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          
          // 안내 메시지
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.lock_reset,
                  size: 48,
                  color: Colors.blue[700],
                ),
                const SizedBox(height: 16),
                Text(
                  '비밀번호를 잊으셨나요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700]!,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '가입하신 이메일 주소를 입력하시면\n비밀번호 재설정 링크를 보내드립니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[700]!,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleResetPassword(),
          ),
          
          const SizedBox(height: 32),
          
          // 재설정 링크 발송 버튼
          GFButton(
            onPressed: _isLoading ? null : _handleResetPassword,
            text: _isLoading ? '발송 중...' : '재설정 링크 발송',
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
          
          const SizedBox(height: 24),
          
          // 로그인 화면으로 돌아가기
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back, size: 20),
                const SizedBox(width: 8),
                const Text(
                  '로그인 화면으로 돌아가기',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSuccessContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 100),
        
        // 성공 메시지
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            children: [
              Icon(
                Icons.mark_email_read,
                size: 64,
                color: Colors.green[700],
              ),
              const SizedBox(height: 24),
              Text(
                '이메일을 발송했습니다!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700]!,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '${_emailController.text}로\n비밀번호 재설정 링크를 발송했습니다.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[700]!,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '이메일을 확인하여 비밀번호를\n재설정해주세요.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[700]!,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 48),
        
        // 로그인 화면으로 돌아가기 버튼
        GFButton(
          onPressed: () {
            Navigator.pop(context);
          },
          text: '로그인 화면으로 돌아가기',
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          size: 56,
          fullWidthButton: true,
          color: AppTheme.primaryColor,
          shape: GFButtonShape.pills,
        ),
        
        const SizedBox(height: 24),
        
        // 이메일 재발송
        TextButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          child: const Text(
            '이메일을 받지 못하셨나요? 다시 보내기',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}