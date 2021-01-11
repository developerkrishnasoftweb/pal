import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pal/Constant/color.dart';
import 'package:pal/UI/OTHERS/track_gift.dart';
import '.././UI/OTHERS/notification.dart';
import '.././UI/OTHERS/report.dart';
import '.././Common/page_route.dart';
import '.././Common/show_dialog.dart';
import '.././UI/HOME/home.dart';
import '.././UI/OTHERS/kyc_details.dart';
import '.././UI/OTHERS/track_complaint.dart';
import '.././UI/PRODUCTS/product_demo.dart';
import '.././UI/PRODUCT_CATALOG/product_catalog.dart';
import '.././UI/RETAILER_BONDING_PROGRAM/earned_points.dart';
import '.././UI/RETAILER_BONDING_PROGRAM/redeem_gift_category.dart';
import '.././UI/RETAILER_BONDING_PROGRAM/redeemed_gifts.dart';
import '.././UI/SERVICE_REQUEST/complain.dart';
import '.././UI/SERVICE_REQUEST/service_request.dart';
import '.././UI/SIGNIN_SIGNUP/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget drawer(
    {@required BuildContext context,
    @required GlobalKey<ScaffoldState> scaffoldKey,
    @required String name,
    @required String availablePoints,
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
    sharedPreferences.clear();
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
                  "Hi!, " + name,
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
                                color: AppColors.primaryColor,
                              ),
                              alignment: PlaceholderAlignment.middle),
                          TextSpan(
                              text: "\t" + availablePoints,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.primaryColor))
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
              ]),
          buildExpansionTile(iconData: Icons.pages_outlined, title: "Products", children: [
            buildExpansionChild(title: "Product Demo", onTap: () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(
                  context,
                  CustomPageRoute(
                      widget: ProductDemo(
                        type: "demo",
                      )));
            }),
            buildExpansionChild(title: "Focused Products", onTap: () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(
                  context,
                  CustomPageRoute(
                      widget: ProductDemo(
                        type: "focused",
                      )));
            }),
          ]),
          buildDrawerItems("Track Complaints", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.push(context, CustomPageRoute(widget: TrackComplaint()));
          }, Icons.outgoing_mail),
          buildExpansionTile(iconData: Icons.pages_outlined, title: "Gift", children: [
            buildExpansionChild(title: "Redeem Gift", onTap: () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(
                  context, CustomPageRoute(widget: GiftCategory()));
            }),
            buildExpansionChild(title: "Redeemed Gifts", onTap: () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(
                  context, CustomPageRoute(widget: RedeemedGift()));
            }),
            buildExpansionChild(title: "Track Gift", onTap: () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(context, CustomPageRoute(widget: TrackGift()));
            }),
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
            // Navigator.push(
            //     context, CustomPageRoute(widget: Notifications()));
          }, Icons.ballot_outlined),
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
