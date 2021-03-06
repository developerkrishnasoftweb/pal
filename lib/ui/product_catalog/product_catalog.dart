import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/page_route.dart';
import '../../constant/global.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../services/services.dart';

import 'catalog_preview.dart';


class ProductCatalog extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductCatalog> {
  List<CategoryItem> categoryItems = [];
  ShapeBorder shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
  @override
  void initState() {
    Services.category(FormData.fromMap({"api_key" : API_KEY})).then((value) {
      if(value.response == "y"){
        for(int i = 0; i < value.data.length; i++){
          setState(() {
            categoryItems.add(
                CategoryItem(
                  title: value.data[i]["title"],
                  id: value.data[i]["id"],
                  catalog: value.data[i]["catalog"]
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
      appBar: appBar(context: context, title: translate(context, LocaleStrings.byCategory)),
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
      ) : Center(child: SizedBox(height: 40, width: 40, child: circularProgressIndicator()),)
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
        onTap: () {Navigator.push(context, CustomPageRoute(widget: CatalogPreview(url: item.catalog,)));},
        shape: shape,
      ),
    );
  }
}
class CategoryItem{
  final String title;
  final String id;
  final String catalog;
  final String promo;
  CategoryItem({this.title, this.id, this.catalog, this.promo});
}