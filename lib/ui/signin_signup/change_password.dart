import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/custom_button.dart';
import '../../ui/widgets/textinput.dart';
import '../../constant/color.dart';
import '../../constant/global.dart';
import '../../services/services.dart';


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
      appBar: appBar(context: context, title: translate(context, LocaleStrings.resetPassword)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                translate(context, LocaleStrings.resetPassword),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            input(
                context: context,
                text: translate(context, LocaleStrings.newPassword),
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
                text: translate(context, LocaleStrings.confirmPassword),
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
          text: isLoading ? null : translate(context, LocaleStrings.submitBtn),
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: isLoading
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: circularProgressIndicator(),
                )
              : null),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _changePassword() async {
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
        await Services.forgotPassword(formData).then((value) {
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
        Fluttertoast.showToast(msg: translate(context, LocaleStrings.passwordDoesntMatch));
      }
    } else {
      Fluttertoast.showToast(msg: translate(context, LocaleStrings.allFieldsAreRequired));
    }
  }
}
