import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/constant/color.dart';
import 'package:pal/constant/strings.dart';
import 'package:pal/localization/localizations_constraints.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/custom_button.dart';
import '../../ui/widgets/page_route.dart';
import '../../ui/widgets/show_dialog.dart';
import '../../ui/widgets/textinput.dart';
import '../../constant/global.dart';
import '../../constant/models.dart';
import '../../services/services.dart';
import '../../ui/signin_signup/otp.dart';

class DeliveryAddress extends StatefulWidget {
  final GiftData giftData;
  final StoreDetails storeDetails;

  const DeliveryAddress(
      {Key key, @required this.giftData, @required this.storeDetails})
      : super(key: key);

  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  String addressType = "Collect from outlet",
      address = "",
      ext = "",
      altMobile = "",
      pincode = "";
  bool collectToShop = false, isLoading = false, fileLoading = false;
  File file;
  TextEditingController stateAPI = TextEditingController();
  TextEditingController areaAPI = TextEditingController();
  TextEditingController cityAPI = TextEditingController();
  List<String> listAreas = [];

  Future getFile() async {
    setFileLoading(true);
    File result = await FilePicker.getFile(type: FileType.any);
    if (result != null) {
      if ((await result.length() / 1024) <= 2048) {
        setState(() {
          ext = result.path.split("/").last.split(".").last;
        });
        if (ext == "pdf" || ext == "jpeg" || ext == "png" || ext == "jpg") {
          setFileLoading(false);
          setState(() {
            file = File(result.path);
          });
        } else {
          setFileLoading(false);
          Fluttertoast.showToast(msg: "File type " + ext + " is not supported");
        }
      } else {
        setFileLoading(false);
        Fluttertoast.showToast(msg: "File size must be under 2MB");
      }
    } else
      setFileLoading(false);
  }

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  setFileLoading(bool status) {
    setState(() {
      fileLoading = status;
    });
  }

