import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pal/services/services.dart';
import '../../ui/widgets/appbar.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';

_CatalogPreviewState catalogPreviewState;

class CatalogPreview extends StatefulWidget {
  final String url;
  final bool adhaarView;

  CatalogPreview({@required this.url, this.adhaarView: false});

  @override
  _CatalogPreviewState createState() {
    catalogPreviewState = _CatalogPreviewState();
    return catalogPreviewState;
  }
}

class _CatalogPreviewState extends State<CatalogPreview> {
  String filePath = "";
  double downloadStatus = 0.0;
  String pageNo = "0/0";

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  loadPDF() async {
    String tempPath = await Services.loadPDF(pdfFile: widget.url);
    setState(() {
      filePath = tempPath;
    });
  }

  downloadProgress(received, total) {
    print(received.toString() + ' ' + total.toString());
    setState(() {
      downloadStatus = (total / received);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: appBar(
            context: context,
            title: widget.adhaarView
                ? "Adhaar View"
                : translate(context, LocaleStrings.catalogPreview),
            actions: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  pageNo,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ))
            ]),
        body: filePath.isNotEmpty
            ? PDFView(
                filePath: filePath,
                enableSwipe: true,
                fitEachPage: true,
                fitPolicy: FitPolicy.BOTH,
                pageFling: true,
                onPageChanged: _pageChanged,
              )
            : Center(
                child: Image.asset('assets/images/loader.gif', height: 100, width: 100,),
              ));
  }

  void _pageChanged(int page, int total) {
    setState(() {
      pageNo = (page + 1).toString() + "/" + total.toString();
    });
  }
}
