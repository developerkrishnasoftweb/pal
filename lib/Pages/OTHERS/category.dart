import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Constant/color.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import '../../Common/appbar.dart';

class CategoryBuilder extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<CategoryBuilder> {
  List<CategoryItem> categoryItems = [];
  ShapeBorder shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
  @override
  void initState() {
    Services.category(FormData.fromMap({"api_key" : Urls.apiKey})).then((value) {
      if(value.response == "y"){
        for(int i = 0; i < value.data.length; i++){
          setState(() {
            categoryItems.add(
                CategoryItem(
                  title: value.data[i]["title"],
                  id: value.data[i]["id"],
                )
            );
          });
        }
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "By Category"),
      body: categoryItems.length != 0 ? SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            for(int i = 0; i < categoryItems.length; i++)...[
              categoryBuilder(categoryItems[i]),
            ],
          ],
        ),
      ) : Center(child: SizedBox(height: 40, width: 40, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),),),)
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
  final String id;
  final String image;
  final String promo;
  CategoryItem({this.title, this.id, this.image, this.promo});
}