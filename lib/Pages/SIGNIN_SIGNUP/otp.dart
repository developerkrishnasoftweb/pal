import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/input_decoration.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  FocusNode textFocusNode = new FocusNode();
  String otp = "";
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
      floatingActionButton: customButton(context: context, onPressed: (){}, height: 60, width: size.width, text: "SUBMIT"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildOtpTextField(int pos){
    return SizedBox(
      height: 60,
      width: 60,
      child: TextFormField(
        decoration: InputDecoration(
          border: border(),
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
      ),
    );
  }
}
