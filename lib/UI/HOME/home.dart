import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/global.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Common/appbar.dart';
import '../../Common/badge.dart';
import '../../Common/carousel.dart';
import '../../Common/drawer.dart';
import '../../Common/page_route.dart';
import '../../Common/rating_builder.dart';
import '../../Constant/color.dart';
import '../../Constant/userdata.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import '../../UI/OTHERS/notification.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/earned_points.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/redeem_gift_category.dart';
import '../../UI/SERVICE_REQUEST/service_request.dart';
import '../PRODUCT_CATALOG/product_catalog.dart';

class Home extends StatefulWidget {
  final bool showRateDialog;
  Home({this.showRateDialog});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey;
  String notificationCount = "0", rateMessage = "";
  List<CarouselItems> carouselItems = [];
  List<ItemListBuilder> itemList = [];
  int rate = 0;

  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      Services.getNotificationCount().then((value) {
        setState(() {
          notificationCount = value;
        });
      });
    });
    Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      await Services.getUserData();
      await Services.getConfig();
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
    scaffoldKey = GlobalKey<ScaffoldState>();
    setItemList();
    super.initState();
    if (widget.showRateDialog != null && widget.showRateDialog)
      Future.delayed(Duration(microseconds: 5000), () => showRatingDialog());
  }

  showRatingDialog() async {
    Size size = MediaQuery.of(context).size;
    setState(() {
      rate = 1;
      rateMessage = " ";
    });
    return showDialog(
        context: context,
        child: AlertDialog(
          content: StatefulBuilder(builder: (context, state) {
            return Container(
              width: (size.width * 0.6) < 200 ? (size.width * 0.6) : 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("How would you rate PAL DEPARTMENTAL STORE ?"),
                  SizedBox(
                    height: 10,
                  ),
                  RatingBuilder(
                    itemCount: 5,
                    itemExtent: 35,
                    activeColor: primaryColor,
                    onChanged: (rate) {
                      switch (rate) {
                        case 1:
                          state(() {
                            this.rate = rate;
                            rateMessage = "Poor";
                          });
                          break;
                        case 2:
                          state(() {
                            this.rate = rate;
                            rateMessage = "Not Satisfied";
                          });
                          break;
                        case 3:
                          state(() {
                            this.rate = rate;
                            rateMessage = "Average";
                          });
                          break;
                        case 4:
                          state(() {
                            this.rate = rate;
                            rateMessage = "Good";
                          });
                          break;
                        case 5:
                          state(() {
                            this.rate = rate;
                            rateMessage = "Excellent";
                          });
                          break;
                        default:
                          state(() {
                            this.rate = rate;
                            rateMessage = " ";
                          });
                          break;
                      }
                    },
                  ),
                  Text(
                    rateMessage,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          }),
          title: Text(
            "RATE US",
            style: TextStyle(color: primaryColor),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "NO, THANKS",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            FlatButton(
              //TODO: check once
              onPressed: _rateApp,
              child: Text(
                "RATE",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
        barrierDismissible: true);
  }

  _rateApp() async {
    if (rate > 0 && rateMessage.isNotEmpty) {
      Navigator.pop(context);
      Services.rateApp(message: rateMessage, rate: rate.toString())
          .then((value) {
        if (value.response == "y") {
          Fluttertoast.showToast(msg: "Thank you for rate us.");
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Please choose your experience to rate");
    }
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
      drawer: drawer(context: context, scaffoldKey: scaffoldKey),
      body: Stack(
        children: [
          Container(
            height: size.height > 500 ? size.height * 0.3 : 180,
            width: size.width,
            decoration: BoxDecoration(
              color: primaryColor,
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
                        (int.parse(notificationCount) == 0)
                            ? IconButton(
                                icon: ImageIcon(
                                  AssetImage(
                                      "assets/icons/notification-icon.png"),
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.push(context,
                                    CustomPageRoute(widget: Notifications())),
                                splashRadius: 23,
                                iconSize: 20,
                              )
                            : badge(
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
