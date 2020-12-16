import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Drawer drawer({@required BuildContext context, @required GlobalKey<ScaffoldState> scaffoldKey}) {
  List<DrawerItem> items = [
    DrawerItem(text: "Home", icon: Icon(Icons.home), onTap: () {
      scaffoldKey.currentState.openEndDrawer();
    }),
    DrawerItem(
        text: "My Orders", icon: Icon(Icons.shopping_cart), onTap: () {
      scaffoldKey.currentState.openEndDrawer();
    }),
    DrawerItem(text: "My Profile", icon: Icon(Icons.person), onTap: () {
      scaffoldKey.currentState.openEndDrawer();
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
        /*Expanded(
          flex: 0,
          child: DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 5, color: Colors.white),
                      image: DecorationImage(
                          image: NetworkImage(UserData.image != null ? Urls.imageBaseUrl + UserData.image : ""),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(UserData.firstName != null ? UserData.firstName : "N/A",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 16),
                          overflow: TextOverflow.ellipsis),
                      SizedBox(
                        height: 3,
                      ),
                      Text(UserData.email != null ? UserData.email : "N/A",
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                      SizedBox(
                        height: 15,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.black,
                                ),
                                alignment: PlaceholderAlignment.middle),
                            TextSpan(
                                style: Theme.of(context).textTheme.bodyText1,
                                text: "100.00")
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colours.primaryAccentColor,
            ),
          ),
        ),*/
        Expanded(
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
        )
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
