import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/show_dialog.dart';
import '../../Constant/userdata.dart';
import '../../UI/HOME/home.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Common/page_route.dart';
import '../../UI/SIGNIN_SIGNUP/change_password.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Constant/color.dart';
import '../../UI/SIGNIN_SIGNUP/signin.dart';
import '../../SERVICES/services.dart';

class OTP extends StatefulWidget {
  final String otp, mobile;
  final FormData formData;
  final bool onlyCheckOtp, redeemGift;
  OTP(
      {this.otp,
      this.formData,
      this.onlyCheckOtp: false,
      this.mobile,
      this.redeemGift: false});
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  FocusNode textFocusNode = new FocusNode();
  String otp = "";
  bool signUpStatus = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Enter OTP"),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Text("We have sent OTP ${widget.mobile != null ? "***" + widget.mobile.substring(6) : "."}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
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
          onPressed: !signUpStatus
              ? widget.onlyCheckOtp
                  ? widget.redeemGift
                      ? _redeemGift
                      : _forgotPassword
                  : _register
              : null,
          height: 60,
          width: size.width,
          text: !signUpStatus ? "SUBMIT" : null,
          child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _redeemGift() async {
    FocusScope.of(context).unfocus();
    if (widget.otp == otp) {
      if (widget.formData != null) {
        print(widget.formData.fields);
        print(widget.formData.files);
        setState(() {
          signUpStatus = true;
        });
        await Services.redeemGift(widget.formData).then((value) async {
          if (value.response == "y") {
            await userData(value.data[0]["customer"]);
            Fluttertoast.showToast(msg: value.message);
            var status = showDialogBox(
                context: context,
                title: "Rate US",
                content: "How would you rate PAL DEPARTMENTAL STORE ?",
                barrierDismissible: true,
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(context,
                        CustomPageRoute(widget: Home()), (route) => false),
                    child: Text(
                      "NO, THANKS",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  FlatButton(
                    onPressed: _rate,
                    child: Text(
                      "RATE",
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ]);
            if (await status == null)
              Navigator.pushAndRemoveUntil(
                  context, CustomPageRoute(widget: Home()), (route) => false);
            setState(() {
              signUpStatus = false;
            });
          } else {
            Fluttertoast.showToast(msg: value.message);
            setState(() {
              signUpStatus = false;
            });
          }
        });
      } else
        Fluttertoast.showToast(msg: "Something went wrong");
    } else
      Fluttertoast.showToast(msg: "Invalid OTP");
  }

  _rate() async {
    var url = "https://play.google.com/store/apps/details?id=com.whatsapp";
    if (await canLaunch(url)) {
      launch(url);
      Navigator.pushAndRemoveUntil(
          context, CustomPageRoute(widget: Home()), (route) => false);
    } else
      Fluttertoast.showToast(msg: "Unable to open play store");
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
      setState(() => signUpStatus = true);
      var shouldLogin = await Services.checkUsersPurchase(mobile: widget.mobile, fromDate: "01/01/2021", toDate: "31/12/2021");
      if(shouldLogin){
        await Services.signUp(widget.formData).then((value) {
          if (value.response == "y") {
            Fluttertoast.showToast(msg: value.message);
            setState(() => signUpStatus = false);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
                    (route) => false);
          } else {
            Fluttertoast.showToast(msg: value.message);
            setState(() => signUpStatus = false);
            Navigator.pop(context);
          }
        });
      } else {
        setState(() {
          signUpStatus = false;
        });
        Fluttertoast.showToast(msg: "You must have to purchase to avail the features");
      }
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
