import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/appbar.dart';
import '../../SERVICES/services.dart';
import '../../Constant/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constant/userdata.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextStyle headerStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle bodyStyle = TextStyle(fontSize: 16);
  ScrollController purchaseScrollController = ScrollController();
  ScrollController redeemScrollController = ScrollController();
  ScrollController earnScrollController = ScrollController();
  List<String> tabs = ["Earn", "Purchase", "Redeem"];
  List earnedData = [], purchaseData = [], redeemData = [];
  double totalEarnedPoints = 0, totalPurchasePoint = 0, totalRedeemPoint = 0;
  String totalPoints = "0";

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (purchaseScrollController.hasClients) {
        purchaseScrollController.animateTo(
          purchaseScrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }
      if (redeemScrollController.hasClients) {
        redeemScrollController.animateTo(
          redeemScrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }
      if (earnScrollController.hasClients) {
        earnScrollController.animateTo(
          earnScrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }
    });
    Services.getReports().then((value) {
      if (value.response == "y") {
        setState(() {
          earnedData = value.data[0]["earn"];
          purchaseData = value.data[0]["purchase"];
          redeemData = value.data[0]["redeem"];
          earnedData.forEach((element) {
            totalEarnedPoints += double.parse(element["point"]);
          });
          purchaseData.forEach((element) {
            totalPurchasePoint += double.parse(element["purchase"]);
          });
          redeemData.forEach((element) {
            totalRedeemPoint += double.parse(element["point"]);
          });
        });
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
    super.initState();
    getData();
  }
  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      totalPoints = sharedPreferences.getString(UserParams.point);
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: appBar(
              context: context,
              title: "Report",
              actions: [
                Center(child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text("Total Points : $totalPoints"),
                )),
              ],
              bottom: TabBar(
                  unselectedLabelColor: Colors.white.withOpacity(0.9),
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  unselectedLabelStyle: TextStyle(fontSize: 16),
                  indicatorWeight: 3,
                  tabs: tabs.map((e) {
                    return Tab(
                      child: Text(e),
                    );
                  }).toList())),
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: [earn(), purchase(), redeem()],
          ),
        ));
  }
  Widget earn() {
    Size size = MediaQuery.of(context).size;
    return earnedData.length > 0
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width,
          color: AppColors.primaryColor,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Total earned point : ${totalEarnedPoints.toString()}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text('Sr.No.', style: headerStyle)),
                      DataColumn(
                          label:
                          Text('Invoice Date', style: headerStyle)),
                      DataColumn(
                          label: Text('Point Earn', style: headerStyle)),
                      DataColumn(
                          label: Text('Branch Name', style: headerStyle)),
                    ],
                    rows: earnedData.map((data) {
                      return DataRow(cells: [
                        DataCell(Text(
                            (earnedData.indexOf(data) + 1).toString())),
                        DataCell(Text(data["created"])),
                        DataCell(Text(data["point"])),
                        DataCell(Text(data["branch_name"])),
                      ]);
                    }).toList()),
              ),
            ),
            isAlwaysShown: true,
            radius: Radius.circular(10),
            controller: earnScrollController,
            thickness: 3,
          ),
        ),
      ],
    )
        : Center(
      child: Text(
        "You don't have earned points!!!",
        textAlign: TextAlign.center,
      ),
    );
  }
  Widget purchase() {
    Size size = MediaQuery.of(context).size;
    return purchaseData.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding: const EdgeInsets.all(8.0),
                color: AppColors.primaryColor,
                child: Text(
                  "Total purchased point : ${totalPurchasePoint.toString()}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: DataTable(
                          columnSpacing: 20,
                          columns: [
                            DataColumn(
                                label: Text('Sr.No.', style: headerStyle)),
                            DataColumn(
                                label:
                                    Text('Invoice Number', style: headerStyle)),
                            DataColumn(
                                label:
                                    Text('Invoice Date', style: headerStyle)),
                            DataColumn(
                                label:
                                    Text('Invoice Amount', style: headerStyle)),
                            DataColumn(
                                label: Text('Point Earn', style: headerStyle)),
                            DataColumn(
                                label: Text('Branch Name', style: headerStyle)),
                          ],
                          rows: purchaseData.map((data) {
                            return DataRow(cells: [
                              DataCell(Text(
                                  (purchaseData.indexOf(data) + 1).toString())),
                              DataCell(Text(data["voucher_no"])),
                              DataCell(Text(data["created"])),
                              DataCell(Text(data["purchase"])),
                              DataCell(Text(data["point"])),
                              DataCell(Text(data["branch_name"])),
                            ]);
                          }).toList()),
                    ),
                  ),
                  isAlwaysShown: true,
                  radius: Radius.circular(10),
                  controller: purchaseScrollController,
                  thickness: 3,
                ),
              ),
            ],
          )
        : Center(
            child: Text(
              "You don't have made any purchase yet!!",
              textAlign: TextAlign.center,
            ),
          );
  }
  Widget redeem() {
    Size size = MediaQuery.of(context).size;
    return redeemData.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                color: AppColors.primaryColor,
                width: size.width,
                child: Text(
                  "Total redeemed point : ${totalRedeemPoint.toString()}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text('Sr.No.', style: headerStyle)),
                            DataColumn(
                                label:
                                    Text('Date of Redeem', style: headerStyle)),
                            DataColumn(
                                label: Text('Redeem Code', style: headerStyle)),
                            DataColumn(
                                label: Text('Gift Code', style: headerStyle)),
                            DataColumn(
                                label: Text('Gift Name', style: headerStyle)),
                            DataColumn(
                                label:
                                    Text('Redeem Point', style: headerStyle)),
                          ],
                          rows: redeemData.map((data) {
                            return DataRow(cells: [
                              DataCell(Text(
                                  (redeemData.indexOf(data) + 1).toString())),
                              DataCell(Text(data["datetime"]
                                  .toString()
                                  .split(" ")
                                  .first)),
                              DataCell(Text(data["code"])),
                              DataCell(Text(data["gift_code"])),
                              DataCell(Text(data["title"])),
                              DataCell(Text(data["point"])),
                            ]);
                          }).toList()),
                    ),
                  ),
                  isAlwaysShown: true,
                  radius: Radius.circular(10),
                  controller: redeemScrollController,
                  thickness: 3,
                ),
              ),
            ],
          )
        : Center(
            child: Text(
              "You don't have redeemed any product yet !!!",
              textAlign: TextAlign.center,
            ),
          );
  }
}
