import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/page_route.dart';
import '../../Common/textinput.dart';
import 'package:barcode_scan/barcode_scan.dart';
import '../../Constant/color.dart';
import '../../Constant/userdata.dart';
import '../../Pages/SERVICE_REQUEST/service_request.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complain extends StatefulWidget {
  @override
  _ComplainState createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  TextEditingController qrCodeTextField = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  File image, video;
  final picker = ImagePicker();
  bool isLoading = false;
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null)
        image = File(pickedFile.path);
    });
  }
  Future getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery, maxDuration: Duration(seconds: 30), preferredCameraDevice: CameraDevice.rear);
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
                input(context: context, text: "Brief Description", decoration: InputDecoration(border: border()), maxLines: 5, controller: descriptionText),
                SizedBox(height: 20,),
                attachButton(onPressed: (){
                  getImage();
                }, text: image != null ? "A file selected" : "Attach Image"),
                SizedBox(height: 20,),
                attachButton(onPressed: (){
                  getVideo();
                }, text: video != null ? "A file selected" : "Attach Video"),
              ],
            ),
          ),
          Align(
            child: customButton(
                context: context, onPressed: isLoading ? null : _addComplain, height: 60, text: isLoading ? null : "SUBMIT", child: isLoading ? SizedBox(height: 30, width: 30, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),),) : null),
            alignment: Alignment(0.0, 0.95),
          )
        ]
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
            Text(text, style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.blue[500], fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
          ],
        ),
        color: Colors.grey[100],
        height: 70);
  }

  _addComplain() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(UserParams.id);
    if(id.isNotEmpty && descriptionText.text.isNotEmpty && qrCodeTextField.text.isNotEmpty){
      FormData data = FormData.fromMap({
        "customer_id" : id,
        "api_key" : Urls.apiKey,
        "description" : descriptionText.text,
        "code" : qrCodeTextField.text,
        "image" : image != null ? await MultipartFile.fromFile(image.path, filename: image.path.split("/").last) : "",
        "video" : video != null ? await MultipartFile.fromFile(video.path, filename: video.path.split("/").last) : ""
      });
      Services.addComplain(data).then((value) {
        if(value.response == "y") {
          Fluttertoast.showToast(msg: value.message);
          Navigator.pop(context);
          Navigator.push(context, CustomPageRoute(widget: ServiceRequest()));
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
      Fluttertoast.showToast(msg: "Please provide QR Code and Description");
    }
  }
}