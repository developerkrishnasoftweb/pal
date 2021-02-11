import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

SharedPreferences sharedPreferences;
Userdata userdata;
Config config;
Locale appLocale;
String SMS_USERNAME;
String SMS_PASSWORD;
String SMS_SENDERID;
String SMS_FL;
String SMS_GWID;

extension RandomInt on int {
  static int generate({int min = 1000, int max = 9999}) {
    final _random = Random();
    return min + _random.nextInt(max - min);
  }
}

FormData SMSDATA({String mobile, String message}) {
  return FormData.fromMap({
    "user": SMS_USERNAME,
    "password": SMS_PASSWORD,
    "msisdn": mobile,
    "sid": SMS_SENDERID,
    "msg": "<#> $message",
    "fl": SMS_FL,
    "gwid": SMS_GWID
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

class GiftData {
  final String specs, rating, points, desc, image, title, id;
  GiftData(
      {this.id,
      this.title,
      this.image,
      this.points,
      this.desc,
      this.specs,
      this.rating});
}
