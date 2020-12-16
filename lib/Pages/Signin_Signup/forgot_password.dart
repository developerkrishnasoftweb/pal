import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/input_border.dart';
import 'package:pal/Common/textinput.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Forgot Password"),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_register_background.png"),
            fit: BoxFit.fill
          )
        ),
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
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: border(),)),
            SizedBox(height: 40,),
            customButton(context: context, onPressed: (){}, text: "GET OTP", height: 65, width: size.width),
          ],
        ),
      ),
    );
  }
}
