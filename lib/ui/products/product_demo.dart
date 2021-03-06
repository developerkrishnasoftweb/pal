import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import '../../ui/widgets/page_route.dart';
import '../../ui/widgets/textinput.dart';
import '../../constant/global.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../services/services.dart';
import '../../ui/products/product_preview.dart';


class ProductDemo extends StatefulWidget {
  final String type;
  ProductDemo({@required this.type});
  @override
  _ProductDemoState createState() => _ProductDemoState();
}

class _ProductDemoState extends State<ProductDemo> {
  ShapeBorder shape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
  List<ProductItem> categoryItems = [], searchedList = [];
  bool dataFound = false, searchedDataFound = false;
  @override
  void initState() {
    getProducts();
    super.initState();
  }

  void getProducts() async {
    FormData body =
        FormData.fromMap({"api_key": API_KEY, "type": widget.type});
    await Services.getProducts(body).then((value) {
      if (value.response == "y") {
        for (int i = 0; i < value.data.length; i++) {
          setState(() {
            categoryItems.add(ProductItem(
                max: value.data[i]["max_price"],
                min: value.data[i]["min_price"],
                image: value.data[i]["image"],
                video: value.data[i]["promo"],
                id: value.data[i]["id"],
                name: value.data[i]["name"]));
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

  _search(String keyword) {
    setState(() {
      searchedList.clear();
    });
    categoryItems.forEach((element) {
      if (element.name.toLowerCase().contains(keyword.toLowerCase())) {
        searchedList.add(element);
      }
    });
    if (keyword.isNotEmpty && searchedList.length == 0) {
      setState(() {
        searchedDataFound = true;
      });
    } else {
      setState(() {
        searchedDataFound = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: translate(context, LocaleStrings.productDemo)),
      body: Column(
        children: [
          input(
              context: context,
              onChanged: _search,
              decoration: InputDecoration(
                  border: border(),
                  contentPadding: EdgeInsets.all(10),
                  hintText: translate(context, LocaleStrings.searchProduct),
                  suffixIcon: Icon(Icons.search))),
          Expanded(
              child: searchedDataFound
                  ? Center(child: Text("No data found !!!"))
                  : searchedList.length > 0
                      ? SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            children: [
                              for (int i = 0; i < searchedList.length; i++) ...[
                                categoryBuilder(searchedList[i]),
                              ],
                            ],
                          ))
                      : categoryItems.length > 0
                          ? SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                children: [
                                  for (int i = 0;
                                      i < categoryItems.length;
                                      i++) ...[
                                    categoryBuilder(categoryItems[i]),
                                  ],
                                ],
                              ))
                          : Center(
                              child: dataFound
                                  ? Text("No products found !!!")
                                  : SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: circularProgressIndicator(),
                                    ),
                            ))
        ],
      ),
    );
  }

  Widget categoryBuilder(ProductItem item) {
    return Card(
      shape: shape,
      elevation: 0.3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        title: Text(
          item.name,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          icon: ImageIcon(
            AssetImage("assets/icons/play-button.png"),
            color: Colors.red,
          ),
          onPressed: () => Navigator.push(
              context,
              CustomPageRoute(
                  widget: ProductPreview(
                path: item.video,
              ))),
          splashRadius: 25,
        ),
        onTap: () {},
        shape: shape,
      ),
    );
  }
}

class ProductItem {
  final String name, video, image, id, min, max;
  ProductItem({this.name, this.min, this.max, this.image, this.id, this.video});
}
