import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pal/LOCALIZATION/localizations_constraints.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constant/color.dart';
import 'Constant/global.dart';
import 'Constant/models.dart';
import 'LOCALIZATION/localization.dart';
import 'SERVICES/services.dart';
import 'UI/HOME/home.dart';
import 'UI/SIGNIN_SIGNUP/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  await Services.getConfig();
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
}

Future<bool> getCredential() async {
  if (sharedPreferences.getString(UserParams.userData) != null) {
    await setData();
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
