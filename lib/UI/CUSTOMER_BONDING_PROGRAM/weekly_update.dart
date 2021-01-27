import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/global.dart';

import '../../Common/appbar.dart';
import '../../SERVICES/services.dart';

class WeeklyUpdate extends StatefulWidget {
  @override
  _WeeklyUpdateState createState() => _WeeklyUpdateState();
}

class _WeeklyUpdateState extends State<WeeklyUpdate> {
  int purchase = 0, earnedPoints = 0;
  List<String> weekPoints = [];
  @override
  void initState() {
    getWeeklyReport();
    super.initState();
  }

  getWeeklyReport() async {
    Services.weeklyReport().then((value) {
      if (value.response == "y") {
        for (int i = 0; i < value.data[0]["earn"].length; i++) {
          var weekPoint = 0;
          for (int j = 0; j < value.data[0]["earn"]["${(i + 1)}"].length; j++) {
            // print(value.data[0]["earn"]["${(i + 1)}"][j]["point"]);
            // print(value.data[0]["earn"]["${(i + 1)}"][j]["purchase"]);
            setState(() {
              weekPoint +=
                  int.parse(value.data[0]["earn"]["${(i + 1)}"][j]["point"]);
              purchase +=
                  int.parse(value.data[0]["earn"]["${(i + 1)}"][j]["purchase"]);
              earnedPoints +=
                  int.parse(value.data[0]["earn"]["${(i + 1)}"][j]["point"]);
            });
          }
          setState(() {
            weekPoints.add(weekPoint.toString());
          });
        }
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Weekly Update"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  buildRow(title: "Current Cycle :", value: "N/A"),
                  buildRow(
                      title: "Purchase for this cycle :",
                      value: purchase.toString()),
                  buildRow(
                      title: "Cumulative Purchase :",
                      value: userdata.totalOrder),
                  buildRow(
                      title: "Earned Points :", value: earnedPoints.toString()),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < weekPoints.length; i++) ...[
                  weekBuilder(
                      head: "WK ${(i + 1).toString()}", value: weekPoints[i]),
                ]
              ],
            ),
            /* SizedBox(height: 30,),
            headerBuilder("Range Multiplier"),
            SizedBox(height: 10,),
            dataTable([
              dataTableRow(title: "Range Achieved / applicable multiplier", value: "1/0%"),
              dataTableRow(title: "Addl. range to be achieved / max multiplier", value: "30/35%"),
            ]),
            SizedBox(height: 30,),
            headerBuilder("Frequency Multiplier"),
            SizedBox(height: 10,),
            dataTable([
              dataTableRow(title: "Frequency Achieved / applicable multiplier", value: "1/0%"),
              dataTableRow(title: "Addl. frequency to be achieved / max achievable frequency multiplier", value: "30/35%"),
            ]), */
          ],
        ),
      ),
    );
  }

  Widget headerBuilder(String head) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 45,
      width: size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xff373737),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        head,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget dataTable(List<Widget> row) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Color(0xff373737).withOpacity(0.5), width: 0)),
        child: Column(
          children: row,
        ));
  }

  Widget dataTableRow({String title, String value}) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Container(
              width: (size.width * 0.7) - 30,
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 12),
                softWrap: true,
              )),
          Container(
              width: (size.width * 0.3) - 30,
              alignment: Alignment.centerRight,
              child: Text(
                value ?? "--/--",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 12),
                softWrap: true,
              )),
        ],
      ),
    );
  }

  Widget weekBuilder({String head, String value}) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: 45,
          width: (size.width - 50) / weekPoints.length,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xff373737),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            head,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 45,
          width: (size.width - 50) / weekPoints.length,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xff373737).withOpacity(0.5))),
          child: Text(
            value ?? "-",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget buildRow({String title, String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Container(
              width: (MediaQuery.of(context).size.width * 0.6) - 30,
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                softWrap: true,
              )),
          Container(
              width: (MediaQuery.of(context).size.width * 0.4) - 30,
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.grey),
                softWrap: true,
              )),
        ],
      ),
    );
  }
}
