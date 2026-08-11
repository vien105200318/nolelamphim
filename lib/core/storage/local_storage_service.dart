import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

class LocalStorageService {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<Map<String, dynamic>>> readList(String key) async {
    final prefs = await _prefs;
    final raw = prefs.getString(key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> writeList(String key, List<Map<String, dynamic>> items) async {
    final prefs = await _prefs;
    await prefs.setString(key, jsonEncode(items));
  }

  Future<List<String>> readStringList(String key) async {
    final prefs = await _prefs;
    final raw = prefs.getString(key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>).cast<String>();
  }

  Future<void> writeStringList(String key, List<String> items) async {
    final prefs = await _prefs;
    await prefs.setString(key, jsonEncode(items));
  }

  Future<Map<String, dynamic>> readMap(String key) async {
    final prefs = await _prefs;
    final raw = prefs.getString(key);
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> writeMap(String key, Map<String, dynamic> map) async {
    final prefs = await _prefs;
    await prefs.setString(key, jsonEncode(map));
  }
}
