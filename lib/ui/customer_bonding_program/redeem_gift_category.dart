import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/ui/others/delivery_address.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/page_route.dart';
import '../../constant/color.dart';
import '../../constant/global.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../services/services.dart';
import '../../services/urls.dart';
import '../../ui/customer_bonding_program/redeem_gift.dart';

class GiftCategory extends StatefulWidget {
  final StoreDetails storeDetails;

  const GiftCategory({Key key, @required this.storeDetails}) : super(key: key);

  @override
  _GiftState createState() => _GiftState();
}

class _GiftState extends State<GiftCategory> {
  List<GiftCategoryData> giftCategoryList = [];

  @override
  void initState() {
    super.initState();
    getGiftsCategory();
  }

  getGiftsCategory() async {
    await Services.giftCategory(FormData.fromMap({"api_key": API_KEY}))
        .then((value) {
      if (value.response == "y") {
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            giftCategoryList.add(GiftCategoryData(
                id: value.data[i]["id"],
                title: value.data[i]["title"],
                max: value.data[i]["max"],
                min: value.data[i]["min"],
                image: value.data[i]["image"],
                status: value.data[i]["status"]));
          });
        }
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBar(
            context: context,
            title: translate(context, LocaleStrings.redeemGift),
            actions: [wallet()]),
        body: giftCategoryList.length != 0
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width,
                      height: 20,
                    ),
                    GridView.builder(
                        shrinkWrap: true,
                        itemCount: giftCategoryList.length,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.9,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return giftCard(giftCategoryList[index]);
                        })
                  ],
                ),
              )
            : Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: circularProgressIndicator(),
                ),
              ));
  }

  Widget giftCard(GiftCategoryData giftCategoryData) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.push(
            context,
            CustomPageRoute(
                widget: RedeemGift(
                    storeDetails: widget.storeDetails,
                    maxPoints: giftCategoryData.max,
                    minPoints: giftCategoryData.min)));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              Urls.imageBaseUrl + giftCategoryData.image,
              height: size.width * 0.15,
              width: size.width * 0.15,
              fit: BoxFit.fill,
              errorBuilder: (context, object, stackTrace) {
                return Icon(
                  Icons.signal_cellular_connected_no_internet_4_bar,
                  color: primaryColor,
                );
              },
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: circularProgressIndicator()),
                      );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${int.parse(giftCategoryData.min) > 0 ? giftCategoryData.min + " - " : ""}${giftCategoryData.max} ${translate(context, LocaleStrings.points)}",
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class GiftCategoryData {
  final String id;
  final String title;
  final String min;
  final String max;
  final String image;
  final String status;

  GiftCategoryData(
      {this.id, this.title, this.max, this.min, this.status, this.image});
}
