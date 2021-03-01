import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/appbar.dart';
import '../../common/custom_button.dart';
import '../../common/rating_builder.dart';
import '../../common/textinput.dart';
import '../../constant/color.dart';
import '../../constant/global.dart';
import '../../constant/models.dart';
import '../../services/services.dart';


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
      //TODO: Add in localization
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
      "api_key": API_KEY,
      "customer_id": userdata.id,
      "gift_id": widget.giftData.id,
      "rate": feedback,
      "comment": review
    });
    await Services.productReview(body).then((value) {
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
