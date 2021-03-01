import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

SharedPreferences sharedPreferences;
Userdata userdata;
Config config;
Locale appLocale;

extension RandomInt on int {
  static int generate({int min = 1000, int max = 9999}) {
    final _random = Random();
    return min + _random.nextInt(max - min);
  }
}

FormData SMS_DATA({String mobile, String message}) {
  return FormData.fromMap({
    "user": config.smsUserName,
    "password": config.smsPassword,
    "msisdn": mobile,
    "sid": config.smsSenderId,
    "msg": "<#> $message",
    "fl": config.smsFL,
    "gwid": config.smsGwID
  });
}

String removeHtmlTags({String data : "N/A"}) {
  RegExp regExp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return data
      .replaceAll(regExp, "")
      .replaceAll("&nbsp;", " ")
      .replaceAll("&amp;", "&")
      .replaceAll("&quot;", "\"") ?? "N/A";
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
