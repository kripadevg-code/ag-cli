import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized local storage service.
/// Wraps SharedPreferences to provide a unified, type-safe API.
class StorageService extends GetxService {
  static StorageService get find => Get.find<StorageService>();

  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ─── Authentication ───
  String? getToken() => _prefs.getString('token');
  Future<bool> setToken(String token) => _prefs.setString('token', token);
  Future<bool> clearToken() => _prefs.remove('token');

  // ─── Generic Typed Methods ───
  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  bool getBool(String key) => _prefs.getBool(key) ?? false;
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  List<String> getStringList(String key) => _prefs.getStringList(key) ?? [];
  Future<bool> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clear() => _prefs.clear();
}
