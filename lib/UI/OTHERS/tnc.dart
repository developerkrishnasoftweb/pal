import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Constant/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsNCondition extends StatefulWidget {
  @override
  _TermsNConditionState createState() => _TermsNConditionState();
}

class _TermsNConditionState extends State<TermsNCondition> {
  String termsNConditions = "", title = "";
  WebViewController _controller;
  @override
  void initState() {
    getConfig();
    super.initState();
  }
  void getConfig() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var config = jsonDecode(sharedPreferences.getString(UserParams.config));
    setState(() {
      termsNConditions = config[0]["terms"];
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Terms & Conditions"),
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),
    );
  }
  _loadHtmlFromAssets() async {;
    _controller.loadUrl( Uri.dataFromString(
        termsNConditions,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}
