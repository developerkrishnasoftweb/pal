import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/textinput.dart';

class TrackComplaint extends StatefulWidget {
  @override
  _TrackComplaintState createState() => _TrackComplaintState();
}

class _TrackComplaintState extends State<TrackComplaint> {
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
            )
          ),
        ],
      ),
      floatingActionButton: customButton(context: context, onPressed: (){}, height: 60, width: size.width, text: "SEARCH"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
