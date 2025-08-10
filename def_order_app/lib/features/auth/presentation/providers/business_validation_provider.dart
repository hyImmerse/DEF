import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/services/auth_service.dart';
import '../../../../core/utils/validators.dart';

part 'business_validation_provider.g.dart';

// 사업자번호 검증 상태
class BusinessValidationState {
  final bool isValidating;
  final bool? isValid;
  final String? businessName;
  final String? errorMessage;
  
  const BusinessValidationState({
    this.isValidating = false,
    this.isValid,
    this.businessName,
    this.errorMessage,
  });
  
  BusinessValidationState copyWith({
    bool? isValidating,
    bool? isValid,
    String? businessName,
    String? errorMessage,
  }) {
    return BusinessValidationState(
      isValidating: isValidating ?? this.isValidating,
      isValid: isValid ?? this.isValid,
      businessName: businessName ?? this.businessName,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class BusinessValidation extends _$BusinessValidation {
  late final AuthService _authService;
  
  @override
  BusinessValidationState build() {
    _authService = ref.watch(authServiceProvider);
    return const BusinessValidationState();
  }
  
  // 사업자번호 검증
  Future<void> validateBusinessNumber(String businessNumber) async {
    // 초기화
    state = const BusinessValidationState(isValidating: true);
    
    // 데모 모드 체크
    const isDemoMode = String.fromEnvironment('IS_DEMO', defaultValue: 'true') == 'true';
    
    // 로컬 형식 검증
    final localValidation = Validators.validateBusinessNumber(businessNumber);
    if (localValidation != null) {
      state = BusinessValidationState(
        isValidating: false,
        isValid: false,
        errorMessage: localValidation,
      );
      return;
    }
    
    try {
      if (isDemoMode) {
        // 데모 모드에서는 가짜 검증 성공 응답
        await Future.delayed(const Duration(milliseconds: 500)); // 실제 API 호출처럼 지연
        
        state = const BusinessValidationState(
          isValidating: false,
          isValid: true,
          businessName: '데모회사', // 가짜 회사명
          errorMessage: null,
        );
      } else {
        // 서버 검증 (프로덕션 모드)
        final result = await _authService.validateBusinessNumber(businessNumber);
        
        state = BusinessValidationState(
          isValidating: false,
          isValid: result['isValid'] as bool,
          businessName: result['businessName'] as String?,
          errorMessage: result['error'] as String?,
        );
      }
    } catch (e) {
      state = BusinessValidationState(
        isValidating: false,
        isValid: false,
        errorMessage: '사업자번호 검증 중 오류가 발생했습니다',
      );
    }
  }
  
  // 상태 초기화
  void reset() {
    state = const BusinessValidationState();
  }
}

// 사업자번호 포맷터
@riverpod
String formatBusinessNumber(FormatBusinessNumberRef ref, String input) {
  // 숫자만 추출
  final numbers = input.replaceAll(RegExp(r'[^0-9]'), '');
  
  // 최대 10자리
  final truncated = numbers.length > 10 ? numbers.substring(0, 10) : numbers;
  
  // 3-2-5 형식으로 포맷팅
  if (truncated.length <= 3) {
    return truncated;
  } else if (truncated.length <= 5) {
    return '${truncated.substring(0, 3)}-${truncated.substring(3)}';
  } else {
    return '${truncated.substring(0, 3)}-${truncated.substring(3, 5)}-${truncated.substring(5)}';
  }
}