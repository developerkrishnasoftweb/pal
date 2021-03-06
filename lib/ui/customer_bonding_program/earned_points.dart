import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../services/services.dart';
import '../../constant/global.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';

class EarnedPoints extends StatefulWidget {
  @override
  _EarnedPointsState createState() => _EarnedPointsState();
}

class _EarnedPointsState extends State<EarnedPoints> {
  List<CycleData> earnedLists = [];
  double _cumulativePurchase = 0.0;

  @override
  void initState() {
    _getEarnedPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
          context: context,
          title: translate(context, LocaleStrings.earnedPoints),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white,
                          ),
                          alignment: PlaceholderAlignment.middle),
                      TextSpan(
                          text: "\t ${userdata.point}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white))
                    ],
                  ),
                ),
              ),
            ),
          ]),
      body: Column(
        children: [
          SizedBox(
            width: size.width,
            height: 20,
          ),
          buildRedeemedAmount(
              title: "${translate(context, LocaleStrings.userName)} : ",
              value: userdata.name,
              leadingTrailing: false,
              fontSize: 17),
          SizedBox(
            height: 10,
          ),
          buildRedeemedAmount(
              title: "${translate(context, LocaleStrings.cumulativeScore)} : ",
              value: "${_cumulativePurchase.round()}",
              leadingTrailing: true),
          SizedBox(
            height: 20,
          ),
          earnedLists.length > 0
              ? Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 10,
                          width: size.width,
                          color: Colors.grey[100],
                        );
                      },
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: earnedLists.length,
                      itemBuilder: (context, index) {
                        return buildCard(earnedLists[index]);
                      }),
                )
              : Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: circularProgressIndicator(),
                  ),
                )
        ],
      ),
    );
  }

  Widget buildCard(CycleData data) {
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
    return ExpansionTile(
      trailing: SizedBox(),
      tilePadding: EdgeInsets.only(left: 20),
      childrenPadding: EdgeInsets.only(left: 20, right: 30),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${translate(context, LocaleStrings.cycleNo)}.: ${data.cycleNo}",
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
          Text(
              "${translate(context, LocaleStrings.purchaseForThisCycle)} : ${double.parse(data.purchase).round()}",
              style: style1),
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
                        text:
                            "${translate(context, LocaleStrings.earnedPoints)} : ",
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
                        text:
                            "${translate(context, LocaleStrings.closingPoint)} : ",
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
        buildChildrenRow(
            title: translate(context, LocaleStrings.purchaseForThisCycle),
            value: "${double.parse(data.purchase).round()}"),
        buildChildrenRow(
            title: translate(context, LocaleStrings.redeemInThisCycle),
            value: data.redeem),
        buildChildrenRow(
            title:
                translate(context, LocaleStrings.pointsEarnedDuringThisCycle),
            value: data.earnedPoints ?? "0"),
        buildChildrenRow(
            title: translate(context, LocaleStrings.lastTransactionOn),
            value: data.transaction.length > 0
                ? data.transaction.last["created"].toString().split(" ").first
                : "--"),
      ],
    );
  }

  Widget buildChildrenRow({String title: " ", String value: " "}) {
    TextStyle style1 = Theme.of(context).textTheme.bodyText1.copyWith(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: style1,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value ?? "0",
              style: style1,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRedeemedAmount(
      {String title, String value, bool leadingTrailing, double fontSize}) {
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
          text: value,
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

  _getEarnedPoints() async {
    var closingPoints = 0;
    setState(() {
      earnedLists = [];
    });
    await Services.getCycle();
    FormData body = FormData.fromMap({
      "api_key": API_KEY,
      "limit": null,
      "customer_id": userdata.id,
    });
    await Services.getEarnedPoints(body).then((value) {
      if (value.response == "y") {
        // ignore: unnecessary_statements
        value.message != "" ? Fluttertoast.showToast(msg: value.message) : null;
        for (int i = value.data.length - 1; i >= 0; i--) {
          closingPoints += ((value.data[i]["total_points"] != null
                      ? double.parse(
                          value.data[i]["total_points"][0]["point"] ?? "0")
                      : 0) -
                  (value.data[i]["redeem"] != null
                      ? double.parse(value.data[i]["redeem"][0]["point"] ?? "0")
                      : 0))
              .round();
          var purchase = "0";
          if (value.data[i]["total_purchase"] != null &&
              value.data[i]["total_purchase"][0]["purchase"] != null) {
            purchase = value.data[i]["total_purchase"][0]["purchase"];
          }
          _cumulativePurchase += double.tryParse(purchase) ?? 0.0;
          earnedLists.add(CycleData(
              cycleNo: value.data[i]["id"],
              closingPoints: closingPoints.toString(),
              dateFrom: value.data[i]["start_date"],
              dateTo: value.data[i]["end_date"],
              transaction: value.data[i]["transaction"],
              earnedPoints: value.data[i]["total_points"] != null
                  ? value.data[i]["total_points"][0]["point"]
                  : "0.0",
              redeem: value.data[i]["redeem"] != null
                  ? value.data[i]["redeem"][0]["point"]
                  : "0",
              purchase: purchase));
        }
        earnedLists = earnedLists.reversed.toList();
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }
}

class CycleData {
  final String cycleNo,
      dateFrom,
      dateTo,
      purchase,
      earnedPoints,
      closingPoints,
      redeem;
  final List transaction;

  CycleData(
      {this.closingPoints,
      this.cycleNo,
      this.dateFrom,
      this.dateTo,
      this.earnedPoints,
      this.purchase,
      this.redeem,
      this.transaction});
}
