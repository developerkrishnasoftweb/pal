import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/models.dart';
import 'package:pal/Constant/strings.dart';
import 'package:pal/LOCALIZATION/localizations_constraints.dart';
import 'package:pal/SERVICES/urls.dart';
import 'package:url_launcher/url_launcher.dart';

import './../Constant/color.dart';
import './../Constant/global.dart';
import './../UI/OTHERS/tnc.dart';
import '.././Common/page_route.dart';
import '.././Common/show_dialog.dart';
import '.././UI/CUSTOMER_BONDING_PROGRAM/earned_points.dart';
import '.././UI/CUSTOMER_BONDING_PROGRAM/redeem_gift_category.dart';
import '.././UI/CUSTOMER_BONDING_PROGRAM/redeemed_gifts.dart';
import '.././UI/HOME/home.dart';
import '.././UI/OTHERS/kyc_details.dart';
import '.././UI/OTHERS/notification.dart';
import '.././UI/OTHERS/report.dart';
import '.././UI/PRODUCTS/product_demo.dart';
import '.././UI/PRODUCT_CATALOG/product_catalog.dart';
import '.././UI/SERVICE_REQUEST/complain.dart';
import '.././UI/SERVICE_REQUEST/service_request.dart';
import '.././UI/SIGNIN_SIGNUP/signin.dart';
import '../UI/SERVICE_REQUEST/track_complaint.dart';

