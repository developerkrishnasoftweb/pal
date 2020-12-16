import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';

class Complain extends StatefulWidget {
  @override
  _ComplainState createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Complain"),
      floatingActionButton: button(context: context, onPressed: (){}, height: 60, text: "SUBMIT"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
