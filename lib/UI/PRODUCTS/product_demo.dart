import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Common/page_route.dart';
import 'package:pal/Constant/color.dart';
import 'package:pal/UI/PRODUCTS/product_preview.dart';
import '../../SERVICES/services.dart';
import '../../SERVICES/urls.dart';
import '../../Common/appbar.dart';
import '../../Common/input_decoration.dart';
import '../../Common/textinput.dart';

class ProductDemo extends StatefulWidget {
  final String type;
  ProductDemo({@required this.type});
  @override
  _ProductDemoState createState() => _ProductDemoState();
}

class _ProductDemoState extends State<ProductDemo> {
  ShapeBorder shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
  List<ProductItem> categoryItems = [];
  bool dataFound = false;
  @override
  void initState() {
    getProducts();
    super.initState();
  }
  void getProducts() {
    FormData body = FormData.fromMap({
      "api_key" : Urls.apiKey,
      "type" : widget.type
    });
    Services.getProducts(body).then((value) {
      if(value.response == "y"){
        for(int i = 0; i < value.data.length; i++){
          setState(() {
            categoryItems.add(ProductItem(max: value.data[i]["max_price"], min: value.data[i]["min_price"], image: value.data[i]["image"], video: value.data[i]["promo"], id: value.data[i]["id"], name: value.data[i]["name"]));
          });
        }
      } else {
        setState(() {
          dataFound = true;
        });
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Product Demo"),
      body: Column(
        children: [
          input(context: context,
              padding: EdgeInsets.symmetric(horizontal: 25),
              decoration: InputDecoration(
                  border: border(),
                  hintText: "Search product...",
                  suffixIcon: Icon(Icons.search)
              )
          ),
          Expanded(
            child: categoryItems.length > 0 ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    for(int i = 0; i < categoryItems.length; i++)...[
                      categoryBuilder(categoryItems[i]),
                    ],
                  ],
                )
            ) : Center(child: dataFound ? Text("No products found !!!") : SizedBox(height: 30, width: 30, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),),),)
          )
        ],
      ),
    );
  }
  Widget categoryBuilder(ProductItem item){
    return Card(
      shape: shape,
      elevation: 0.3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        title: Text(item.name, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16, fontWeight: FontWeight.w500),),
        trailing: IconButton(icon: ImageIcon(AssetImage("assets/icons/play-button.png"), color: Colors.red,), onPressed: () => Navigator.push(context, CustomPageRoute(widget: ProductPreview(path: item.video,))), splashRadius: 25,),
        onTap: (){},
        shape: shape,
      ),
    );
  }
}
class ProductItem{
  final String name, video, image, id, min, max;
  ProductItem({this.name, this.min, this.max, this.image, this.id, this.video});
}