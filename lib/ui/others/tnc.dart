import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ui/widgets/appbar.dart';
import '../../constant/global.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';


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