import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';

class CategoryBuilder extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<CategoryBuilder> {
  List<CategoryItem> categoryItems = [
    CategoryItem(title: "Cosmetic"),
    CategoryItem(title: "General Goods"),
    CategoryItem(title: "Grocery"),
    CategoryItem(title: "Kids Fashion"),
    CategoryItem(title: "Stylish and Casual Footwear"),
    CategoryItem(title: "Ladies Fashion"),
    CategoryItem(title: "Men's Fashion and Accessories"),
    CategoryItem(title: "Babies Section"),
    CategoryItem(title: "Home Furnishing"),
    CategoryItem(title: "Kitchen and cookwear"),
  ];
  ShapeBorder shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "By Category"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            for(int i = 0; i < categoryItems.length; i++)...[
              categoryBuilder(categoryItems[i]),
            ],
          ],
        ),
      ),
    );
  }
  Widget categoryBuilder(CategoryItem item){
    return Card(
      shape: shape,
      elevation: 0.3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        title: Text(item.title, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16, fontWeight: FontWeight.w500),),
        trailing: Icon(Icons.arrow_forward_ios, size: 15,),
        onTap: (){},
        shape: shape,
      ),
    );
  }
}
class CategoryItem{
  final String title;
  CategoryItem({this.title});
}