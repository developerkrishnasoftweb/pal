import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Constant/global.dart';
import 'package:pal/Constant/strings.dart';
import 'package:pal/LOCALIZATION/localizations_constraints.dart';

class TermsNCondition extends StatefulWidget {
  @override
  _TermsNConditionState createState() => _TermsNConditionState();
}

class _TermsNConditionState extends State<TermsNCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: translate(context, LocaleStrings.termsAndConditions)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(removeHtmlTags(data: config.terms)),
      ),
    );
  }
}