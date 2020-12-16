import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';

class EarnedPoints extends StatefulWidget {
  @override
  _EarnedPointsState createState() => _EarnedPointsState();
}

class _EarnedPointsState extends State<EarnedPoints> {
  String lastCycles = "Last 12 Cycles";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Earned Point"),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 20,
              ),
              buildRedeemedAmount(
                  title: "User Name : ",
                  amount: "Pal General Store (134312)",
                  leadingTrailing: false,
                  fontSize: 17),
              SizedBox(
                height: 10,
              ),
              buildRedeemedAmount(
                  title: "Cumulative Purchase : ",
                  amount: "394230.00",
                  leadingTrailing: true),
              SizedBox(height: 10,),
              Container(
                width: size.width - 20,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 5,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButton(
                  isExpanded: true,
                  onChanged: (value){
                    setState(() {
                      lastCycles = value;
                    });
                  },
                  underline: SizedBox.shrink(),
                  value: lastCycles,
                  items: ["Last 12 Cycles"].map((text) {
                    return DropdownMenuItem(
                      value: text,
                      child: Text(text),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        )
    );
  }
  Widget buildRedeemedAmount(
      {String title, String amount, bool leadingTrailing, double fontSize}) {
    TextStyle style = Theme.of(context).textTheme.bodyText1.copyWith(
        color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold);
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: leadingTrailing ? "(" : "",
          style: style,
        ),
        TextSpan(
          text: title,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.grey,
              fontSize: fontSize ?? 13,
              fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: amount,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.black, fontSize: fontSize ?? 13),
        ),
        TextSpan(
          text: leadingTrailing ? ")" : "",
          style: style,
        ),
      ]),
    );
  }
}
