import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '.././Common/page_route.dart';
import '.././Common/show_dialog.dart';
import '.././Constant/userdata.dart';
import '.././UI/HOME/home.dart';
import '.././UI/OTHERS/kyc_details.dart';
import '.././UI/OTHERS/track_complaint.dart';
import '.././UI/PRODUCTS/product_demo.dart';
import '.././UI/PRODUCT_CATALOG/product_catalog.dart';
import '.././UI/RETAILER_BONDING_PROGRAM/earned_points.dart';
import '.././UI/RETAILER_BONDING_PROGRAM/redeem_gift_category.dart';
import '.././UI/RETAILER_BONDING_PROGRAM/redeemed_gifts.dart';
import '.././UI/RETAILER_BONDING_PROGRAM/weekly_update.dart';
import '.././UI/SERVICE_REQUEST/complain.dart';
import '.././UI/SERVICE_REQUEST/service_request.dart';
import '.././UI/SIGNIN_SIGNUP/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget drawer({@required BuildContext context, @required GlobalKey<ScaffoldState> scaffoldKey, @required String name, @required String totalOrder, String version : "1.0.0"}) {
  Size size = MediaQuery.of(context).size;
  Widget buildDrawerItems(String text, GestureTapCallback onTap, Icon icon) {
    return ListTile(
      title: Align(alignment: Alignment(-1.2, 0.0), child: Text(text)),
      leading: icon ?? null,
      onTap: onTap,
    );
  }
  void getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString(UserParams.name) ?? "N/A";
    totalOrder = sharedPreferences.getString(UserParams.totalOrder) ?? "0";
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
  getData();
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
                Text("Hi!, " + name),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total : " + totalOrder),
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
            Navigator.pushAndRemoveUntil(context, CustomPageRoute(widget: Home()), (route) => false);
          }, Icon(Icons.home)),
          ListTile(
            title: Align(
                alignment: Alignment(-1.3, 0.0),
                child: Text("Product Catalog")),
            onTap: () {
              scaffoldKey.currentState.openEndDrawer();
              Navigator.push(
                  context, CustomPageRoute(widget: ProductCatalog()));
            },
            leading: Icon(Icons.book_outlined),
          ),
          buildDrawerItems("Update KYC", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.push(context, CustomPageRoute(widget: KYC()));
          }, Icon(Icons.book_online_outlined)),
          ExpansionTile(
            title: Align(
                alignment: Alignment(-2.4, 0.0),
                child: Text(
                  "Retailer Bonding Program",
                  style: TextStyle(color: Colors.black),
                )),
            initiallyExpanded: true,
            leading: Icon(
              Icons.table_chart_outlined,
              color: Colors.grey,
            ),
            childrenPadding: EdgeInsets.only(left: 50),
            children: [
              ListTile(
                title: Text("My Weekly Update"),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: WeeklyUpdate()));
                },
              ),
              ListTile(
                title: Text("My Earned Points"),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: EarnedPoints()));
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Align(
                alignment: Alignment(-1.2, 0.0),
                child: Text(
                  "Service Request",
                  style: TextStyle(color: Colors.black),
                )),
            initiallyExpanded: true,
            leading: Icon(
              Icons.pages,
              color: Colors.grey,
            ),
            childrenPadding: EdgeInsets.only(left: 50),
            children: [
              ListTile(
                title: Text("New Service Request"),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: Complain()));
                },
              ),
              ListTile(
                title: Text("View Service Request"),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: ServiceRequest()));
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Align(
                alignment: Alignment(-1.2, 0.0),
                child: Text(
                  "Products",
                  style: TextStyle(color: Colors.black),
                )),
            initiallyExpanded: true,
            leading: Icon(
              Icons.pages_outlined,
              color: Colors.grey,
            ),
            childrenPadding: EdgeInsets.only(left: 50),
            children: [
              ListTile(
                title: Text("Product Demo"),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, CustomPageRoute(widget: ProductDemo(type: "demo",)));
                },
              ),
              ListTile(
                title: Text("Focused Products"),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, CustomPageRoute(widget: ProductDemo(type: "focused",)));
                },
              ),
            ],
          ),
          buildDrawerItems("Track Complaints", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.push(
                context, CustomPageRoute(widget: TrackComplaint()));
          },
              Icon(
                Icons.outgoing_mail,
                color: Colors.grey,
              )),
          buildDrawerItems("Redeem Gift", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.push(context, CustomPageRoute(widget: GiftCategory()));
          },
              Icon(
                Icons.card_giftcard,
                color: Colors.grey,
              )),
          buildDrawerItems("Redeemed Gifts", () {
            scaffoldKey.currentState.openEndDrawer();
            Navigator.push(context, CustomPageRoute(widget: RedeemedGift()));
          },
              Icon(
                Icons.card_giftcard,
                color: Colors.grey,
              )),
          buildDrawerItems("Reports", () {
            scaffoldKey.currentState.openEndDrawer();
          },
              Icon(
                Icons.report,
                color: Colors.grey,
              )),
          buildDrawerItems("My Notification", () {
            scaffoldKey.currentState.openEndDrawer();
          },
              Icon(
                Icons.notifications_on_outlined,
                color: Colors.grey,
              )),
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
              Icon(Icons.logout)),
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
