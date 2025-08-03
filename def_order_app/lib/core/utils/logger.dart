import 'dart:developer' as developer;

/// 간단한 로거 클래스
class Logger {
  final String name;
  
  Logger(this.name);
  
  /// 정보 레벨 로그
  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: name,
      level: 800,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// 경고 레벨 로그
  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: name,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// 에러 레벨 로그
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// 디버그 레벨 로그
  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: name,
      level: 500,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// 기본 로거 인스턴스
final logger = Logger('DefOrderApp');