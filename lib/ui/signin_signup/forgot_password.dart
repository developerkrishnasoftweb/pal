import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/custom_button.dart';
import '../../ui/widgets/page_route.dart';
import '../../ui/widgets/textinput.dart';
import '../../ui/widgets/appbar.dart';
import '../../constant/global.dart';
import '../../services/services.dart';

import 'otp.dart';

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
      //TODO: Add to locale strings
      appBar: appBar(
          context: context,
          title: translate(context, LocaleStrings.forgotPassword)),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
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
                text: translate(context, LocaleStrings.mobileNo),
                onChanged: (value) {
                  setState(() {
                    mobile = value;
                  });
                },
                keyboardType: TextInputType.number,
                onEditingComplete: _forgotPassword),
            SizedBox(
              height: 40,
            ),
            customButton(
                context: context,
                onPressed: isLoading ? null : _forgotPassword,
                text:
                    isLoading ? null : translate(context, LocaleStrings.getOTP),
                child: isLoading
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: circularProgressIndicator(),
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
      FormData smsData = SMS_DATA(
          message: otp +
              " is your OTP to Change Your Password to PAL App. Don't share it with anyone.",
          mobile: mobile);
      await Services.sms(
                  "<#> $otp is your OTP to Change Your Password to PAL App. Don't share it with anyone.",
              mobile)
          .then((value) {
        if (value.response == "0") {
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(
              context,
              CustomPageRoute(
                  widget: OTP(
                otp: otp,
                action: OtpActions.FORGOT_PASSWORD,
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
      Fluttertoast.showToast(
          msg: translate(context, LocaleStrings.pleaseEnterValidMobileNo));
    }
  }
}
