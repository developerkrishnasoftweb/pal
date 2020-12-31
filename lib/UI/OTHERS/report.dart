import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextStyle headerStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle bodyStyle = TextStyle(fontSize: 16);
  final ScrollController purchaseScrollController = ScrollController();
  final ScrollController redeemScrollController = ScrollController();
  List<String> tabs = ["Purchase", "Redeem"];
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
            children: [purchase(), redeem()],
          ),
        ));
  }

  Widget purchase() {
    return Scrollbar(child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: DataTable(columnSpacing: 20, columns: [
        DataColumn(label: Text('Sr.No.', style: headerStyle)),
        DataColumn(label: Text('Invoice Amount', style: headerStyle)),
        DataColumn(label: Text('Point Earned', style: headerStyle)),
        DataColumn(label: Text('Invoice Date', style: headerStyle)),
      ], rows: [
        DataRow(cells: [
          DataCell(Text('1')),
          DataCell(Text('Stephen')),
          DataCell(Text('Actor')),
          DataCell(Text('Actor')),
        ]),
        DataRow(cells: [
          DataCell(Text('4')),
          DataCell(Text('Stephen')),
          DataCell(Text('Actor')),
          DataCell(Text('Actor')),
        ]),
        DataRow(cells: [
          DataCell(Text('2')),
          DataCell(Text('Stephen')),
          DataCell(Text('Actor')),
          DataCell(Text('Actor')),
        ]),
        DataRow(cells: [
          DataCell(Text('3')),
          DataCell(Text('Stephen')),
          DataCell(Text('Actor')),
          DataCell(Text('Actor')),
        ]),
      ]),
    ), isAlwaysShown: true, radius: Radius.circular(10), controller: ScrollController(), thickness: 3,);
  }

  Widget redeem() {
    return Scrollbar(child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: DataTable(columns: [
        DataColumn(label: Text('Sr.No.', style: headerStyle)),
        DataColumn(label: Text('Redeem Code', style: headerStyle)),
        DataColumn(label: Text('Gift Code', style: headerStyle)),
        DataColumn(label: Text('Gift Name', style: headerStyle)),
        DataColumn(label: Text('Point', style: headerStyle)),
        DataColumn(label: Text('Date of Redeem', style: headerStyle)),
      ], rows: [
        DataRow(cells: [
          DataCell(Text('1')),
          DataCell(Text('Stephen')),
          DataCell(Text('Actor')),
          DataCell(Text('Actor')),
          DataCell(Text('Actor')),
          DataCell(Text('Actor')),
        ]),
      ]),
    ), isAlwaysShown: true, radius: Radius.circular(10), controller: ScrollController(), thickness: 3,);
  }
}
