import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/global.dart';

import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/textinput.dart';
import '../../Constant/color.dart';
import '../../SERVICES/services.dart';

class ResetPassword extends StatefulWidget {
  final String mobile;
  ResetPassword({@required this.mobile}) : assert(mobile != null);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String password = "", confirmPassword = "";
  bool showPassword = false, isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Reset password"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Reset Password",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            input(
                context: context,
                text: "New Password",
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                autoFocus: true,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                obscureText: !showPassword,
                decoration: InputDecoration(
                    border: border(),
                    contentPadding: EdgeInsets.all(10),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        color: showPassword ? primaryColor : Colors.grey))),
            input(
                context: context,
                text: "Confirm Password",
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                },
                onEditingComplete: _changePassword),
          ],
        ),
      ),
      floatingActionButton: customButton(
          context: context,
          height: 50,
          onPressed: isLoading ? null : _changePassword,
          text: isLoading ? null : "SAVE",
          outerPadding: EdgeInsets.symmetric(horizontal: 20),
          child: isLoading
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  ),
                )
              : null),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _changePassword() {
    if (password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(widget.mobile)) {
      if (password == confirmPassword) {
        setState(() {
          isLoading = true;
        });
        FormData formData = FormData.fromMap({
          "api_key": API_KEY,
          "mobile": widget.mobile,
          "password": confirmPassword,
        });
        Services.forgotPassword(formData).then((value) {
          if (value.response == "y") {
            Fluttertoast.showToast(msg: value.message);
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(msg: value.message);
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        Fluttertoast.showToast(msg: "Password doesn't matched");
      }
    } else {
      Fluttertoast.showToast(msg: "Please enter password");
    }
  }
}
