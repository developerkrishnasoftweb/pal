import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/userdata.dart';
import 'package:pal/SERVICES/services.dart';
import 'package:pal/SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common/appbar.dart';
import '../../Constant/color.dart';

class GiftCategory extends StatefulWidget {
  @override
  _GiftState createState() => _GiftState();
}

class _GiftState extends State<GiftCategory> {
  List<GiftCategoryData> giftCategoryList = [];
  String points = "0";
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
                status: value.data[i]["status"]));
          });
        }
      } else {
        print(value.message);
      }
    });
    super.initState();
  }

  void getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getString(UserParams.point));
    setState(() {
      points = sharedPreferences.getString(UserParams.point) ?? "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBar(context: context, title: "Redeem Gift", actions: [
          IconButton(
            onPressed: () {},
            splashRadius: 25,
            icon: Icon(Icons.shopping_cart),
          )
        ]),
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
                        title: "My Earned Points : ",
                        amount: points,
                        leadingTrailing: false,
                        fontSize: 17),
                    SizedBox(
                      height: 10,
                    ),
                    buildRedeemedAmount(
                        title: "Cumulative Purchase : ",
                        amount: "0.0",
                        leadingTrailing: true),
                    GridView.builder(
                        shrinkWrap: true,
                        itemCount: giftCategoryList.length,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.2,
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
    return InkWell(
      onTap: (){

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
            Text(
              giftCategoryData.title,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text("${giftCategoryData.min} - ${giftCategoryData.max} Points",
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
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
  final String status;
  GiftCategoryData({this.id, this.title, this.max, this.min, this.status});
}
