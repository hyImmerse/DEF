import 'package:flutter/material.dart';

class AppTheme {
  // 색상 정의
  static const Color primaryColor = Color(0xFF2196F3); // 파란색
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color errorColor = Color(0xFFB00020);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  
  // 40-60대 사용자를 위한 큰 폰트 사이즈
  static const double bodyLarge = 20.0;
  static const double bodyMedium = 18.0;
  static const double bodySmall = 16.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    
    // 텍스트 테마 - 40-60대 사용자를 위한 큰 글씨
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: headlineLarge,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: headlineMedium,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineSmall: TextStyle(
        fontSize: headlineSmall,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: bodyLarge,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: bodyMedium,
        color: Colors.black87,
      ),
      bodySmall: TextStyle(
        fontSize: bodySmall,
        color: Colors.black54,
      ),
      labelLarge: TextStyle(
        fontSize: bodyLarge,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // 앱바 테마
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
    
    // 버튼 테마 - 큰 버튼
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: bodyLarge,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    
    // 인풋 테마 - 큰 입력 필드
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: errorColor,
          width: 2,
        ),
      ),
      labelStyle: const TextStyle(
        fontSize: bodyMedium,
      ),
      hintStyle: TextStyle(
        fontSize: bodyMedium,
        color: Colors.grey[600],
      ),
    ),
    
    // 카드 테마
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    ),
    
    // 하단 네비게이션 테마
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
      ),
      type: BottomNavigationBarType.fixed,
    ),
  );
}