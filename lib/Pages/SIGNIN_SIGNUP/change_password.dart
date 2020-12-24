import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/input_decoration.dart';
import 'package:pal/Common/textinput.dart';
import 'package:pal/Constant/color.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String password = "", confirmPassword = "";
  bool showPassword = false;
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
                onChanged: (value){
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
                  suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                    setState(() {
                      showPassword = !showPassword;
                    });
                  }, color: showPassword ? AppColors.primaryColor : Colors.grey)
                )),
            input(
                context: context,
                text: "Confirm Password",
                obscureText: true,
                onChanged: (value){
                  setState(() {
                    confirmPassword = value;
                  });
                },
                onEditingComplete: _changePassword,
                decoration: InputDecoration(border: border())),
          ],
        ),
      ),
      floatingActionButton:
          customButton(context: context, onPressed: _changePassword, text: "SAVE", outerPadding: EdgeInsets.symmetric(horizontal: 20)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _changePassword() {
    if(password.isNotEmpty && confirmPassword.isNotEmpty){
      if(password == confirmPassword){
        print(password);
      } else {
        Fluttertoast.showToast(msg: "Password doesn't matched");
      }
    } else {
      Fluttertoast.showToast(msg: "Please enter password");
    }
  }
}
