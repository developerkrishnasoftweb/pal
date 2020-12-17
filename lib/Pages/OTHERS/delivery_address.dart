import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/input_border.dart';
import 'package:pal/Common/textinput.dart';

class DeliveryAddress extends StatefulWidget {
  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  String addressType = "Select Delivery Type";
  bool collectToShop = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Delivery Address"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 100),
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              height: 20,
            ),
            Container(
              width: size.width - 20,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 10,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButton(
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    addressType = value;
                    if (value == "Collect to shop") {
                      collectToShop = true;
                    } else if (value == "Home delivery") {
                      collectToShop = false;
                    }
                  });
                },
                underline: SizedBox.shrink(),
                value: addressType,
                items: [
                  "Select Delivery Type",
                  "Collect to shop",
                  "Home delivery"
                ].map((text) {
                  return DropdownMenuItem(
                    value: text,
                    child: Text(text),
                  );
                }).toList(),
              ),
            ),
            Visibility(
                replacement: addressType != "Select Delivery Type"
                    ? buildHomeDelivery()
                    : SizedBox.shrink(),
                visible: collectToShop,
                child: addressType != "Select Delivery Type"
                    ? buildCollectToShop()
                    : SizedBox.shrink()),
          ],
        ),
      ),
      floatingActionButton: customButton(
          context: context,
          onPressed: () {},
          height: 60,
          width: size.width,
          text: "CONFIRM"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildHomeDelivery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        input(
            context: context,
            text: "Address",
            decoration: InputDecoration(
              border: border(),
            ),
            maxLines: 5),
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
            "Upload Proof (Any one) :",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        proofBuilder("Aadhaar, Pan, Voter Card, Driving Licence")
      ],
    );
  }

  Widget buildCollectToShop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitledRow(
            title: "Current Address :",
            value:
                "NR Gov.School, Main Market, Sherpur Kalan, Ludhiana, 9216785632, Sherpur"),
        SizedBox(
          height: 15,
        ),
        Text(
          "Upload Proof (Any one) :",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        proofBuilder("Aadhaar, Pan, Voter Card, Driving Licence")
      ],
    );
  }

  Widget proofBuilder(String text) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 120,
        width: 180,
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment(0.0, 0.7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]),
        ),
        child: Text(text),
      ),
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
