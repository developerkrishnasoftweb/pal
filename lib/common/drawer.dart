import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/page_route.dart';
import '../common/show_dialog.dart';
import '../constant/color.dart';
import '../constant/global.dart';
import '../constant/models.dart';
import '../constant/strings.dart';
import '../localization/localizations_constraints.dart';
import '../services/urls.dart';
import '../ui/customer_bonding_program/earned_points.dart';
import '../ui/customer_bonding_program/redeem_gift_category.dart';
import '../ui/customer_bonding_program/redeemed_gifts.dart';
import '../ui/home/home.dart';
import '../ui/others/kyc_details.dart';
import '../ui/others/notification.dart';
import '../ui/others/report.dart';
import '../ui/others/tnc.dart';
import '../ui/product_catalog/product_catalog.dart';
import '../ui/products/product_demo.dart';
import '../ui/service_request/complain.dart';
import '../ui/service_request/service_request.dart';
import '../ui/service_request/track_complaint.dart';
import '../ui/signin_signup/signin.dart';

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
