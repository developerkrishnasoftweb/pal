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
import 'Constant/userdata.dart';
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
  SharedPreferences sharedPreference = await SharedPreferences.getInstance();
  if (sharedPreference.getString("username") != null &&
      sharedPreference.getString(UserParams.password) != null) {
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
      userdata = Userdata(
          name: data[0][UserParams.name],
          pinCode: data[0][UserParams.pinCode],
          state: data[0][UserParams.state],
          city: data[0][UserParams.city],
          mobile: data[0][UserParams.mobile],
          image: data[0][UserParams.image],
          address: data[0][UserParams.address],
          adhaar: data[0][UserParams.adhaar],
          altMobile: data[0][UserParams.altMobile],
          anniversary: data[0][UserParams.anniversary],
          area: data[0][UserParams.area],
          dob: data[0][UserParams.dob],
          maritalStatus: data[0][UserParams.maritalStatus],
          email: data[0][UserParams.email],
          gender: data[0][UserParams.gender] != null &&
                  data[0][UserParams.gender] != ""
              ? data[0][UserParams.gender]
              : "m",
          branchCode: data[0][UserParams.branchCode],
          branchName: data[0][UserParams.branchName],
          id: data[0][UserParams.id],
          membershipSeries: data[0][UserParams.membershipSeries],
          memDetNo: data[0][UserParams.memDetNo],
          password: data[0][UserParams.password],
          point: data[0][UserParams.point],
          status: data[0][UserParams.status],
          token: data[0][UserParams.token],
          totalOrder: data[0][UserParams.totalOrder],
          vehicleType: data[0][UserParams.vehicleType],
          kyc: data[0][UserParams.kyc]);
    }
  }
}
