import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Common/page_route.dart';
import '../../Constant/userdata.dart';
import '../../UI/OTHERS/delivery_address.dart';
import '../../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../UI/RETAILER_BONDING_PROGRAM/redeem_gift.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Constant/color.dart';

class ProductDescription extends StatefulWidget {
  final GiftData giftData;
  final bool readOnly;
  ProductDescription({@required this.giftData, this.readOnly : false});
  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  String points = "0";
  void getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      points = sharedPreferences.getString(UserParams.point) ?? "0";
    });
  }
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Product Description"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width,
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Image.network(
                Urls.imageBaseUrl + widget.giftData.image,
                height: 250,
                width: size.width,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Container(
                          height: 200,
                          width: 200,
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      AppColors.primaryColor))),
                        );
                },
              ),
            ),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.center,
                child: Text(
                  widget.giftData.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            buildTitledRow(title: "Points", value: widget.giftData.points),
            buildTitledRow(
                title: "Product Description", value: widget.giftData.desc),
            SizedBox(
              height: 10,
            ),
            Text(
              "Gift Specification : ",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.giftData.specs,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.readOnly ? null : customButton(
        context: context,
        color: int.parse(points) >= int.parse(widget.giftData.points) ? null : Colors.grey[200],
        textColor: int.parse(points) >= int.parse(widget.giftData.points) ? null : Colors.black,
        onPressed: int.parse(points) >= int.parse(widget.giftData.points)
            ? () => Navigator.push(context, CustomPageRoute(widget: DeliveryAddress(giftData: widget.giftData,)))
            : () {
                Fluttertoast.showToast(
                    msg: "You don't have enough points to redeem this gift.");
              },
        height: 60,
        text: "REDEEM",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
