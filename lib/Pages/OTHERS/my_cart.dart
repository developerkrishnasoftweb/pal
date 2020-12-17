import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Constant/color.dart';

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
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16))),
            ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return Slidable(
                  child: Card(
                    elevation: 0.5,
                    child: ListTile(
                      leading: Image.network(
                        "https://s.aolcdn.com/dims-global/dims3/GLOB/legacy_thumbnail/360x200/quality/85/https://s.aolcdn.com/commerce/autodata/images/USD00MBCBJ3A021001.jpg",
                        height: 70,
                        width: 60,
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
                      title: Text("Wildcraft Shuttle Travel Bag"),
                      subtitle: Text(
                        "1000",
                        style: TextStyle(color: Colors.grey),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                          side: BorderSide(color: Colors.black)),
                      onTap: () {},
                    ),
                  ),
                  secondaryActions: [
                    Container(
                      height: 70,
                      child: customButton(context: context, onPressed: (){}, child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      )),
                    ),
                  ],
                  actionPane: SlidableScrollActionPane());
            })
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
