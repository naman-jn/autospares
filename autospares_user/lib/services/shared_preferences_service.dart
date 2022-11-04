import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<void> setStringValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getStringValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? dataJson = prefs.getString(key);
    return dataJson;
  }

  Future<void> setBoolValue(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool?> getBoolValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool? isPermissionGranted = prefs.getBool(key);
    return isPermissionGranted;
  }

  Future<bool> removeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool isRemoved = await prefs.remove(key);
    return isRemoved;
  }
}
