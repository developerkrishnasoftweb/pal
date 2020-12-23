import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/color.dart';
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
  bool isLoading = false;
  _getComplainData() async {
    details = null;
    if(complainNo.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      Services.trackComplaint(FormData.fromMap({"api_key" : Urls.apiKey, "ticket_no" : complainNo})).then((value) {
        if(value.response == "y"){
          setState(() {
            details = ComplainDetails(complainNo: value.data[0]["detail"]["ticket_no"], status: value.data[0]["detail"]["status"], desc: value.data[0]["detail"]["description"], progress: value.data[0]["progress"]);
            isLoading = false;
          });
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
      Fluttertoast.showToast(msg: "Please enter complain no.");
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Track Complaint"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
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
            SizedBox(height: 10,),
            details != null ? ExpansionTile(
              title: Text("Complain No.:" + details.complainNo),
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
                Divider(endIndent: 20,),
                Align(child: Text("Progress", style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 17)), alignment: Alignment.centerLeft,),
                for(int i = 0; i < details.progress.length; i++)...[
                  Container(child: Text(details.progress[i]["comment"]), padding: EdgeInsets.symmetric(vertical: 5), alignment: Alignment.centerLeft,),
                ]
              ],
            ) : isLoading ? SizedBox(height: 30, width: 30, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),),) : SizedBox()
          ],
        ),
      ),
      floatingActionButton: complainNo.isNotEmpty ? customButton(context: context, onPressed: _getComplainData, height: 60, width: size.width, text: "SEARCH") : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
class ComplainDetails{
  final String complainNo, desc, status;
  final List<dynamic> progress;
  ComplainDetails({this.status, this.desc, this.complainNo, this.progress});
}