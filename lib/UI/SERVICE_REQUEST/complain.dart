import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/page_route.dart';
import '../../Common/textinput.dart';
import '../../Constant/color.dart';
import '../../Constant/userdata.dart';
import '../../UI/SERVICE_REQUEST/service_request.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complain extends StatefulWidget {
  @override
  _ComplainState createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  // TextEditingController qrCodeTextField = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  File image, video;
  final picker = ImagePicker();
  bool isLoading = false;
  List<String> complainCategory = ["Product Related", "Price Related", "Staff Related", "Other"];
  String complain = "Product Related";
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null)
        image = File(pickedFile.path);
    });
    if((await image.length() / 1024) > 2048) {
      setState(() {
        image = null;
      });
      Fluttertoast.showToast(msg: "File size must be under 2MB");
    }
  }
  Future getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery, preferredCameraDevice: CameraDevice.rear);
    setState(() {
      if(pickedFile != null)
        video = File(pickedFile.path);
    });
    if((await video.length() / 1024) > 2048) {
      setState(() {
        video = null;
      });
      Fluttertoast.showToast(msg: "File size must be under 2MB");
    }
  }
  /*
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
  */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(context: context, title: "Complain"),
      body: Stack(
        children : [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 30, bottom: 100),
            child: Column(
              children: [
                Container(
                  width: size.width - 20,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 10,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton(
                      underline: SizedBox.shrink(),
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      value: complain,
                      isExpanded: true,
                      items: complainCategory.map((comp) {
                        return DropdownMenuItem(
                            value: comp, child: Text(comp));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          complain = value;
                        });
                      }),
                ),
                input(context: context, text: "Brief Description $mandatoryChar", decoration: InputDecoration(border: border()), maxLines: 5, controller: descriptionText),
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
  Widget attachButton({String text, @required VoidCallback onPressed}){
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
    if(id.isNotEmpty && descriptionText.text.isNotEmpty && complain.isNotEmpty){
      FormData data = FormData.fromMap({
        "customer_id" : id,
        "api_key" : Urls.apiKey,
        "description" : descriptionText.text,
        "code" : complain,
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
      Fluttertoast.showToast(msg: "Please provide description");
    }
  }
}