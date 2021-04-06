import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models.dart';

SharedPreferences sharedPreferences;
Userdata userdata;
Config config;
Locale appLocale;
const String API_KEY = "0imfnc8mVLWwsAawjYr4Rx";
const String mandatoryChar = "*";
const String lastNotificationId = "last_notification_id";
const String APP_URL =
    "https://play.google.com/store/apps/details?id=com.palgeneralstore.customer";
const String APK_VERSION = "2.0.3";

extension RandomInt on int {
  static int generate({int min = 1000, int max = 9999}) {
    final _random = Random();
    return min + _random.nextInt(max - min);
  }
}

Map<String, dynamic> SMS_DATA({String mobile, String message}) {
  return {
    'SenderId': 'PALDEP',
    'Is_Unicode': 'false',
    'MobileNumbers': mobile,
    'ClientId': '54a91a69-16cd-4dac-a172-760ba08698b4',
    'Message': Uri.encodeComponent('<#> $message')
  };
}

String removeHtmlTags({String data: "N/A"}) {
  RegExp regExp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return data
          .replaceAll(regExp, "")
          .replaceAll("&nbsp;", " ")
          .replaceAll("&amp;", "&")
          .replaceAll("&quot;", "\"") ??
      "N/A";
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
                    "${userdata?.point != null ? double.parse(userdata.point).round() : "0"}",
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

getUpdatedVersion({@required BuildContext context}) async {
  if (config?.customerVersion != null) {
    if (config.customerVersion != APK_VERSION) {
      showDialog<Widget>(
          barrierDismissible: true,
          context: context,
          builder: (_) => WillPopScope(
                onWillPop: () => Future.value(false),
                child: AlertDialog(
                  title: Text("New Update Available",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Text(
                      "There is a newer version of app available please update it now"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => SystemNavigator.pop(),
                        child: Text("NO THANKS",
                            style: TextStyle(color: Colors.grey))),
                    TextButton(onPressed: update, child: Text("UPDATE"))
                  ],
                ),
              ));
    }
  } else {
    await Services.getConfig();
    getUpdatedVersion(context: context);
  }
}

void update() async {
  if (await canLaunch(APP_URL)) {
    await launch(APP_URL);
    SystemNavigator.pop();
  } else
    Fluttertoast.showToast(msg: "Unable to open play store");
}
