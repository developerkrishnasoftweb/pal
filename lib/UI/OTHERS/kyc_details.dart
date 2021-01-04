import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../SERVICES/urls.dart';
import '../../Common/page_route.dart';
import '../../Constant/userdata.dart';
import '../../UI/OTHERS/change_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common/appbar.dart';

class KYC extends StatefulWidget {
  @override
  _KYCState createState() => _KYCState();
}

class _KYCState extends State<KYC> {
  Userdata data = Userdata();
  GoogleMapController googleMapController;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List userdata = await jsonDecode(preferences.getString(UserParams.userData));
    setState(() {
      data = Userdata(
          name: userdata[0][UserParams.name],
          alternateMobile: userdata[0][UserParams.altMobile],
          email: userdata[0][UserParams.email],
          address: userdata[0][UserParams.address],
          pinCode: userdata[0][UserParams.pinCode],
          state: userdata[0][UserParams.state],
          city: userdata[0][UserParams.city],
          area: userdata[0][UserParams.area],
          gender: userdata[0][UserParams.gender],
          dob: userdata[0][UserParams.dob],
          maritalStatus: userdata[0][UserParams.maritalStatus],
          anniversaryDate: userdata[0][UserParams.anniversary],
          mobile: userdata[0][UserParams.mobile],
          adhaar: userdata[0][UserParams.adhaar],
          kyc: userdata[0][UserParams.kyc],
          image: userdata[0][UserParams.image]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "KYC Details", actions:  [
        IconButton(
          onPressed: data.kyc == "y" ? null : () {
            Navigator.pop(context);
            Navigator.push(
                context, CustomPageRoute(widget: ChangeAddress(userdata: data,)));
          },
          icon: Icon(data.kyc == "y" ? Icons.check_circle : Icons.edit, color: Colors.white,),
        )
      ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.network(
                Urls.imageBaseUrl + data.image,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Container(
                          height: 200,
                          width: 200,
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.grey),
                              )),
                        );
                },
                errorBuilder: (BuildContext context, Object object, StackTrace trace){
                  return SizedBox();
                },
              ),
            ),
            buildTitledRow(title: "Name :", value: data.name),
            buildTitledRow(title: "Current Address :", value: data.address),
            buildTitledRow(title: "Pincode :", value: data.pinCode),
            buildTitledRow(title: "State :", value: data.state),
            buildTitledRow(title: "City :", value: data.city),
            buildTitledRow(title: "Area :", value: data.area),
            buildTitledRow(title: "Gender :", value: data.gender == "m" ? "Male" : "Female"),
            buildTitledRow(title: "Date of Birth :", value: data.dob),
            buildTitledRow(title: "Registered Mo. No. :", value: data.mobile),
            /*Container(
              height: 200,
              width: size.width,
              child: GoogleMap(
                  onMapCreated: onMapCreated,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(40.6789, -73.9442), zoom: 14.0)),
            ),*/
          ],
        ),
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
            value != "" && value != null ? value : "N/A",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      googleMapController = controller;
    });
  }
}
