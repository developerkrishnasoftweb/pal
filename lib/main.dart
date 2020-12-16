import 'package:flutter/material.dart';
import 'package:pal/Pages/Others/change_address.dart';
import 'package:pal/Pages/Others/complain.dart';
import 'package:pal/Pages/Others/earned_points.dart';
import 'package:pal/Pages/Others/kyc_details.dart';
import 'package:pal/Pages/Others/product_description.dart';
import 'package:pal/Pages/Others/redeem_gift.dart';

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
      home: EarnedPoints(),
    );
  }
}
