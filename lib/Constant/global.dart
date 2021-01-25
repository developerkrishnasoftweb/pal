import 'dart:math';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SERVICES/urls.dart';
import 'userdata.dart';

SharedPreferences sharedPreferences;
Userdata userdata;

extension RandomInt on int {
  static int generate({int min = 1000, int max = 9999}) {
    final _random = Random();
    return min + _random.nextInt(max - min);
  }
}

FormData SMSDATA({String mobile, String message}) {
  return FormData.fromMap({
    "user": Urls.user,
    "password": Urls.password,
    "msisdn": mobile,
    "sid": Urls.sID,
    "msg": "<#> $message",
    "fl": Urls.fl,
    "gwid": Urls.gwID
  });
}
