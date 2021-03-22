import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constant/color.dart';
import 'constant/global.dart';
import 'constant/models.dart';
import 'constant/strings.dart';
import 'localization/localization.dart';
import 'localization/localizations_constraints.dart';
import 'services/services.dart';
import 'ui/home/home.dart';
import 'ui/signin_signup/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  appLocale = await getLocale();
  await getCredential().then((status) {
    runApp(MaterialApp(
      title: 'PAL',
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: appLocale,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('pa', 'IN'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (deviceLocale, supportedLocale) {
        for (var locale in supportedLocale) {
          if (locale.languageCode == deviceLocale.languageCode &&
              locale.countryCode == deviceLocale.countryCode) {
            return deviceLocale;
          }
        }
        return supportedLocale.first;
      },
      home: status ? Home() : SignIn(),
      debugShowCheckedModeBanner: false,
    ));
  });
  // await Services.getConfig();
}

Future<bool> getCredential() async {
  if (sharedPreferences.getString(UserParams.userData) != null) {
    await setData();
    await Services.getUserData();
    return true;
  } else
    return false;
}

/*
* set userdata
* */
Future<void> setData() async {
  List data = await jsonDecode(
      sharedPreferences.getString(UserParams.userData) ?? "[{}]");
  if (data != null) {
    if (data.length > 0) {
      userdata = Userdata.fromJSON(data[0]);
    }
  }
}
