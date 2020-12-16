import 'package:flutter/material.dart';
import 'package:pal/Pages/Others/complain.dart';
import 'package:pal/Pages/Others/kyc_details.dart';
import 'package:pal/Pages/Others/product_description.dart';

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
      home: ProductDescription(),
    );
  }
}
