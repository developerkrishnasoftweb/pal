import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/appbar.dart';
import '../../common/custom_button.dart';
import '../../common/page_route.dart';
import '../../common/show_dialog.dart';
import '../../constant/color.dart';
import '../../constant/global.dart';
import '../../constant/models.dart';
import '../../services/services.dart';
import '../../ui/home/home.dart';
import '../../ui/signin_signup/signin.dart';

import '../../main.dart';
import 'change_password.dart';


class OTP extends StatefulWidget {
  final String otp, mobile;
  final FormData formData;
  final OtpActions action;
  OTP({
    this.otp,
    this.formData,
    this.mobile,
    this.action,
  });
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  FocusNode textFocusNode = new FocusNode();
  String otp = "";
  bool isLoading = false;
  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //TODO: Add to locale strings
      appBar: appBar(context: context, title: "Enter OTP"),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "We have sent OTP ${widget.mobile != null ? "***" + widget.mobile.substring(6) : "."}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            width: size.width,
          ),
          Image(
            image: AssetImage("assets/images/message.png"),
            height: 200,
            width: 200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    buildOtpTextField(i),
                  ]
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
      floatingActionButton: customButton(
          context: context,
          onPressed: isLoading
              ? null
              : widget.action != null
                  ? _action
                  : null,
          width: size.width,
          text: !isLoading ? "SUBMIT" : null,
          child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _action() {
    if (widget.otp == this.otp) {
      switch (widget.action) {
        case OtpActions.REGISTER:
          _register();
          break;
        case OtpActions.FORGOT_PASSWORD:
          _forgotPassword();
          break;
        case OtpActions.REDEEM_GIFT:
          _redeemGift();
          break;
        default:
          print("Action can't be null");
          break;
      }
    } else {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
  }

  _redeemGift() async {
    FocusScope.of(context).unfocus();
    if (widget.otp == otp) {
      if (widget.formData != null) {
        setLoading(true);
        await Services.redeemGift(widget.formData).then((value) async {
          if (value.response == "y") {
            await sharedPreferences.setString(
                UserParams.userData, jsonEncode(value.data[0]["customer"]));
            await setData();
            setLoading(false);
            var dialogStatus = showDialogBox(
                context: context,
                title: "Gift Redeemed Successfully",
                content:
                    "Your Redeem Code is ${value.data[0]["redeem"]["code"]}.\nThank you for purchasing with us.",
                barrierDismissible: true,
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        CustomPageRoute(
                            widget: Home(
                          showRateDialog: true,
                        )),
                        (route) => false),
                    child: Text(
                      "GO TO HOME",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ]);
            if (await dialogStatus == null)
              Navigator.pushAndRemoveUntil(
                  context,
                  CustomPageRoute(
                      widget: Home(
                    showRateDialog: true,
                  )),
                  (route) => false);
            Fluttertoast.showToast(msg: value.message);
          } else {
            Fluttertoast.showToast(msg: value.message);
            setLoading(false);
          }
        });
      } else
        Fluttertoast.showToast(msg: "Something went wrong");
    } else
      Fluttertoast.showToast(msg: "Invalid OTP");
  }

  _forgotPassword() async {
    FocusScope.of(context).unfocus();
    if (widget.otp == otp) {
      Navigator.pop(context);
      Navigator.push(
          context,
          CustomPageRoute(
              widget: ResetPassword(
            mobile: widget.mobile,
          )));
    } else {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
  }

  _register() async {
    FocusScope.of(context).unfocus();
    if (widget.otp == otp) {
      setLoading(true);
      await Services.signUp(widget.formData).then((value) {
        if (value.response == "y") {
          Fluttertoast.showToast(msg: value.message);
          setLoading(false);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SignIn(
                        email: widget.mobile,
                      )),
              (route) => false);
        } else {
          Fluttertoast.showToast(msg: value.message);
          setLoading(false);
          Navigator.pop(context);
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
  }

  Widget buildOtpTextField(int pos) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            contentPadding: EdgeInsets.all(10)),
        keyboardType: TextInputType.number,
        maxLength: 1,
        buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
        onChanged: (value) {
          if (value.isEmpty) {
            if (otp != null && otp.length > 0) {
              setState(() {
                otp = otp.substring(0, otp.length - 1);
              });
            }
            FocusScope.of(context).previousFocus();
          }
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
            setState(() {
              otp += value;
            });
          }
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}

enum OtpActions { REGISTER, REDEEM_GIFT, FORGOT_PASSWORD }
