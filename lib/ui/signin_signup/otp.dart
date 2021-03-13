import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/constant/strings.dart';
import 'package:pal/localization/localizations_constraints.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/custom_button.dart';
import '../../ui/widgets/page_route.dart';
import '../../ui/widgets/show_dialog.dart';
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
  int length = 4;
  List<TextEditingController> controllers;
  List<FocusNode> focusNodes;

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  void initState() {
    super.initState();
    controllers = List.generate(length, (index) => TextEditingController());
    focusNodes = List.generate(length, (index) => FocusNode());
    focusNodes.forEach((node) {
      TextEditingController controller = controllers[focusNodes.indexOf(node)];
      node.addListener(() {
        if (node.hasFocus) {
          controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.text.length);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllers.forEach((controller) {
      controller.dispose();
    });
    focusNodes.forEach((node) {
      node.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //TODO: Add to locale strings
      appBar: appBar(context: context, title: translate(context, LocaleStrings.enterOTP)),
      body: Column(
        children: [
          SizedBox(
            height: 10,
            width: size.width,
          ),
          Text(
            "We have sent OTP ${widget.mobile != null ? "***" + widget.mobile.substring(6) : "."}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  for (int i = 0; i < controllers.length; i++)
                    buildOtpTextField(
                        pos: i,
                        textEditingController: controllers[i],
                        focusNode: focusNodes[i]),
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
          text: !isLoading ? translate(context, LocaleStrings.submitBtn) : null,
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
    otp = "";
    controllers.forEach((controller) {
      otp += controller.text;
    });
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
      Fluttertoast.showToast(msg: translate(context, LocaleStrings.invalidOTP));
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
                title: translate(context, LocaleStrings.giftRedeemedSuccessfully),
                content:
                    "${translate(context, LocaleStrings.yourRedeemCodeIs)} ${value.data[0]["redeem"]["code"]}.\n${translate(context, LocaleStrings.thankYouForPurchasingWithUs)}.",
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
                      translate(context, LocaleStrings.goTOHome),
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
        Fluttertoast.showToast(msg: translate(context, LocaleStrings.somethingWentWrong));
    } else
      Fluttertoast.showToast(msg: translate(context, LocaleStrings.invalidOTP));
  }

  _forgotPassword() async {
    FocusScope.of(context).unfocus();
    if (widget.otp == otp) {
      Navigator.pushReplacement(
          context,
          CustomPageRoute(
              widget: ResetPassword(
            mobile: widget.mobile,
          )));
    } else {
      Fluttertoast.showToast(msg: translate(context, LocaleStrings.invalidOTP));
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
      Fluttertoast.showToast(msg: translate(context, LocaleStrings.invalidOTP));
    }
  }

  Widget buildOtpTextField(
      {int pos,
      TextEditingController textEditingController,
      FocusNode focusNode}) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            contentPadding: EdgeInsets.all(10)),
        keyboardType: TextInputType.number,
        maxLength: 1,
        cursorColor: primaryColor,
        buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
        onChanged: (value) {
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        enableInteractiveSelection: false,
        focusNode: focusNode,
        controller: textEditingController,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}

enum OtpActions { REGISTER, REDEEM_GIFT, FORGOT_PASSWORD }
