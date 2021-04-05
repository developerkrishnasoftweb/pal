import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/custom_button.dart';
import '../../ui/widgets/page_route.dart';
import '../../ui/widgets/textinput.dart';
import '../../constant/color.dart';
import '../../constant/global.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../services/services.dart';

import 'otp.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool terms = false;
  bool signUpStatus = false;
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    fullName.dispose();
    email.dispose();
    mobile.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 25,
                  splashRadius: 25,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: size.width,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "${translate(context, LocaleStrings.letsGetStart)}!",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Color(0xff000000),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: size.width,
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: Text(
                  translate(context,
                      LocaleStrings.createAnAccountOnToUseAllTheFeatures),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Color(0xffA8A8A8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              input(
                  context: context,
                  onChanged: validateName,
                  controller: fullName,
                  enableInteractiveSelection: false,
                  textInputAction: TextInputAction.next,
                  text: translate(context, LocaleStrings.userName)),
              input(
                  context: context,
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  textInputAction: TextInputAction.next,
                  text: translate(context, LocaleStrings.email)),
              input(
                  context: context,
                  keyboardType: TextInputType.number,
                  controller: mobile,
                  textInputAction: TextInputAction.next,
                  text: translate(context, LocaleStrings.mobileNo)),
              input(
                  context: context,
                  controller: password,
                  onEditingComplete: _signUp,
                  obscureText: true,
                  text: translate(context, LocaleStrings.password)),
              Container(
                width: size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                alignment: Alignment.centerLeft,
                child: CheckboxListTile(
                    value: terms,
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      translate(context,
                          LocaleStrings.bySigningUpYouAgreeToOurTermsAndPolicy),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Color(0xffa8a8a8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    onChanged: (value) {
                      setState(() {
                        terms = !terms;
                      });
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              customButton(
                  context: context,
                  onPressed: !signUpStatus ? _signUp : null,
                  child: signUpStatus
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: circularProgressIndicator(),
                        )
                      : Text(
                          translate(context, LocaleStrings.signUp),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Color(0xffffffff),
                                fontSize: 18,
                              ),
                        )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: RichText(
                  text: TextSpan(
                      text:
                          "${translate(context, LocaleStrings.alreadyHaveAnAccount)}?\t",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Color(0xffa8a8a8),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: [
                        WidgetSpan(
                            child: GestureDetector(
                          child: Text(
                            translate(context, LocaleStrings.signIn),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ))
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _signUp() async {
    FocusScope.of(context).unfocus();
    if (fullName.text.isNotEmpty &&
        email.text.isNotEmpty &&
        mobile.text.isNotEmpty &&
        password.text.isNotEmpty) {
      if (terms) {
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email.text)) {
          if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(mobile.text)) {
            String otp = RandomInt.generate().toString();
            setState(() => signUpStatus = true);
            FormData userData = FormData.fromMap({
              "name": fullName.text,
              "email": email.text,
              "mobile": mobile.text,
              "gender": "male",
              "password": password.text,
              "token": "1234",
              "api_key": API_KEY
            });
            FormData smsData = SMS_DATA(
                message: otp +
                    " is your OTP to Sign-Up to PAL App. Don't share it with anyone.",
                mobile: mobile.text);
            /* var shouldLogin = await Services.checkUsersPurchase(
                mobile: mobile, fromDate: "01/01/2021", toDate: "31/12/2021");
            if (shouldLogin) {

            } else {
              setState(() {
                signUpStatus = false;
              });
              Fluttertoast.showToast(
                  msg: translate(
                      context,
                      LocaleStrings
                          .youMustHaveToPurchaseToAvailAllTheFeatures));
            } */
            await Services.sms(
                    "<#> $otp is your OTP to Sign-Up to PAL App. Don't share it with anyone.",
                    mobile.text)
                .then((value) {
                  print(value.response);
              if (value.response == "0") {
                setState(() => signUpStatus = false);
                Navigator.push(
                    context,
                    CustomPageRoute(
                        widget: OTP(
                      otp: otp,
                      formData: userData,
                      mobile: mobile.text,
                      action: OtpActions.REGISTER,
                    ))).then((value) {
                  setState(() => signUpStatus = false);
                });
              } else {
                setState(() => signUpStatus = false);
                Fluttertoast.showToast(
                    msg: value.message, toastLength: Toast.LENGTH_LONG);
              }
            });
          } else {
            Fluttertoast.showToast(
                msg: translate(context, LocaleStrings.invalidMobileNumber));
          }
        } else {
          Fluttertoast.showToast(
              msg: translate(context, LocaleStrings.invalidEmail));
        }
      } else {
        Fluttertoast.showToast(
            msg: translate(
                context, LocaleStrings.pleaseCheckTermsAndConditions));
      }
    } else {
      Fluttertoast.showToast(
          msg: translate(context, LocaleStrings.allFieldsAreRequired));
    }
  }

  void validateName(String value) {
    if (value.length > 0) {
      if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(fullName.text)) {
        setState(() {
          fullName.text = fullName.text.substring(0, value.length - 1);
          fullName.selection = TextSelection.fromPosition(
              TextPosition(offset: fullName.text.length));
        });
      }
    }
  }
}
