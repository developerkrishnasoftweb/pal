import 'package:flutter/material.dart';
import 'package:pal/Pages/Others/category.dart';
import 'package:pal/Pages/Others/product_demo.dart';
import 'package:pal/Pages/Others/service_request.dart';
import 'package:pal/Pages/Others/track_complaint.dart';
import 'package:pal/Pages/Others/weekly_update.dart';
import 'package:pal/Pages/Signin_Signup/forgot_password.dart';
import 'package:pal/Pages/Signin_Signup/signin.dart';
import 'Pages/Home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PAL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TrackComplaint(),
    );
  }
}
