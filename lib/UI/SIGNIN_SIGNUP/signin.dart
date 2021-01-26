import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/UI/HOME/home.dart';

import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/page_route.dart';
import '../../Common/textinput.dart';
import '../../Constant/color.dart';
import '../../Constant/global.dart';
import '../../Constant/userdata.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import '../../UI/SIGNIN_SIGNUP/forgot_password.dart';
import '../../UI/SIGNIN_SIGNUP/signup.dart';
import '../../main.dart';

class SignIn extends StatefulWidget {
  final String email;
  SignIn({this.email});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLogging = false;
  String username = "", password = "", token = "";
  TextEditingController emailController = TextEditingController();
  FocusNode myFocusNode;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    setState(() {
      emailController.text = username = widget.email ?? "";
    });
    myFocusNode = FocusNode();
    if (widget.email != null) {
      myFocusNode.requestFocus();
    }
    firebaseCloudMessagingListeners();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) iOSPermission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((token) {
      setState(() {
        this.token = token;
      });
    });
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/login_register_background.png"),
          fit: BoxFit.fill,
        )),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30, left: 20, right: 20),
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/images/pal-logo.png"),
                height: 200,
                width: 200,
              ),
              input(
                  context: context,
                  style: TextStyle(fontSize: 17),
                  text: "User Name",
                  autoFocus: true,
                  keyboardType: TextInputType.emailAddress,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                      contentPadding: AppTextFieldDecoration.textFieldPadding,
                      border: border())),
              input(
                  context: context,
                  style: TextStyle(fontSize: 17),
                  text: "Password",
                  obscureText: true,
                  onEditingComplete: _signIn,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  focusNode: myFocusNode,
                  decoration: InputDecoration(
                      contentPadding: AppTextFieldDecoration.textFieldPadding,
                      border: border())),
              Align(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, CustomPageRoute(widget: ForgotPassword()));
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
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                    ),
                  ),
                  height: 65,
                  width: size.width),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: RichText(
                  text: TextSpan(
                      text: "Don't have an account?\t",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Color(0xffa8a8a8),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: [
                        WidgetSpan(
                            child: GestureDetector(
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                                context, CustomPageRoute(widget: SignUp()));
                          },
                        ))
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLogging = true;
    });
    if (username.isNotEmpty && password.isNotEmpty) {
      if (token.isEmpty) firebaseCloudMessagingListeners();
      FormData formData = FormData.fromMap({
        "username": username,
        "password": password,
        "api_key": Urls.apiKey,
        "token": token
      });
      Services.signIn(formData).then((result) async {
        if (result.response == "y") {
          setState(() {
            isLogging = false;
          });
          await sharedPreferences.setString(
              UserParams.userData, jsonEncode(result.data));
          await sharedPreferences.setString("username", username);
          await sharedPreferences.setString(
              UserParams.password, result.data[0][UserParams.password]);
          await setData();
          if (userdata != null) {
            Fluttertoast.showToast(msg: result.message);
            Navigator.pushAndRemoveUntil(
                context, CustomPageRoute(widget: Home()), (route) => false);
          } else {
            Fluttertoast.showToast(msg: Services.errorMessage);
          }
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
