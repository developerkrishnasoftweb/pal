import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/ui/product_catalog/catalog_preview.dart';
import 'package:path_provider/path_provider.dart';
import '../constant/global.dart';
import '../constant/models.dart';

import '../main.dart';
import 'data.dart';
import 'urls.dart';

class Services {
  static Data internetError =
      Data(message: "No internet connection", response: null, data: null);
  static Data someThingWentWrong = Data(
      message: "Something went wrong, please try later",
      response: null,
      data: null);

  static Future<Data> signIn(body) async {
    String url = Urls.baseUrl + Urls.signIn;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      final jsonResponse = jsonDecode(response.data);
      Data data = Data();
      if (response.statusCode == 200) {
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      print(e);
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      print(e);
      return someThingWentWrong;
    }
  }

  static Future<Data> signUp(body) async {
    String url = Urls.baseUrl + Urls.signUp;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        List userData;
        userData = [{}];
        data.data = userData;
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> category(body) async {
    String url = Urls.baseUrl + Urls.category;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> gift(body, {String departmentId}) async {
    String url = Urls.baseUrl + Urls.gift + "/$departmentId";
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        throw (e);
        return someThingWentWrong;
      }
    } catch (e) {
      throw (e);
      return someThingWentWrong;
    }
  }

  static Future<Data> redeemedGifts(body) async {
    String url = Urls.baseUrl + Urls.redeemedGifts;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> productReview(body) async {
    String url = Urls.baseUrl + Urls.productReview;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> banners(body) async {
    String url = Urls.baseUrl + Urls.banners;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> sms(String message, String mobile,
      {Map<String, dynamic> body}) async {
    try {
      dio.Response response = await dio.Dio().get(Urls.smsBaseUrl +
          "?SenderId=PALDEP&Is_Unicode=false&MobileNumbers=$mobile&ClientId=54a91a69-16cd-4dac-a172-760ba08698b4&Message=${Uri.encodeComponent(message)}&ApiKey=bPkxFrI7mIoLuY8kfWJlR7JqmVPNVA41PGtnB%2F6tEoE%3D");
      if (response.statusCode == 200) {
        Data data = Data();
        data.message = response.data["ErrorDescription"];
        data.response = response.data["ErrorCode"].toString();
        data.data = response.data["Data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        print(e);
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> giftCategory(body) async {
    String url = Urls.baseUrl + Urls.giftCategory;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> addComplain(body) async {
    String url = Urls.baseUrl + Urls.addComplain;
    try {
      dio.Response response = await dio.Dio().post(
        url,
        data: body,
      );
      Data data = Data();
      final jsonResponse = jsonDecode(response.toString());
      if (response.statusCode == 200) {
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> serviceRequests(body) async {
    String url = Urls.baseUrl + Urls.getComplain;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> trackComplaint(body) async {
    String url = Urls.baseUrl + Urls.trackComplaint;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> redeemGift(dio.FormData body) async {
    String url = Urls.baseUrl + Urls.redeemGift;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        print(e);
        return internetError;
      } else {
        print(e);
        throw (e);
        return someThingWentWrong;
      }
    } catch (e) {
      print(e);
      throw (e);
      return someThingWentWrong;
    }
  }

  static Future<Data> getUserData() async {
    String url = Urls.baseUrl + Urls.getUserData;
    try {
      dio.Response response = await dio.Dio().post(url,
          data: dio.FormData.fromMap({"api_key": API_KEY, "id": userdata.id}));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.data);
        Data data = Data();
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        if (data.response == "y") {
          await sharedPreferences.setString(
              UserParams.userData, jsonEncode(data.data));
          await setData();
        }
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> getPinData(String pinCode) async {
    String url = Urls.pinCodeData + pinCode;
    try {
      dio.Response response = await dio.Dio().get(url);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = response.data;
        data.message = jsonResponse[0]["Message"];
        data.response = jsonResponse[0]["Status"];
        data.data = jsonResponse[0]["PostOffice"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> forgotPassword(body) async {
    String url = Urls.baseUrl + Urls.forgotPassword;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> getEarnedPoints(body) async {
    String url = Urls.baseUrl + Urls.getEarnedPoints;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<void> getCycle() async {
    String url = Urls.baseUrl + Urls.getCycles;
    try {
      dio.Response response = await dio.Dio()
          .post(url, data: dio.FormData.fromMap({"api_key": API_KEY}));
      if (response.statusCode == 200) {
        return true;
      }
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
      } else {}
    } catch (e) {}
  }

  static Future<Data> getProducts(body) async {
    String url = Urls.baseUrl + Urls.getProducts;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> customerKYC(body) async {
    String url = Urls.baseUrl + Urls.customerKYC;
    try {
      dio.Response response = await dio.Dio().post(url, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        print(e);
        return someThingWentWrong;
      }
    } catch (e) {
      print(e);
      return someThingWentWrong;
    }
  }

  static Future<String> getNotificationCount() async {
    if (userdata != null) {
      String lastNotification =
          sharedPreferences.getString(lastNotificationId) != null
              ? sharedPreferences.getString(lastNotificationId)
              : "0";
      if (userdata.id != null && userdata.id.isNotEmpty) {
        String url = Urls.baseUrl +
            Urls.getNotificationCount +
            lastNotification +
            "/" +
            userdata.id;
        try {
          dio.Response response = await dio.Dio()
              .post(url, data: dio.FormData.fromMap({"api_key": API_KEY}));
          if (response.statusCode == 200) {
            final jsonResponse = [jsonDecode(response.data)];
            return jsonResponse[0]["count"].toString();
          }
          return null;
        } on dio.DioError catch (e) {
          if (dio.DioErrorType.DEFAULT == e.type &&
              e.error.runtimeType == SocketException) {
            return "0";
          } else {
            return "0";
          }
        } catch (e) {
          return "0";
        }
      } else {
        return "0";
      }
    } else
      return "0";
  }

  static Future<Data> getNotifications() async {
    String url = Urls.baseUrl + Urls.getNotifications + userdata.id;
    try {
      dio.Response response = await dio.Dio()
          .post(url, data: dio.FormData.fromMap({"api_key": API_KEY}));
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> getStores() async {
    String url = Urls.baseUrl + Urls.getStores;
    try {
      dio.Response response = await dio.Dio()
          .post(url, data: dio.FormData.fromMap({"api_key": API_KEY}));
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<bool> syncCustomerPurchase() async {
    if (userdata?.id != null) {
      String url = Urls.baseUrl + Urls.syncCustomerPurchase + userdata.id;
      try {
        dio.Response response = await dio.Dio()
            .post(url, data: dio.FormData.fromMap({"api_key": API_KEY}));
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } on dio.DioError catch (e) {
        if (dio.DioErrorType.DEFAULT == e.type &&
            e.error.runtimeType == SocketException) {
          throw (e);
        } else {
          throw (e);
        }
      } catch (e) {
        throw (e);
      }
    } else {
      return false;
    }
  }

  static Future<void> getConfig() async {
    String url = Urls.baseUrl + Urls.getConfig;
    try {
      dio.Response response = await dio.Dio()
          .post(url, data: dio.FormData.fromMap({"api_key": API_KEY}));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.data);
        if (jsonResponse["status"] == 'y') {
          config = Config.fromJson(jsonResponse["data"]);
        }
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        Fluttertoast.showToast(msg: "No internet connection");
      } else {
        throw (e);
      }
    } catch (e) {
      throw (e);
    }
  }

  static Future<Data> getReports() async {
    String url = Urls.baseUrl + Urls.getReports;
    try {
      dio.Response response = await dio.Dio().post(url,
          data: dio.FormData.fromMap(
              {"api_key": API_KEY, "customer_id": userdata.id}));
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> rateApp({String rate, String message}) async {
    String url = Urls.baseUrl + Urls.appRate;
    try {
      dio.Response response = await dio.Dio().post(url,
          data: dio.FormData.fromMap({
            "api_key": API_KEY,
            "customer_id": userdata.id,
            "rate": rate,
            "comment": message
          }));
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  static Future<Data> weeklyReport() async {
    String url = Urls.baseUrl + Urls.weeklyReport;
    try {
      dio.Response response = await dio.Dio().post(url,
          data: dio.FormData.fromMap(
              {"api_key": API_KEY, "customer_id": userdata.id}));
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        return internetError;
      } else {
        return someThingWentWrong;
      }
    } catch (e) {
      return someThingWentWrong;
    }
  }

  /* static Future<Data> trackBooking({String trackNo}) async {
    var headers = {
      'Content-Type': 'text/plain',
      'Username': 'maruticourier',
      'Password': '17322463b3e529f1ee3184444b7e0d61',
      'TOKEN': 'ABX78952-081E-41D4-8C86-FB410EF83123',
    };
    try {
      var request = http.Request('POST', Uri.parse(Urls.trackGiftBaseUrl));
      request.body = jsonEncode({"data": {"barcode_no":"$trackNo", "type":"booking"}});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(await response.stream.bytesToString());
        data.message = jsonResponse["message"];
        data.response = jsonResponse["success"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      print(e);
      if (dio.DioErrorType.DEFAULT == e.type && e.error.runtimeType == SocketException) {
        print(e);
        return internetError;
      } else {
        print(e);
        return someThingWentWrong;
      }
    } catch (e) {
      print(e);
      return someThingWentWrong;
    }
  } */

  static Future<Data> trackBookingInfo({String trackNo}) async {
    var headers = {
      'Content-Type': 'text/plain',
      'Username': 'maruticourier',
      'Password': '17322463b3e529f1ee3184444b7e0d61',
      'TOKEN': 'ABX78952-081E-41D4-8C86-FB410EF83123',
    };
    try {
      dio.Response response = await dio.Dio().post(Urls.trackGiftBaseUrl,
          data: jsonEncode({
            "data": {"barcode_no": "$trackNo", "type": "booking"}
          }),
          options: dio.Options(headers: headers));
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["success"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      print(e);
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        print(e);
        return internetError;
      } else {
        print(e);
        return someThingWentWrong;
      }
    } catch (e) {
      print(e);
      return someThingWentWrong;
    }
  }

  static Future<Data> trackTravellingInfo({String trackNo}) async {
    var headers = {
      'Content-Type': 'text/plain',
      'Username': 'maruticourier',
      'Password': '17322463b3e529f1ee3184444b7e0d61',
      'TOKEN': 'ABX78952-081E-41D4-8C86-FB410EF83123',
    };
    try {
      dio.Response response = await dio.Dio().post(Urls.trackGiftBaseUrl,
          data: jsonEncode({
            "data": {"barcode_no": "$trackNo", "type": "traveling"}
          }),
          options: dio.Options(headers: headers));
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["success"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      print(e);
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        print(e);
        return internetError;
      } else {
        print(e);
        return someThingWentWrong;
      }
    } catch (e) {
      print(e);
      return someThingWentWrong;
    }
  }

  static Future<Data> trackDeliveryInfo(
      {String trackNo, String bookingDate}) async {
    var headers = {
      'Content-Type': 'text/plain',
      'Username': 'maruticourier',
      'Password': '17322463b3e529f1ee3184444b7e0d61',
      'TOKEN': 'ABX78952-081E-41D4-8C86-FB410EF83123',
    };
    try {
      dio.Response response = await dio.Dio().post(Urls.trackGiftBaseUrl,
          data: jsonEncode({
            "data": {
              "barcode_no": "$trackNo",
              "type": "delivery",
              "booking_date": "$bookingDate"
            }
          }),
          options: dio.Options(headers: headers));
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["success"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      print(e);
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        print(e);
        return internetError;
      } else {
        print(e);
        return someThingWentWrong;
      }
    } catch (e) {
      print(e);
      return someThingWentWrong;
    }
  }

  static Future<bool> checkUsersPurchase(
      {String mobile, String fromDate, String toDate}) async {
    try {
      dio.Response response = await dio.Dio().get(Urls.checkUsersPurchaseBPGS +
          "?MobileNo=$mobile&FromDate=$fromDate&ToDate=$toDate");
      dio.Response response1;
      response1 = await dio.Dio().get(Urls.checkUsersPurchaseBPGN +
          "?MobileNo=$mobile&FromDate=$fromDate&ToDate=$toDate");
      if (response.statusCode == 200 && response1.statusCode == 200) {
        if (response.data.length != 0 || response1.data.length != 0) {
          return true;
        } else {
          return false;
        }
      }
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type &&
          e.error.runtimeType == SocketException) {
        Fluttertoast.showToast(msg: "No internet connection !!!");
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<String> loadPDF({@required String pdfFile}) async {
    var dir = await getTemporaryDirectory();
    var path = dir.path + pdfFile.split("/").last;
    if (await File(path).exists()) return path;
    dio.Response response = await dio.Dio().get(Urls.imageBaseUrl + pdfFile,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
        onReceiveProgress: catalogPreviewState.downloadProgress);
    File file = new File(path);
    await file.writeAsBytes(response.data, flush: true);
    return file.path;
  }
}
