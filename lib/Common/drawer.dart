import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pal/Common/page_route.dart';
import 'package:pal/Pages/Others/kyc_details.dart';

Drawer drawer({@required BuildContext context, @required GlobalKey<ScaffoldState> scaffoldKey}) {
  List<DrawerItem> items = [
    DrawerItem(text: "Home", icon: Icon(Icons.home), onTap: () {
      scaffoldKey.currentState.openEndDrawer();
    }),
    DrawerItem(
        text: "Update KYC", icon: Icon(Icons.book_online), onTap: () {
      scaffoldKey.currentState.openEndDrawer();
      Navigator.push(context, CustomPageRoute(widget: KYC()));
    }),
    DrawerItem(
        text: "Logout",
        icon: Icon(Icons.exit_to_app),
        onTap: () async {
          // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          // String email = sharedPreferences.getString("email");
          // sharedPreferences.clear();
          // Navigator.pushAndRemoveUntil(context, CustomPageRoute(widget: SignIn(email : email)), (route) => false);
        }),
  ];
  return Drawer(
    child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top,),
        ListTile(
          title: Text("HOME"),
        ),
        ListTile(
          title: Text("Update KYC"),
        ),
        ListTile(
          title: Text("PRODUCT CATALOG"),
        ),
        ExpansionTile(title: Text("RETAILER BONDING PROGRAM"),
          children: [
            ListTile(
              title: Text("My Weekly Update"),
            ),
            ListTile(
              title: Text("My Earned Points"),
            ),
          ],
        ),
        ExpansionTile(title: Text("SERVICE REQUEST"),
          children: [
            ListTile(
              title: Text("New Service Request"),
            ),
            ListTile(
              title: Text("View Service Request"),
            ),
          ],
        ),
        ListTile(
          title: Text("TRACK COMPLAINT"),
        ),
        ExpansionTile(title: Text("PRODUCTS"),
          children: [
            ListTile(
              title: Text("Product Demo"),
            ),
          ],
        ),
        /*Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  leading: items[index].icon ?? null,
                  title: Align(
                      alignment: items[index].icon != null
                          ? Alignment(-1.2, 0.0)
                          : Alignment.centerLeft,
                      child: Text(
                        items[index].text,
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                  onTap: items[index].onTap,
                );
              }),
        )*/
      ],
    ),
  );
}

class DrawerItem {
  final Icon icon;
  final String text;
  final GestureTapCallback onTap;
  DrawerItem({this.icon, this.text, this.onTap});
}