  @override
  void dispose() {
    super.dispose();
    stateAPI.dispose();
    areaAPI.dispose();
    cityAPI.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
          context: context,
          title: translate(context, LocaleStrings.deliveryAddress)),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 100),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              height: 20,
            ),
            /* Container(
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
                    if (value == "Collect from outlet") {
                      collectToShop = false;
                    } else if (value == "Home delivery") {
                      collectToShop = true;
                    }
                  });
                },
                underline: SizedBox.shrink(),
                value: addressType,
                //TODO: In future "Home Delivery" option will be added in dropdown
                items: ["Collect from outlet"].map((text) {
                  return DropdownMenuItem(
                    value: text,
                    child: Text(text),
                  );
                }).toList(),
              ),
            ), */
            Visibility(
                replacement: buildCollectToShop(),
                visible: collectToShop,
                child: buildHomeDelivery())
          ],
        ),
      ),
      floatingActionButton: customButton(
          context: context,
          onPressed: isLoading ? null : _redeem,
          width: size.width,
          child: isLoading
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: circularProgressIndicator(),
                )
              : null,
          text: isLoading ? null : translate(context, LocaleStrings.submitBtn)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildHomeDelivery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        input(
            context: context,
            text: translate(context, LocaleStrings.address),
            onChanged: (value) {
              setState(() {
                address = value;
              });
            },
            textInputAction: TextInputAction.next),
        input(
            context: context,
            text: translate(context, LocaleStrings.alternateMobileNumber),
            onChanged: (value) {
              setState(() {
                altMobile = value;
              });
            },
            keyboardType: TextInputType.number),
        input(
            context: context,
            text: translate(context, LocaleStrings.pinCode),
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
                contentPadding: EdgeInsets.all(10),
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
            text: translate(context, LocaleStrings.state),
            controller: stateAPI),
        input(
            context: context,
            text: translate(context, LocaleStrings.city),
            controller: cityAPI),
        listAreas.length > 1
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(context, LocaleStrings.address),
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
                text: translate(context, LocaleStrings.address),
                controller: areaAPI),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Upload Proof (Any one) :",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        proofBuilder(onTap: getFile),
        Text(
          "Note : Home delivery charges applied (\u20B9 100) / As per geographical location",
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  _getPinCodeData() {
    setState(() {
      listAreas = [];
    });
    if (pincode.length == 6) {
      FocusScope.of(context).unfocus();
      showDialogBox(
          context: context,
          widget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: circularProgressIndicator(),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                translate(context, LocaleStrings.pleaseWait),
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
        Text(
          "${widget.storeDetails.name}",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: primaryColor, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "${translate(context, LocaleStrings.currentAddress)} :",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        buildTitledRow(
            title: translate(context, LocaleStrings.address),
            value: widget.storeDetails.location),
        buildTitledRow(
            title: translate(context, LocaleStrings.city),
            value: widget.storeDetails.city),
        buildTitledRow(
            title: translate(context, LocaleStrings.state),
            value: widget.storeDetails.state),
        buildTitledRow(
            title: translate(context, LocaleStrings.pinCode),
            value: widget.storeDetails.pinCode),
        input(
            context: context,
            text:
                "${translate(context, LocaleStrings.alternateMobileNumber)} $mandatoryChar",
            onChanged: (value) {
              setState(() {
                altMobile = value;
              });
            },
            keyboardType: TextInputType.number),
        /* Text(
          "Upload Proof (Any one) : Aadhaar, Pan, Voter Card, Driving Licence $mandatoryChar",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        proofBuilder(onTap: getFile) */
      ],
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
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value != "" && value != null ? value : "N/A",
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget proofBuilder({GestureTapCallback onTap}) {
    return Container(
      height: 120,
      width: 180,
      padding: const EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: fileLoading
          ? SizedBox(
              height: 15,
              width: 15,
              child: circularProgressIndicator(),
            )
          : file == null
              ? Column(
                  children: [
                    attachButton(onPressed: getFile, text: "Attach File"),
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

  _redeem() async {
    String otp = RandomInt.generate().toString();
    if (addressType == "Home delivery") {
      if (address.isNotEmpty &&
          stateAPI.text.isNotEmpty &&
          cityAPI.text.isNotEmpty &&
          areaAPI.text.isNotEmpty &&
          pincode.isNotEmpty &&
          file != null) {
        if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(altMobile)) {
          setLoading(true);
          FormData data = FormData.fromMap({
            "customer_id": userdata.id,
            "api_key": API_KEY,
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
                : "",
            "delivery_type": "h",
            "store_id": "0"
          });
          sendSMS(mobile: userdata.mobile, formData: data, otp: otp);
        } else {
          Fluttertoast.showToast(
              msg: translate(context, LocaleStrings.invalidMobileNumber));
        }
      } else {
        Fluttertoast.showToast(
            msg: translate(context, LocaleStrings.allFieldsAreRequired));
      }
    } else {
      /*
      * Collect from outlet
      * */
      if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(altMobile)) {
        setLoading(true);
        FormData data = FormData.fromMap({
          "customer_id": userdata.id,
          "api_key": API_KEY,
          "gift_id": widget.giftData.id,
          "point": widget.giftData.points,
          "address": widget.storeDetails.location,
          "area": widget.storeDetails.location,
          "city": widget.storeDetails.city,
          "pincode": widget.storeDetails.pinCode,
          "alt_mobile": altMobile,
          "state": widget.storeDetails.state,
          "proof": file != null
              ? await MultipartFile.fromFile(file.path,
                  filename: file.path.split("/").last)
              : "",
          "delivery_type": "s",
          "store_id": widget.storeDetails.code,
        });
        sendSMS(mobile: userdata.mobile, formData: data, otp: otp);
      } else {
        Fluttertoast.showToast(
            msg: translate(context, LocaleStrings.invalidMobileNumber));
      }
    }
  }

  sendSMS({String mobile, String otp, FormData formData}) async {
    FormData smsData = SMS_DATA(
        message: otp +
            " is your OTP to Redeem to PAL App. Don't share it with anyone",
        mobile: mobile);
    await Services.sms(
                "<#> $otp is your OTP to Redeem to PAL App. Don't share it with anyone",
            mobile)
        .then((value) {
      if (value.response == "0") {
        setLoading(false);
        Navigator.pushReplacement(
            context,
            CustomPageRoute(
                widget: OTP(
              mobile: mobile,
              action: OtpActions.REDEEM_GIFT,
              formData: formData,
              otp: otp,
            )));
      } else {
        setLoading(false);
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }
}

class StoreDetails {
  final String id,
      name,
      code,
      status,
      inserted,
      insertedBy,
      modified,
      modifiedBy,
      apiType,
      giftStatus,
      location,
      city,
      state,
      pinCode;

  StoreDetails(
      {this.id,
      this.name,
      this.code,
      this.status,
      this.inserted,
      this.insertedBy,
      this.modified,
      this.modifiedBy,
      this.apiType,
      this.giftStatus,
      this.location,
      this.city,
      this.state,
      this.pinCode});

  StoreDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        code = json['code'],
        status = json['status'],
        inserted = json['inserted'],
        insertedBy = json['inserted_by'],
        modified = json['modified'],
        modifiedBy = json['modified_by'],
        apiType = json['api_type'],
        giftStatus = json['gift_status'],
        location = json['location'],
        city = json['city'],
        state = json['state'],
        pinCode = json['pincode'];
}
