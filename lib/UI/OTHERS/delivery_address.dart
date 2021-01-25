import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/page_route.dart';
import '../../Common/show_dialog.dart';
import '../../Common/textinput.dart';
import '../../Constant/color.dart';
import '../../Constant/global.dart';
import '../../Constant/userdata.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/redeem_gift.dart';
import '../../UI/SIGNIN_SIGNUP/otp.dart';

class DeliveryAddress extends StatefulWidget {
  final GiftData giftData;
  DeliveryAddress({@required this.giftData});
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
  List<StoreDetails> stores = [];
  // String selectedStoreCode = "";
  String storeCity = "",
      storeArea = "",
      storeState = "",
      storePinCode = "",
      storeID = "";

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
  void initState() {
    getStores();
    super.initState();
  }

  getStores() async {
    Services.getStores().then((value) {
      if (value.response == "y") {
        setState(() {
          storeID = value.data[0]["store_code"];
        });
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            stores.add(StoreDetails(
                id: value.data[i]["id"],
                name: value.data[i]["name"],
                state: value.data[i]["state"],
                pinCode: value.data[i]["pincode"],
                city: value.data[i]["city"],
                location: value.data[i]["location"],
                storeCode: value.data[i]["store_code"]));
          });
        }
        stores.forEach((store) {
          if (store.storeCode == storeID) {
            setState(() {
              storeID = store.id;
              storeArea = store.location;
              storeCity = store.city;
              storeState = store.state;
              storePinCode = store.pinCode;
            });
          }
        });
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Delivery Address"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 100),
        physics: BouncingScrollPhysics(),
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
            ),
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
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Text(
          "Current Address :",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        stores.length > 0
            ? Container(
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
                    value: storeID,
                    isExpanded: true,
                    items: stores.map((store) {
                      return DropdownMenuItem(
                          value: store.id, child: Text(store.name));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        storeID = value;
                      });
                      stores.forEach((store) {
                        if (store.id == storeID) {
                          setState(() {
                            storeID = store.id;
                            storeArea = store.location;
                            storeCity = store.city;
                            storeState = store.state;
                            storePinCode = store.pinCode;
                          });
                        }
                      });
                    }),
              )
            : Align(
                alignment: Alignment.center, child: Text("No store found !!!")),
        SizedBox(
          height: 15,
        ),
        buildTitledRow(title: "Area", value: storeArea),
        buildTitledRow(title: "City", value: storeCity),
        buildTitledRow(title: "State", value: storeState),
        buildTitledRow(title: "Pincode", value: storePinCode),
        input(
            context: context,
            text: "Alternate Mobile No. $mandatoryChar",
            onChanged: (value) {
              setState(() {
                altMobile = value;
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(border: border())),
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
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.grey[400]),
                strokeWidth: 2,
              ),
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
                : "",
            "delivery_type": "h",
            "store_id": "0"
          });
          sendSMS(mobile: userdata.mobile, formData: data, otp: otp);
        } else {
          Fluttertoast.showToast(msg: "Invalid mobile number");
        }
      } else {
        Fluttertoast.showToast(msg: "All fields are required");
      }
    } else {
      /*
      * Collect from outlet
      * */
      if (storeState.isNotEmpty &&
              storePinCode.isNotEmpty &&
              storeCity.isNotEmpty &&
              storeArea.isNotEmpty &&
              storeID.isNotEmpty &&
              altMobile.isNotEmpty /* &&
          file != null */
          ) {
        if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(altMobile)) {
          setLoading(true);
          FormData data = FormData.fromMap({
            "customer_id": userdata.id,
            "api_key": Urls.apiKey,
            "gift_id": widget.giftData.id,
            "point": widget.giftData.points,
            "address": storeArea,
            "area": storeArea,
            "city": storeCity,
            "pincode": storePinCode,
            "alt_mobile": "1234567890",
            "state": storeState,
            "proof": file != null
                ? await MultipartFile.fromFile(file.path,
                    filename: file.path.split("/").last)
                : "",
            "delivery_type": "s",
            "store_id": storeID,
          });
          print(otp);
          sendSMS(mobile: userdata.mobile, formData: data, otp: otp);
        } else {
          Fluttertoast.showToast(msg: "Invalid mobile number");
        }
      } else {
        Fluttertoast.showToast(msg: "All fields are required");
      }
    }
  }

  sendSMS({String mobile, String otp, FormData formData}) async {
    FormData smsData = FormData.fromMap({
      "user": Urls.user,
      "password": Urls.password,
      "msisdn": mobile,
      "sid": Urls.sID,
      "msg": "<#> " +
          otp +
          " is your OTP to Redeem to PAL App. Don't share it with anyone.",
      "fl": Urls.fl,
      "gwid": Urls.gwID
    });
    await Services.sms(smsData).then((value) {
      if (value.response == "000") {
        setLoading(false);
        Navigator.pop(context);
        Navigator.push(
            context,
            CustomPageRoute(
                widget: OTP(
              mobile: mobile,
              redeemGift: true,
              onlyCheckOtp: true,
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
  final String id, name, location, city, state, pinCode, storeCode;
  StoreDetails(
      {this.state,
      this.city,
      this.pinCode,
      this.name,
      this.id,
      this.location,
      this.storeCode});
}
