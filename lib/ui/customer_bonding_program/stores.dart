import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/constant/color.dart';
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
  int selectedStoreDetailIndex = 0;

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
          context: context,
          title: translate(context, LocaleStrings.redeemGift),
          actions: [wallet()]),
      body: stores != null
          ? stores.length > 0
              ? Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text(
                              "Select Store From Where You Want To Redeem :",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        )),
                    Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedStoreDetailIndex = index;
                                        storeDetails = stores[index];
                                      });
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(index ==
                                                    selectedStoreDetailIndex
                                                ? primaryColor
                                                : Colors.grey
                                                    .withOpacity(0.2))),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(stores[index].name,
                                                  style: TextStyle(
                                                      color: index ==
                                                              selectedStoreDetailIndex
                                                          ? Colors.white
                                                          : Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                              Text(
                                                  stores[index].location +
                                                      ", " +
                                                      stores[index].city,
                                                  style: TextStyle(
                                                      color: index ==
                                                              selectedStoreDetailIndex
                                                          ? Colors.white
                                                          : Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13))
                                            ]),
                                      ),
                                    )),
                              );
                            },
                            itemCount: stores.length)),
                    customButton(
                        context: context,
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        onPressed: () => Navigator.push(
                            context,
                            CustomPageRoute(
                                widget: GiftCategory(
                              storeDetails: storeDetails,
                            ))),
                        text: "NEXT"),
                  ],
                )
              : Center(
                  child: Image.asset('assets/images/loading-gif.gif',
                      height: size.width * 0.4, width: size.width * 0.4))
          : Center(
              child: Text("Oops, something went wrong, Please try again later"),
            ),
    );
  }
}
