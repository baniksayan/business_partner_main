import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
    if (user.token != null) {
      await prefs.setString(_tokenKey, user.token!);
    }
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      return UserModel.fromJson(json.decode(userString));
    }
    return null;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    await prefs.remove(_isLoggedInKey);
  }
}
