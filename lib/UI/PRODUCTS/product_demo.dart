import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../Common/page_route.dart';
import '../../Pages/PRODUCTS/product_preview.dart';
import '../../Common/appbar.dart';
import '../../Common/input_decoration.dart';
import '../../Common/textinput.dart';

class ProductDemo extends StatefulWidget {
  @override
  _ProductDemoState createState() => _ProductDemoState();
}

class _ProductDemoState extends State<ProductDemo> {
  ShapeBorder shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
  List<ProductItem> categoryItems = [
    ProductItem(title: "Bajaj Calenta Digi 25L (150764)"),
    ProductItem(title: "Bajaj Calenta 6L (150765)"),
    ProductItem(title: "Shakti PC Deluxe 25L (150772)"),
    ProductItem(title: "Majesty One Dry iron (150772)"),
    ProductItem(title: "Ebony Concave Griddle 26cm with lb (IECG26)"),
  ];
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
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    for(int i = 0; i < categoryItems.length; i++)...[
                      categoryBuilder(categoryItems[i]),
                    ],
                  ],
                )
            ),
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
        title: Text(item.title, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16, fontWeight: FontWeight.w500),),
        trailing: IconButton(icon: ImageIcon(AssetImage("assets/icons/play-button.png"), color: Colors.red,), onPressed: () => Navigator.push(context, CustomPageRoute(widget: ProductPreview())), splashRadius: 25,),
        onTap: (){},
        shape: shape,
      ),
    );
  }
}
class ProductItem{
  final String title;
  ProductItem({this.title});
}