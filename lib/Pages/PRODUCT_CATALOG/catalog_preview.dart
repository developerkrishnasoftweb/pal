import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pal/SERVICES/urls.dart';
import '../../Common/appbar.dart';
import '../../Constant/color.dart';
import 'package:path_provider/path_provider.dart';

class CatalogPreview extends StatefulWidget {
  final String url;
  CatalogPreview({@required this.url});
  @override
  _CatalogPreviewState createState() => _CatalogPreviewState();
}

class _CatalogPreviewState extends State<CatalogPreview> {
  String filePath = "";
  String loaded = "0";
  String pageNo = "0/0";
  @override
  void initState() {
    loadPDF().then((value) {
      setState(() {
        filePath = value;
      });
    });
    super.initState();
  }

  Future<String> loadPDF() async {
    Dio dio = Dio();
    Response response = await dio.get(Urls.imageBaseUrl + widget.url, onReceiveProgress: showDownloadProgress, options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) { return status < 500; }
    ),);
    var dir = await getTemporaryDirectory();
    File file = new File(dir.path + "/data.pdf");
    await file.writeAsBytes(response.data, flush: true);
    return file.path;
  }
  void showDownloadProgress(received, total) {
    if (total != -1) {
      setState(() {
        loaded = (received / total * 100).toStringAsFixed(0);
      });
    } else {
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Catalog", actions: [Center(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(pageNo, style: TextStyle(fontWeight: FontWeight.bold),),
      ))]),
      body: filePath.isNotEmpty ? PDFView(
        filePath: filePath,
        enableSwipe: true,
        fitEachPage: true,
        fitPolicy: FitPolicy.BOTH,
        onError: (error){
          print(error);
        },
        pageFling: true,
        onPageChanged: _pageChanged,
      ) : Center(child: Container(
        height: 60,
        width: size.width * 0.6,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200],
              blurRadius: 3
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30, width: 30, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),),),
            SizedBox(width: 20,),
            Text(loaded + "/100% Please wait"),
          ],
        ),
      ),)
    );
  }

  void _pageChanged(int page, int total) {
    setState(() {
      pageNo = page.toString() + "/" + total.toString();
    });
  }
}
