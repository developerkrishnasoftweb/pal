import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/page_route.dart';
import 'package:pal/Pages/SERVICE_REQUEST/complain.dart';

class ServiceRequest extends StatefulWidget {
  @override
  _ServiceRequestState createState() => _ServiceRequestState();
}
class _ServiceRequestState extends State<ServiceRequest> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Service Request"),
      body: SingleChildScrollView(
        physics: PageScrollPhysics(),
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 100),
        child: Column(
          children: [
            buildRequest(complainNumber: "CHA18129009724766-1", date: "27 Apr 2019", status: 0, time: "01:59 PM"),
            buildRequest(complainNumber: "CHA18129009724766-1", date: "27 Apr 2019", status: 1, time: "01:59 PM"),
            buildRequest(complainNumber: "CHA18129009724766-1", date: "27 Apr 2019", status: 1, time: "01:59 PM"),
          ],
        ),
      ),
      floatingActionButton: customButton(context: context, onPressed: () => Navigator.push(context, CustomPageRoute(widget: Complain())), height: 60, width: size.width, text: "NEW SERVICE REQUEST"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildRequest({String complainNumber, String date, String time, int status}){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                  text: "Complain Code : ",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15, color: Colors.black),
                  children: [
                    TextSpan(
                      text: complainNumber,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15, color: Colors.grey),
                    ),
                  ]
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date + " | " + time, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14, color: Colors.grey),),
                Text(status == 1 ? "Closed Call" : "Cancelled Call", style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14, color: status == 1 ? Colors.green : Colors.redAccent),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
