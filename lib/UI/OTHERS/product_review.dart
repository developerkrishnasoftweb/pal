import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/color.dart';
import 'package:pal/Constant/global.dart';
import 'package:pal/SERVICES/services.dart';
import 'package:pal/SERVICES/urls.dart';

import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Common/input_decoration.dart';
import '../../Common/rating_builder.dart';
import '../../Common/textinput.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/redeem_gift.dart';

class ProductReview extends StatefulWidget {
  final GiftData giftData;
  ProductReview({@required this.giftData});
  @override
  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  int feedback = 0;
  String review = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Review"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: RatingBuilder(
              iconSize: 50,
              itemExtent: 50,
              onChanged: (value) {
                setState(() {
                  feedback = value;
                });
              },
            ),
          ),
          input(
              context: context,
              decoration: InputDecoration(border: border()),
              maxLines: 5,
              text: "Review",
              onChanged: (value) => setState(() => review = value)),
        ],
      ),
      floatingActionButton: feedback > 0 && review.isNotEmpty
          ? customButton(
              context: context,
              onPressed: isLoading ? null : _addReview,
              text: isLoading ? null : "SUBMIT",
              child: isLoading
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(primaryColor),
                      ))
                  : null)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _addReview() async {
    setState(() {
      isLoading = true;
    });
    FormData body = FormData.fromMap({
      "api_key": Urls.apiKey,
      "customer_id": userdata.id,
      "gift_id": widget.giftData.id,
      "rate": feedback,
      "comment": review
    });
    Services.productReview(body).then((value) {
      if (value.response == "y") {
        Fluttertoast.showToast(msg: value.message);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: value.message);
        setState(() {
          isLoading = false;
        });
      }
    });
  }
}
