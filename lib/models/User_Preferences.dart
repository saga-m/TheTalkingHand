import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setToken(String token) async => await _preferences.setString('userToken', token);

  static String? getToken() => _preferences.getString('userToken');
}