import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/input_decoration.dart';
import 'package:pal/Common/textinput.dart';
import '../../Common/appbar.dart';
import '../../Common/rating_builder.dart';

class ProductReview extends StatefulWidget {
  @override
  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  int feedback = 0;
  String review = "";
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
              onChanged: (value){
                setState(() {
                  feedback = value;
                });
              },
            ),
          ),
          input(context: context, decoration: InputDecoration(border: border()), maxLines: 5, text: "Review", onChanged: (value) => setState(() => review = value)),
        ],
      ),
      floatingActionButton: feedback > 0 && review.isNotEmpty ? customButton(context: context, onPressed: (){}, text: "SUBMIT") : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
