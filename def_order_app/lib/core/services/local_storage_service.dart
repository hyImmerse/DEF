import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 로컬 저장소 서비스
/// 
/// SharedPreferences를 래핑하여 타입 안전한 로컬 저장소 접근을 제공합니다.
class LocalStorageService {
  final SharedPreferences _prefs;
  
  LocalStorageService(this._prefs);
  
  /// String 값 저장
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }
  
  /// String 값 읽기
  String? getString(String key) {
    return _prefs.getString(key);
  }
  
  /// int 값 저장
  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }
  
  /// int 값 읽기
  int? getInt(String key) {
    return _prefs.getInt(key);
  }
  
  /// bool 값 저장
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }
  
  /// bool 값 읽기
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }
  
  /// double 값 저장
  Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }
  
  /// double 값 읽기
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }
  
  /// JSON 객체 저장
  Future<bool> saveJson(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    return await _prefs.setString(key, jsonString);
  }
  
  /// JSON 객체 읽기
  Map<String, dynamic>? getJson(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
  
  /// 특정 키 삭제
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }
  
  /// 모든 데이터 삭제
  Future<bool> clear() async {
    return await _prefs.clear();
  }
  
  /// 키 존재 여부 확인
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
  
  /// 모든 키 목록
  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}

/// LocalStorage Service Provider
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('LocalStorageService must be overridden in main.dart');
});