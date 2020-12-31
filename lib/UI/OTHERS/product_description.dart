import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/UI/OTHERS/product_review.dart';
import '../../Common/page_route.dart';
import '../../Constant/userdata.dart';
import '../../UI/OTHERS/delivery_address.dart';
import '../../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/redeem_gift.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Constant/color.dart';

class ProductDescription extends StatefulWidget {
  final GiftData giftData;
  final bool readOnly;
  ProductDescription({@required this.giftData, this.readOnly: false});
  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  String points = "0", kyc = "";
  void getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      points = sharedPreferences.getString(UserParams.point) ?? "0";
      kyc = jsonDecode(sharedPreferences.getString(UserParams.userData))[0][UserParams.kyc];
      kyc = kyc != "" ? kyc : "n";
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Product Description"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width,
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Image.network(
                Urls.imageBaseUrl + widget.giftData.image,
                height: 250,
                width: size.width,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Container(
                          height: 200,
                          width: 200,
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      AppColors.primaryColor))),
                        );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.giftData.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                !widget.readOnly
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(3)),
                        alignment: Alignment.center,
                        width: 50,
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.giftData.rating.padLeft(1),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.green, fontSize: 14),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.green,
                              size: 20,
                            )
                          ],
                        ),
                      )
                    : SizedBox()
              ],
            ),
            buildTitledRow(title: "Points", value: widget.giftData.points),
            buildTitledRow(
                title: "Product Description", value: widget.giftData.desc),
            SizedBox(
              height: 10,
            ),
            Text(
              "Gift Specification : ",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.giftData.specs,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.readOnly
          ? customButton(
              context: context,
              onPressed: () => Navigator.push(
                  context,
                  CustomPageRoute(
                      widget: ProductReview(
                    giftData: widget.giftData,
                  ))),
              text: "Rate this product",
              color: Colors.blue[100],
              textColor: Colors.blue)
          : customButton(
              context: context,
              color: int.parse(points) >= int.parse(widget.giftData.points)
                  ? null
                  : Colors.grey[200],
              textColor: int.parse(points) >= int.parse(widget.giftData.points)
                  ? null
                  : Colors.black,
              onPressed: int.parse(points) >= int.parse(widget.giftData.points)
                  ? () => kyc == "y" ? Navigator.push(
                  context,
                  CustomPageRoute(
                      widget: DeliveryAddress(
                        giftData: widget.giftData,
                      ))) : Fluttertoast.showToast(msg: "Your KYC is pending. To avail features please do KYC.", toastLength: Toast.LENGTH_LONG)
                  : () {
                      Fluttertoast.showToast(
                          msg:
                              "You don't have enough points to redeem this gift.");
                    },
              height: 60,
              text: "REDEEM",
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildTitledRow({String title, String value}) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
