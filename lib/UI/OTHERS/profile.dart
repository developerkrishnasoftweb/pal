import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pal/Constant/strings.dart';
import 'package:pal/LOCALIZATION/localizations_constraints.dart';

import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/show_dialog.dart';
import '../../Common/textinput.dart';
import '../../Constant/color.dart';
import '../../Constant/global.dart';
import '../../Constant/models.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import '../../main.dart';

class ChangeAddress extends StatefulWidget {
  @override
  _ChangeAddressState createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  TextEditingController state = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController altMobile = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController anniversaryDate = TextEditingController();
  String selectedGender = "m",
      selectedMaritalStatus = "n",
      ext = "",
      selectedVehicleType = "Cycle";
  List<String> gender = ["Male", "Female"],
      maritalStatus = ["Married", "Unmarried"],
      vehicleType = ["Cycle", "Activa/Scooter/Motorbike", "Car", "Other"],
      listAreas = [];
  File image, adhaar;
  DateTime selectedDate = DateTime.now();
  bool isLoading = false, validMobile = false;

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  Future getImage() async {
    File result = await FilePicker.getFile(type: FileType.image);
    if (result != null)
      setState(() {
        image = result;
      });
  }

  Future getAdhaar() async {
    File result =
        await FilePicker.getFile(type: FileType.custom, fileExtension: "pdf");
    if (result != null) {
      setState(() {
        ext = result.path.split("/").last.split(".").last;
      });
      if (ext == "pdf") {
        setState(() {
          adhaar = File(result.path);
        });
      } else {
        Fluttertoast.showToast(
            msg: "${translate(context, LocaleStrings.fileType)} " +
                ext +
                " ${translate(context, LocaleStrings.isNotSupported)}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  void setUserData() {
    setState(() {
      selectedGender = userdata.gender ?? "m";
      selectedMaritalStatus =
          userdata.maritalStatus.isNotEmpty ? userdata.maritalStatus : "n";
      selectedVehicleType =
          userdata.vehicleType != null && userdata.vehicleType != ""
              ? userdata.vehicleType
              : "Cycle";
      name.text = userdata.name;
      altMobile.text = userdata.altMobile;
      email.text = userdata.email;
      address.text = userdata.address;
      pinCode.text = userdata.pinCode;
      state.text = userdata.state;
      city.text = userdata.city;
      area.text = userdata.area;
      dob.text = userdata.dob;
      anniversaryDate.text = userdata.anniversary;
    });
    if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(userdata.altMobile)) {
      setState(() {
        validMobile = true;
      });
    }
    if (userdata.dob != null) {
      setState(() {
        selectedDate = DateTime.parse(userdata.dob);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
          context: context, title: translate(context, LocaleStrings.profile)),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10, bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImage(),
            input(
              context: context,
              text: "${translate(context, LocaleStrings.name)} $mandatoryChar",
              controller: name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(border: border()),
            ),
            input(
              context: context,
              controller: altMobile,
              text:
                  "${translate(context, LocaleStrings.alternateMobileNumber)} $mandatoryChar",
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                setState(() {
                  if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(value)) {
                    setState(() {
                      validMobile = true;
                    });
                  } else {
                    setState(() {
                      validMobile = false;
                    });
                  }
                });
              },
              decoration: InputDecoration(
                  border: border(),
                  suffixIcon: validMobile
                      ? Icon(
                          Icons.check_circle_outline_outlined,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        )),
            ),
            input(
              context: context,
              controller: email,
              text: "${translate(context, LocaleStrings.email)} $mandatoryChar",
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              readOnly: userdata.kyc == "y" ?? false,
              decoration: InputDecoration(
                  border: border(),
                  suffixIcon: userdata.kyc == "y"
                      ? Icon(
                          Icons.check_circle_outline_outlined,
                          color: Colors.green,
                        )
                      : null),
            ),
            input(
              context: context,
              text:
                  "${translate(context, LocaleStrings.address)} $mandatoryChar",
              controller: address,
              maxLines: userdata.kyc == "y" ? 2 : 5,
              textInputAction: TextInputAction.next,
              readOnly: userdata.kyc == "y" ?? false,
              decoration: InputDecoration(border: border()),
            ),
            input(
                context: context,
                text:
                    "${translate(context, LocaleStrings.pinCode)} $mandatoryChar",
                controller: pinCode,
                keyboardType: TextInputType.number,
                readOnly: userdata.kyc == "y" ?? false,
                onChanged: (value) {
                  _getPinCodeData();
                },
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                text:
                    "${translate(context, LocaleStrings.state)} $mandatoryChar",
                controller: state,
                readOnly: userdata.kyc == "y" ?? false,
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                text:
                    "${translate(context, LocaleStrings.city)} $mandatoryChar",
                controller: city,
                readOnly: userdata.kyc == "y" ?? false,
                decoration: InputDecoration(border: border())),
            listAreas.length > 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${translate(context, LocaleStrings.area)} $mandatoryChar",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                            value: area.text,
                            isExpanded: true,
                            decoration: InputDecoration(border: border()),
                            items: listAreas.map((area) {
                              return DropdownMenuItem(
                                  child: Text(area), value: area);
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                area.text = value;
                              });
                            }),
                      ],
                    ),
                  )
                : input(
                    context: context,
                    text:
                        "${translate(context, LocaleStrings.area)} $mandatoryChar",
                    controller: area,
                    readOnly: userdata.kyc == "y" ?? false,
                    decoration: InputDecoration(border: border())),
            userdata.kyc == "y"
                ? input(
                    context: context,
                    text:
                        "${translate(context, LocaleStrings.gender)} $mandatoryChar",
                    controller: TextEditingController(
                        text: selectedGender == "m" ? "Male" : "Female"),
                    readOnly: true,
                    decoration: InputDecoration(border: border()))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${translate(context, LocaleStrings.gender)} $mandatoryChar",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                            onTap: () => FocusScope.of(context).unfocus(),
                            value: selectedGender,
                            isExpanded: true,
                            decoration: InputDecoration(border: border()),
                            items: gender.map((value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value.substring(0, 1).toLowerCase(),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            }),
                      ],
                    ),
                  ),
            input(
                context: context,
                text: "${translate(context, LocaleStrings.DOB)} $mandatoryChar",
                controller: dob,
                onTap: userdata.kyc == "y"
                    ? null
                    : () => _selectDate(SelectDateType.DOB),
                readOnly: true,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(border: border())),
            userdata.maritalStatus == "y"
                ? input(
                    context: context,
                    readOnly: true,
                    text:
                        "${translate(context, LocaleStrings.maritalStatus)} $mandatoryChar",
                    controller: TextEditingController(text: "Married"),
                    decoration: InputDecoration(border: border()))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${translate(context, LocaleStrings.maritalStatus)} $mandatoryChar",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                            onTap: () => FocusScope.of(context).unfocus(),
                            value: selectedMaritalStatus,
                            isExpanded: true,
                            decoration: InputDecoration(border: border()),
                            items: maritalStatus.map((value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value == "Married" ? "y" : "n",
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMaritalStatus = value;
                                if (value == "n")
                                  setState(() {
                                    anniversaryDate.text = "";
                                  });
                              });
                            }),
                      ],
                    ),
                  ),
            selectedMaritalStatus == "y"
                ? input(
                    context: context,
                    text:
                        "${translate(context, LocaleStrings.anniversaryDate)} $mandatoryChar",
                    controller: anniversaryDate,
                    onTap: userdata.maritalStatus == "y"
                        ? null
                        : () => _selectDate(SelectDateType.ANNIVERSARY_DATE),
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(border: border()))
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${translate(context, LocaleStrings.vehicleType)} $mandatoryChar",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                      onTap: () => FocusScope.of(context).unfocus(),
                      value: selectedVehicleType,
                      isExpanded: true,
                      decoration: InputDecoration(border: border()),
                      items: vehicleType.map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedVehicleType = value;
                        });
                      }),
                ],
              ),
            ),
            //Don't remove the commented line below
            /* SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment(-0.9, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adhaar Card : " + (widget.userdata.adhaar != null && widget.userdata.adhaar.isNotEmpty ? "(${widget.userdata.adhaar.split("/").last})" : "$mandatoryChar"),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  customButton(
                      context: context,
                      onPressed: widget.status == "y" && widget.userdata.adhaar.isNotEmpty ? () => Navigator.push(context, CustomPageRoute(widget: CatalogPreview(url: widget.userdata.adhaar, adhaarView: true,))) : getAdhaar,
                      child: Text(widget.userdata.adhaar.isNotEmpty && widget.status == "y" ? "View" : adhaar == null ?
                      "Attach File" : adhaar.path.split("/").last,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.blue[500], fontWeight: FontWeight.bold, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      outerPadding: EdgeInsets.zero,
                      color: Colors.blue[100],
                      height: 50, width: 100)
                ],
              ),
            ), */
          ],
        ),
      ),
      floatingActionButton: customButton(
          context: context,
          onPressed: isLoading ? null : _updateKYC,
          height: 60,
          width: size.width,
          child: isLoading
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  ),
                )
              : null,
          text: isLoading ? null : translate(context, LocaleStrings.submitBtn)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _updateKYC() async {
    if (userdata.kyc != "y") {
      if (name.text.isNotEmpty &&
          altMobile.text.isNotEmpty &&
          email.text.isNotEmpty &&
          address.text.isNotEmpty &&
          pinCode.text.isNotEmpty &&
          state.text.isNotEmpty &&
          city.text.isNotEmpty &&
          area.text.isNotEmpty &&
          selectedGender.isNotEmpty &&
          /* adhaar != null && */
          dob.text.isNotEmpty) {
        /* if ((await adhaar.length() / 1024) < 200) {

        } else {
          Fluttertoast.showToast(msg: "Adhaar file size must be under 200 KB");
        } */
        // If aadhar is added move the "if" condition given below in above if condition
        if (selectedMaritalStatus == "y" && anniversaryDate.text.isEmpty) {
          Fluttertoast.showToast(
              msg: translate(
                  context, LocaleStrings.pleaseProvideAnniversaryDate));
          return;
        }
        if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(altMobile.text)) {
          if (RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(email.text)) {
            setLoading(true);
            FormData data = FormData.fromMap({
              "customer_id": userdata.id,
              "name": name.text,
              "alt_mobile": altMobile.text,
              "email": email.text,
              "gender": selectedGender,
              "address": address.text,
              "pincode": pinCode.text,
              "area": area.text,
              "city": city.text,
              "state": state.text,
              "dob": dob.text,
              "marital_status": selectedMaritalStatus,
              "anniversary": anniversaryDate.text,
              "api_key": Urls.apiKey,
              "image": image != null
                  ? await MultipartFile.fromFile(image.path,
                      filename: image.path.split("/").last)
                  : null,
              "adhaar": adhaar != null
                  ? await MultipartFile.fromFile(adhaar.path,
                      filename: adhaar.path.split("/").last)
                  : null,
              "vehicle_type": selectedVehicleType
            });
            Services.customerKYC(data).then((value) async {
              if (value.response == "y") {
                await sharedPreferences.setString(
                    UserParams.userData, jsonEncode(value.data));
                await setData();
                Fluttertoast.showToast(msg: value.message);
                Navigator.pop(context);
                // Navigator.pushAndRemoveUntil(
                //     context, CustomPageRoute(widget: Home()), (route) => false);
              } else {
                setLoading(false);
                Fluttertoast.showToast(msg: value.message);
              }
            });
          } else {
            Fluttertoast.showToast(
                msg: translate(context, LocaleStrings.invalidEmail));
          }
        } else {
          Fluttertoast.showToast(
              msg: translate(context, LocaleStrings.invalidMobileNumber));
        }
      } else {
        Fluttertoast.showToast(
            msg: translate(context, LocaleStrings.allFieldsAreRequired));
      }
    } else {
      if (name.text.isNotEmpty && altMobile.text.isNotEmpty) {
        if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(altMobile.text)) {
          if (DateTime.parse(dob.text ?? "0000-00-00").year.isNegative) {
            Fluttertoast.showToast(
                msg: translate(context, LocaleStrings.provideDOB));
            return;
          }
          if (DateTime.parse(anniversaryDate.text ?? "0000-00-00")
              .year
              .isNegative) {
            Fluttertoast.showToast(
                msg: translate(
                    context, LocaleStrings.pleaseProvideAnniversaryDate));
            return;
          }
          if (selectedMaritalStatus == "y" && anniversaryDate.text.isEmpty) {
            Fluttertoast.showToast(
                msg: translate(
                    context, LocaleStrings.pleaseProvideAnniversaryDate));
            return;
          }
          setLoading(true);
          FormData formData = FormData.fromMap({
            "customer_id": userdata.id,
            "name": name.text,
            "alt_mobile": altMobile.text,
            "email": email.text,
            "gender": selectedGender,
            "address": address.text,
            "pincode": pinCode.text,
            "area": area.text,
            "city": city.text,
            "state": state.text,
            "dob": dob.text,
            "marital_status": selectedMaritalStatus,
            "anniversary":
                anniversaryDate.text.isNotEmpty ? anniversaryDate.text : null,
            "api_key": Urls.apiKey,
            "image": image != null
                ? await MultipartFile.fromFile(image.path,
                    filename: image.path.split("/").last)
                : null,
            "vehicle_type": selectedVehicleType
          });
          await Services.customerKYC(formData).then((value) async {
            if (value.response == "y") {
              await sharedPreferences.setString(
                  UserParams.userData, jsonEncode(value.data));
              await setData();
              Fluttertoast.showToast(msg: value.message);
              Navigator.pop(context);
              // Navigator.pushAndRemoveUntil(
              //     context, CustomPageRoute(widget: Home()), (route) => false);
            } else {
              setLoading(false);
              Fluttertoast.showToast(msg: value.message);
            }
          });
        } else {
          Fluttertoast.showToast(
              msg: translate(context, LocaleStrings.invalidMobileNumber));
        }
      } else {
        Fluttertoast.showToast(
            msg: translate(
                context, LocaleStrings.nameAndAlternateMobileCantBeEmpty));
      }
    }
  }

  _selectDate(SelectDateType type) async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year - 90),
        lastDate: DateTime.now());
    if (type == SelectDateType.DOB) {
      if (date != null &&
          date != DateTime.now() &&
          (DateTime.now().year - date.year) >= 18) {
        print(dob.text);
        setState(() {
          selectedDate = date;
          dob.text = DateFormat('yyyy-M-d').format(selectedDate);
        });
      } else {
        setState(() {
          dob.clear();
        });
        Fluttertoast.showToast(
            msg: translate(context, LocaleStrings.minimumAgeLimit) +
                " 15 " +
                translate(context, LocaleStrings.years));
      }
    } else {
      if (dob.text.isNotEmpty) {
        if (date != null &&
            date != DateTime.now() &&
            (DateFormat('y-m-d').parse(dob.text).year + 15) < date.year) {
          setState(() {
            selectedDate = date;
            anniversaryDate.text = DateFormat('yyyy-M-d').format(selectedDate);
          });
        } else {
          setState(() {
            anniversaryDate.clear();
          });
          Fluttertoast.showToast(
              msg: translate(context, LocaleStrings.anniversaryDateMustBe),
              toastLength: Toast.LENGTH_LONG);
        }
      } else {
        Fluttertoast.showToast(
            msg: translate(context, LocaleStrings.provideDOB));
      }
    }
  }

  _getPinCodeData() {
    setState(() {
      listAreas = [];
    });
    if (pinCode.text.length == 6) {
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
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
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
      Services.getPinData(pinCode.text).then((value) {
        if (value.response == "Success") {
          FocusScope.of(context).unfocus();
          for (int i = 0; i < value.data.length; i++) {
            setState(() {
              listAreas.add(value.data[i]["Name"]);
            });
          }
          setState(() {
            state.text = value.data[0]["Circle"];
            city.text = value.data[0]["District"];
            area.text = value.data[0]["Name"];
          });
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: value.message);
          setState(() {
            state.clear();
            city.clear();
            area.clear();
          });
          Navigator.pop(context);
        }
      });
    }
  }

  Widget profileImage() {
    return InkWell(
      onTap: getImage,
      borderRadius: BorderRadius.circular(150),
      child: Container(
        height: 150,
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
            border: Border.all(color: Colors.grey[300]),
            image: image != null
                ? DecorationImage(image: FileImage(image))
                : userdata.image.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(Urls.imageBaseUrl + userdata.image),
                        fit: BoxFit.cover)
                    : null),
        child: image == null && userdata.image.isEmpty
            ? Icon(Icons.add_a_photo_outlined)
            : null,
      ),
    );
  }
}

enum SelectDateType { DOB, ANNIVERSARY_DATE }
