import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Constant/color.dart';

class RedeemGift extends StatefulWidget {
  @override
  _RedeemGiftState createState() => _RedeemGiftState();
}

class _RedeemGiftState extends State<RedeemGift> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Redeem Gift", actions: [
        IconButton(
          onPressed: () {},
          splashRadius: 25,
          icon: Icon(Icons.shopping_cart),
        )
      ]),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              height: 20,
            ),
            buildRedeemedAmount(
                title: "My Earned Points : ",
                amount: "196604",
                leadingTrailing: false,
                fontSize: 17),
            SizedBox(
              height: 10,
            ),
            buildRedeemedAmount(
                title: "Cumulative Purchase : ",
                amount: "394230.00",
                leadingTrailing: true),
            GridView.builder(
                shrinkWrap: true,
                itemCount: 10,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey[200], blurRadius: 5)
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://s.aolcdn.com/dims-global/dims3/GLOB/legacy_thumbnail/360x200/quality/85/https://s.aolcdn.com/commerce/autodata/images/USD00MBCBJ3A021001.jpg",
                          height: size.width * 0.25,
                          width: size.width * 0.25,
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.signal_cellular_connected_no_internet_4_bar,
                              color: AppColors.primaryColor,
                            );
                          },
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            AppColors.primaryColor)));
                          },
                        ),
                        Text(
                          "Mercedes Car",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text("55,00,000 Points",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                        customButton(
                            context: context,
                            onPressed: () {},
                            height: 35,
                            width: size.width * 0.3,
                            color: Colors.white,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.card_giftcard,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "VIEW",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 12),
                                  softWrap: true,
                                )
                              ],
                            ))
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget buildRedeemedAmount(
      {String title, String amount, bool leadingTrailing, double fontSize}) {
    TextStyle style = Theme.of(context).textTheme.bodyText1.copyWith(
        color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold);
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: leadingTrailing ? "(" : "",
          style: style,
        ),
        TextSpan(
          text: title,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.grey,
              fontSize: fontSize ?? 13,
              fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: amount,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.black, fontSize: fontSize ?? 13),
        ),
        TextSpan(
          text: leadingTrailing ? ")" : "",
          style: style,
        ),
      ]),
    );
  }
}
