import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
          input(context: context, decoration: InputDecoration(border: border()), maxLines: 5, text: "Review"),
        ],
      ),

    );
  }
}
