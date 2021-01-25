import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/global.dart';
import 'package:pal/UI/OTHERS/track_complaint.dart';

import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/page_route.dart';
import '../../Constant/color.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import '../../UI/SERVICE_REQUEST/complain.dart';

class ServiceRequest extends StatefulWidget {
  @override
  _ServiceRequestState createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  List<ServiceData> services = [];
  bool isLoading = false;
  @override
  void initState() {
    getServices();
    super.initState();
  }

  void getServices() async {
    Services.serviceRequests(FormData.fromMap(
        {"customer_id": userdata.id, "api_key": Urls.apiKey})).then((value) {
      if (value.response == "y") {
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            services.add(ServiceData(
                image: value.data[i]["image"],
                desc: value.data[i]["description"],
                code: value.data[i]["code"],
                dateTime: value.data[i]["registered"],
                status: value.data[i]["status"],
                ticketNo: value.data[i]["ticket_no"],
                video: value.data[i]["video"],
                id: value.data[i]["id"]));
          });
        }
      } else {
        setState(() {
          isLoading = true;
        });
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Service Request"),
      body: services.length != 0
          ? SingleChildScrollView(
              physics: PageScrollPhysics(),
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 100),
              child: Column(
                children: [
                  for (int i = 0; i < services.length; i++) ...[
                    buildRequest(
                        complainNumber: services[i].ticketNo,
                        date: services[i].dateTime.split(" ").first,
                        status: services[i].status,
                        time: services[i].dateTime.split(" ").last),
                  ],
                ],
              ),
            )
          : Center(
              child: isLoading
                  ? Text("No services found !!!!")
                  : SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(primaryColor),
                      ),
                    ),
            ),
      floatingActionButton: customButton(
          context: context,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, CustomPageRoute(widget: Complain()));
          },
          height: 60,
          width: size.width,
          text: "NEW SERVICE REQUEST"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildRequest(
      {String complainNumber, String date, String time, String status}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                  text: "Complain Code : ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 15, color: Colors.black),
                  children: [
                    TextSpan(
                      text: complainNumber,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 15, color: Colors.grey),
                    ),
                    WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: IconButton(
                          icon: Icon(Icons.copy_outlined),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: complainNumber));
                            Fluttertoast.showToast(msg: "Copied");
                          },
                          splashRadius: 25,
                          iconSize: 18,
                          color: Colors.grey[400],
                        ))
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date + " | " + time,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 14, color: Colors.grey),
                ),
                status == "open"
                    ? FlatButton(
                        onPressed: () => Navigator.push(
                            context,
                            CustomPageRoute(
                                widget: TrackComplaint(
                              complainNumber: complainNumber,
                            ))),
                        child: Text(
                          status.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 14,
                              color: status == "open"
                                  ? Colors.green
                                  : Colors.redAccent),
                        ),
                      )
                    : Text(
                        "CLOSE",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 14, color: Colors.redAccent),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceData {
  final String code, dateTime, desc, image, video, status, ticketNo, id;
  ServiceData(
      {this.video,
      this.image,
      this.status,
      this.desc,
      this.code,
      this.dateTime,
      this.ticketNo,
      this.id});
}
