import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Constant/strings.dart';
import '../../LOCALIZATION/localizations_constraints.dart';
import '../../UI/HOME/home.dart';

import '../../Common/custom_button.dart';
import '../../Common/page_route.dart';
import '../../Common/textinput.dart';
import '../../Constant/color.dart';
import '../../Constant/global.dart';
import '../../Constant/models.dart';
import '../../SERVICES/services.dart';
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    setState(() {
      emailController.text = username = widget.email ?? "";
      userdata = null;
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
        showNotification(message);
    },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
    await _firebaseMessaging.subscribeToTopic('all');
    await _firebaseMessaging.getToken().then((token) {
      setState(() {
        this.token = token;
      });
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails('channel_id', 'CHANNEL NAME', 'channelDescription');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.show(Random().nextInt(100), msg["notification"]["title"], msg["notification"]["body"], platform);
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
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/images/pal-logo.png"),
                height: 280,
                width: 350,
                fit: BoxFit.fill,
              ),
              input(
                  context: context,
                  style: TextStyle(fontSize: 17),
                  text: translate(context, LocaleStrings.userName),
                  autoFocus: true,
                  keyboardType: TextInputType.emailAddress,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  controller: emailController),
              input(
                  context: context,
                  style: TextStyle(fontSize: 17),
                  text: translate(context, LocaleStrings.password),
                  obscureText: true,
                  onEditingComplete: _signIn,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  focusNode: myFocusNode),
              Align(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, CustomPageRoute(widget: ForgotPassword()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "${translate(context, LocaleStrings.forgotPassword)}?",
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
                  text: !isLogging
                      ? translate(context, LocaleStrings.login)
                      : null,
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                    ),
                  ),
                  height: 50,
                  width: size.width),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: RichText(
                  text: TextSpan(
                      text:
                          "${translate(context, LocaleStrings.donthaveAnAccount)}?\t",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Color(0xffa8a8a8),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: [
                        WidgetSpan(
                            child: GestureDetector(
                          child: Text(
                            translate(context, LocaleStrings.signUp),
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
        "api_key": API_KEY,
        "token": token
      });
      Services.signIn(formData).then((result) async {
        if (result.response == "y") {
          setState(() {
            isLogging = false;
          });
          await sharedPreferences.setString(
              UserParams.userData, jsonEncode(result.data));
          await setData();
          if (userdata != null) {
            Fluttertoast.showToast(msg: result.message);
            Navigator.pushAndRemoveUntil(
                context, CustomPageRoute(widget: Home()), (route) => false);
          } else {
            Fluttertoast.showToast(msg: "Something went wrong");
          }
        } else {
          setState(() {
            isLogging = false;
          });
          Fluttertoast.showToast(msg: result.message);
        }
      });
    } else {
      Fluttertoast.showToast(
          msg:
              translate(context, LocaleStrings.pleaseEnterUsernameAndPassword));
      setState(() {
        isLogging = false;
      });
    }
  }
}
