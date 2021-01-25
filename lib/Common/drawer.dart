import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import './../Constant/color.dart';
import './../UI/OTHERS/tnc.dart';
import '.././Common/page_route.dart';
import '.././Common/show_dialog.dart';
import '.././UI/HOME/home.dart';
import '.././UI/OTHERS/kyc_details.dart';
import '.././UI/OTHERS/notification.dart';
import '.././UI/OTHERS/report.dart';
import '.././UI/OTHERS/track_complaint.dart';
import '.././UI/PRODUCTS/product_demo.dart';
import '.././UI/PRODUCT_CATALOG/product_catalog.dart';
import '.././UI/RETAILER_BONDING_PROGRAM/earned_points.dart';
import '.././UI/RETAILER_BONDING_PROGRAM/redeem_gift_category.dart';
import '.././UI/RETAILER_BONDING_PROGRAM/redeemed_gifts.dart';
import '.././UI/SERVICE_REQUEST/complain.dart';
import '.././UI/SERVICE_REQUEST/service_request.dart';
import '.././UI/SIGNIN_SIGNUP/signin.dart';

Widget drawer(
    {@required BuildContext context,
    @required GlobalKey<ScaffoldState> scaffoldKey,
    String version: "1.0.0"}) {
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
      // leading: icon ?? null,
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
      childrenPadding: EdgeInsets.only(left: 50),
      children: children,
    );
  }

  Widget buildExpansionChild(
      {@required String title, @required GestureTapCallback onTap}) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

  _logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var email = sharedPreferences.getString("username");
    await sharedPreferences.clear();
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
    child: SingleChildScrollView(
      child: Column(
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
                  "Hi!, " + userdata.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                              text: "\t" + userdata.point,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: primaryColor))
                        ],
                      ),
                    ),
                    Text(
                      "Version " + version,
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          buildDrawerItems("HOME", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.pushAndRemoveUntil(
                context, CustomPageRoute(widget: Home()), (route) => false);
          }, Icons.home),
          buildDrawerItems("Product Catalog", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.push(context, CustomPageRoute(widget: ProductCatalog()));
          }, Icons.book_outlined),
          buildDrawerItems("Update KYC", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.push(context, CustomPageRoute(widget: KYC()));
          }, Icons.book_online_outlined),
          buildExpansionTile(
              iconData: Icons.table_chart_outlined,
              title: "Customer Bonding Program",
              children: [
                buildExpansionChild(
                  title: "My Earned Points",
                  onTap: () {
                    scaffoldKey.currentState.openEndDrawer();
                    Navigator.push(
                        context, CustomPageRoute(widget: EarnedPoints()));
                  },
                ),
              ]),
          buildExpansionTile(
              iconData: Icons.pages,
              title: "Service Request",
              children: [
                buildExpansionChild(
                    title: "New Service Request",
                    onTap: () {
                      scaffoldKey.currentState.openEndDrawer();
                      Navigator.push(
                          context, CustomPageRoute(widget: Complain()));
                    }),
                buildExpansionChild(
                    title: "View Service Request",
                    onTap: () {
                      scaffoldKey.currentState.openEndDrawer();
                      Navigator.push(
                          context, CustomPageRoute(widget: ServiceRequest()));
                    }),
                buildExpansionChild(
                    title: "Track Complaints",
                    onTap: () {
                      scaffoldKey.currentState.openEndDrawer();
                      Navigator.push(
                          context, CustomPageRoute(widget: TrackComplaint()));
                    }),
              ]),
          buildExpansionTile(
              iconData: Icons.pages_outlined,
              title: "Products",
              children: [
                buildExpansionChild(
                    title: "Product Demo",
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
                    title: "Focused Products",
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
              title: "Gift",
              children: [
                buildExpansionChild(
                    title: "Redeem Gift",
                    onTap: () {
                      scaffoldKey.currentState.openEndDrawer();
                      Navigator.push(
                          context, CustomPageRoute(widget: GiftCategory()));
                    }),
                buildExpansionChild(
                    title: "Redeemed Gifts",
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
          buildDrawerItems("Reports", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.push(context, CustomPageRoute(widget: Report()));
          }, Icons.report),
          buildDrawerItems("My Notification", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.push(context, CustomPageRoute(widget: Notifications()));
          }, Icons.notifications_on_outlined),
          buildDrawerItems("Terms & Conditions", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.push(context, CustomPageRoute(widget: TermsNCondition()));
          }, Icons.ballot_outlined),
          buildDrawerItems("Visit our site", () async {
            scaffoldKey.currentState.openEndDrawer();
            var url = "https://www.palshopie.com/";
            if (await canLaunch(url))
              launch(url);
            else
              Fluttertoast.showToast(msg: "Unable to load web page");
          }, Icons.web),
          buildDrawerItems("Pal Shoppie", () async {
            scaffoldKey.currentState.openEndDrawer();
            var url =
                "https://play.google.com/store/apps/details?id=com.krishnasoftweb.palshoppie";
            if (await canLaunch(url))
              launch(url);
            else
              Fluttertoast.showToast(msg: "Unable to open play store");
          }, Icons.play_arrow_rounded),
          buildDrawerItems(
              "Logout",
              () => showDialogBox(
                  context: context,
                  actions: [
                    buildAlertButton(
                        text: "NO",
                        context: context,
                        onPressed: () => Navigator.pop(context),
                        textColor: Colors.grey),
                    buildAlertButton(
                        text: "YES", context: context, onPressed: _logout),
                  ],
                  title: "Alert",
                  content: "Are you sure you want to exit?"),
              Icons.logout),
        ],
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
