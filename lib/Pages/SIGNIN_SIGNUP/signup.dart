import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/page_route.dart';
import '../../Common/textinput.dart';
import '../../Constant/color.dart';
import '../../Pages/SIGNIN_SIGNUP/otp.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool terms = false;
  bool signUpStatus = false;
  String fullName = "", email = "", mobile = "", password = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: size.width,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 25,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: size.width,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Let's get start!",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Color(0xff000000),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: size.width,
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: Text(
                  "Create an account on to use all the features",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Color(0xffA8A8A8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              input(
                  context: context,
                  decoration: InputDecoration(
                    contentPadding: AppTextFieldDecoration.textFieldPadding,
                    border: border(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      fullName = value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  text: "Full Name"),
              input(
                  context: context,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: AppTextFieldDecoration.textFieldPadding,
                    border: border(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  text: "Email"),
              input(
                  context: context,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: AppTextFieldDecoration.textFieldPadding,
                    border: border(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      mobile = value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  text: "Mobile No."),
              input(
                  context: context,
                  decoration: InputDecoration(
                    contentPadding: AppTextFieldDecoration.textFieldPadding,
                    border: border(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  onEditingComplete: _signUp,
                  obscureText: true,
                  text: "Password"),
              Container(
                width: size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                alignment: Alignment.centerLeft,
                child: CheckboxListTile(
                    value: terms,
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "By signing up, you agree to our terms & policy",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Color(0xffa8a8a8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    onChanged: (value) {
                      setState(() {
                        terms = !terms;
                      });
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              customButton(
                  context: context,
                  onPressed: !signUpStatus ? _signUp : null,
                  height: 55,
                  child: signUpStatus
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                          ),
                        )
                      : Text(
                          "Sign Up",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Color(0xffffffff),
                                fontSize: 18,
                              ),
                        )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: RichText(
                  text: TextSpan(
                      text: "Already have an account?\t",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Color(0xffa8a8a8),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: [
                        WidgetSpan(
                            child: GestureDetector(
                          child: Text(
                            "Sign In",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.pop(context);
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
  _signUp() async {
    if (fullName != "" &&
        email != "" &&
        mobile != "" &&
        password != "") {
      if (terms) {
        if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email)) {
          if (RegExp(r"^(?:[+0]9)?[0-9]{10}$")
              .hasMatch(mobile)) {
            String otp = RandomInt.generate().toString();
            setState(() => signUpStatus = true);
            String firstName, lastName;
            if (fullName.split(" ").length >= 2) {
              firstName = fullName.split(" ")[0];
              lastName = fullName.split(" ")[1];
              print(firstName + lastName);
            } else
              firstName = fullName;
            FormData userData = FormData.fromMap({
              "name": fullName,
              "email": email,
              "mobile": mobile,
              "gender": "male",
              "password": password,
              "token" : "1234",
              "api_key" : Urls.apiKey
            });
            FormData smsData = FormData.fromMap({
              "user" : Urls.user,
              "password" : Urls.password,
              "msisdn" : mobile,
              "sid" : Urls.sID,
              "msg" : "<#> "+ otp +" is your OTP to Sign-Up to PAL App. Don't share it with anyone.",
              "fl" : Urls.fl,
              "gwid" : Urls.gwID
            });
            Services.sms(smsData).then((value) {
              if(value.response == "000"){
                setState(() => signUpStatus = false);
                Navigator.push(context, CustomPageRoute(widget: OTP(otp: otp, formData: userData,)));
              } else {
                setState(() => signUpStatus = false);
                Fluttertoast.showToast(msg: value.message);
              }
            });
          } else {
            Fluttertoast.showToast(msg: "Invalid Mobile");
          }
        } else {
          Fluttertoast.showToast(msg: "Invalid Email");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please check terms & conditions");
      }
    } else {
      Fluttertoast.showToast(msg: "All fields are required!");
    }
  }
}
extension RandomInt on int {
  static int generate({int min = 1000, int max = 9999}){
    final _random = Random();
    return min + _random.nextInt(max - min);
  }
}