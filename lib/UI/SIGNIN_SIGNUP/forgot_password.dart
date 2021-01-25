import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/page_route.dart';
import '../../Common/textinput.dart';
import '../../Constant/color.dart';
import '../../Constant/global.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import '../../UI/SIGNIN_SIGNUP/otp.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String mobile = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Forgot Password"),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image:
                    AssetImage("assets/images/login_register_background.png"),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Image(
              image: AssetImage("assets/images/message.png"),
              height: 200,
              width: 200,
            ),
            input(
                style: TextStyle(fontSize: 17),
                autoFocus: true,
                context: context,
                text: "Mobile Number",
                onChanged: (value) {
                  setState(() {
                    mobile = value;
                  });
                },
                keyboardType: TextInputType.number,
                onEditingComplete: _forgotPassword,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: border(),
                )),
            SizedBox(
              height: 40,
            ),
            customButton(
                context: context,
                onPressed: isLoading ? null : _forgotPassword,
                text: isLoading ? null : "GET OTP",
                height: 65,
                child: isLoading
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(primaryColor),
                        ),
                      )
                    : null,
                width: size.width),
          ],
        ),
      ),
    );
  }

  _forgotPassword() async {
    if (mobile.isNotEmpty &&
        RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(mobile)) {
      setState(() {
        isLoading = true;
      });
      String otp = RandomInt.generate().toString();
      FormData smsData = FormData.fromMap({
        "user": Urls.user,
        "password": Urls.password,
        "msisdn": mobile,
        "sid": Urls.sID,
        "msg": "<#> " +
            otp +
            " is your OTP to Sign-Up to PAL App. Don't share it with anyone.",
        "fl": Urls.fl,
        "gwid": Urls.gwID
      });
      await Services.sms(smsData).then((value) {
        if (value.response == "000") {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
          Navigator.push(
              context,
              CustomPageRoute(
                  widget: OTP(
                otp: otp,
                onlyCheckOtp: true,
                mobile: mobile,
              )));
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: value.message);
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Please enter valid mobile number");
    }
  }
}
