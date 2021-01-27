import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pal/Constant/global.dart';

import '../../Common/appbar.dart';
import '../../Common/page_route.dart';
import '../../SERVICES/urls.dart';
import '../../UI/OTHERS/profile.dart';

class KYC extends StatefulWidget {
  @override
  _KYCState createState() => _KYCState();
}

class _KYCState extends State<KYC> {
  GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "KYC Details", actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, CustomPageRoute(widget: ChangeAddress()));
          },
          icon: Icon(
            userdata.kyc == "y" ? Icons.check_circle : Icons.edit,
            color: Colors.white,
          ),
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
                child: userdata.image != null
                    ? Image.network(
                        Urls.imageBaseUrl + userdata.image,
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
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.grey),
                                      )),
                                );
                        },
                        errorBuilder: (BuildContext context, Object object,
                            StackTrace trace) {
                          return SizedBox();
                        },
                      )
                    : SizedBox()),
            buildTitledRow(title: "Name :", value: userdata.name),
            buildTitledRow(title: "Current Address :", value: userdata.address),
            buildTitledRow(title: "Pincode :", value: userdata.pinCode),
            buildTitledRow(title: "State :", value: userdata.state),
            buildTitledRow(title: "City :", value: userdata.city),
            buildTitledRow(title: "Area :", value: userdata.area),
            buildTitledRow(
                title: "Gender :",
                value: userdata.gender == "m" ? "Male" : "Female"),
            buildTitledRow(title: "Date of Birth :", value: userdata.dob),
            buildTitledRow(
                title: "Registered Mo. No. :", value: userdata.mobile),
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
