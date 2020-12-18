import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Common/appbar.dart';
import 'package:pal/Common/custom_button.dart';
import 'package:pal/Common/input_decoration.dart';
import 'package:pal/Common/textinput.dart';
import 'package:barcode_scan/barcode_scan.dart';

class Complain extends StatefulWidget {
  @override
  _ComplainState createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  TextEditingController qrCodeTextField = TextEditingController();
  Future _scanQrCode() async {
    try{
      var result = await BarcodeScanner.scan();
      setState(() {
        qrCodeTextField.text = result.rawContent;
      });
    } on PlatformException catch(e) {
      if(e.code == BarcodeScanner.cameraAccessDenied){
        Fluttertoast.showToast(msg: "Permission Denied");
      } else {
        Fluttertoast.showToast(msg: "Something went wrong " + e.toString());
      }
    } on FormatException{
      Fluttertoast.showToast(msg: "Closed");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Complain"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 30, bottom: 100),
        child: Column(
          children: [
            customButton(
                context: context,
                onPressed: _scanQrCode,
                text: "Scan QR Code",
                color: Colors.grey[100],
                height: 70,
                textColor: Colors.black),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("OR", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),),
            ),
            input(context: context, text: "Enter QR Code", decoration: InputDecoration(border: border()), controller: qrCodeTextField),
            input(context: context, text: "Brief Description", decoration: InputDecoration(border: border()), maxLines: 5),
            SizedBox(height: 20,),
            attachButton(onPressed: (){}, text: "Attach Image"),
            SizedBox(height: 20,),
            attachButton(onPressed: (){}, text: "Attach Video"),
          ],
        ),
      ),
      floatingActionButton: customButton(
          context: context, onPressed: () {}, height: 60, text: "SUBMIT"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Widget attachButton({String text,  @required VoidCallback onPressed}){
    return customButton(
        context: context,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.attach_file, color: Colors.blue[500],),
            SizedBox(width: 10,),
            Text(text, style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.blue[500], fontWeight: FontWeight.bold),)
          ],
        ),
        color: Colors.grey[100],
        height: 70);
  }
}
