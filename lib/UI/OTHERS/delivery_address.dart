import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/show_dialog.dart';
import '../../Common/page_route.dart';
import '../../Constant/color.dart';
import '../../Constant/userdata.dart';
import '../../UI/HOME/home.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/redeem_gift.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/textinput.dart';

class DeliveryAddress extends StatefulWidget {
  final GiftData giftData;
  DeliveryAddress({@required this.giftData});
  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  String addressType = "Select Delivery Type",
      address = "",
      ext = "",
      altMobile = "",
      pincode = "";
  bool collectToShop = false, isLoading = false;
  File file;
  TextEditingController stateAPI = TextEditingController();
  TextEditingController areaAPI = TextEditingController();
  TextEditingController cityAPI = TextEditingController();
  List<String> listAreas = [];

  Future getImage() async {
    File result = await FilePicker.getFile(
        allowedExtensions: ["pdf", "jpg", "jpeg", "png"],
        type: FileType.custom);
    if (result != null) {
      setState(() {
        ext = result.path.split("/").last.split(".").last;
      });
      if (ext == "pdf" || ext == "jpeg" || ext == "png" || ext == "jpg") {
        setState(() {
          file = File(result.path);
        });
      } else {
        Fluttertoast.showToast(msg: "File type " + ext + " is not supported");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Delivery Address"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 100),
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              height: 20,
            ),
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
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    file = null;
                    addressType = value;
                    if (value == "Collect to shop") {
                      collectToShop = true;
                    } else if (value == "Home delivery") {
                      collectToShop = false;
                    }
                  });
                },
                underline: SizedBox.shrink(),
                value: addressType,
                items: [
                  "Select Delivery Type",
                  "Collect to shop",
                  "Home delivery"
                ].map((text) {
                  return DropdownMenuItem(
                    value: text,
                    child: Text(text),
                  );
                }).toList(),
              ),
            ),
            Visibility(
                replacement: addressType != "Select Delivery Type"
                    ? buildHomeDelivery()
                    : SizedBox.shrink(),
                visible: collectToShop,
                child: addressType != "Select Delivery Type"
                    ? buildCollectToShop()
                    : SizedBox.shrink()),
          ],
        ),
      ),
      floatingActionButton: customButton(
          context: context,
          onPressed: isLoading ? null : _redeem,
          height: 60,
          width: size.width,
          child: isLoading
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                )
              : null,
          text: isLoading ? null : "CONFIRM"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildHomeDelivery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        input(
            context: context,
            text: "Address",
            onChanged: (value) {
              setState(() {
                address = value;
              });
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: border(),
            ),
            maxLines: 5),
        input(
            context: context,
            text: "Alternate Mobile No.",
            onChanged: (value) {
              setState(() {
                altMobile = value;
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(border: border())),
        input(
            context: context,
            text: "Pincode",
            onChanged: (value) {
              setState(() {
                pincode = value;
              });
              _getPinCodeData();
            },
            onEditingComplete: _getPinCodeData,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: border(),
                prefixIcon: Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/icons/indian-flag-icon.png",
                      height: 30,
                      width: 30,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    )))),
        input(
            context: context,
            text: "State",
            controller: stateAPI,
            decoration: InputDecoration(border: border())),
        input(
            context: context,
            text: "City",
            controller: cityAPI,
            decoration: InputDecoration(border: border())),
        listAreas.length > 1
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Area",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                        value: areaAPI.text,
                        isExpanded: true,
                        decoration: InputDecoration(border: border()),
                        items: listAreas.map((area) {
                          return DropdownMenuItem(
                              child: Text(area), value: area);
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            areaAPI.text = value;
                          });
                        }),
                  ],
                ),
              )
            : input(
                context: context,
                text: "Area",
                controller: areaAPI,
                decoration: InputDecoration(border: border())),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Upload Proof (Any one) :",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        proofBuilder(onTap: getImage)
      ],
    );
  }

  _getPinCodeData() {
    setState(() {
      listAreas = [];
    });
    if (pincode.length == 6) {
      showDialogBox(
          context: context,
          widget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Please wait...",
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          barrierDismissible: false);
      Services.getPinData(pincode).then((value) {
        if (value.response == "Success") {
          for (int i = 0; i < value.data.length; i++) {
            setState(() {
              listAreas.add(value.data[i]["Name"]);
            });
          }
          setState(() {
            stateAPI.text = value.data[0]["Circle"];
            cityAPI.text = value.data[0]["District"];
            areaAPI.text = value.data[0]["Name"];
          });
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: value.message);
          setState(() {
            stateAPI.clear();
            cityAPI.clear();
            areaAPI.clear();
          });
          Navigator.pop(context);
        }
      });
    }
  }

  Widget buildCollectToShop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitledRow(
            title: "Current Address :",
            value:
                "NR Gov.School, Main Market, Sherpur Kalan, Ludhiana, 9216785632, Sherpur"),
        SizedBox(
          height: 15,
        ),
        Text(
          "Upload Proof (Any one) : Aadhaar, Pan, Voter Card, Driving Licence",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        proofBuilder(onTap: getImage)
      ],
    );
  }

  Widget proofBuilder({GestureTapCallback onTap}) {
    return Container(
      height: 120,
      width: 180,
      padding: const EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: file == null
          ? Column(
              children: [
                attachButton(onPressed: getImage, text: "Attach File"),
              ],
            )
          : file != null && ext != "pdf"
              ? Image.file(
                  File(file.path),
                  fit: BoxFit.fill,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/pdf-icon.png",
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      file.path.split("/").last,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ), //Image.file(File(file.path), fit: BoxFit.fill,),
    );
  }

  Widget attachButton({String text, @required VoidCallback onPressed}) {
    return customButton(
        context: context,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.attach_file,
              color: Colors.blue[500],
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.blue[500], fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        color: Colors.grey[100],
        height: 50);
  }

  Widget buildTitledRow({String title, String value}) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  _redeem() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString(UserParams.id);
    if (addressType == "Home delivery") {
      setState(() {
        isLoading = true;
      });
      if (address.isNotEmpty &&
          stateAPI.text.isNotEmpty &&
          cityAPI.text.isNotEmpty &&
          areaAPI.text.isNotEmpty &&
          pincode.isNotEmpty &&
          file != null) {
        if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(altMobile)) {
          FormData data = FormData.fromMap({
            "customer_id": id,
            "api_key": Urls.apiKey,
            "gift_id": widget.giftData.id,
            "point": widget.giftData.points,
            "address": address,
            "area": areaAPI.text,
            "city": cityAPI.text,
            "pincode": pincode,
            "alt_mobile": altMobile,
            "state": stateAPI.text,
            "proof": file != null
                ? await MultipartFile.fromFile(file.path,
                    filename: file.path.split("/").last)
                : null,
          });
          await Services.redeemGift(data).then((value) async {
            if (value.response == "y") {
              await userData(value.data[0]["customer"]);
              Fluttertoast.showToast(msg: value.message);
              Navigator.pushAndRemoveUntil(
                  context, CustomPageRoute(widget: Home()), (route) => false);
              setState(() {
                isLoading = false;
              });
            } else {
              Fluttertoast.showToast(msg: value.message);
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Invalid mobile number");
        }
      } else {
        Fluttertoast.showToast(msg: "All fields are required");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Unable to process request");
    }
  }
}
