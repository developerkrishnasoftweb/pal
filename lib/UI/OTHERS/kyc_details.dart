import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pal/Common/page_route.dart';
import 'package:pal/Constant/userdata.dart';
import 'package:pal/UI/OTHERS/change_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common/show_dialog.dart';
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
    List userdata = jsonDecode(preferences.getString(UserParams.userData));
    setState(() {
      data = Userdata(
          name: userdata[0][UserParams.name],
          address: userdata[0][UserParams.address],
          alternateMobile: userdata[0][UserParams.altMobile],
          area: userdata[0][UserParams.area],
          city: userdata[0][UserParams.city],
          mobile: userdata[0][UserParams.mobile],
          pinCode: userdata[0][UserParams.pinCode],
          state: userdata[0][UserParams.state]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "KYC Details", actions: [
        IconButton(
          onPressed: () =>
              showDialogBox(context: context, title: "Alert", actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildAlertButton(
                    context: context,
                    text: "MODIFY EXISTING ADDRESS",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context, CustomPageRoute(widget: ChangeAddress()));
                    }),
                buildAlertButton(
                    context: context,
                    text: "NEW ADDRESS",
                    onPressed: () {},
                    textColor: Colors.grey),
              ],
            )
          ]),
          icon: Icon(Icons.edit),
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
                "https://static01.nyt.com/images/2018/08/01/dining/01Grocery1-alpha/01Grocery1-superJumbo-v2.jpg",
                height: 200,
                width: 200,
                fit: BoxFit.fill,
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
              ),
            ),
            buildTitledRow(title: "Name :", value: data.name),
            buildTitledRow(title: "Current Address :", value: data.address),
            buildTitledRow(title: "State :", value: data.state),
            buildTitledRow(title: "City :", value: data.city),
            buildTitledRow(title: "Pincode :", value: data.pinCode),
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

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      googleMapController = controller;
    });
  }
}
