import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../core/theme/index.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../providers/business_validation_provider.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'admin_approval_waiting_screen.dart';

/// 사업자번호 기반 로그인 화면
/// 40-60대 사용자를 위한 큰 폰트와 버튼으로 구성
class LoginScreenV2 extends ConsumerStatefulWidget {
  const LoginScreenV2({super.key});

  @override
  ConsumerState<LoginScreenV2> createState() => _LoginScreenV2State();
}

class _LoginScreenV2State extends ConsumerState<LoginScreenV2> {
  final _formKey = GlobalKey<FormState>();
  final _businessNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  
  @override
  void dispose() {
    _businessNumberController.dispose();
    _passwordController.dispose();
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
  
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      final businessNumber = _businessNumberController.text.replaceAll('-', '');
      
      // 사업자번호로 이메일 조회 후 로그인
      await ref.read(authProvider.notifier).signInWithBusinessNumber(
        businessNumber: businessNumber,
        password: _passwordController.text,
      );
      
      final user = ref.read(authProvider).user;
      final status = user?.userMetadata?['status'];
      
      if (mounted) {
        if (status == 'pending') {
          // 승인 대기 화면으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminApprovalWaitingScreen(),
            ),
          );
        } else if (status == 'approved') {
          // 홈으로 이동
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      if (mounted) {
        String message = '로그인에 실패했습니다';
        
        if (e.toString().contains('PENDING_APPROVAL')) {
          message = '관리자 승인 대기 중입니다';
          // 승인 대기 화면으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminApprovalWaitingScreen(),
            ),
          );
          return;
        } else if (e.toString().contains('REJECTED')) {
          message = '가입이 거절되었습니다';
        } else if (e.toString().contains('INACTIVE')) {
          message = '비활성화된 계정입니다';
        } else if (e.toString().contains('Invalid login credentials')) {
          message = '사업자번호 또는 비밀번호가 올바르지 않습니다';
        } else if (e.toString().contains('Business number not found')) {
          message = '등록되지 않은 사업자번호입니다';
        }
        
        GFToast.showToast(
          message,
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: AppColors.error,
          textStyle: AppTextStyles.button.copyWith(color: Colors.white),
          toastDuration: 3,
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.allXL,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 로고 및 타이틀
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_shipping_rounded,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ).centered(),
                    
                    AppSpacing.v24,
                    
                    '요소컴케이엠'.text
                      .textStyle(AppTextStyles.displaySmall)
                      .color(AppColors.primary)
                      .makeCentered(),
                    
                    AppSpacing.v8,
                    
                    '요소수 출고 주문관리 시스템'.text
                      .textStyle(AppTextStyles.titleLarge)
                      .color(AppColors.textSecondary)
                      .makeCentered(),
                    
                    AppSpacing.v48,
                    
                    // 사업자번호 입력
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        '사업자번호'.text
                          .textStyle(AppTextStyles.titleMedium)
                          .color(AppColors.textPrimary)
                          .make(),
                        AppSpacing.v8,
                        TextFormField(
                          controller: _businessNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                            LengthLimitingTextInputFormatter(12),
                          ],
                          style: AppTextStyles.input,
                          decoration: InputDecoration(
                            hintText: '123-45-67890',
                            hintStyle: AppTextStyles.inputHint,
                            prefixIcon: Icon(
                              Icons.business_center_rounded,
                              size: 28,
                              color: AppColors.textSecondary,
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                              borderSide: BorderSide(color: AppColors.primary, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                              borderSide: BorderSide(color: AppColors.error),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                          ),
                          validator: Validators.validateBusinessNumber,
                          onChanged: _onBusinessNumberChanged,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                    
                    AppSpacing.v24,
                    
                    // 비밀번호 입력
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        '비밀번호'.text
                          .textStyle(AppTextStyles.titleMedium)
                          .color(AppColors.textPrimary)
                          .make(),
                        AppSpacing.v8,
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          style: AppTextStyles.input,
                          decoration: InputDecoration(
                            hintText: '비밀번호를 입력하세요',
                            hintStyle: AppTextStyles.inputHint,
                            prefixIcon: Icon(
                              Icons.lock_rounded,
                              size: 28,
                              color: AppColors.textSecondary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible 
                                  ? Icons.visibility_off_rounded 
                                  : Icons.visibility_rounded,
                                size: 28,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                              borderSide: BorderSide(color: AppColors.primary, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                              borderSide: BorderSide(color: AppColors.error),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
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
                      ],
                    ),
                    
                    AppSpacing.v16,
                    
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
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                        child: '비밀번호를 잊으셨나요?'.text
                          .textStyle(AppTextStyles.bodyLarge)
                          .color(AppColors.primary)
                          .make(),
                      ),
                    ),
                    
                    AppSpacing.v32,
                    
                    // 로그인 버튼
                    GFButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      text: authState.isLoading ? '로그인 중...' : '로그인',
                      textStyle: AppTextStyles.buttonLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      size: 60,
                      fullWidthButton: true,
                      color: AppColors.primary,
                      disabledColor: AppColors.disabled,
                      shape: GFButtonShape.pills,
                      elevation: 2,
                    ),
                    
                    AppSpacing.v32,
                    
                    // 회원가입 안내
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        '아직 계정이 없으신가요?'.text
                          .textStyle(AppTextStyles.bodyLarge)
                          .color(AppColors.textSecondary)
                          .make(),
                        AppSpacing.h8,
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignupScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                          child: '회원가입'.text
                            .textStyle(AppTextStyles.titleMedium)
                            .color(AppColors.primary)
                            .make(),
                        ),
                      ],
                    ),
                    
                    AppSpacing.v24,
                    
                    // 안내 메시지
                    Container(
                      padding: AppSpacing.allLG,
                      decoration: BoxDecoration(
                        color: AppColors.infoLight,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                        border: Border.all(color: AppColors.infoBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.info,
                            size: 24,
                          ),
                          AppSpacing.h12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                '안내사항'.text
                                  .textStyle(AppTextStyles.titleSmall)
                                  .color(AppColors.info)
                                  .make(),
                                AppSpacing.v4,
                                '• 사업자번호로 로그인이 가능합니다'.text
                                  .textStyle(AppTextStyles.bodyMedium)
                                  .color(AppColors.infoText)
                                  .make(),
                                '• 가입 후 관리자 승인이 필요합니다'.text
                                  .textStyle(AppTextStyles.bodyMedium)
                                  .color(AppColors.infoText)
                                  .make(),
                                '• 승인 완료 시 로그인 가능합니다'.text
                                  .textStyle(AppTextStyles.bodyMedium)
                                  .color(AppColors.infoText)
                                  .make(),
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
        ),
      ),
    );
  }
}