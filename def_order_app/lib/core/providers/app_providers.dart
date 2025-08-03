import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/supabase_service.dart';
import '../services/local_storage_service.dart';
import '../utils/logger.dart';

/// 앱 전역 Provider 설정
/// 
/// 이 파일은 앱 전체에서 사용되는 핵심 Provider들을 정의합니다.
/// 모든 Provider는 여기서 중앙 집중식으로 관리됩니다.

// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized before use');
});

// LocalStorage Service Provider
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

// Logger Provider
final loggerProvider = Provider<Logger>((ref) {
  return Logger();
});

// Connectivity Provider
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged;
});

// 네트워크 연결 상태 Provider
final isConnectedProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.maybeWhen(
    data: (result) => result != ConnectivityResult.none,
    orElse: () => true,
  );
});

// 앱 초기화 상태 Provider
final appInitializationProvider = FutureProvider<void>((ref) async {
  // Supabase 초기화 확인
  final supabaseService = ref.watch(supabaseServiceProvider);
  
  // 로컬 저장소 초기화 확인
  final localStorage = ref.watch(localStorageServiceProvider);
  
  // 기타 초기화 작업
  await Future.delayed(const Duration(milliseconds: 500)); // 스플래시 화면 표시 시간
});

// 앱 설정 Provider
class AppSettings {
  final bool isDarkMode;
  final String locale;
  final bool isPushEnabled;
  final bool isAutoLoginEnabled;
  
  const AppSettings({
    this.isDarkMode = false,
    this.locale = 'ko',
    this.isPushEnabled = true,
    this.isAutoLoginEnabled = true,
  });
  
  AppSettings copyWith({
    bool? isDarkMode,
    String? locale,
    bool? isPushEnabled,
    bool? isAutoLoginEnabled,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      locale: locale ?? this.locale,
      isPushEnabled: isPushEnabled ?? this.isPushEnabled,
      isAutoLoginEnabled: isAutoLoginEnabled ?? this.isAutoLoginEnabled,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'locale': locale,
      'isPushEnabled': isPushEnabled,
      'isAutoLoginEnabled': isAutoLoginEnabled,
    };
  }
  
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] ?? false,
      locale: json['locale'] ?? 'ko',
      isPushEnabled: json['isPushEnabled'] ?? true,
      isAutoLoginEnabled: json['isAutoLoginEnabled'] ?? true,
    );
  }
}

// 앱 설정 State Notifier
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final LocalStorageService _localStorage;
  
  static const String _settingsKey = 'app_settings';
  
  AppSettingsNotifier(this._localStorage) : super(const AppSettings()) {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final settingsJson = await _localStorage.getJson(_settingsKey);
    if (settingsJson != null) {
      state = AppSettings.fromJson(settingsJson);
    }
  }
  
  Future<void> _saveSettings() async {
    await _localStorage.saveJson(_settingsKey, state.toJson());
  }
  
  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
    _saveSettings();
  }
  
  void setLocale(String locale) {
    state = state.copyWith(locale: locale);
    _saveSettings();
  }
  
  void togglePushNotifications() {
    state = state.copyWith(isPushEnabled: !state.isPushEnabled);
    _saveSettings();
  }
  
  void toggleAutoLogin() {
    state = state.copyWith(isAutoLoginEnabled: !state.isAutoLoginEnabled);
    _saveSettings();
  }
}

// 앱 설정 Provider
final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return AppSettingsNotifier(localStorage);
});

// 편의 Provider들
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(appSettingsProvider).isDarkMode;
});

final currentLocaleProvider = Provider<String>((ref) {
  return ref.watch(appSettingsProvider).locale;
});

final isPushEnabledProvider = Provider<bool>((ref) {
  return ref.watch(appSettingsProvider).isPushEnabled;
});

// 앱 상태 관리를 위한 전역 Provider
enum AppLifecycleState {
  resumed,
  inactive,
  paused,
  detached,
}

class AppLifecycleNotifier extends StateNotifier<AppLifecycleState> {
  AppLifecycleNotifier() : super(AppLifecycleState.resumed);
  
  void updateState(AppLifecycleState newState) {
    state = newState;
  }
}

final appLifecycleProvider = StateNotifierProvider<AppLifecycleNotifier, AppLifecycleState>((ref) {
  return AppLifecycleNotifier();
});