Widget drawer(
    {@required BuildContext context,
    @required GlobalKey<ScaffoldState> scaffoldKey}) {
  Size size = MediaQuery.of(context).size;
  SizedBox gap = SizedBox(
    width: 10,
  );
  Widget buildDrawerItems(
      String text, GestureTapCallback onTap, IconData icon) {
    return ListTile(
      title: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          gap,
          Text(text),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget buildExpansionTile(
      {@required IconData iconData,
      @required String title,
      List<Widget> children}) {
    return ExpansionTile(
      title: Row(
        children: [
          Icon(
            iconData,
            color: Colors.grey,
          ),
          gap,
          Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      initiallyExpanded: true,
      childrenPadding: EdgeInsets.only(left: 0),
      children: children,
    );
  }

  Widget buildExpansionChild(
      {@required String title, @required GestureTapCallback onTap}) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      contentPadding: EdgeInsets.only(left: 55),
    );
  }

  _logout() async {
    var email = userdata.email;
    var notificationCount =
    sharedPreferences.getString(UserParams.lastNotificationId);
    var langCode = sharedPreferences.getString(LANGUAGE_CODE);
    await sharedPreferences.clear();
    await sharedPreferences.setString(
        UserParams.lastNotificationId, notificationCount);
    userdata = Userdata();
    await sharedPreferences.setString(LANGUAGE_CODE, langCode);
    if (sharedPreferences.getString("userdata") == null &&
        sharedPreferences.getString("password") == null) {
      Navigator.pushAndRemoveUntil(
          context,
          CustomPageRoute(
              widget: SignIn(
            email: email,
          )),
          (route) => false);
    }
  }

  return Container(
    width: size.width * 0.85,
    color: Colors.white,
    height: size.height,
    child: Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi!, " + userdata.name ?? " ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                            child: Icon(
                              Icons.account_balance_wallet_outlined,
                              color: primaryColor,
                            ),
                            alignment: PlaceholderAlignment.middle),
                        TextSpan(
                            text: "\t" + userdata.point ?? "0",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: primaryColor))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            buildDrawerItems(translate(context, LocaleStrings.home), () {
              scaffoldKey.currentState.openEndDrawer();
              homeState.setState(() {});
            }, Icons.home),
            buildDrawerItems(translate(context, LocaleStrings.productCatalog),
                () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(
                  context, CustomPageRoute(widget: ProductCatalog()));
            }, Icons.book_outlined),
            buildDrawerItems(translate(context, LocaleStrings.updateKYC), () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(context, CustomPageRoute(widget: KYC()));
            }, Icons.book_online_outlined),
            buildExpansionTile(
                iconData: Icons.table_chart_outlined,
                title: translate(context, LocaleStrings.customerBondingProgram),
                children: [
                  buildExpansionChild(
                    title: translate(context, LocaleStrings.myEarnedPoints),
                    onTap: () {
                      scaffoldKey.currentState.openEndDrawer();
                      Navigator.push(
                          context, CustomPageRoute(widget: EarnedPoints()));
                    },
                  ),
                ]),
            buildExpansionTile(
                iconData: Icons.pages,
                title: translate(context, LocaleStrings.serviceRequest),
                children: [
                  buildExpansionChild(
                      title:
                          translate(context, LocaleStrings.newServiceRequest),
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                        Navigator.push(
                            context, CustomPageRoute(widget: Complain()));
                      }),
                  buildExpansionChild(
                      title:
                          translate(context, LocaleStrings.viewServiceRequest),
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                        Navigator.push(
                            context, CustomPageRoute(widget: ServiceRequest()));
                      }),
                  buildExpansionChild(
                      title: translate(context, LocaleStrings.trackComplaints),
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                        Navigator.push(
                            context, CustomPageRoute(widget: TrackComplaint()));
                      }),
                ]),
            buildExpansionTile(
                iconData: Icons.pages_outlined,
                title: translate(context, LocaleStrings.products),
                children: [
                  buildExpansionChild(
                      title: translate(context, LocaleStrings.productDemo),
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                        Navigator.push(
                            context,
                            CustomPageRoute(
                                widget: ProductDemo(
                              type: "demo",
                            )));
                      }),
                  buildExpansionChild(
                      title: translate(context, LocaleStrings.focusedProduct),
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                        Navigator.push(
                            context,
                            CustomPageRoute(
                                widget: ProductDemo(
                              type: "focused",
                            )));
                      }),
                ]),
            buildExpansionTile(
                iconData: Icons.pages_outlined,
                title: translate(context, LocaleStrings.gift),
                children: [
                  buildExpansionChild(
                      title: translate(context, LocaleStrings.redeemGift),
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                        Navigator.push(
                            context, CustomPageRoute(widget: GiftCategory()));
                      }),
                  buildExpansionChild(
                      title: translate(context, LocaleStrings.redeemedGifts),
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                        Navigator.push(
                            context, CustomPageRoute(widget: RedeemedGift()));
                      }),
                  /* buildExpansionChild(
                      title: "Track Gift",
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                        Navigator.push(
                            context, CustomPageRoute(widget: TrackGift()));
                      }), */
                ]),
            buildDrawerItems(translate(context, LocaleStrings.reports), () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(context, CustomPageRoute(widget: Report()));
            }, Icons.report),
            buildDrawerItems(translate(context, LocaleStrings.myNotifications),
                () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(context, CustomPageRoute(widget: Notifications()));
            }, Icons.notifications_on_outlined),
            buildDrawerItems(
                translate(context, LocaleStrings.termsAndConditions), () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(
                  context, CustomPageRoute(widget: TermsNCondition()));
            }, Icons.ballot_outlined),
            ListTile(
              title: Row(
                children: [
                  ImageIcon(
                    AssetImage("assets/icons/app-icon.png"),
                    color: Colors.grey,
                    size: 30,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(translate(context, LocaleStrings.visitOurSite)),
                ],
              ),
              onTap: () async {
                scaffoldKey.currentState.openEndDrawer();
                var url = Urls.imageBaseUrl;
                if (await canLaunch(url))
                  launch(url);
                else
                  Fluttertoast.showToast(msg: "Unable to open");
              },
            ),
            ListTile(
              title: Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  ImageIcon(
                    AssetImage("assets/icons/playstore.png"),
                    color: Colors.grey,
                    size: 18,
                  ),
                  gap,
                  Text(translate(context, LocaleStrings.palShoppie)),
                ],
              ),
              onTap: () async {
                scaffoldKey.currentState.openEndDrawer();
                var url =
                    config.apkLink ?? "https://play.google.com/store/apps/details?id=com.palgeneralstore.palshoppie";
                if (await canLaunch(url))
                  launch(url);
                else
                  Fluttertoast.showToast(msg: "Unable to open");
              },
            ),
            buildDrawerItems(
                translate(context, LocaleStrings.logout),
                () => showDialogBox(
                    context: context,
                    actions: [
                      buildAlertButton(
                          text: translate(context, LocaleStrings.no),
                          context: context,
                          onPressed: () => Navigator.pop(context),
                          textColor: Colors.grey),
                      buildAlertButton(
                          text: translate(context, LocaleStrings.yes),
                          context: context,
                          onPressed: _logout),
                    ],
                    title: translate(context, LocaleStrings.palShoppie),
                    content: translate(
                        context, LocaleStrings.areYouSureYouWantTOExit)),
                Icons.logout),
          ],
        ),
      ),
    ),
  );
}

class DrawerItem {
  final Icon icon;
  final String text;
  final GestureTapCallback onTap;
  DrawerItem({this.icon, this.text, this.onTap});
}
