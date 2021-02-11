import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Constant/global.dart';
import 'package:pal/Constant/strings.dart';
import 'package:pal/LOCALIZATION/localizations_constraints.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsNCondition extends StatefulWidget {
  @override
  _TermsNConditionState createState() => _TermsNConditionState();
}

class _TermsNConditionState extends State<TermsNCondition> {
  String title = "";
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          context: context,
          title: translate(context, LocaleStrings.termsAndConditions)),
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),
    );
  }

  _loadHtmlFromAssets() async {
    _controller.loadUrl(Uri.dataFromString(config.terms,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
