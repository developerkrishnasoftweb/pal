import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/appbar.dart';
import '../../common/custom_button.dart';
import '../../common/textinput.dart';
import '../../constant/color.dart';
import '../../constant/global.dart';
import '../../services/services.dart';


class TrackGift extends StatefulWidget {
  @override
  _TrackGiftState createState() => _TrackGiftState();
}

class _TrackGiftState extends State<TrackGift> {
  String trackNo = "", message = "";
  BookingInfo bookingInfo;
  bool isLoading = false, dataFound = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context: context, title: "Track Your Shipment"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            input(
                autoFocus: true,
                context: context,
                text: "Enter your shipment no  $mandatoryChar",
                onEditingComplete: _getDeliveryData,
                onChanged: (value) {
                  setState(() {
                    trackNo = value;
                  });
                }),
            SizedBox(
              height: 10,
            ),
            bookingInfo != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "BOOKING INFORMATION",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                            )),
                      ),
                      buildRow(
                          title: "document no", value: bookingInfo.documentNo),
                      buildRow(
                          title: "booking date",
                          value: bookingInfo.bookingDate),
                      buildRow(
                          title: "booking center",
                          value: bookingInfo.bookingCenter),
                      buildRow(title: "to center", value: bookingInfo.toCenter),
                      buildRow(title: "receiver", value: bookingInfo.receiver),
                      buildRow(
                          title: "booking type",
                          value: bookingInfo.bookingType),
                      buildRow(
                          title: "delivery type",
                          value: bookingInfo.deliveryDate),
                      buildRow(title: "status", value: bookingInfo.status),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: trackNo.isNotEmpty
          ? isLoading
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  ),
                )
              : customButton(
                  context: context,
                  onPressed: _getDeliveryData,
                  width: size.width,
                  text: "SEARCH")
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildRow({String title, String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase() ?? "-",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          Text(
            value != null && value != "" ? value : "-",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  _getDeliveryData() async {
    FocusScope.of(context).unfocus();
    if (trackNo.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await Services.trackBookingInfo(trackNo: trackNo).then((value) {
        if (value.response == "1") {
          setState(() {
            bookingInfo = BookingInfo(
                documentNo: value.data[0]["trackinginfo"]["DocumentNo"],
                status: "IN TRANSIT",
                bookingCenter: value.data[0]["trackinginfo"]["BookingCenter"],
                bookingDate: value.data[0]["trackinginfo"]["BookingDate"],
                bookingType: value.data[0]["trackinginfo"]["DocType"] +
                    " - " +
                    value.data[0]["trackinginfo"]["ServiceType"],
                deliveryDate: value.data[0]["trackinginfo"]["DeliveryDate"],
                receiver: value.data[0]["trackinginfo"]["ReceiverName"],
                toCenter: value.data[0]["trackinginfo"]["ToCenter"]);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            bookingInfo = null;
          });
          Fluttertoast.showToast(msg: value.message);
        }
      });
      Services.trackTravellingInfo(trackNo: trackNo).then((value) {
        if (value.response == "1") {
          Fluttertoast.showToast(msg: value.message);
        } else {
          Fluttertoast.showToast(msg: value.message);
        }
      });
      var dateMonth = bookingInfo.bookingDate.split(" ");
      int month = getMonthIndex(monthName: dateMonth.first);
      int date = int.parse(dateMonth.last.split(", ").first);
      int year = int.parse(dateMonth.last.split(", ").last);
    }
  }

  int getMonthIndex({String monthName}) {
    switch (monthName.toLowerCase()) {
      case "jan":
        return 1;
        break;
      case "feb":
        return 2;
        break;
      case "mar":
        return 3;
        break;
      case "apr":
        return 4;
        break;
      case "may":
        return 5;
        break;
      case "jun":
        return 6;
        break;
      case "jul":
        return 7;
        break;
      case "aug":
        return 8;
        break;
      case "sep":
        return 9;
        break;
      case "oct":
        return 10;
        break;
      case "nov":
        return 11;
        break;
      case "dec":
        return 12;
        break;
      default:
        return 1;
        break;
    }
  }
}

class BookingInfo {
  final String documentNo,
      bookingDate,
      bookingCenter,
      toCenter,
      receiver,
      bookingType,
      deliveryDate,
      status;
  BookingInfo(
      {this.documentNo,
      this.status,
      this.bookingCenter,
      this.bookingDate,
      this.bookingType,
      this.deliveryDate,
      this.receiver,
      this.toCenter});
}
