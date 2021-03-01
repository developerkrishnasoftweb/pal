import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/global.dart';
import 'package:pal/Constant/strings.dart';
import 'package:pal/LOCALIZATION/localizations_constraints.dart';

import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/textinput.dart';
import '../../Constant/color.dart';
import '../../Constant/models.dart';
import '../../SERVICES/services.dart';

class TrackComplaint extends StatefulWidget {
  final String complainNumber;
  TrackComplaint({this.complainNumber});
  @override
  _TrackComplaintState createState() => _TrackComplaintState();
}

class _TrackComplaintState extends State<TrackComplaint> {
  TextEditingController complainNo = TextEditingController();
  ComplainDetails details;
  bool isLoading = false, dataFound = false;
  @override
  void initState() {
    setState(() {
      complainNo.text =
          widget.complainNumber != null ? widget.complainNumber : "";
    });
    _getComplainData();
    super.initState();
  }

  _getComplainData() async {
    details = null;
    if (complainNo.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      Services.trackComplaint(FormData.fromMap(
              {"api_key": API_KEY, "ticket_no": complainNo.text}))
          .then((value) {
        if (value.response == "y") {
          if (value.data[0].length != 0) {
            setState(() {
              details = ComplainDetails(
                  complainNo: value.data[0]["detail"]["ticket_no"],
                  status: value.data[0]["detail"]["status"],
                  desc: value.data[0]["detail"]["description"],
                  progress: value.data[0]["progress"]);
              isLoading = false;
            });
          } else {
            setState(() {
              dataFound = true;
            });
            Fluttertoast.showToast(msg: value.message);
          }
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: value.message);
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: translate(context, LocaleStrings.enterComplainNo));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
          context: context,
          title: translate(context, LocaleStrings.trackComplaints)),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            input(
              autoFocus: widget.complainNumber != null ? false : true,
              context: context,
              text:
                  "${translate(context, LocaleStrings.enterComplainNo)} $mandatoryChar",
              onChanged: (value) {
                setState(() {});
              },
              onEditingComplete: _getComplainData,
              controller: complainNo,
            ),
            SizedBox(
              height: 10,
            ),
            details != null
                ? ExpansionTile(
                    title: Text(
                        "${translate(context, LocaleStrings.complainNo)} : " +
                            details.complainNo),
                    initiallyExpanded: true,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Issue : " + details.desc),
                        Text("Status : " + details.status),
                      ],
                    ),
                    childrenPadding: EdgeInsets.only(left: 20),
                    children: [
                      Divider(
                        endIndent: 20,
                      ),
                      Align(
                        child: Text("Progress",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 17)),
                        alignment: Alignment.centerLeft,
                      ),
                      for (int i = 0; i < details.progress.length; i++) ...[
                        Container(
                          child: Text(details.progress[i]["comment"]),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.centerLeft,
                        ),
                      ]
                    ],
                  )
                : dataFound
                    ? SizedBox()
                    : isLoading
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(primaryColor),
                            ),
                          )
                        : SizedBox()
          ],
        ),
      ),
      floatingActionButton: complainNo.text.length > 0
          ? customButton(
              context: context,
              onPressed: _getComplainData,
              height: 60,
              width: size.width,
              text: translate(context, LocaleStrings.searchBtn))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ComplainDetails {
  final String complainNo, desc, status;
  final List<dynamic> progress;
  ComplainDetails({this.status, this.desc, this.complainNo, this.progress});
}
