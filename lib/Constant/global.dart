import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SERVICES/urls.dart';
import 'userdata.dart';

SharedPreferences sharedPreferences;
Userdata userdata;
Locale appLocale;

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

Widget wallet({Color color}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: color ?? Colors.white,
                ),
                alignment: PlaceholderAlignment.middle),
            TextSpan(
                text: "\t" +
                    "${userdata != null ? userdata.point != null ? double.parse(userdata.point).round() : "0" : "0"}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: color ?? Colors.white))
          ],
        ),
      ),
    ),
  );
}