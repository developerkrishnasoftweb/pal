import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/badge.dart';
import '../../ui/widgets/carousel.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/drawer.dart';
import '../../ui/widgets/page_route.dart';
import '../../constant/color.dart';
import '../../constant/global.dart';
import '../../constant/strings.dart';
import '../../localization/language.dart';
import '../../localization/localizations_constraints.dart';
import '../../services/services.dart';
import '../../services/urls.dart';
import '../../ui/customer_bonding_program/earned_points.dart';
import '../../ui/customer_bonding_program/redeem_gift_category.dart';
import '../../ui/others/notification.dart';
import '../../ui/product_catalog/product_catalog.dart';
import '../../ui/service_request/service_request.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';

_HomeState homeState;

class Home extends StatefulWidget {
  final bool showRateDialog;

  Home({this.showRateDialog});

  @override
  _HomeState createState() {
    homeState = _HomeState();
    return homeState;
  }
}

class _HomeState extends State<Home> {
  DateTime currentBackPressTime;
  GlobalKey<ScaffoldState> scaffoldKey;
  String rateMessage = "";
  List<CarouselItems> carouselItems = [];
  List<ItemListBuilder> itemList = [
    ItemListBuilder(
        title: LocaleStrings.productCatalog,
        widget: ProductCatalog(),
        image: AssetImage("assets/images/product-catalog.png")),
    ItemListBuilder(
        title: LocaleStrings.earnedPoints,
        widget: EarnedPoints(),
        image: AssetImage("assets/images/earned-point.png")),
    ItemListBuilder(
        title: LocaleStrings.redeemGift,
        widget: GiftCategory(),
        image: AssetImage("assets/images/redeem-gift.png")),
    ItemListBuilder(
        title: LocaleStrings.serviceRequest,
        widget: ServiceRequest(),
        image: AssetImage("assets/images/service-request.png")),
  ];
  int rate = 0, lastNotificationCount = 0;
  Language language;
  bool isChangingLang = false;
  Timer timer;

  @override
  void initState() {
    super.initState();
    Services.banners(FormData.fromMap({"api_key": API_KEY})).then((value) {
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
    scaffoldKey = GlobalKey<ScaffoldState>();
    if (widget.showRateDialog != null && widget.showRateDialog)
      Future.delayed(Duration(microseconds: 5000), () => showRatingDialog());
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getNotificationCount();
    });
  }

  showRatingDialog() async {
    Size size = MediaQuery.of(context).size;
    setState(() {
      rate = 1;
      rateMessage = " ";
    });
    return showDialog(
        builder: (context) => AlertDialog(
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
                  /* RatingBuilder(
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
                  ), */
                ],
              ),
            );
          }),
          title: Text(
            translate(context, LocaleStrings.rateUs),
            style: TextStyle(color: primaryColor),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                translate(context, LocaleStrings.noThanks),
                style: TextStyle(color: Colors.grey),
              ),
            ),
            FlatButton(
              onPressed: _rateApp,
              child: Text(
                translate(context, LocaleStrings.rateBtn),
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ), context: context,
        barrierDismissible: true);
  }

  _rateApp() async {
    /* if (rate > 0 && rateMessage.isNotEmpty) {
      Navigator.pop(context);
      await Services.rateApp(message: rateMessage, rate: rate.toString())
          .then((value) {
        if (value.response == "y") {
          Fluttertoast.showToast(msg: value.message);
        } else {
          Fluttertoast.showToast(msg: value.message);
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Please choose your experience to rate");
    } */
    if (await canLaunch(""))
      launch("");
    else
      Fluttertoast.showToast(msg: "Unable to open");
  }

  _languageChanged(Language lang) async {
    setState(() {
      language = lang;
      isChangingLang = true;
    });
    await setLocale(lang.languageCode);
    // appLocale = await setLocale(lang.languageCode);
    await main();
    setState(() {
      isChangingLang = false;
    });
    Fluttertoast.showToast(msg: "Language changed successfully");
  }

  getNotificationCount() async {
    await Services.getNotificationCount().then((value) {
      if(this.mounted) {
        setState(() {
          lastNotificationCount = int.parse(value);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _exit,
      child: Scaffold(
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
                        title: translate(context, LocaleStrings.home),
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
                          isChangingLang
                              ? Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: circularProgressIndicator(),
                                  ),
                                )
                              : PopupMenuButton<Language>(
                                  onSelected: _languageChanged,
                                  itemBuilder: (_) => Language.languageList()
                                      .map<PopupMenuItem<Language>>((lang) {
                                    return PopupMenuItem(
                                      child: Text(lang.flag + " " + lang.name),
                                      value: lang,
                                    );
                                  }).toList(),
                                  icon: Icon(Icons.language_outlined),
                                ),
                          SizedBox(width: isChangingLang ? 20 : 0),
                          badge(
                              iconButton: IconButton(
                                icon: ImageIcon(
                                  AssetImage(
                                      "assets/icons/notification-icon.png"),
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.push(
                                        context,
                                        CustomPageRoute(
                                            widget: Notifications())),
                                splashRadius: 23,
                                iconSize: 20,
                              ),
                              badgeValue: lastNotificationCount,
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 1),
                          itemBuilder: (BuildContext context, int index) {
                            return buildItems(
                                context: context,
                                index: index,
                                image: itemList[index].image,
                                widget: itemList[index].widget,
                                title: itemList[index].title);
                          }))
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: config.whatsAppNumber != null
            ? config.whatsAppNumber.isNotEmpty
                ? FloatingActionButton(
                    onPressed: _messaging,
                    child: Image.asset("assets/icons/whatsapp.png",
                        fit: BoxFit.fill),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    tooltip: "Message",
                  )
                : null
            : null,
      ),
    );
  }

  Future<bool> _exit() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: translate(context, LocaleStrings.pressAgainToExit));
      return Future.value(false);
    }
    return Future.value(true);
  }

  _messaging() async {
    var url = "https://wa.me/+91${config.whatsAppNumber}";
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
    Widget widget,
    int index}) {
  return Card(
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.15),
    child: InkWell(
      borderRadius: BorderRadius.circular(3),
      onTap: () => Navigator.push(context, CustomPageRoute(widget: widget)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: image,
            height: index == 1 || index == 0 ? 60 : 50,
            width: index == 1 || index == 0 ? 70 : 50,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            translate(context, title),
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
  final Widget widget;

  ItemListBuilder({this.image, this.title, this.widget});
}
