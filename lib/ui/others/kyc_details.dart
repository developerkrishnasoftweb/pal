import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/page_route.dart';
import '../../constant/global.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../services/urls.dart';
import '../../ui/others/profile.dart';

class KYC extends StatefulWidget {
  @override
  _KYCState createState() => _KYCState();
}

class _KYCState extends State<KYC> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
          context: context,
          title: translate(context, LocaleStrings.KYCDetails),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                        context, CustomPageRoute(widget: ChangeAddress()))
                    .then((value) {
                  setState(() {});
                });
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
                        height: 100,
                        width: 100,
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
                                      child: circularProgressIndicator()),
                                );
                        },
                        errorBuilder: (BuildContext context, Object object,
                            StackTrace trace) {
                          return SizedBox();
                        },
                      )
                    : SizedBox()),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${translate(context, LocaleStrings.referralCode)} :",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "${userdata.referralCode}",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        children: [
                          WidgetSpan(child: SizedBox(width: 10)),
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: IconButton(
                                    icon: Icon(Icons.copy_rounded,
                                        color: Colors.grey, size: 20),
                                    alignment: Alignment.center,
                                    splashRadius: 20,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: userdata.referralCode));
                                      Fluttertoast.showToast(
                                          msg: translate(context, LocaleStrings.copied));
                                    }),
                              ))
                        ]),
                  )
                ],
              ),
            ),
            buildTitledRow(
                title: "${translate(context, LocaleStrings.name)} :",
                value: userdata.name),
            buildTitledRow(
                title: "${translate(context, LocaleStrings.currentAddress)} :",
                value: userdata.address),
            buildTitledRow(
                title: "${translate(context, LocaleStrings.pinCode)} :",
                value: userdata.pinCode),
            buildTitledRow(
                title: "${translate(context, LocaleStrings.state)} :",
                value: userdata.state),
            buildTitledRow(
                title: "${translate(context, LocaleStrings.city)} :",
                value: userdata.city),
            buildTitledRow(
                title: "${translate(context, LocaleStrings.area)} :",
                value: userdata.area),
            buildTitledRow(
                title: "${translate(context, LocaleStrings.gender)} :",
                value: userdata.gender == "m" ? "Male" : "Female"),
            buildTitledRow(
                title: "${translate(context, LocaleStrings.DOB)} :",
                value: userdata.dob),
            buildTitledRow(
                title:
                    "${translate(context, LocaleStrings.registeredMobileNo)} :",
                value: userdata.mobile),
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
}
