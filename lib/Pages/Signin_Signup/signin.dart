import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_register_background.png"),
            fit: BoxFit.fill,
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/images/pal-logo.png"),
                height: 200,
                width: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
