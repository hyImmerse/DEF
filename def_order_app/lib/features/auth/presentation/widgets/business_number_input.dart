import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../core/theme/index.dart';
import '../../../../core/utils/validators.dart';
import '../providers/business_validation_provider.dart';

/// 사업자번호 입력 위젯
/// 40-60대 사용자를 위한 큰 입력 필드와 실시간 포맷팅
class BusinessNumberInput extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool showValidationButton;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final VoidCallback? onFieldSubmitted;
  final bool enabled;
  
  const BusinessNumberInput({
    super.key,
    required this.controller,
    this.labelText = '사업자번호',
    this.hintText = '123-45-67890',
    this.showValidationButton = false,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  @override
  ConsumerState<BusinessNumberInput> createState() => _BusinessNumberInputState();
}

class _BusinessNumberInputState extends ConsumerState<BusinessNumberInput> {
  void _onChanged(String value) {
    // 자동 포맷팅
    final formatted = ref.read(formatBusinessNumberProvider(value));
    if (formatted != value) {
      widget.controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    
    // 외부 onChanged 콜백
    widget.onChanged?.call(formatted);
  }
  
  Future<void> _validateBusinessNumber() async {
    final businessNumber = widget.controller.text;
    if (businessNumber.replaceAll('-', '').length != 10) return;
    
    await ref.read(businessValidationProvider.notifier)
        .validateBusinessNumber(businessNumber);
  }
  
  @override
  Widget build(BuildContext context) {
    final validationState = widget.showValidationButton 
        ? ref.watch(businessValidationProvider) 
        : null;
    
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
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
            LengthLimitingTextInputFormatter(12),
          ],
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: Icon(
              Icons.business_center_rounded,
              size: 28,
              color: widget.enabled 
                  ? AppColors.textSecondary 
                  : AppColors.disabled,
            ),
            suffixIcon: widget.showValidationButton 
                ? _buildSuffixIcon(validationState) 
                : null,
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
          validator: widget.validator ?? Validators.validateBusinessNumber,
          onChanged: _onChanged,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: (_) => widget.onFieldSubmitted?.call(),
        ),
        
        if (validationState?.errorMessage != null) ...[
          AppSpacing.v8,
          validationState!.errorMessage!.text
            .textStyle(AppTextStyles.bodySmall)
            .color(AppColors.error)
            .make()
            .px(AppSpacing.md),
        ],
      ],
    );
  }
  
  Widget? _buildSuffixIcon(BusinessValidationState? state) {
    if (state == null) return null;
    
    if (state.isValidating) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ).p(AppSpacing.sm);
    }
    
    if (state.isValid == true) {
      return Icon(
        Icons.check_circle,
        color: AppColors.success,
        size: 28,
      );
    }
    
    if (state.isValid == false) {
      return Icon(
        Icons.error,
        color: AppColors.error,
        size: 28,
      );
    }
    
    return TextButton(
      onPressed: _validateBusinessNumber,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
      child: '확인'.text
        .textStyle(AppTextStyles.button)
        .color(AppColors.primary)
        .make(),
    );
  }
}