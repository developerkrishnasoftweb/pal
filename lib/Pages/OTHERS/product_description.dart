import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/SERVICES/urls.dart';
import '../../Pages/RETAILER_BONDING_PROGRAM/redeem_gift.dart';
import '../../Common/appbar.dart';
import '../../Common/custom_button.dart';
import '../../Constant/color.dart';

class ProductDescription extends StatefulWidget {
  final GiftData giftData;
  ProductDescription({@required this.giftData});
  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
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
            SizedBox(width: size.width, height: 20,),
            Align(
              alignment: Alignment.center,
              child: Image.network(Urls.imageBaseUrl + widget.giftData.image,
                height: 250,
                width: size.width,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, progress){
                  return progress == null ? child : Container(
                    height: 200,
                    width: 200,
                    alignment: Alignment.center,
                    child: SizedBox(height: 40, width: 40, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryColor))),
                  );
                },
              ),
            ),
            Align(alignment: Alignment.center, child: Text(widget.giftData.title, style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 20),)),
            SizedBox(height: 30,),
            buildTitledRow(title: "Points", value: widget.giftData.points),
            buildTitledRow(title: "Product Description", value: widget.giftData.desc),
            SizedBox(height: 10,),
            Text("Gift Specification : ", style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 16),),
            SizedBox(height: 10,),
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.\n\n"
                "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n\n"
                "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey, fontSize: 14),),
          ],
        ),
      ),
      floatingActionButton: customButton(context: context, onPressed: (){}, height: 60, width: size.width, text: "ADD TO CART"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Widget buildTitledRow({String title, String value}){
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),),
          SizedBox(height: 5,),
          Text(value, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
