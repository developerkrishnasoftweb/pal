import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../Pages/RETAILER_BONDING_PROGRAM/redeem_gift.dart';
import '../../Common/appbar.dart';
import '../../Common/carousel.dart';
import '../../Common/page_route.dart';
import '../../Constant/color.dart';
import '../../Pages/OTHERS/category.dart';
import '../../Pages/OTHERS/kyc_details.dart';
import '../../Pages/RETAILER_BONDING_PROGRAM/earned_points.dart';
import '../../Pages/RETAILER_BONDING_PROGRAM/weekly_update.dart';
import '../../Pages/SERVICE_REQUEST/complain.dart';
import '../../Pages/SERVICE_REQUEST/service_request.dart';
import '../../Pages/SIGNIN_SIGNUP/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey;
  Future showDialogBox() {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => AlertDialog(
              content: Text("Are you sure you want to Logout?"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "NO",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FlatButton(
                  onPressed: _logout,
                  child: Text(
                    "YES",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ));
  }

  _logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("userdata");
    sharedPreferences.remove("password");
    if (sharedPreferences.getString("userdata") == null &&
        sharedPreferences.getString("password") == null) {
      Navigator.pushAndRemoveUntil(
          context, CustomPageRoute(widget: SignIn(email: sharedPreferences.getString("username"),)), (route) => false);
    }
  }

  List<CarouselItems> carouselItems = [
    CarouselItems(image: AssetImage("assets/images/pal-logo1.png")),
    CarouselItems(image: AssetImage("assets/images/pal-logo1.png")),
    CarouselItems(image: AssetImage("assets/images/pal-logo1.png")),
  ];

  List<ItemListBuilder> itemList;

  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    itemList = [
      ItemListBuilder(
          title: "Product Catalog",
          onTap: () => Navigator.push(context, CustomPageRoute(widget: CategoryBuilder())),
          image: AssetImage("assets/images/product-catalog.png")),
      ItemListBuilder(
          title: "Earned Point",
          onTap: () => Navigator.push(context, CustomPageRoute(widget: EarnedPoints())),
          image: AssetImage("assets/images/earned-point.png")),
      ItemListBuilder(
          title: "Redeem Gift",
          onTap: () => Navigator.push(context, CustomPageRoute(widget: RedeemGift())),
          image: AssetImage("assets/images/redeem-gift.png")),
      ItemListBuilder(
          title: "Service Request",
          onTap: () => Navigator.push(context, CustomPageRoute(widget: ServiceRequest())),
          image: AssetImage("assets/images/service-request.png")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
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
                          "Version 4.5",
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
              ListTile(
                title:
                    Align(alignment: Alignment(-1.2, 0.0), child: Text("HOME")),
                onTap: () {
                  Navigator.pushAndRemoveUntil(context,
                      CustomPageRoute(widget: Home()), (route) => false);
                },
                leading: Icon(Icons.home),
              ),
              ListTile(
                title: Align(
                    alignment: Alignment(-1.2, 0.0), child: Text("Update KYC")),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(context, CustomPageRoute(widget: KYC()));
                },
                leading: Icon(Icons.book_online_outlined),
              ),
              ListTile(
                title: Align(
                    alignment: Alignment(-1.2, 0.0),
                    child: Text("PRODUCT CATALOG")),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: CategoryBuilder()));
                },
                leading: Icon(Icons.book_outlined),
              ),
              ListTile(
                title: Align(
                    alignment: Alignment(-1.2, 0.0),
                    child: Text("My Weekly Update")),
                leading: Icon(
                  Icons.table_chart_outlined,
                  color: Colors.grey,
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: WeeklyUpdate()));
                },
              ),
              ListTile(
                title: Align(
                    alignment: Alignment(-1.2, 0.0),
                    child: Text("My Earned Points")),
                leading: Icon(
                  Icons.table_chart,
                  color: Colors.grey,
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: EarnedPoints()));
                },
              ),
              ListTile(
                title: Align(
                    alignment: Alignment(-1.2, 0.0),
                    child: Text("New Service Request")),
                leading: Icon(
                  Icons.pages,
                  color: Colors.grey,
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: Complain()));
                },
              ),
              ListTile(
                title: Align(
                    alignment: Alignment(-1.2, 0.0),
                    child: Text("View Service Request")),
                leading: Icon(
                  Icons.pages_outlined,
                  color: Colors.grey,
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: ServiceRequest()));
                },
              ),
              ListTile(
                title: Align(
                    alignment: Alignment(-1.2, 0.0),
                    child: Text("Redeem Gift")),
                leading: Icon(
                  Icons.card_giftcard,
                  color: Colors.grey,
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: RedeemGift()));
                },
              ),
              ListTile(
                title: Align(
                    alignment: Alignment(-1.2, 0.0),
                    child: Text("Reports")),
                leading: Icon(
                  Icons.report,
                  color: Colors.grey,
                ),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  Navigator.push(
                      context, CustomPageRoute(widget: RedeemGift()));
                },
              ),
              ListTile(
                title: Align(
                    alignment: Alignment(-1.2, 0.0), child: Text("Logout")),
                onTap: showDialogBox,
                leading: Icon(Icons.logout),
              ),
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
}

Widget buildItems(
    {@required BuildContext context, ImageProvider image, String title, GestureTapCallback onTap}) {
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
