import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../Common/input_decoration.dart';
import '../../Common/show_dialog.dart';
import '../../Common/textinput.dart';
import '../../Common/appbar.dart';
import '../../SERVICES/services.dart';
import '../../Constant/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constant/userdata.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> with SingleTickerProviderStateMixin {
  TextStyle headerStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle bodyStyle = TextStyle(fontSize: 16);
  ScrollController purchaseScrollController = ScrollController();
  ScrollController redeemScrollController = ScrollController();
  ScrollController earnScrollController = ScrollController();
  TabController _tabController;
  TextEditingController fromDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime(
          DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)));
  TextEditingController toDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  List<String> tabs = ["Earn", "Purchase", "Redeem"];
  List earnedData = [], purchaseData = [], redeemData = [];
  List filteredEarnedData = [],
      filteredPurchaseData = [],
      filteredRedeemData = [];
  int totalEarnedPoints = 0, totalPurchasePoint = 0, totalRedeemPoint = 0;
  String totalPoints = "0";
  bool isLoading = false, isFiltered = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
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
    _getReports();
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _getReports() async {
    setState(() {
      isLoading = true;
    });
    Services.getReports().then((value) {
      if (value.response == "y") {
        setState(() {
          earnedData = value.data[0]["earn"];
          purchaseData = value.data[0]["purchase"];
          redeemData = value.data[0]["redeem"];
          filteredEarnedData = value.data[0]["earn"];
          filteredPurchaseData = value.data[0]["purchase"];
          filteredRedeemData = value.data[0]["redeem"];
          filteredEarnedData.forEach((element) {
            totalEarnedPoints += int.parse(element["point"]);
          });
          filteredPurchaseData.forEach((element) {
            totalPurchasePoint += int.parse(element["purchase"]);
          });
          filteredRedeemData.forEach((element) {
            totalRedeemPoint += int.parse(element["point"]);
          });
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      totalPoints = sharedPreferences.getString(UserParams.point);
    });
  }

  _selectDate(TextEditingController controller) async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year - 10),
        lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
    if (controller == fromDate) {
      setState(() {
        fromDate.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    } else if (controller == toDate) {
      setState(() {
        toDate.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  _filter() async {
    Navigator.pop(context);
    if (fromDate.text.isNotEmpty && toDate.text.isNotEmpty) {
      DateTime from = DateTime.parse(fromDate.text).subtract(Duration(days: 1));
      DateTime to = DateTime.parse(toDate.text).add(Duration(days: 1));
      switch (_tabController.index) {
        case 0:
          _filterEarnedData(from: from, to: to);
          break;
        case 1:
          _filterPurchaseData(from: from, to: to);
          break;
        case 2:
          _filterRedeemedData(from: from, to: to);
          break;
      }
    } else {
      Fluttertoast.showToast(msg: "Please select from and to date");
    }
  }

  _filterEarnedData({DateTime from, DateTime to}) {
    setState(() {
      filteredEarnedData = [];
      totalEarnedPoints = 0;
    });
    var count = 0;
    earnedData.forEach((element) {
      if (DateTime.parse(element["created"]).isAfter(from) &&
          DateTime.parse(element["created"]).isBefore(to)) {
        setState(() {
          filteredEarnedData.add(element);
          totalEarnedPoints += int.parse(element["point"]);
          isFiltered = true;
          count++;
        });
      }
    });
    if (count == 0) {
      setState(() {
        filteredEarnedData = earnedData;
        filteredEarnedData.forEach((element) {
          totalEarnedPoints += int.parse(element["point"]);
        });
      });
      Fluttertoast.showToast(
          msg:
              "No earned report found between ${fromDate.text} - ${toDate.text}");
    }
  }

  _filterPurchaseData({DateTime from, DateTime to}) {
    setState(() {
      filteredPurchaseData = [];
      totalPurchasePoint = 0;
    });
    var count = 0;
    purchaseData.forEach((element) {
      if (DateTime.parse(element["created"]).isAfter(from) &&
          DateTime.parse(element["created"]).isBefore(to)) {
        setState(() {
          filteredPurchaseData.add(element);
          totalPurchasePoint += int.parse(element["purchase"]);
          isFiltered = true;
          count++;
        });
      }
    });
    if (count == 0) {
      setState(() {
        filteredPurchaseData = purchaseData;
        filteredPurchaseData.forEach((element) {
          totalPurchasePoint += int.parse(element["purchase"]);
        });
      });
      Fluttertoast.showToast(
          msg:
              "No purchase report found between ${fromDate.text} - ${toDate.text}");
    }
  }

  _filterRedeemedData({DateTime from, DateTime to}) {
    setState(() {
      filteredRedeemData = [];
      totalRedeemPoint = 0;
    });
    var count = 0;
    redeemData.forEach((element) {
      if (DateTime.parse(element["datetime"]).isAfter(from) &&
              DateTime.parse(element["datetime"]).isBefore(to)) {
        setState(() {
          filteredRedeemData.add(element);
          totalRedeemPoint += int.parse(element["point"]);
          isFiltered = true;
          count++;
        });
      }
    });
    if (count == 0) {
      setState(() {
        filteredRedeemData = redeemData;
        filteredRedeemData.forEach((element) {
          totalRedeemPoint += int.parse(element["point"]);
        });
      });
      Fluttertoast.showToast(
          msg:
              "No redeem report found between ${fromDate.text} - ${toDate.text}");
    }
  }

  _reset() {
    Navigator.pop(context);
    setState(() {
      filteredRedeemData = filteredPurchaseData = filteredEarnedData = [];
      totalEarnedPoints = totalPurchasePoint = totalRedeemPoint = 0;
      filteredRedeemData = redeemData;
      filteredPurchaseData = purchaseData;
      filteredEarnedData = earnedData;
      filteredEarnedData.forEach((element) {
        totalEarnedPoints += int.parse(element["point"]);
      });
      filteredPurchaseData.forEach((element) {
        totalPurchasePoint += int.parse(element["purchase"]);
      });
      filteredRedeemData.forEach((element) {
        totalRedeemPoint += int.parse(element["point"]);
      });
      isFiltered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: appBar(
              context: context,
              title: "Report",
              actions: [
                IconButton(
                  icon: Icon(Icons.filter_list_outlined),
                  onPressed: () {
                    showDialogBox(
                        context: context,
                        title: "Filter Report By Date",
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            input(
                                context: context,
                                decoration: InputDecoration(
                                    border: border(),
                                    hintText: "From Date",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20)),
                                text: "From Date",
                                height: 50,
                                width: size.width * 0.4,
                                readOnly: true,
                                onTap: () => _selectDate(fromDate),
                                controller: fromDate),
                            input(
                                context: context,
                                decoration: InputDecoration(
                                    border: border(),
                                    hintText: "To Date",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20)),
                                text: "To Date",
                                height: 50,
                                width: size.width * 0.4,
                                readOnly: true,
                                onTap: () => _selectDate(toDate),
                                controller: toDate)
                          ],
                        ),
                        actions: [
                          FlatButton(
                              onPressed: isFiltered
                                  ? _reset
                                  : () => Navigator.pop(context),
                              child: Text(isFiltered ? "Reset" : "Close")),
                          FlatButton(onPressed: _filter, child: Text("Filter")),
                        ]);
                  },
                  splashRadius: 25,
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 20),
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
                            text: "\t" + totalPoints,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                      ],
                    ),
                  ),
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
                  controller: _tabController,
                  onTap: (index) {
                    setState(() {
                      _tabController.index = index;
                    });
                  },
                  tabs: tabs.map((e) {
                    return Tab(
                      child: Text(e),
                    );
                  }).toList())),
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            controller: _tabController,
            children: [earn(), purchase(), redeem()],
          ),
        ));
  }

  Widget earn() {
    Size size = MediaQuery.of(context).size;
    return filteredEarnedData.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                color: AppColors.primaryColor,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Total earned point : ${totalEarnedPoints.toString()}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
                          rows: filteredEarnedData.map((data) {
                            return DataRow(cells: [
                              DataCell(Text(
                                  (filteredEarnedData.indexOf(data) + 1)
                                      .toString())),
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
            child: !isLoading
                ? Text(
                    "No data found !!!",
                    textAlign: TextAlign.center,
                  )
                : SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.primaryColor),
                    ),
                  ),
          );
  }

  Widget purchase() {
    Size size = MediaQuery.of(context).size;
    return filteredPurchaseData.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding: const EdgeInsets.all(8.0),
                color: AppColors.primaryColor,
                child: Text(
                  "Total purchased point : ${totalPurchasePoint.toString()}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
                                label: Text('Point Earn', style: headerStyle)),
                            DataColumn(
                                label: Text('Branch Name', style: headerStyle)),
                          ],
                          rows: filteredPurchaseData.map((data) {
                            return DataRow(cells: [
                              DataCell(Text(
                                  (filteredPurchaseData.indexOf(data) + 1)
                                      .toString())),
                              DataCell(Text(data["voucher_no"])),
                              DataCell(Text(data["created"])),
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
            child: !isLoading
                ? Text(
                    "No data found !!!",
                    textAlign: TextAlign.center,
                  )
                : SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.primaryColor),
                    ),
                  ),
          );
  }

  Widget redeem() {
    Size size = MediaQuery.of(context).size;
    return filteredRedeemData.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                color: AppColors.primaryColor,
                width: size.width,
                child: Text(
                  "Total redeemed point : ${totalRedeemPoint.toString()}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
                          rows: filteredRedeemData.map((data) {
                            return DataRow(cells: [
                              DataCell(Text(
                                  (filteredRedeemData.indexOf(data) + 1)
                                      .toString())),
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
            child: !isLoading
                ? Text(
                    "No data found !!!",
                    textAlign: TextAlign.center,
                  )
                : SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.primaryColor),
                    ),
                  ),
          );
  }
}
