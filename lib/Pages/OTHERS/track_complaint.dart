import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/SERVICES/services.dart';
import 'package:pal/SERVICES/urls.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/textinput.dart';

class TrackComplaint extends StatefulWidget {
  @override
  _TrackComplaintState createState() => _TrackComplaintState();
}

class _TrackComplaintState extends State<TrackComplaint> {
  String complainNo = "";
  ComplainDetails details;
  _getComplainData() async {
    if(complainNo.isNotEmpty){
      Services.trackComplaint(FormData.fromMap({"api_key" : Urls.apiKey, "ticket_no" : complainNo})).then((value) {
        if(value.response == "y"){
          details = ComplainDetails(complainNo: value.data[0]["detail"]["ticket_no"]);
        } else {
          Fluttertoast.showToast(msg: value.message);
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Please enter complain no.");
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Track Complaint"),
      body: Column(
        children: [
          input(
            autoFocus: true,
            context: context,
            text: "Enter Complaint No.",
            padding: EdgeInsets.all(20),
            decoration: InputDecoration(
              border: border(),
            ),
            onEditingComplete: _getComplainData,
            onChanged: (value){
              setState(() {
                complainNo = value;
              });
            }
          ),
        ],
      ),
      floatingActionButton: complainNo.isNotEmpty ? customButton(context: context, onPressed: _getComplainData, height: 60, width: size.width, text: "SEARCH") : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
class ComplainDetails{
  final String complainNo, desc, status;
  final List<Progress> progress;
  ComplainDetails({this.status, this.desc, this.complainNo, this.progress});
}
class Progress{
  final String id, comment, dateTime, lastModifyDate;
  Progress({this.dateTime, this.id, this.comment, this.lastModifyDate});
}