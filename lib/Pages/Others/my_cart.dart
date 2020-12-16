import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "My Cart"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 100),
        child: Column(
          children: [
            SizedBox(
              height: 20,
              width: size.width,
            ),
            RichText(
              text: TextSpan(
                  text: "Total Points(1 Item) : ",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey),
                  children: [
                    TextSpan(
                        text: "973.93",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
                child: Text("List Item : ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16)))
          ],
        ),
      ),
      floatingActionButton: customButton(
          context: context,
          onPressed: () {},
          height: 60,
          width: size.width,
          text: "PROCEED TO CHECKOUT"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
