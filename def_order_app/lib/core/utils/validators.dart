class Validators {
  // 사업자 번호 검증
  static String? validateBusinessNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '사업자 번호를 입력해주세요';
    }
    
    // 데모 모드에서는 검증 통과 (데모 촬영용)
    const isDemoMode = String.fromEnvironment('IS_DEMO', defaultValue: 'true') == 'true';
    if (isDemoMode) {
      // 기본 길이 검증만 수행 (10자리)
      final cleaned = value.replaceAll('-', '');
      if (cleaned.length != 10) {
        return '올바른 사업자 번호 형식이 아닙니다 (10자리)';
      }
      if (!RegExp(r'^\d{10}$').hasMatch(cleaned)) {
        return '숫자만 입력 가능합니다';
      }
      // 데모 모드에서는 형식만 맞으면 통과
      return null;
    }
    
    // 숫자와 하이픈만 허용
    final cleaned = value.replaceAll('-', '');
    if (cleaned.length != 10) {
      return '올바른 사업자 번호 형식이 아닙니다 (10자리)';
    }
    
    if (!RegExp(r'^\d{10}$').hasMatch(cleaned)) {
      return '숫자만 입력 가능합니다';
    }
    
    // 사업자 번호 검증 알고리즘 (프로덕션 모드에서만)
    final checksum = [1, 3, 7, 1, 3, 7, 1, 3, 5];
    int sum = 0;
    
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cleaned[i]) * checksum[i];
    }
    
    sum += (int.parse(cleaned[8]) * 5) ~/ 10;
    final result = (10 - (sum % 10)) % 10;
    
    if (result != int.parse(cleaned[9])) {
      return '유효하지 않은 사업자 번호입니다';
    }
    
    return null;
  }
  
  // 전화번호 검증
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '전화번호를 입력해주세요';
    }
    
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length < 10 || cleaned.length > 11) {
      return '올바른 전화번호 형식이 아닙니다';
    }
    
    if (!cleaned.startsWith('01')) {
      return '휴대폰 번호를 입력해주세요';
    }
    
    return null;
  }
  
  // 이메일 검증
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }
    
    return null;
  }
  
  // 주문 수량 검증
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return '수량을 입력해주세요';
    }
    
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return '숫자만 입력 가능합니다';
    }
    
    if (quantity <= 0) {
      return '1개 이상 입력해주세요';
    }
    
    return null;
  }
  
  // 필수 입력 검증
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName을(를) 입력해주세요';
    }
    return null;
  }
}