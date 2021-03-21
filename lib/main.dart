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
      home: status ? MyApp(child: Home()) : MyApp(child: SignIn()),
      debugShowCheckedModeBanner: false,
    ));
  });
}

class MyApp extends StatefulWidget {
  final Widget child;
  const MyApp({Key key, this.child}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double horizontalMargin = 35;
  Widget updateWidget;

  getUpdatedVersion() async {
    if (config.customerVersion == APK_VERSION) {
      setState(() {
        updateWidget = widget.child;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUpdatedVersion();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return updateWidget ?? Scaffold(
      backgroundColor: Colors.white.withOpacity(0.94),
      body: Center(
        child: Container(
          height: size.height * 0.3 > 150 ? size.height * 0.3 : 150,
          width: size.width,
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300], spreadRadius: 10, blurRadius: 10),
              ],
              borderRadius: BorderRadius.circular(7)),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(translate(context, LocaleStrings.palShoppie),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "New version is available, Please update your application",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text("NO THANKS",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey))),
                SizedBox(width: 10),
                TextButton(
                    onPressed: () async {
                      if (await canLaunch(APP_URL)) {
                        await launch(APP_URL);
                        SystemNavigator.pop();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Unable to open play store");
                      }
                    },
                    child: Text("UPDATE",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor))),
              ])
            ],
          ),
        ),
      ),
    );
  }
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
