import 'package:flutter/material.dart';
import '../../../../core/theme/index.dart';

/// 비밀번호 입력 위젯
/// 40-60대 사용자를 위한 큰 입력 필드와 보기/숨기기 토글
class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final VoidCallback? onFieldSubmitted;
  final bool enabled;
  final Widget? prefixIcon;
  
  const PasswordInput({
    super.key,
    required this.controller,
    this.labelText = '비밀번호',
    this.hintText = '비밀번호를 입력하세요',
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
    this.prefixIcon,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isPasswordVisible = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          widget.labelText!.text
            .textStyle(AppTextStyles.titleMedium)
            .color(AppColors.textPrimary)
            .make(),
          AppSpacing.v8,
        ],
        
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: !_isPasswordVisible,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: widget.prefixIcon ?? Icon(
              Icons.lock_rounded,
              size: 28,
              color: widget.enabled 
                  ? AppColors.textSecondary 
                  : AppColors.disabled,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible 
                  ? Icons.visibility_off_rounded 
                  : Icons.visibility_rounded,
                size: 28,
                color: widget.enabled 
                    ? AppColors.textSecondary 
                    : AppColors.disabled,
              ),
              onPressed: widget.enabled 
                  ? () => setState(() => _isPasswordVisible = !_isPasswordVisible)
                  : null,
            ),
            filled: true,
            fillColor: widget.enabled 
                ? AppColors.surface 
                : AppColors.backgroundSecondary,
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          validator: widget.validator ?? (value) {
            if (value == null || value.isEmpty) {
              return '비밀번호를 입력해주세요';
            }
            if (value.length < 8) {
              return '비밀번호는 8자 이상이어야 합니다';
            }
            return null;
          },
          textInputAction: widget.textInputAction,
          onFieldSubmitted: (_) => widget.onFieldSubmitted?.call(),
        ),
      ],
    );
  }
}