import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/show_dialog.dart';
import '../../ui/widgets/textinput.dart';
import '../../constant/color.dart';
import '../../constant/global.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../services/services.dart';


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
  ScrollController festivalScrollController = ScrollController();
  TabController _tabController;
  // TextEditingController fromDate = TextEditingController(
  //     text: DateFormat('yyyy-MM-dd').format(DateTime(
  //         DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)));
  TextEditingController fromDate = TextEditingController(
      text: DateFormat("yyyy-MM-dd")
          .format(DateTime.parse("2021-01-01"))
          .toString());
  TextEditingController toDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  List<String> tabs = [
        LocaleStrings.earned,
        LocaleStrings.scored,
        LocaleStrings.redeemed,
        LocaleStrings.extraRewards
      ],
      earnTabHeader = ["Sr. No.", "Invoice Date", "Point Earn", "Branch Name"],
      purchaseTabHeader = [
        "Sr. No.",
        "Invoice Number",
        "Invoice Date",
        "Point Earn",
        "Branch Name"
      ],
      redeemTabHeader = [
        "Sr. No.",
        "Date of Redeem",
        "Redeem Code",
        "Gift Code",
        "Gift Name",
        "Redeem Point",
        "Delivery",
        "Status"
      ],
      festivalTabHeader = ["Sr. No.", "Date", "Point Earned", "Festival/Event"];
  List earnedData = [], purchaseData = [], redeemData = [], festivalData = [];
  List filteredEarnedData = [],
      filteredPurchaseData = [],
      filteredRedeemData = [],
      filteredFestivalData = [];
  double totalEarnedPoints = 0,
      totalPurchasePoint = 0,
      totalRedeemPoint = 0,
      totalFestivalPoint = 0;
  bool isLoading = false, isFiltered = false;
  DateTime selectedDate = DateTime.now();

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  void initState() {
    super.initState();
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
      if (festivalScrollController.hasClients) {
        festivalScrollController.animateTo(
          festivalScrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }
    });
    _getReports();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    purchaseScrollController.dispose();
    redeemScrollController.dispose();
    earnScrollController.dispose();
    festivalScrollController.dispose();
    fromDate.dispose();
    toDate.dispose();
  }

  _getReports() async {
    setLoading(true);
    await Services.getReports().then((value) {
      if (value.response == "y") {
        setState(() {
          earnedData = value.data[0]["earn"];
          purchaseData = value.data[0]["purchase"];
          redeemData = value.data[0]["redeem"];
          festivalData = value.data[0]["festival"];

          filteredEarnedData = value.data[0]["earn"];
          filteredPurchaseData = value.data[0]["purchase"];
          filteredRedeemData = value.data[0]["redeem"];
          filteredFestivalData = value.data[0]["festival"];

          filteredEarnedData.forEach((element) {
            totalEarnedPoints += double.parse(element["point"]);
          });
          filteredPurchaseData.forEach((element) {
            totalPurchasePoint += double.parse(element["purchase"]);
          });
          filteredRedeemData.forEach((element) {
            totalRedeemPoint += double.parse(element["point"]);
          });
          filteredFestivalData.forEach((element) {
            totalFestivalPoint += double.parse(element["point"]);
          });
        });
        setLoading(false);
      } else {
        setLoading(false);
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  _selectDate(TextEditingController controller) async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // firstDate: DateTime(DateTime.now().year - 10),
        firstDate: DateTime.parse("2021-01-01"),
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
    DateTime from = DateTime.parse(fromDate.text).subtract(Duration(days: 1));
    DateTime to = DateTime.parse(toDate.text).add(Duration(days: 1));
    if (fromDate.text.isNotEmpty && toDate.text.isNotEmpty) {
      if (to.isAfter(from)) {
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
          case 3:
            _filterFestivalData(from: from, to: to);
            break;
        }
      } else {
        Fluttertoast.showToast(
            msg: translate(
                context, LocaleStrings.toDateMustBeGreaterThanFromDate));
      }
    } else {
      Fluttertoast.showToast(
          msg: translate(context, LocaleStrings.pleaseSelectToAndFromDate));
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
          totalEarnedPoints += double.parse(element["point"]);
          isFiltered = true;
          count++;
        });
      }
    });
    if (count == 0) {
      setState(() {
        filteredEarnedData = earnedData;
        filteredEarnedData.forEach((element) {
          totalEarnedPoints += double.parse(element["point"]);
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
          totalPurchasePoint += double.parse(element["purchase"]);
          isFiltered = true;
          count++;
        });
      }
    });
    if (count == 0) {
      setState(() {
        filteredPurchaseData = purchaseData;
        filteredPurchaseData.forEach((element) {
          totalPurchasePoint += double.parse(element["purchase"]);
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
          totalRedeemPoint += double.parse(element["point"]);
          isFiltered = true;
          count++;
        });
      }
    });
    if (count == 0) {
      setState(() {
        filteredRedeemData = redeemData;
        filteredRedeemData.forEach((element) {
          totalRedeemPoint += double.parse(element["point"]);
        });
      });
      Fluttertoast.showToast(
          msg:
              "No redeem report found between ${fromDate.text} - ${toDate.text}");
    }
  }

  _filterFestivalData({DateTime from, DateTime to}) {
    setState(() {
      filteredFestivalData = [];
      totalFestivalPoint = 0;
    });
    var count = 0;
    festivalData.forEach((element) {
      if (DateTime.parse(element["created"]).isAfter(from) &&
          DateTime.parse(element["created"]).isBefore(to)) {
        setState(() {
          filteredFestivalData.add(element);
          totalFestivalPoint += double.parse(element["point"]);
          isFiltered = true;
          count++;
        });
      }
    });
    if (count == 0) {
      setState(() {
        filteredFestivalData = festivalData;
        filteredFestivalData.forEach((element) {
          totalFestivalPoint += double.parse(element["point"]);
        });
      });
      Fluttertoast.showToast(
          msg:
              "No festival report found between ${fromDate.text} - ${toDate.text}");
    }
  }

  _reset() {
    Navigator.pop(context);
    setState(() {
      filteredRedeemData = filteredPurchaseData = filteredEarnedData = [];
      totalEarnedPoints =
          totalPurchasePoint = totalRedeemPoint = totalFestivalPoint = 0;
      filteredRedeemData = redeemData;
      filteredPurchaseData = purchaseData;
      filteredEarnedData = earnedData;
      filteredFestivalData = festivalData;
      filteredEarnedData.forEach((element) {
        totalEarnedPoints += double.parse(element["point"]);
      });
      filteredPurchaseData.forEach((element) {
        totalPurchasePoint += double.parse(element["purchase"]);
      });
      filteredRedeemData.forEach((element) {
        totalRedeemPoint += double.parse(element["point"]);
      });
      filteredFestivalData.forEach((element) {
        totalFestivalPoint += double.parse(element["point"]);
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
              title: translate(context, LocaleStrings.reports),
              actions: [
                IconButton(
                  icon: ImageIcon(AssetImage("assets/icons/calendar.png")),
                  onPressed: () {
                    showDialogBox(
                        context: context,
                        title: translate(
                            context, LocaleStrings.filterReportByDate),
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            input(
                                context: context,
                                decoration: InputDecoration(
                                    border: border(),
                                    hintText: translate(
                                        context, LocaleStrings.fromDate),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20)),
                                text:
                                    translate(context, LocaleStrings.fromDate),
                                height: 50,
                                width: size.width * 0.7,
                                readOnly: true,
                                onTap: () => _selectDate(fromDate),
                                controller: fromDate),
                            input(
                                context: context,
                                decoration: InputDecoration(
                                    border: border(),
                                    hintText: translate(
                                        context, LocaleStrings.toDate),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20)),
                                text: translate(context, LocaleStrings.toDate),
                                height: 50,
                                width: size.width * 0.7,
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
                              child: Text(isFiltered
                                  ? translate(context, LocaleStrings.resetBtn)
                                  : translate(context, LocaleStrings.close))),
                          FlatButton(
                              onPressed: _filter,
                              child: Text(
                                  translate(context, LocaleStrings.filter))),
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
                            text: "\t" + userdata.point,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                      ],
                    ),
                  ),
                )),
              ],
              bottom: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.white.withOpacity(0.9),
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  physics: BouncingScrollPhysics(),
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
                      text: translate(context, e),
                    );
                  }).toList())),
          body: isLoading ? Center(child: circularProgressIndicator()) : TabBarView(
            physics: BouncingScrollPhysics(),
            controller: _tabController,
            children: [earn(), purchase(), redeem(), festival()],
          ),
        ));
  }

  Widget earn() {
    return filteredEarnedData.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pointRow(
                  "${translate(context, LocaleStrings.totalEarnedPoint)} : ${totalEarnedPoints.round()}"),
              scrollViewBuilder(
                  widget: DataTable(
                      columns: earnTabHeader.map((header) {
                        return DataColumn(
                            label: Text(header, style: headerStyle));
                      }).toList(),
                      rows: filteredEarnedData.map((data) {
                        return DataRow(cells: [
                          DataCell(Text((filteredEarnedData.indexOf(data) + 1)
                              .toString())),
                          DataCell(Text(
                              data["created"].toString().split(" ").first ??
                                  "--")),
                          DataCell(Text(data["point"] ?? "--")),
                          DataCell(Text(data["branch_name"] ?? "--")),
                        ]);
                      }).toList()),
                  scrollController: earnScrollController),
            ],
          )
        : Center(child: Text(translate(context, LocaleStrings.noDataFound)));
  }

  Widget purchase() {
    return filteredPurchaseData.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pointRow(
                  "${translate(context, LocaleStrings.totalScored)} : ${totalPurchasePoint.round()}"),
              scrollViewBuilder(
                  widget: DataTable(
                      columnSpacing: 20,
                      columns: purchaseTabHeader.map((header) {
                        return DataColumn(
                            label: Text(header, style: headerStyle));
                      }).toList(),
                      rows: filteredPurchaseData.map((data) {
                        return DataRow(cells: [
                          DataCell(Text((filteredPurchaseData.indexOf(data) + 1)
                              .toString())),
                          DataCell(Text(data["voucher_no"] ?? "--")),
                          DataCell(Text(
                              data["created"].toString().split(" ").first ??
                                  "--")),
                          DataCell(Text(data["point"] ?? "--")),
                          DataCell(Text(data["branch_name"] ?? "--")),
                        ]);
                      }).toList()),
                  scrollController: purchaseScrollController),
            ],
          )
        : Center(child: Text(translate(context, LocaleStrings.noDataFound)));
  }

  Widget redeem() {
    return filteredRedeemData.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pointRow(
                  "${translate(context, LocaleStrings.totalRedeemedPoint)} : ${totalRedeemPoint.round()}"),
              scrollViewBuilder(
                  widget: DataTable(
                      columns: redeemTabHeader.map((header) {
                        return DataColumn(
                            label: Text(header, style: headerStyle));
                      }).toList(),
                      rows: filteredRedeemData.map((data) {
                        return DataRow(cells: [
                          DataCell(Text((filteredRedeemData.indexOf(data) + 1)
                              .toString())),
                          DataCell(Text(
                              data["datetime"].toString().split(" ").first ??
                                  "--")),
                          DataCell(Text(data["code"] ?? "--")),
                          DataCell(Text(data["gift_code"] ?? "--")),
                          DataCell(Text(data["title"] ?? "--")),
                          DataCell(Text(data["point"] ?? "--")),
                          DataCell(Text(data["delivery_type"] == "s"
                              ? data["store_name"]
                              : "Home Delivery" ?? "--")),
                          /* DataCell(Text(data["delivery_type"] == "s"
                                  ? "--"
                                  : data["tracking_number"])), */
                          DataCell(Text(data["delivery_status"] == "y"
                              ? "Picked"
                              : "Un Picked" ?? "--")),
                        ]);
                      }).toList()),
                  scrollController: redeemScrollController),
            ],
          )
        : Center(child: Text(translate(context, LocaleStrings.noDataFound)));
  }

  Widget festival() {
    return filteredFestivalData.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pointRow(
                  "${translate(context, LocaleStrings.totalFestivalPoint)} : ${totalFestivalPoint.round()}"),
              scrollViewBuilder(
                  widget: DataTable(
                      columnSpacing: 20,
                      columns: festivalTabHeader.map((header) {
                        return DataColumn(
                            label: Text(header, style: headerStyle));
                      }).toList(),
                      rows: filteredFestivalData.map((data) {
                        return DataRow(cells: [
                          DataCell(Text((filteredFestivalData.indexOf(data) + 1)
                              .toString())),
                          DataCell(Text(
                              data["created"].toString().split(" ").first ??
                                  "--")),
                          DataCell(Text(data["point"] ?? "--")),
                          DataCell(Text(data["branch_name"] ?? "--")),
                        ]);
                      }).toList()),
                  scrollController: festivalScrollController),
            ],
          )
        : Center(child: Text(translate(context, LocaleStrings.noDataFound)));
  }

  Widget scrollViewBuilder({Widget widget, ScrollController scrollController}) {
    return Expanded(
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: widget,
          ),
        ),
        isAlwaysShown: true,
        radius: Radius.circular(10),
        controller: scrollController,
        thickness: 3,
      ),
    );
  }

  Widget pointRow(String text) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: primaryColor,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text ?? " ",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
