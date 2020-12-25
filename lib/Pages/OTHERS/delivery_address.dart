import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../Common/page_route.dart';
import '../../Constant/color.dart';
import '../../Constant/userdata.dart';
import '../../Pages/HOME/home.dart';
import '../../Pages/RETAILER_BONDING_PROGRAM/redeem_gift.dart';
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
      state = "",
      city = "",
      area = "",
      ext = "",
      pincode = "";
  bool collectToShop = false, isLoading = false;
  File file;

  Future getImage() async {
    File result = await FilePicker.getFile(allowedExtensions: ["pdf", "jpg", "jpeg", "png"], type: FileType.custom);
    ext = result.path.split("/").last.split(".").last;
    if(result != null) {
      if(ext == "pdf" || ext == "jpeg" || ext == "png" || ext == "jpg"){
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
          child: isLoading ? SizedBox(height: 30, width: 30, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),),) : null,
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
            text: "State",
            onChanged: (value) {
              setState(() {
                state = value;
              });
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(border: border())),
        input(
            context: context,
            text: "City",
            onChanged: (value) {
              setState(() {
                city = value;
              });
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(border: border())),
        input(
            context: context,
            text: "Area",
            onChanged: (value) {
              setState(() {
                area = value;
              });
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(border: border())),
        input(
            context: context,
            text: "Pincode",
            onChanged: (value) {
              setState(() {
                pincode = value;
              });
            },
            onEditingComplete: _redeem,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(border: border())),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Upload Proof (Any one) :",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        proofBuilder("Aadhaar, Pan, Voter Card, Driving Licence",
            onTap: getImage)
      ],
    );
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
          "Upload Proof (Any one) :",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        proofBuilder("Aadhaar, Pan, Voter Card, Driving Licence",
            onTap: getImage)
      ],
    );
  }

  Widget proofBuilder(String text, {GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 120,
        width: 180,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: file == null ? Text(text) : Text(file.path.split("/").last),
        ) //Image.file(File(file.path), fit: BoxFit.fill,),
      ),
    );
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
          state.isNotEmpty &&
          city.isNotEmpty &&
          area.isNotEmpty &&
          pincode.isNotEmpty &&
          file != null) {
        FormData data = FormData.fromMap({
          "customer_id": id,
          "api_key": Urls.apiKey,
          "gift_id": widget.giftData.id,
          "point": widget.giftData.points,
          "address": address,
          "area": area,
          "city": city,
          "pincode": pincode,
          "state": state,
          "proof": await MultipartFile.fromFile(file.path,
              filename: file.path.split("/").last),
        });
        await Services.redeemGift(data).then((value) async {
          if(value.response == "y"){
            await userData(value.data[0]["customer"]);
            Fluttertoast.showToast(msg: value.message);
            Navigator.pushAndRemoveUntil(context, CustomPageRoute(widget: Home()), (route) => false);
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
