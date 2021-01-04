import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/page_route.dart';
import '../../Constant/userdata.dart';
import '../../UI/OTHERS/product_description.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Constant/color.dart';

class RedeemGift extends StatefulWidget {
  final String minPoints;
  final String maxPoints;
  RedeemGift({@required this.maxPoints, @required this.minPoints});
  @override
  _RedeemGiftState createState() => _RedeemGiftState();
}

class _RedeemGiftState extends State<RedeemGift> {
  List<GiftData> giftList = [];
  String points = "0", cumulativePurchase = "0";
  bool dataFound = false;
  @override
  void initState() {
    getUserData();
    Services.gift(FormData.fromMap({
      "api_key": Urls.apiKey,
      "min": widget.minPoints,
      "max": widget.maxPoints
    })).then((value) {
      if (value.response == "y") {
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            giftList.add(GiftData(
                id: value.data[i]["id"] ?? " ",
                title: value.data[i]["title"] ?? " ",
                points: value.data[i]["point"] ?? " ",
                desc: value.data[i]["description"] ?? " ",
                image: value.data[i]["image"] ?? " ",
                rating: value.data[i]["rating"] ?? " ",
                specs: value.data[i]["specification"] ?? " "));
          });
        }
      } else {
        setState(() {
          Fluttertoast.showToast(msg: "No gifts available");
          dataFound = true;
        });
      }
    });
    super.initState();
  }

  void getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List data = jsonDecode(sharedPreferences.getString(UserParams.userData));
    setState(() {
      points = data[0][UserParams.point] ?? "0";
      cumulativePurchase = data[0][UserParams.totalOrder] ?? "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Redeem Gift"),
      body: giftList.length != 0
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    width: size.width,
                    height: 20,
                  ),
                  buildRedeemedAmount(
                      title: "My Earned Points : ",
                      amount: points,
                      leadingTrailing: false,
                      fontSize: 17),
                  SizedBox(
                    height: 10,
                  ),
                  buildRedeemedAmount(
                      title: "Cumulative Purchase : ",
                      amount: cumulativePurchase,
                      leadingTrailing: true),
                  GridView.builder(
                      shrinkWrap: true,
                      itemCount: giftList.length,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return giftCard(giftList[index]);
                      })
                ],
              ),
            )
          : Center(
              child: !dataFound
                  ? SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.primaryColor),
                      ))
                  : Image(
                      image: AssetImage("assets/images/no-gifts2.png"),
                      height: 150,
                      width: 150,
                    )),
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
          Image.network(
            Urls.imageBaseUrl + giftData.image,
            height: size.width * 0.25,
            width: size.width * 0.25,
            fit: BoxFit.fill,
            errorBuilder: (context, object, stackTrace) {
              return Icon(
                Icons.signal_cellular_connected_no_internet_4_bar,
                color: AppColors.primaryColor,
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
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(AppColors.primaryColor),
                            strokeWidth: 1,
                          )),
                    );
            },
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            giftData.title,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text("${giftData.points} Points",
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          customButton(
              context: context,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onPressed: () => Navigator.push(
                  context,
                  CustomPageRoute(
                      widget: ProductDescription(
                    giftData: giftData,
                  ))),
              height: 35,
              width: size.width * 0.3,
              color: Colors.white,
              child: Row(
                children: [
                  Icon(
                    Icons.card_giftcard,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "VIEW",
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

class GiftData {
  final String specs, rating, points, desc, image, title, id;
  GiftData(
      {this.id,
      this.title,
      this.image,
      this.points,
      this.desc,
      this.specs,
      this.rating});
}

class FilterList {
  final String min, max;
  bool value;
  FilterList({this.value: false, this.min, this.max});
}
