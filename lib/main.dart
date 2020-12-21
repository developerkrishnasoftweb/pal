import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal/Constant/userdata.dart';
import 'package:pal/Pages/SIGNIN_SIGNUP/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/HOME/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  getCredential().then((status) {
    runApp(MaterialApp(
      title: 'PAL',
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  status ? Home() : SignIn(),
      debugShowCheckedModeBanner: false,
    ));
  });
}

Future<bool> getCredential() async {
  SharedPreferences sharedPreference = await SharedPreferences.getInstance();
  if (sharedPreference.getString("username") != null && sharedPreference.getString(UserParams.password) != null)
    return true;
  else
    return false;
}