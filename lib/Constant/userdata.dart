import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserParams{
  static String id = "id";
  static String name = "name";
  static String mobile = "mobile";
  static String email = "email";
  static String gender = "gender";
  static String image = "image";
  static String status = "status";
  static String point = "point";
  static String token = "token";
  static String password = "password";
}
Future<void> userData(List<dynamic> data) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(UserParams.name, data[0][UserParams.name]);
  sharedPreferences.setString(UserParams.mobile, data[0][UserParams.mobile]);
  sharedPreferences.setString(UserParams.email, data[0][UserParams.email]);
  sharedPreferences.setString(UserParams.image, data[0][UserParams.image]);
  sharedPreferences.setString(UserParams.gender, data[0][UserParams.gender]);
  sharedPreferences.setString(UserParams.point, data[0][UserParams.point]);
  sharedPreferences.setString(UserParams.status, data[0][UserParams.status]);
  sharedPreferences.setString(UserParams.token, data[0][UserParams.token]);
  sharedPreferences.setString(UserParams.id, data[0][UserParams.id]);
  sharedPreferences.setString("userdata", jsonEncode(data));
}