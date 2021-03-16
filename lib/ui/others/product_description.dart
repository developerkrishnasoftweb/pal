import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/custom_button.dart';
import '../../ui/widgets/page_route.dart';
import '../../constant/global.dart';
import '../../constant/models.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../services/services.dart';
import '../../services/urls.dart';
import '../../ui/others/product_review.dart';

import 'delivery_address.dart';
import 'kyc_details.dart';

class ProductDescription extends StatefulWidget {
  final GiftData giftData;
  final bool readOnly;
  final StoreDetails storeDetails;

  const ProductDescription({Key key, this.giftData, this.readOnly : false, @required this.storeDetails}) : super(key: key);


  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
          context: context,
          title: translate(context, LocaleStrings.productDescription)),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              Urls.imageBaseUrl + widget.giftData.image,
              height: 270,
              width: size.width,
              fit: BoxFit.contain,
              errorBuilder: (context, object, stackTrace) {
                return Image(image: AssetImage("assets/images/pal-logo.png"));
              },
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : Container(
                        height: 250,
                        width: size.width,
                        alignment: Alignment.center,
                        child: SizedBox(
                            height: 40,
                            width: 40,
                            child: circularProgressIndicator()));
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.giftData.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                !widget.readOnly
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(3)),
                        alignment: Alignment.center,
                        width: 50,
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.giftData.rating == "0"
                                  ? "4"
                                  : widget.giftData.rating.padLeft(1),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.green, fontSize: 14),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.green,
                              size: 20,
                            )
                          ],
                        ),
                      )
                    : SizedBox()
              ],
            ),
            buildTitledRow(
                title: translate(context, LocaleStrings.points),
                value: widget.giftData.points),
            buildTitledRow(
                title: translate(context, LocaleStrings.productDescription),
                value: removeHtmlTags(data: widget.giftData.desc)),
            SizedBox(
              height: 10,
            ),
            buildTitledRow(
                title:
                    "${translate(context, LocaleStrings.giftSpecification)} : ",
                value: removeHtmlTags(data: widget.giftData.specs)),
          ],
        ),
      ),
      floatingActionButton: widget.readOnly
          ? customButton(
              context: context,
              onPressed: () => Navigator.push(
                  context,
                  CustomPageRoute(
                      widget: ProductReview(
                    giftData: widget.giftData,
                  ))),
              text: "Rate this product",
              color: Colors.blue[100],
              textColor: Colors.blue)
          : customButton(
              context: context,
              color:
                  int.parse(userdata.point) >= int.parse(widget.giftData.points)
                      ? null
                      : Colors.grey[200],
              textColor:
                  int.parse(userdata.point) >= int.parse(widget.giftData.points)
                      ? null
                      : Colors.black,
              onPressed: int.parse(userdata.point) >=
                      int.parse(widget.giftData.points)
                  ? userdata.kyc == "y"
                      ? () => Navigator.push(
                              context,
                              CustomPageRoute(
                                  widget: DeliveryAddress(
                                giftData: widget.giftData,
                                    storeDetails: widget.storeDetails,
                              )))
                          .then((value) async => await Services.getUserData())
                      : () {
                          Fluttertoast.showToast(
                              msg:
                                  "Your KYC is pending. To avail features please do KYC.",
                              toastLength: Toast.LENGTH_LONG);
                          Navigator.push(
                              context, CustomPageRoute(widget: KYC()));
                        }
                  : () {
                      Fluttertoast.showToast(
                          msg: translate(context,
                              LocaleStrings.dontHaveEnoughPointToRedeem));
                    },
              text: translate(context, LocaleStrings.redeemBtn),
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
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
