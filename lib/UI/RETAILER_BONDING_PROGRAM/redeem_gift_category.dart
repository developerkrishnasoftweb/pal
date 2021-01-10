import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Common/page_route.dart';
import '../../Constant/userdata.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/redeem_gift.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common/appbar.dart';
import '../../Constant/color.dart';

class GiftCategory extends StatefulWidget {
  @override
  _GiftState createState() => _GiftState();
}

class _GiftState extends State<GiftCategory> {
  List<GiftCategoryData> giftCategoryList = [];
  String points = "0", cumulativePurchase = "0";
  @override
  void initState() {
    getUserData();
    Services.giftCategory(FormData.fromMap({"api_key": Urls.apiKey}))
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
        body: giftCategoryList.length != 0
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width,
                      height: 20,
                    ),
                    buildRedeemedAmount(
                        title: "Available Points : ",
                        amount: points,
                        leadingTrailing: false,
                        fontSize: 17),
                    SizedBox(
                      height: 10,
                    ),
                    buildRedeemedAmount(
                        title: "Cumulative Score : ",
                        amount: cumulativePurchase,
                        leadingTrailing: true),
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
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),
              ));
  }

  Widget giftCard(GiftCategoryData giftCategoryData) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: (){
        Navigator.push(context, CustomPageRoute(widget: RedeemGift(maxPoints: giftCategoryData.max, minPoints: giftCategoryData.min)));
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
                        valueColor: AlwaysStoppedAnimation(
                            AppColors.primaryColor), strokeWidth: 1,)),
                );
              },
            ),
            SizedBox(height: 10,),
            Text("${int.parse(giftCategoryData.min) > 0 ? giftCategoryData.min + " - " : ""}${giftCategoryData.max} Points",
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

class GiftCategoryData {
  final String id;
  final String title;
  final String min;
  final String max;
  final String image;
  final String status;
  GiftCategoryData({this.id, this.title, this.max, this.min, this.status, this.image});
}
