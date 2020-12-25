import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../Common/appbar.dart';

class EarnedPoints extends StatefulWidget {
  @override
  _EarnedPointsState createState() => _EarnedPointsState();
}

class _EarnedPointsState extends State<EarnedPoints> {
  String lastCycles = "Last 12 Cycles";
  List<EarnedPoints> earnedLists = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Earned Point"),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 20,
              ),
              buildRedeemedAmount(
                  title: "User Name : ",
                  amount: "Pal General Store (134312)",
                  leadingTrailing: false,
                  fontSize: 17),
              SizedBox(
                height: 10,
              ),
              buildRedeemedAmount(
                  title: "Cumulative Purchase : ",
                  amount: "394230.00",
                  leadingTrailing: true),
              SizedBox(height: 10,),
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
                  borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButton(
                  isExpanded: true,
                  onChanged: (value){
                    setState(() {
                      lastCycles = value;
                    });
                  },
                  underline: SizedBox.shrink(),
                  value: lastCycles,
                  items: ["Show all cycles", "Last 12 Cycles", "Last 24 Cycles", "Last 36 Cycles", "Last 48 Cycles", "Last 60 Cycles"].map((text) {
                    return DropdownMenuItem(
                      value: text,
                      child: Text(text),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10,),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index){
                  return buildCard();
                })
            ],
          ),
        )
    );
  }

  Widget buildCard(){
    Size size = MediaQuery.of(context).size;
    TextStyle style = Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15);
    TextStyle style1 = Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 15);
    TextStyle style2 = Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13);
    return Container(
      height: 180,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200],
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Cycle No.: 52", style: style2,),
              Text("30 Nov - 27 Dec", style: style2,),
            ],
          ),
          SizedBox(height: 10,),
          Text("Purchase for this cycle : 3585", style: style1),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * 0.4,
                child: RichText(
                  text: TextSpan(
                      text: "Earned Point : ",
                      style: style1,
                      children: [
                        TextSpan(
                            text: "973.93",
                            style: style
                        )
                      ]
                  ),
                ),
              ),
              Container(
                width: size.width * 0.4,
                child: RichText(
                  text: TextSpan(
                      text: "Closing Point : ",
                      style: style1,
                      children: [
                        TextSpan(
                            text: "1925.6",
                            style: style
                        )
                      ]
                  ),
                ),
              )
            ],
          )
        ],
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
class CycleData{
  final String cycleNo, dateFrom, dateTo, purchase, earnedPoints, closingPoints;
  CycleData({this.closingPoints, this.cycleNo, this.dateFrom, this.dateTo, this.earnedPoints, this.purchase});
}