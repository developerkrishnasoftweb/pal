import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Constant/color.dart';
import '../../Pages/SIGNIN_SIGNUP/signin.dart';
import '../../SERVICES/services.dart';

class OTP extends StatefulWidget {
  final String otp;
  final FormData formData;
  OTP({this.otp, this.formData});
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
          SizedBox(width: size.width,),
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
                  for(int i = 0; i < 4; i++)...[
                    buildOtpTextField(i),
                  ]
                ],
              ),
            ),
          ),
          SizedBox(height: 40,),
        ],
      ),
      floatingActionButton: customButton(context: context, onPressed: !signUpStatus ? _register : null, height: 60, width: size.width, text: !signUpStatus ? "SUBMIT" : null, child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),),)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  _register() async {
    if(widget.otp == otp){
      setState(() => signUpStatus = true);
      await Services.signUp(widget.formData).then((value) {
        if (value.response == "y") {
          Fluttertoast.showToast(msg: value.message);
          setState(() => signUpStatus = false);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SignIn()),
                  (route) => false);
        } else {
          Fluttertoast.showToast(msg: value.message);
          setState(() => signUpStatus = false);
          Navigator.pop(context);
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
  }

  Widget buildOtpTextField(int pos){
    return SizedBox(
      height: 50,
      width: 50,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          contentPadding: EdgeInsets.all(10)
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
        onChanged: (value){
          if(value.isEmpty){
            if (otp != null && otp.length > 0) {
              setState(() {
                otp = otp.substring(0, otp.length - 1);
              });
            }
            FocusScope.of(context).previousFocus();
          }
          if(value.length == 1){
            FocusScope.of(context).nextFocus();
            setState(() {
              otp += value;
            });
          }
          print(otp);
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
