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
    await Services.getStores().then((value) {
      if (value.response == "y") {
        print(value.data.last);
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
          context: context,
          title: translate(context, LocaleStrings.redeemGift),
          actions: [wallet()]),
      body: stores.length > 0
          ? Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Text("Select Store", style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                      )),
                    )),
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
                        storeDetails = value;
                      });
                    },
                    underline: SizedBox.shrink(),
                    value: storeDetails,
                    items: stores.map((store) {
                      return DropdownMenuItem(
                        value: store,
                        child: Text(store.name),
                      );
                    }).toList(),
                  ),
                ),
                Spacer(),
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
          : Center(child: Text("Looking for stores...")),
    );
  }
}
