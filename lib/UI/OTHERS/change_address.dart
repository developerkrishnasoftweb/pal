import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/show_dialog.dart';
import '../../Constant/color.dart';
import '../../Constant/userdata.dart';
import '../../SERVICES/services.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/textinput.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChangeAddress extends StatefulWidget {
  final Userdata userdata;
  ChangeAddress({this.userdata});
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
  List<String> listAreas = [];
  File image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Change Address"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10, bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImage(),
            input(
                context: context,
                text: "Name",
                controller: name,
                decoration: InputDecoration(border: border()),
                autoFocus: true),
            input(
              context: context,
              controller: altMobile,
              text: "Alternate Mobile Number",
              decoration: InputDecoration(border: border()),
            ),
            input(
              context: context,
              text: "Address",
              controller: address,
              decoration: InputDecoration(border: border()),
            ),
            input(
                context: context,
                text: "Pincode",
                controller: pinCode,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _getPinCodeData();
                },
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                text: "State",
                controller: state,
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                text: "City",
                controller: city,
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
                    text: "Area",
                    controller: area,
                    decoration: InputDecoration(border: border())),
          ],
        ),
      ),
      floatingActionButton: customButton(
          context: context,
          onPressed: () {},
          height: 60,
          width: size.width,
          text: "PROCEED"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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
      Services.getPinData(pinCode.text).then((value) {
        if (value.response == "Success") {
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
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: Image.file(
                  image,
                  fit: BoxFit.fill,
                  width: 150,
                  height: 150,
                ))
            : Icon(Icons.add_a_photo_outlined),
      ),
    );
  }
}
