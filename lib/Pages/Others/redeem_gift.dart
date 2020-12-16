import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';

class RedeemGift extends StatefulWidget {
  @override
  _RedeemGiftState createState() => _RedeemGiftState();
}

class _RedeemGiftState extends State<RedeemGift> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Redeem Gift"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: size.width, height: 20,),
            buildRedeemedAmount(title: "My Earned Points : ", amount: "196604", leadingTrailing: false, fontSize: 17),
            SizedBox(height: 10,),
            buildRedeemedAmount(title: "Cumulative Purchase : ", amount: "394230.00", leadingTrailing: true),
          ],
        ),
      ),
    );
  }
  Widget buildRedeemedAmount({String title, String amount, bool leadingTrailing, double fontSize}){
    TextStyle style = Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold);
    return RichText(
      text: TextSpan(
          children: [
            TextSpan(
              text: leadingTrailing ? "(" : "",
              style: style,
            ),
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey, fontSize: fontSize ?? 13, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: amount,
              style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black, fontSize: fontSize ?? 13),
            ),
            TextSpan(
              text: leadingTrailing ? ")" : "",
              style: style,
            ),
          ]
      ),
    );
  }
}
