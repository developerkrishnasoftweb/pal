import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/carousel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<CarouselItems> carouselItems = [
    CarouselItems(image: AssetImage("assets/images/splash-screen.jpg")),
    CarouselItems(image: AssetImage("assets/images/splash-screen.jpg")),
    CarouselItems(image: AssetImage("assets/images/splash-screen.jpg")),
  ];

  List<ItemListBuilder> itemList = [
    ItemListBuilder(title: "Product Catalog", image: AssetImage("assets/images/product-catalog.png")),
    ItemListBuilder(title: "Earned Point", image: AssetImage("assets/images/earned-point.png")),
    ItemListBuilder(title: "Redeem Gift", image: AssetImage("assets/images/redeem-gift.png")),
    ItemListBuilder(title: "Service Request", image: AssetImage("assets/images/service-request.png")),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Container(
            height: size.height > 500 ? size.height * 0.3 : 180,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.red,
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
                        onPressed: () {
                        },
                        splashRadius: 23,
                        iconSize: 20,
                      )
                    ]
                  ),
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
                SizedBox(height: 30,),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    physics: BouncingScrollPhysics(),
                    itemCount: itemList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1
                    ),
                    itemBuilder: (BuildContext context, int index){
                      return buildItems(context: context, image: itemList[index].image, title: itemList[index].title);
                    })
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}
Widget buildItems({@required BuildContext context, ImageProvider image, String title}){
  return Card(
    elevation: 2,
    shadowColor: Colors.grey[50],
    child: InkWell(
      borderRadius: BorderRadius.circular(3),
      onTap: (){},
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
          SizedBox(height: 10,),
          Text(title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    ),
  );
}

class ItemListBuilder{
  final ImageProvider image;
  final String title;
  ItemListBuilder({this.image, this.title});
}