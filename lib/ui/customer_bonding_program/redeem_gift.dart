import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/ui/others/delivery_address.dart';
import '../../constant/global.dart';
import '../../constant/models.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../services/services.dart';
import '../../services/urls.dart';
import '../../ui/others/product_description.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/custom_button.dart';
import '../../ui/widgets/page_route.dart';

class RedeemGift extends StatefulWidget {
  final String minPoints;
  final String maxPoints;

  RedeemGift({@required this.maxPoints, @required this.minPoints});

  @override
  _RedeemGiftState createState() => _RedeemGiftState();
}

class _RedeemGiftState extends State<RedeemGift> {
  List<GiftData> giftList = [];
  bool dataFound = false;
  List<StoreDetails> stores = [];
  StoreDetails storeDetails;

  @override
  void initState() {
    super.initState();
    getStores();
  }

  getStores() async {
    await Services.getStores().then((value) {
      if (value.response == "y") {
        if(value.data.length == 0) {
          stores = null;
          return;
        }
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            stores.add(StoreDetails(
                id: value.data[i]["id"],
                name: value.data[i]["name"],
                state: value.data[i]["state"],
                pinCode: value.data[i]["pincode"],
                city: value.data[i]["city"],
                location: value.data[i]["location"],
                storeCode: value.data[i]["store_code"]));
          });
        }
        if (stores.length > 0) {
          setState(() {
            storeDetails = stores[0];
          });
          getGifts();
        }
      } else {
        setState(() {
          stores = null;
        });
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  getGifts() async {
    setState(() {
      dataFound = false;
    });
    await Services.gift(
            FormData.fromMap({
              "api_key": API_KEY,
              "min": widget.minPoints,
              "max": widget.maxPoints
            }),
            departmentId: storeDetails.id)
        .then((value) {
      if (value.response == "y") {
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            giftList.add(GiftData.fromJson(value.data[i]));
          });
        }
      } else {
        setState(() {
          Fluttertoast.showToast(msg: value.message);
          dataFound = true;
        });
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
      body: stores.length > 0
          ? Column(
              children: [
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "( ",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: translate(context, LocaleStrings.cumulativeScore) +
                          " : ",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: userdata.totalOrder,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.black, fontSize: 15),
                    ),
                    TextSpan(
                      text: " )",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
                Container(
                  width: size.width - 20,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 10,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton(
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        storeDetails = value;
                      });
                      getGifts();
                    },
                    underline: SizedBox.shrink(),
                    value: storeDetails,
                    //TODO: In future "Home Delivery" option will be added in dropdown
                    items: stores.map((store) {
                      return DropdownMenuItem(
                        value: store,
                        child: Text(store.name),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                    child: giftList.length != 0
                        ? GridView.builder(
                            shrinkWrap: true,
                            itemCount: giftList.length,
                            padding: EdgeInsets.all(10),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.9,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return giftCard(giftList[index]);
                            })
                        : Center(
                            child: !dataFound
                                ? SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: circularProgressIndicator())
                                : Image(
                                    image: AssetImage(
                                        "assets/images/no-gifts2.png"),
                                    height: 150,
                                    width: 150,
                                  )))
              ],
            )
          : Center(
              child: Text("Looking for stores..."),
            ),
    );
  }

  Widget giftCard(GiftData giftData) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey[200], blurRadius: 5)],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                Urls.imageBaseUrl + giftData.image,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                errorBuilder: (context, object, stackTrace) {
                  return Image(image: AssetImage("assets/images/pal-logo.png"));
                },
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Center(
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: circularProgressIndicator()),
                        );
                },
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              giftData.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text("${giftData.points} ${translate(context, LocaleStrings.points)}",
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          customButton(
              context: context,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () => Navigator.push(
                  context,
                  CustomPageRoute(
                      widget: ProductDescription(
                    giftData: giftData,
                        storeDetails: storeDetails
                  ))),
              height: 35,
              width: size.width * 0.3,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_giftcard,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    translate(context, LocaleStrings.viewBtn),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 12),
                    softWrap: true,
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget buildRedeemedAmount(
      {String title, String amount, bool leadingTrailing, double fontSize}) {
    TextStyle style = Theme.of(context).textTheme.bodyText1.copyWith(
        color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold);
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: leadingTrailing ? "(" : "",
          style: style,
        ),
        TextSpan(
          text: title,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.grey,
              fontSize: fontSize ?? 13,
              fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: amount,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.black, fontSize: fontSize ?? 13),
        ),
        TextSpan(
          text: leadingTrailing ? ")" : "",
          style: style,
        ),
      ]),
    );
  }
}

// class GiftData {
//   final String specs, rating, points, desc, image, title, id;
//   GiftData(
//       {this.id,
//       this.title,
//       this.image,
//       this.points,
//       this.desc,
//       this.specs,
//       this.rating});
// }

class FilterList {
  final String min, max;
  bool value;

  FilterList({this.value: false, this.min, this.max});
}
