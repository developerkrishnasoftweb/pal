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
  String lastCycle = "Last 12 Cycles";
  int cycle = 0;
  List<CycleData> earnedLists = [];
  @override
  void initState() {
    _getEarnedPoints(lastCycle);
    super.initState();
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
    Size size = MediaQuery.of(context).size;
    TextStyle style = Theme.of(context).textTheme.bodyText1.copyWith(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15);
    TextStyle style1 = Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(fontWeight: FontWeight.bold, fontSize: 15);
    TextStyle style2 = Theme.of(context).textTheme.bodyText1.copyWith(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13);
    var startDate = DateFormat('d MMM').format(DateTime.parse(data.dateFrom));
    var endDate = DateFormat('d MMM').format(DateTime.parse(data.dateTo));
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
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
              Container(
                width: size.width * 0.4,
                child: RichText(
                  text: TextSpan(
                      text: "Earned Point : ",
                      style: style1,
                      children: [
                        TextSpan(text: data.earnedPoints, style: style)
                      ]),
                ),
              ),
              Container(
                width: size.width * 0.4,
                child: RichText(
                  text: TextSpan(
                      text: "Closing Point : ",
                      style: style1,
                      children: [
                        TextSpan(text: data.closingPoints, style: style)
                      ]),
                ),
              )
            ],
          )
        ],
      ),
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
                closingPoints: "N/A",
                dateFrom: value.data[i]["start_date"],
                dateTo: value.data[i]["end_date"],
                transaction: value.data[i]["transaction"],
                earnedPoints: value.data[i]["total_points"] != null
                    ? value.data[i]["total_points"][0]["point"]
                    : "N/A",
                purchase: value.data[i]["total_purchase"] != null
                    ? value.data[i]["total_purchase"][0]["purchase"]
                    : "N/A"));
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
