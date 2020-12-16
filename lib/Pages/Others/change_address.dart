import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/input_border.dart';
import 'package:pal/Common/textinput.dart';
import 'package:pal/Constant/color.dart';

class ChangeAddress extends StatefulWidget {
  @override
  _ChangeAddressState createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  List<String> proofTextLists = [
    "GSTN Certificate",
    "Shop Electricity Bill",
    "Shop Tel. / Mobile Bill",
    "Copy of letter head"
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Change Address"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            input(
                context: context,
                text: "Address 1",
                decoration: InputDecoration(border: border()),
                autoFocus: true),
            input(
                context: context,
                text: "Address 2",
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                text: "Address 3",
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                text: "State",
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                text: "City",
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                text: "Area",
                decoration: InputDecoration(border: border())),
            input(
                context: context,
                text: "Pincode",
                decoration: InputDecoration(border: border())),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Upload Proof :",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 280,
              width: size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: proofTextLists.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemBuilder: (BuildContext context, int index) {
                    return proofBuilder(proofTextLists[index]);
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: button(context: context, onPressed: (){}, height: 60, width: size.width, text: "PROCEED"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget proofBuilder(String text) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment(0.0, 0.7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]),
        ),
        child: Text(text),
      ),
    );
  }
}
