import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/input_border.dart';
import 'package:pal/Common/page_route.dart';
import 'package:pal/Common/textinput.dart';
import 'package:pal/Constant/color.dart';
import 'package:pal/Pages/HOME/home.dart';
import 'package:pal/Pages/SIGNIN_SIGNUP/forgot_password.dart';
import 'package:pal/SERVICES/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLogging = false;
  String username = "", password = "";
  String getStoredUserName = "";
  void getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      getStoredUserName = sharedPreferences.getString("email") ?? "";
      username = getStoredUserName;
    });
  }
  @override
  void initState() {
    getUserName();
    super.initState();
  }

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
        )),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/images/pal-logo.png"),
                height: 200,
                width: 200,
              ),
              SizedBox(
                height: 50,
              ),
              input(
                  context: context,
                  style: TextStyle(fontSize: 17),
                  text: "User Name",
                  autoFocus: true,
                  keyboardType: TextInputType.emailAddress,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  onChanged: (value){
                    setState(() {
                      username = value;
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20), border: border())),
              input(
                  context: context,
                  style: TextStyle(fontSize: 17),
                  text: "Password",
                  obscureText: true,
                  onEditingComplete: _signIn,
                  onChanged: (value){
                    setState(() {
                      password = value;
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20), border: border())),
              Align(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, CustomPageRoute(widget: ForgotPassword()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Forgot Password?",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
              SizedBox(
                height: 30,
              ),
              customButton(
                  context: context,
                  onPressed: !isLogging ? () => _signIn() : null,
                  text: !isLogging ? "LOGIN" : null,
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.primaryColor),
                    ),
                  ),
                  height: 65,
                  width: size.width),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      isLogging = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(username.isNotEmpty && password.isNotEmpty){
      FormData formData = FormData.fromMap({
        "username" : username,
        "password" : password,
        "api_key" : "abc123"
      });
      await Services.signIn(formData).then((result) {
        if(result.response == "y"){
          setState(() {
            isLogging = false;
          });
          sharedPreferences.setString("userdata", jsonEncode(result.data));
          sharedPreferences.setString("email", result.data[0]["email"]);
          sharedPreferences.setString("mobile", result.data[0]["mobile"]);
          sharedPreferences.setString("password", result.data[0]["password"]);
          Navigator.pushAndRemoveUntil(context, CustomPageRoute(widget: Home()), (route) => false);
          Fluttertoast.showToast(msg: result.message);
        } else {
          setState(() {
            isLogging = false;
          });
          Fluttertoast.showToast(msg: result.message);
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Please enter username and password");
      setState(() {
        isLogging = false;
      });
    }
  }
}
