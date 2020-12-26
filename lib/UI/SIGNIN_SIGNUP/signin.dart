import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/page_route.dart';
import '../../Common/textinput.dart';
import '../../Constant/color.dart';
import '../../Constant/userdata.dart';
import '../../Pages/HOME/home.dart';
import '../../Pages/SIGNIN_SIGNUP/forgot_password.dart';
import '../../Pages/SIGNIN_SIGNUP/signup.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  final String email;
  SignIn({this.email});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLogging = false;
  String username = "", password = "";
  TextEditingController emailController = TextEditingController();
  FocusNode myFocusNode;
  @override
  void initState() {
    setState(() {
      emailController.text = username = widget.email ?? "";
    });
    super.initState();
    myFocusNode = FocusNode();
    if (widget.email != null) {
      myFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/login_register_background.png"),
          fit: BoxFit.fill,
        )),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30, left: 20, right: 20),
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/images/pal-logo.png"),
                height: 200,
                width: 200,
              ),
              input(
                  context: context,
                  style: TextStyle(fontSize: 17),
                  text: "User Name",
                  autoFocus: true,
                  keyboardType: TextInputType.emailAddress,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                      contentPadding: AppTextFieldDecoration.textFieldPadding,
                      border: border())),
              input(
                  context: context,
                  style: TextStyle(fontSize: 17),
                  text: "Password",
                  obscureText: true,
                  onEditingComplete: _signIn,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  focusNode: myFocusNode,
                  decoration: InputDecoration(
                      contentPadding: AppTextFieldDecoration.textFieldPadding,
                      border: border())),
              Align(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, CustomPageRoute(widget: ForgotPassword()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Forgot Password?",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
              SizedBox(
                height: 30,
              ),
              customButton(
                  context: context,
                  onPressed: !isLogging ? () => _signIn() : null,
                  text: !isLogging ? "LOGIN" : null,
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.primaryColor),
                    ),
                  ),
                  height: 65,
                  width: size.width),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: RichText(
                  text: TextSpan(
                      text: "Don't have an account?\t",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Color(0xffa8a8a8),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: [
                        WidgetSpan(
                            child: GestureDetector(
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                                context, CustomPageRoute(widget: SignUp()));
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

  void _signIn() async {
    setState(() {
      isLogging = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (username.isNotEmpty && password.isNotEmpty) {
      FormData formData = FormData.fromMap(
          {"username": username, "password": password, "api_key": Urls.apiKey});
      await Services.signIn(formData).then((result) {
        if (result.response == "y") {
          setState(() {
            isLogging = false;
          });
          userData(result.data);
          sharedPreferences.setString("username", username);
          sharedPreferences.setString(UserParams.password, result.data[0][UserParams.password]);
          Navigator.pushAndRemoveUntil(
              context, CustomPageRoute(widget: Home()), (route) => false);
          Fluttertoast.showToast(msg: result.message);
        } else {
          setState(() {
            isLogging = false;
          });
          Fluttertoast.showToast(msg: result.message);
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Please enter username and password");
      setState(() {
        isLogging = false;
      });
    }
  }
}
