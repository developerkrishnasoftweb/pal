import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/custom_button.dart';
import '../../ui/widgets/page_route.dart';
import '../../ui/widgets/textinput.dart';
import '../../constant/global.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../services/services.dart';
import '../../ui/service_request/service_request.dart';


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
  int fileSize = 500;
  List<String> complainCategory = [
    "Product Related",
    "Price Related",
    "Staff Related",
    "Other"
  ];
  String complain = "Product Related";
  Future getImage({@required ImageSource source}) async {
    final pickedFile = await picker.getImage(
        source: source, preferredCameraDevice: CameraDevice.rear);
    setState(() {
      if (pickedFile != null) image = File(pickedFile.path);
    });
    if (image != null) {
      if ((await image.length() / 1024) > fileSize) {
        setState(() {
          image = null;
        });
        Fluttertoast.showToast(
            msg:
                "File size must be up to ${(fileSize / 1024).toStringAsFixed(2)}MB");
      }
    }
  }

  Future getVideo({@required ImageSource source}) async {
    final pickedFile = await picker.getVideo(
        source: source, preferredCameraDevice: CameraDevice.rear);
    setState(() {
      if (pickedFile != null) video = File(pickedFile.path);
    });
    if (video != null) {
      if ((await video.length() / 1024) > 2048) {
        setState(() {
          video = null;
        });
        Fluttertoast.showToast(msg: "File size must be up to 2MB");
      }
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
      appBar: appBar(
          context: context, title: translate(context, LocaleStrings.complain)),
      body: Stack(children: [
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
                      return DropdownMenuItem(value: comp, child: Text(comp));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        complain = value;
                      });
                    }),
              ),
              input(
                  context: context,
                  text:
                      "${translate(context, LocaleStrings.briefDescriptions)} $mandatoryChar",
                  maxLines: 5,
                  controller: descriptionText),
              SizedBox(
                height: 20,
              ),
              attachButton(
                  onPressed: () => _showSheet(
                      cameraOnPressed: () => _getFile(
                          mediaType: MediaType.IMAGE, source: Source.CAMERA),
                      galleryOnPressed: () => _getFile(
                          mediaType: MediaType.IMAGE, source: Source.GALLERY)),
                  text: image != null
                      ? image.path.split("/").last
                      : translate(context, LocaleStrings.attachImage),
                  showIcon: image != null ? false : true),
              SizedBox(
                height: 20,
              ),
              attachButton(
                  // onPressed: () => _showSheet(
                  //     cameraOnPressed: () => _getFile(
                  //         mediaType: MediaType.VIDEO, source: Source.CAMERA),
                  //     galleryOnPressed: () => _getFile(
                  //         mediaType: MediaType.VIDEO, source: Source.GALLERY)),
                  text: video != null
                      ? video.path.split("/").last
                      : translate(context, LocaleStrings.attachVideo),
                  onPressed: null,
                  showIcon: video != null ? false : true),
            ],
          ),
        ),
        Align(
          child: customButton(
              context: context,
              onPressed: isLoading ? null : _addComplain,
              text: isLoading
                  ? null
                  : translate(context, LocaleStrings.submitBtn),
              child: isLoading
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: circularProgressIndicator(),
                    )
                  : null),
          alignment: Alignment(0.0, 0.95),
        )
      ]),
    );
  }

  Widget attachButton(
      {String text, @required VoidCallback onPressed, bool showIcon: true}) {
    return customButton(
        context: context,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showIcon
                ? Icon(
                    Icons.attach_file,
                    color:
                        onPressed != null ? Colors.blue[500] : Colors.blue[100],
                  )
                : SizedBox(),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color:
                        onPressed != null ? Colors.blue[500] : Colors.blue[100],
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        color: Colors.grey[100],
        height: 70);
  }

  _addComplain() async {
    setState(() {
      isLoading = true;
    });
    if (userdata.id.isNotEmpty &&
        descriptionText.text.isNotEmpty &&
        complain.isNotEmpty) {
      FormData data = FormData.fromMap({
        "customer_id": userdata.id,
        "api_key": API_KEY,
        "description": descriptionText.text,
        "code": complain,
        "image": image != null
            ? await MultipartFile.fromFile(image.path,
                filename: image.path.split("/").last)
            : "",
        "video": video != null
            ? await MultipartFile.fromFile(video.path,
                filename: video.path.split("/").last)
            : ""
      });
      await Services.addComplain(data).then((value) {
        if (value.response == "y") {
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
      Fluttertoast.showToast(
          msg: translate(context, LocaleStrings.pleaseProvideDescription));
    }
  }

  _getFile({@required MediaType mediaType, @required Source source}) async {
    if (mediaType == MediaType.IMAGE && source == Source.CAMERA) {
      Navigator.pop(context);
      getImage(source: ImageSource.camera);
    } else if (mediaType == MediaType.IMAGE && source == Source.GALLERY) {
      Navigator.pop(context);
      getImage(source: ImageSource.gallery);
    } else if (mediaType == MediaType.VIDEO && source == Source.GALLERY) {
      Navigator.pop(context);
      getVideo(source: ImageSource.gallery);
    } else if (mediaType == MediaType.VIDEO && source == Source.CAMERA) {
      Navigator.pop(context);
      getVideo(source: ImageSource.camera);
    }
  }

  _showSheet(
      {@required VoidCallback cameraOnPressed,
      @required VoidCallback galleryOnPressed}) {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: size.width,
            height: 110,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                  onPressed: cameraOnPressed,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey,
                      ),
                      Text(
                        translate(context, LocaleStrings.camera),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: galleryOnPressed,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.grey,
                      ),
                      Text(
                        translate(context, LocaleStrings.gallery),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

enum MediaType { IMAGE, VIDEO }
enum Source { CAMERA, GALLERY }
