import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Constant/color.dart';

class KYC extends StatefulWidget {
  @override
  _KYCState createState() => _KYCState();
}

class _KYCState extends State<KYC> {
  Future showDialogBox() {
    return showDialog(barrierDismissible: true, context: context, builder: (_) => AlertDialog(
      title: Text("Alert"),
      content: Text("Are you sure you want to proceed?"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FlatButton(onPressed: (){}, child: Text("MODIFY EXISTING ADDRESS", style: Theme.of(context).textTheme.bodyText1.copyWith(color: AppColors.primaryColor, fontSize: 14, fontWeight: FontWeight.bold),),),
            FlatButton(onPressed: (){}, child: Text("NEW ADDRESS", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),),),
          ],
        )
      ],
    ));
  }

  GoogleMapController googleMapController;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "KYC Details", actions: [
        IconButton(
          onPressed: showDialogBox,
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
            buildTitledRow(
                title: "Firm Name :",
                value: "Pal General Store (Sherpur Kalan)"),
            buildTitledRow(title: "Proprietor Name :", value: "Hardeep Singh"),
            buildTitledRow(
                title: "Current Address :",
                value:
                    "NR Gov. School, Main Market, Sherpur Kalan, Ludhiana, 9216916315, Sherpur"),
            buildTitledRow(title: "State :", value: "Punjab"),
            buildTitledRow(title: "City :", value: "Ludhiana"),
            buildTitledRow(title: "Pincode :", value: "141010"),
            buildTitledRow(
                title: "Registered Mo. No. :", value: "+91 9216916315"),
            Container(
              height: 200,
              width: size.width,
              child: GoogleMap(
                  onMapCreated: onMapCreated,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(40.6789, -73.9442), zoom: 14.0)),
            ),
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