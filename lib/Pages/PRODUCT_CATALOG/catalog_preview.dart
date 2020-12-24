import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/show_dialog.dart';
import 'package:pal/Constant/color.dart';
import 'package:path_provider/path_provider.dart';

class CatalogPreview extends StatefulWidget {
  final String url;
  CatalogPreview({this.url});
  @override
  _CatalogPreviewState createState() => _CatalogPreviewState();
}

class _CatalogPreviewState extends State<CatalogPreview> {
  String filePath = "";
  String loaded = "";
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
    Response response = await dio.get("http://generalstore.krishnasoftweb.com/assets/catalog/20201224163212.pdf", onReceiveProgress: showDownloadProgress, options: Options(
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
    print(filePath);
    return Scaffold(
      appBar: appBar(context: context, title: "Catalog"),
      body: filePath.isNotEmpty ? PDFView(
        filePath: filePath,
        enableSwipe: true,
        fitEachPage: true,
        fitPolicy: FitPolicy.BOTH,
        swipeHorizontal: true,
      ) : null
    );
  }
}
