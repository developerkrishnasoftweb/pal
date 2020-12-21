import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/input_decoration.dart';
import 'package:pal/Common/textinput.dart';
import 'package:barcode_scan/barcode_scan.dart';

class Complain extends StatefulWidget {
  @override
  _ComplainState createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  TextEditingController qrCodeTextField = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  File image;
  File video;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if(pickedFile != null)
        image = File(pickedFile.path);
    });
  }
  Future getVideo(ImageSource source) async {
    final pickedFile = await picker.getVideo(source: source, maxDuration: Duration(seconds: 30), preferredCameraDevice: CameraDevice.rear);
    setState(() {
      if(pickedFile != null)
        video = File(pickedFile.path);
    });
  }
  Future _scanQrCode() async {
    try{
      var result = await BarcodeScanner.scan();
      setState(() {
        qrCodeTextField.text = result.rawContent;
      });
    } on PlatformException catch(e) {
      if(e.code == BarcodeScanner.cameraAccessDenied){
        Fluttertoast.showToast(msg: "Permission Denied");
      } else {
        Fluttertoast.showToast(msg: "Something went wrong " + e.toString());
      }
    } on FormatException{
      Fluttertoast.showToast(msg: "Closed");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(context: context, title: "Complain"),
      body: Stack(
        children : [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 30, bottom: 100),
            child: Column(
              children: [
                customButton(
                    context: context,
                    onPressed: _scanQrCode,
                    text: "Scan QR Code",
                    color: Colors.grey[100],
                    height: 70,
                    textColor: Colors.black),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text("OR", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),),
                ),
                input(context: context, text: "Enter QR Code", decoration: InputDecoration(border: border()), controller: qrCodeTextField),
                input(context: context, text: "Brief Description", decoration: InputDecoration(border: border()), maxLines: 5),
                SizedBox(height: 20,),
                attachButton(onPressed: (){
                  scaffoldKey.currentState.showBottomSheet((context){
                    return bottomSheet(TYPE.image);
                  }, backgroundColor: Colors.white, elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))));
                }, text: "Attach Image"),
                SizedBox(height: 20,),
                attachButton(onPressed: (){
                  scaffoldKey.currentState.showBottomSheet((context){
                    return bottomSheet(TYPE.video);
                  }, backgroundColor: Colors.white, elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))));
                }, text: "Attach Video"),
              ],
            ),
          ),
          Align(
            child: customButton(
                context: context, onPressed: () {}, height: 60, text: "SUBMIT"),
            alignment: Alignment(0.0, 0.95),
          )
        ]
      ),
    );
  }
  Widget bottomSheet(TYPE type){
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 120,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customButton(context: context, onPressed: (){
            type == TYPE.image ? getImage(ImageSource.camera) : getImage(ImageSource.gallery);
          }, child: Column(
            children: [
              Icon(Icons.camera_alt_rounded),
              Text("Camera", style: TextStyle(fontSize: 12),)
            ],
          ), color: Colors.grey[100], width: size.width * 0.3, padding: EdgeInsets.only(top: 20), height: 80),
          customButton(context: context, onPressed: (){
            type == TYPE.video ? getVideo(ImageSource.camera) : getVideo(ImageSource.gallery);
          }, child: Column(
            children: [
              Icon(Icons.image_outlined),
              Text("Gallery", style: TextStyle(fontSize: 12),)
            ],
          ), color: Colors.grey[100], width: size.width * 0.3, padding: EdgeInsets.only(top: 20), height: 80)
        ],
      ),
    );
  }
  Widget attachButton({String text,  @required VoidCallback onPressed}){
    return customButton(
        context: context,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.attach_file, color: Colors.blue[500],),
            SizedBox(width: 10,),
            Text(text, style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.blue[500], fontWeight: FontWeight.bold),)
          ],
        ),
        color: Colors.grey[100],
        height: 70);
  }
}
enum TYPE{
  image,
  video
}