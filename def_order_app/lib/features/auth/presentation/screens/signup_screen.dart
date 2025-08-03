import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../providers/business_validation_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNumberController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _representativeNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  bool _agreedToTerms = false;
  
  @override
  void dispose() {
    _businessNumberController.dispose();
    _businessNameController.dispose();
    _representativeNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
  
  void _onBusinessNumberChanged(String value) {
    final formatted = ref.read(formatBusinessNumberProvider(value));
    if (formatted != value) {
      _businessNumberController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }
  
  Future<void> _validateBusinessNumber() async {
    final businessNumber = _businessNumberController.text;
    if (businessNumber.replaceAll('-', '').length != 10) return;
    
    await ref.read(businessValidationProvider.notifier)
        .validateBusinessNumber(businessNumber);
    
    final validation = ref.read(businessValidationProvider);
    if (validation.isValid == true && validation.businessName != null) {
      _businessNameController.text = validation.businessName!;
    }
  }
  
  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_agreedToTerms) {
      GFToast.showToast(
        '이용약관에 동의해주세요',
        context,
        toastPosition: GFToastPosition.BOTTOM,
        backgroundColor: AppTheme.warningColor,
      );
      return;
    }
    
    try {
      await ref.read(authProvider.notifier).signUp(
        businessNumber: _businessNumberController.text,
        businessName: _businessNameController.text,
        representativeName: _representativeNameController.text,
        phone: _phoneController.text,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      if (mounted) {
        // 회원가입 성공 다이얼로그
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('회원가입 완료'),
            content: const Text(
              '회원가입이 완료되었습니다.\n'
              '관리자 승인 후 로그인이 가능합니다.\n'
              '승인 완료 시 이메일로 안내드리겠습니다.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.of(context).pop(); // 회원가입 화면 닫기
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        GFToast.showToast(
          e.toString().replaceAll('Exception: ', ''),
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
    final validationState = ref.watch(businessValidationProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 사업자번호
              TextFormField(
                controller: _businessNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                  LengthLimitingTextInputFormatter(12), // 3-2-5 + 하이픈 2개
                ],
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: '사업자번호',
                  hintText: '123-45-67890',
                  prefixIcon: const Icon(Icons.business, size: 24),
                  suffixIcon: validationState.isValidating
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : validationState.isValid == true
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : validationState.isValid == false
                        ? const Icon(Icons.error, color: Colors.red)
                        : TextButton(
                            onPressed: _validateBusinessNumber,
                            child: const Text('확인'),
                          ),
                ),
                validator: Validators.validateBusinessNumber,
                onChanged: _onBusinessNumberChanged,
                textInputAction: TextInputAction.next,
              ),
              
              if (validationState.errorMessage != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    validationState.errorMessage!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.errorColor,
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // 사업자명
              TextFormField(
                controller: _businessNameController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: '사업자명',
                  hintText: '요소컴케이엠(주)',
                  prefixIcon: Icon(Icons.store, size: 24),
                ),
                validator: (value) => Validators.validateRequired(value, '사업자명'),
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 24),
              
              // 대표자명
              TextFormField(
                controller: _representativeNameController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: '대표자명',
                  hintText: '홍길동',
                  prefixIcon: Icon(Icons.person, size: 24),
                ),
                validator: (value) => Validators.validateRequired(value, '대표자명'),
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 24),
              
              // 휴대폰번호
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: '휴대폰번호',
                  hintText: '01012345678',
                  prefixIcon: Icon(Icons.phone, size: 24),
                ),
                validator: Validators.validatePhoneNumber,
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 24),
              
              // 이메일
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: '이메일',
                  hintText: 'example@company.com',
                  prefixIcon: Icon(Icons.email, size: 24),
                ),
                validator: Validators.validateEmail,
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 24),
              
              // 비밀번호
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: '8자 이상',
                  prefixIcon: const Icon(Icons.lock, size: 24),
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
                  if (value.length < 8) {
                    return '비밀번호는 8자 이상이어야 합니다';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 24),
              
              // 비밀번호 확인
              TextFormField(
                controller: _passwordConfirmController,
                obscureText: !_isPasswordConfirmVisible,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  prefixIcon: const Icon(Icons.lock_outline, size: 24),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordConfirmVisible 
                        ? Icons.visibility_off 
                        : Icons.visibility,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 다시 입력해주세요';
                  }
                  if (value != _passwordController.text) {
                    return '비밀번호가 일치하지 않습니다';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              
              const SizedBox(height: 32),
              
              // 이용약관 동의
              GFCheckboxListTile(
                titleText: '이용약관 및 개인정보처리방침에 동의합니다',
                size: 24,
                activeBgColor: AppTheme.primaryColor,
                type: GFCheckboxType.square,
                activeIcon: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    _agreedToTerms = value;
                  });
                },
                value: _agreedToTerms,
                inactiveIcon: null,
              ),
              
              const SizedBox(height: 24),
              
              // 회원가입 버튼
              GFButton(
                onPressed: authState.isLoading ? null : _handleSignup,
                text: authState.isLoading ? '처리 중...' : '회원가입',
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
            ],
          ),
        ),
      ),
    );
  }
}