import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Constant/color.dart';
import 'package:pal/Constant/global.dart';
import 'package:pal/Constant/strings.dart';
import 'package:pal/LOCALIZATION/localizations_constraints.dart';
import 'package:pal/SERVICES/services.dart';
import 'package:pal/SERVICES/urls.dart';
import 'package:pal/UI/OTHERS/product_description.dart';

class RedeemedGift extends StatefulWidget {
  @override
  _RedeemedGiftState createState() => _RedeemedGiftState();
}

class _RedeemedGiftState extends State<RedeemedGift> {
  List<GiftData> giftList = [];
  bool dataFound = false;
  @override
  void initState() {
    getRedeemedGifts();
    super.initState();
  }

  void getRedeemedGifts() async {
    Services.redeemedGifts(
            FormData.fromMap({"api_key": Urls.apiKey, "id": userdata.id}))
        .then((value) {
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
        appBar: appBar(context: context, title: translate(context, LocaleStrings.redeemedGifts)),
        body: giftList.length != 0
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
                          valueColor: AlwaysStoppedAnimation(primaryColor),
                        ))
                    : Image(
                        image: AssetImage("assets/images/no-gifts2.png"),
                        height: 150,
                        width: 150,
                      )));
  }

  Widget giftCard(GiftData giftData) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDescription(
                    giftData: giftData,
                    readOnly: true,
                  ))),
      highlightColor: Colors.grey[200],
      splashColor: Colors.grey[500],
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
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(primaryColor),
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
          Text("Redeemed",
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ],
      ),
    );
  }
}
