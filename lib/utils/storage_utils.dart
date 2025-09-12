import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储工具类
class StorageUtils {
  static SharedPreferences? _prefs;

  /// 初始化
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 保存字符串
  static Future<bool> setString(String key, String value) async {
    await init();
    return _prefs!.setString(key, value);
  }

  /// 获取字符串
  static Future<String?> getString(String key) async {
    await init();
    return _prefs!.getString(key);
  }

  /// 保存整数
  static Future<bool> setInt(String key, int value) async {
    await init();
    return _prefs!.setInt(key, value);
  }

  /// 获取整数
  static Future<int?> getInt(String key) async {
    await init();
    return _prefs!.getInt(key);
  }

  /// 保存布尔值
  static Future<bool> setBool(String key, bool value) async {
    await init();
    return _prefs!.setBool(key, value);
  }

  /// 获取布尔值
  static Future<bool?> getBool(String key) async {
    await init();
    return _prefs!.getBool(key);
  }

  /// 保存双精度浮点数
  static Future<bool> setDouble(String key, double value) async {
    await init();
    return _prefs!.setDouble(key, value);
  }

  /// 获取双精度浮点数
  static Future<double?> getDouble(String key) async {
    await init();
    return _prefs!.getDouble(key);
  }

  /// 保存字符串列表
  static Future<bool> setStringList(String key, List<String> value) async {
    await init();
    return _prefs!.setStringList(key, value);
  }

  /// 获取字符串列表
  static Future<List<String>?> getStringList(String key) async {
    await init();
    return _prefs!.getStringList(key);
  }

  /// 保存对象(JSON序列化)
  static Future<bool> setObject(String key, Map<String, dynamic> value) async {
    await init();
    return _prefs!.setString(key, jsonEncode(value));
  }

  /// 获取对象(JSON反序列化)
  static Future<Map<String, dynamic>?> getObject(String key) async {
    await init();
    final String? jsonString = _prefs!.getString(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// 删除指定key的数据
  static Future<bool> remove(String key) async {
    await init();
    return _prefs!.remove(key);
  }

  /// 清空所有数据
  static Future<bool> clear() async {
    await init();
    return _prefs!.clear();
  }

  /// 检查是否包含指定key
  static Future<bool> containsKey(String key) async {
    await init();
    return _prefs!.containsKey(key);
  }

  /// 获取所有key
  static Future<Set<String>> getKeys() async {
    await init();
    return _prefs!.getKeys();
  }
}
