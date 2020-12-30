import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Constant/color.dart';
import '../../Constant/userdata.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common/appbar.dart';
import 'package:intl/intl.dart';

class EarnedPoints extends StatefulWidget {
  @override
  _EarnedPointsState createState() => _EarnedPointsState();
}

class _EarnedPointsState extends State<EarnedPoints> {
  String lastCycle = "Last 12 Cycles", name = " ", cumulativePurchase = "0";
  int cycle = 0;
  List<CycleData> earnedLists = [];
  TextStyle style, style1, style2;
  @override
  void initState() {
    setState(() {
      style = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15);
      style1 = Theme.of(context)
          .textTheme
          .bodyText1
          .copyWith(fontWeight: FontWeight.bold, fontSize: 15);
      style2 = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13);
    });
    _getEarnedPoints(lastCycle);
    getUserData();
    super.initState();
  }
  void getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List data = jsonDecode(sharedPreferences.getString(UserParams.userData));
    setState(() {
      name = data[0][UserParams.name];
      cumulativePurchase = data[0][UserParams.purchase] ?? "0";
    });
  }
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
                  amount: name,
                  leadingTrailing: false,
                  fontSize: 17),
              SizedBox(
                height: 10,
              ),
              buildRedeemedAmount(
                  title: "Cumulative Purchase : ",
                  amount: cumulativePurchase,
                  leadingTrailing: true),
              SizedBox(
                height: 10,
              ),
              Container(
                width: size.width - 20,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 10,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton(
                  isExpanded: true,
                  onChanged: _getEarnedPoints,
                  underline: SizedBox.shrink(),
                  value: lastCycle,
                  items: [
                    "Show all cycles",
                    "Last 12 Cycles",
                    "Last 24 Cycles",
                    "Last 36 Cycles",
                    "Last 48 Cycles",
                    "Last 60 Cycles"
                  ].map((text) {
                    return DropdownMenuItem(
                      value: text,
                      child: Text(text),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              earnedLists.length > 0 ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: earnedLists.length,
                  itemBuilder: (context, index) {
                    return buildCard(earnedLists[index]);
                  }) : SizedBox(height: 30, width: 30, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),),)
            ],
          ),
        ));
  }

  Widget buildCard(CycleData data) {
    var startDate = DateFormat('d MMM').format(DateTime.parse(data.dateFrom));
    var endDate = DateFormat('d MMM').format(DateTime.parse(data.dateTo));
    return ExpansionTile(
      trailing: SizedBox(),
      tilePadding: EdgeInsets.only(left: 20,),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cycle No.: ${data.cycleNo}",
                style: style2,
              ),
              Text(
                "${startDate.toString()} - ${endDate.toString()}",
                style: style2,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text("Purchase for this cycle : ${data.purchase}", style: style1),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                        text: "Earned Point : ",
                        style: style1,
                        children: [
                          TextSpan(text: data.earnedPoints, style: style)
                        ]),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                        text: "Closing Point : ",
                        style: style1,
                        children: [
                          TextSpan(text: data.closingPoints, style: style)
                        ]),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      children: [
        buildChildrenRow(title: "Purchase for this cycle", value: data.purchase),
      ],
    );
  }
  Widget buildChildrenRow({String title : " ", String value : " "}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: style1,),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(value, style: style1,),
          ),
        ),
      ],
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

  _getEarnedPoints(value) async {
    setState(() {
      earnedLists = [];
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(UserParams.id);
    try {
      setState(() {
        cycle = int.parse(value.toString().split(" ")[1]);
      });
    } catch (e) {
      setState(() {
        cycle = null;
      });
    }
    setState(() {
      lastCycle = value;
    });
    FormData body = FormData.fromMap({
      "api_key": Urls.apiKey,
      "limit": cycle.toString(),
      "customer_id": id,
    });
    Services.getEarnedPoints(body).then((value) {
      if (value.response == "y") {
        // ignore: unnecessary_statements
        value.message != "" ? Fluttertoast.showToast(msg: value.message) : null;
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            earnedLists.add(CycleData(
                cycleNo: value.data[i]["id"],
                closingPoints: value.data[i]["closing_points"] ?? "0.0",
                dateFrom: value.data[i]["start_date"],
                dateTo: value.data[i]["end_date"],
                transaction: value.data[i]["transaction"],
                earnedPoints: value.data[i]["total_points"] != null
                    ? value.data[i]["total_points"][0]["point"]
                    : "0.0",
                purchase: value.data[i]["total_purchase"] != null
                    ? value.data[i]["total_purchase"][0]["purchase"] != null ? value.data[i]["total_purchase"][0]["purchase"] : "0.0"
                    : "0.0"));
          });
        }
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }
}

class CycleData {
  final String cycleNo, dateFrom, dateTo, purchase, earnedPoints, closingPoints;
  final List transaction;
  CycleData(
      {this.closingPoints,
      this.cycleNo,
      this.dateFrom,
      this.dateTo,
      this.earnedPoints,
      this.purchase,
      this.transaction});
}