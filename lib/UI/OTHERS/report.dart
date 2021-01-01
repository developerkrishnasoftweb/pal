import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/appbar.dart';
import '../../SERVICES/services.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextStyle headerStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle bodyStyle = TextStyle(fontSize: 16);
  final ScrollController purchaseScrollController = ScrollController();
  final ScrollController redeemScrollController = ScrollController();
  List<String> tabs = ["Earn", "Purchase", "Redeem"];
  List earnedData = [], purchaseData = [], redeemData = [];

  @override
  void initState() {
    Services.getReports().then((value) {
      if(value.response == "y"){
        setState(() {
          earnedData = value.data[0]["earn"];
          purchaseData = value.data[0]["purchase"];
          redeemData = value.data[0]["redeem"];
        });
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: appBar(
              context: context,
              title: "Report",
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

  Widget purchase() {
    return purchaseData.length > 0 ? Scrollbar(child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: DataTable(columnSpacing: 20, columns: [
          DataColumn(label: Text('Sr.No.', style: headerStyle)),
          DataColumn(label: Text('Invoice Number', style: headerStyle)),
          DataColumn(label: Text('Invoice Date', style: headerStyle)),
          DataColumn(label: Text('Invoice Amount', style: headerStyle)),
          DataColumn(label: Text('Point Earn', style: headerStyle)),
          DataColumn(label: Text('Branch Name', style: headerStyle)),
        ], rows: purchaseData.map((data) {
          return DataRow(cells: [
            DataCell(Text(purchaseData.indexOf(data).toString())),
            DataCell(Text(data["voucher_no"])),
            DataCell(Text(data["created"])),
            DataCell(Text(data["purchase"])),
            DataCell(Text(data["point"])),
            DataCell(Text(data["branch_name"])),
          ]);
        }).toList()),
      ),
    ), isAlwaysShown: true, radius: Radius.circular(10), controller: ScrollController(), thickness: 3,) : Center(child: Text("You don't have made any purchase yet!!", textAlign: TextAlign.center,),);
  }
  Widget redeem() {
    return redeemData.length > 0 ? Scrollbar(child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: DataTable(columns: [
          DataColumn(label: Text('Sr.No.', style: headerStyle)),
          DataColumn(label: Text('Date of Redeem', style: headerStyle)),
          DataColumn(label: Text('Redeem Code', style: headerStyle)),
          DataColumn(label: Text('Gift Code', style: headerStyle)),
          DataColumn(label: Text('Gift Name', style: headerStyle)),
          DataColumn(label: Text('Redeem Point', style: headerStyle)),
        ], rows: redeemData.map((data) {
          return DataRow(cells: [
            DataCell(Text(redeemData.indexOf(data).toString())),
            DataCell(Text(data["datetime"].toString().split(" ").first)),
            DataCell(Text(data["code"])),
            DataCell(Text(data["gift_code"])),
            DataCell(Text(data["title"])),
            DataCell(Text(data["point"])),
          ]);
        }).toList()),
      ),
    ), isAlwaysShown: true, radius: Radius.circular(10), controller: ScrollController(), thickness: 3,) : Center(child: Text("You don't have redeemed any product yet !!!", textAlign: TextAlign.center,),);
  }
  Widget earn() {
    return earnedData.length > 0 ? Scrollbar(child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: DataTable(columns: [
          DataColumn(label: Text('Sr.No.', style: headerStyle)),
          DataColumn(label: Text('Invoice Date', style: headerStyle)),
          DataColumn(label: Text('Point Earn', style: headerStyle)),
          DataColumn(label: Text('Branch Name', style: headerStyle)),
        ], rows: earnedData.map((data) {
          return DataRow(cells: [
            DataCell(Text(earnedData.indexOf(data).toString())),
            DataCell(Text(data["created"])),
            DataCell(Text(data["point"])),
            DataCell(Text(data["branch_name"])),
          ]);
        }).toList()),
      ),
    ), isAlwaysShown: true, radius: Radius.circular(10), controller: ScrollController(), thickness: 3,) : Center(child: Text("You don't have earned points!!!", textAlign: TextAlign.center,),);
  }
}
