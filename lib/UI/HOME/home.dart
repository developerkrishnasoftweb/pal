import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/badge.dart';
import '../../UI/OTHERS/notification.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Common/drawer.dart';
import '../../Constant/userdata.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/redeem_gift_category.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import '../../Common/appbar.dart';
import '../../Common/carousel.dart';
import '../../Common/page_route.dart';
import '../../Constant/color.dart';
import '../PRODUCT_CATALOG/product_catalog.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/earned_points.dart';
import '../../UI/SERVICE_REQUEST/service_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey;
  String points = "0", name = "", availablePoints = "";
  String notificationCount = "0";
  List<CarouselItems> carouselItems = [];
  List<ItemListBuilder> itemList = [];

  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      Services.getNotificationCount().then((value) {
        notificationCount = value;
        // setState(() {
        //
        // });
      });
    });
    Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      await Services.getUserData();
    });
    Services.getConfig();
    Services.banners(FormData.fromMap({"api_key": Urls.apiKey})).then((value) {
      if (value.response == "y") {
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            carouselItems.add(CarouselItems(
                image: Urls.imageBaseUrl + value.data[i]["image"],
                title: value.data[i]["title"],
                categoryId: value.data[i]["id"]));
          });
        }
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
    Services.getNotificationCount().then((value) {
      setState(() {
        notificationCount = value;
      });
    });
    getData();
    scaffoldKey = GlobalKey<ScaffoldState>();
    setItemList();
    super.initState();
  }

  void getData() async {
    await Services.getUserData();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List data = jsonDecode(sharedPreferences.getString(UserParams.userData));
    name = data[0][UserParams.name] ?? "N/A";
    availablePoints = sharedPreferences.getString(UserParams.point) ?? "0";
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
      drawer: drawer(
          context: context,
          scaffoldKey: scaffoldKey,
          name: name,
          availablePoints: availablePoints),
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
                        badge(
                            iconButton: IconButton(
                              icon: ImageIcon(
                                AssetImage(
                                    "assets/icons/notification-icon.png"),
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.push(context,
                                  CustomPageRoute(widget: Notifications())),
                              splashRadius: 23,
                              iconSize: 20,
                            ),
                            badgeValue: int.parse(notificationCount),
                            context: context,
                            badgeSize: Size(15, 15)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _messaging,
        child: Image.asset("assets/icons/whatsapp.png", fit: BoxFit.fill),
        backgroundColor: Colors.transparent,
        elevation: 0,
        tooltip: "Message",
      ),
    );
  }

  _messaging() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String mobileNumber =
        jsonDecode(sharedPreferences.getString(UserParams.config))[0]
            ["contact"];
    var url = "https://wa.me/+91$mobileNumber";
    if (await canLaunch(url))
      launch(url);
    else
      Fluttertoast.showToast(msg: "Maybe you don't have installed WhatsApp");
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
