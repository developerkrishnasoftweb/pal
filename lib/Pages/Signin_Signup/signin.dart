import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/input_border.dart';
import 'package:pal/Common/textinput.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/login_register_background.png"),
          fit: BoxFit.fill,
        )),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/images/pal-logo.png"),
                height: 200,
                width: 200,
              ),
              SizedBox(height: 50,),
              input(
                  context: context,
                  style: TextStyle(fontSize: 17),
                  text: "User Name",
                  autoFocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    border: border())),
              input(
                  context: context,
                  style: TextStyle(fontSize: 17),
                  text: "Password",
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    border: border())),
              Align(
                child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Forgot Password?", style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 15),),
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 30,),
              button(context: context, onPressed: (){}, text: "LOGIN", height: 65, width: size.width),
            ],
          ),
        ),
      ),
    );
  }
}
