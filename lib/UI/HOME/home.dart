import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/redeemed_gifts.dart';
import '../../UI/PRODUCTS/product_demo.dart';
import '../../Common/show_dialog.dart';
import '../../Constant/userdata.dart';
import '../../UI/OTHERS/track_complaint.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/redeem_gift_category.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import '../../Common/appbar.dart';
import '../../Common/carousel.dart';
import '../../Common/page_route.dart';
import '../../Constant/color.dart';
import '../PRODUCT_CATALOG/product_catalog.dart';
import '../../UI/OTHERS/kyc_details.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/earned_points.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/weekly_update.dart';
import '../../UI/SERVICE_REQUEST/complain.dart';
import '../../UI/SERVICE_REQUEST/service_request.dart';
import '../../UI/SIGNIN_SIGNUP/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey;
  String points = "0";

  void getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      points = sharedPreferences.getString(UserParams.point);
    });
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

  List<CarouselItems> carouselItems = [];

  List<ItemListBuilder> itemList;

  @override
  void initState() {
    Services.banners(FormData.fromMap({"api_key": Urls.apiKey})).then((value) {
      if (value.response == "y") {
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            carouselItems.add(CarouselItems(
                image: NetworkImage(Urls.imageBaseUrl + value.data[i]["image"]),
                title: value.data[i]["title"],
                categoryId: value.data[i]["id"]));
          });
        }
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    setItemList();
    Services.getUserData();
  }
  void setItemList() {
    itemList = [
      ItemListBuilder(
          title: "Product Catalog",
          onTap: () => Navigator.push(
              context, CustomPageRoute(widget: ProductCatalog())),
          image: AssetImage("assets/images/product-catalog.png")),
      ItemListBuilder(
          title: "Earned Point",
          onTap: () =>
              Navigator.push(context, CustomPageRoute(widget: EarnedPoints())),
          image: AssetImage("assets/images/earned-point.png")),
      ItemListBuilder(
          title: "Redeem Gift",
          onTap: () =>
              Navigator.push(context, CustomPageRoute(widget: GiftCategory())),
          image: AssetImage("assets/images/redeem-gift.png")),
      ItemListBuilder(
          title: "Service Request",
          onTap: () => Navigator.push(
              context, CustomPageRoute(widget: ServiceRequest())),
          image: AssetImage("assets/images/service-request.png")),
    ];
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
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
                    Text("Pal General Store (Sherpur Kalan)"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("134312"),
                        Text(
                          "Version 1.0.0",
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
      ),
      body: Stack(
        children: [
          Container(
            height: size.height > 500 ? size.height * 0.3 : 180,
            width: size.width,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: appBar(
                      title: "Home",
                      centerTitle: true,
                      context: context,
                      leading: IconButton(
                        icon: ImageIcon(
                          AssetImage("assets/icons/menu-hamburger.png"),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          scaffoldKey.currentState.openDrawer();
                        },
                        splashRadius: 23,
                        iconSize: 20,
                      ),
                      actions: [
                        IconButton(
                          icon: ImageIcon(
                            AssetImage("assets/icons/notification-icon.png"),
                            color: Colors.white,
                          ),
                          onPressed: () {},
                          splashRadius: 23,
                          iconSize: 20,
                        )
                      ]),
                ),
                SizedBox(
                  height: 30,
                ),
                Carousel(
                  height: size.height > 500 ? null : 150,
                  items: carouselItems,
                  width: size.width * 0.92,
                  borderRadius: BorderRadius.circular(20),
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                    child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        physics: BouncingScrollPhysics(),
                        itemCount: itemList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1),
                        itemBuilder: (BuildContext context, int index) {
                          return buildItems(
                              context: context,
                              image: itemList[index].image,
                              onTap: itemList[index].onTap,
                              title: itemList[index].title);
                        }))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItems(String text, GestureTapCallback onTap, Icon icon) {
    return ListTile(
      title: Align(alignment: Alignment(-1.2, 0.0), child: Text(text)),
      leading: icon ?? null,
      onTap: onTap,
    );
  }
}

Widget buildItems(
    {@required BuildContext context,
    ImageProvider image,
    String title,
    GestureTapCallback onTap}) {
  return Card(
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.15),
    child: InkWell(
      borderRadius: BorderRadius.circular(3),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: image,
            height: 50,
            width: 50,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    ),
  );
}

class ItemListBuilder {
  final ImageProvider image;
  final String title;
  final GestureTapCallback onTap;
  ItemListBuilder({this.image, this.title, this.onTap});
}
