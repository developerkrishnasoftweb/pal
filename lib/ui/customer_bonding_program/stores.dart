import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/constant/global.dart';
import 'package:pal/constant/strings.dart';
import 'package:pal/localization/localizations_constraints.dart';
import 'package:pal/services/services.dart';
import 'package:pal/ui/customer_bonding_program/redeem_gift_category.dart';
import 'package:pal/ui/others/delivery_address.dart';
import 'package:pal/ui/widgets/appbar.dart';
import 'package:pal/ui/widgets/custom_button.dart';
import 'package:pal/ui/widgets/page_route.dart';

class Stores extends StatefulWidget {
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  List<StoreDetails> stores = [];
  StoreDetails storeDetails;

  @override
  void initState() {
    super.initState();
    getStores();
  }

  getStores() async {
    stores.clear();
    await Services.getStores().then((value) {
      if (value.response == "y") {
        if (value.data.length == 0) {
          stores = null;
          return;
        }
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            stores.add(StoreDetails.fromJson(value.data[i]));
          });
        }
        if (stores.length > 0) {
          setState(() {
            storeDetails = stores[0];
          });
        }
      } else {
        setState(() {
          stores = null;
        });
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          context: context,
          title: translate(context, LocaleStrings.redeemGift),
          actions: [wallet()]),
      body: stores != null ? stores.length > 0
          ? Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text("Select Store",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17)),
                    )),
                Expanded(
                    child: ListView.builder(
                        itemBuilder: (_, index) {
                          return RadioListTile<StoreDetails>(
                              value: stores[index],
                              groupValue: storeDetails,
                              title: Text(stores[index].name),
                              onChanged: (store) {
                                setState(() {
                                  storeDetails = store;
                                });
                              });
                        },
                        itemCount: stores.length)),
                customButton(
                    context: context,
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    onPressed: () => Navigator.push(
                        context,
                        CustomPageRoute(
                            widget: GiftCategory(
                          storeDetails: storeDetails,
                        ))),
                    text: "NEXT"),
              ],
            )
          : Center(child: Text("Looking for stores...")) : Center(child: Text("Oops, something went wrong, Please try again later"),),
    );
  }
}
