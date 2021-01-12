import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../Constant/userdata.dart';
import '../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/data.dart';

class Services {
  static String errorMessage = "Something went wrong !!!";

  static Future<Data> signIn(body) async {
    String url = Urls.baseUrl + Urls.signIn;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      print(e);
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> signUp(body) async {
    String url = Urls.baseUrl + Urls.signUp;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> category(body) async {
    String url = Urls.baseUrl + Urls.category;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> gift(body) async {
    String url = Urls.baseUrl + Urls.gift;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> redeemedGifts(body) async {
    String url = Urls.baseUrl + Urls.redeemedGifts;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> productReview(body) async {
    String url = Urls.baseUrl + Urls.productReview;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> banners(body) async {
    String url = Urls.baseUrl + Urls.banners;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> sms(body) async {
    try {
      dio.Response response;
      response = await dio.Dio().post(Urls.smsBaseUrl, data: body);
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["ErrorMessage"];
        data.response = jsonResponse["ErrorCode"];
        data.data = jsonResponse["MessageData"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> giftCategory(body) async {
    String url = Urls.baseUrl + Urls.giftCategory;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> addComplain(body) async {
    String url = Urls.baseUrl + Urls.addComplain;
    try {
      dio.Response response;
      response = await dio.Dio().post(
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> serviceRequests(body) async {
    String url = Urls.baseUrl + Urls.getComplain;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> trackComplaint(body) async {
    String url = Urls.baseUrl + Urls.trackComplaint;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> redeemGift(dio.FormData body) async {
    String url = Urls.baseUrl + Urls.redeemGift;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> getUserData() async {
    String url = Urls.baseUrl + Urls.getUserData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString(UserParams.id);
    try {
      dio.Response response;
      response = await dio.Dio().post(url,
          data: dio.FormData.fromMap({"api_key": Urls.apiKey, "id": id}));
      if (response.statusCode == 200) {
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        await userData(data.data);
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> getPinData(String pinCode) async {
    String url = Urls.pinCodeData + pinCode;
    try {
      dio.Response response;
      response = await dio.Dio().get(url);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> forgotPassword(body) async {
    String url = Urls.baseUrl + Urls.forgotPassword;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> getEarnedPoints(body) async {
    String url = Urls.baseUrl + Urls.getEarnedPoints;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<void> getCycle() async {
    String url = Urls.baseUrl + Urls.getCycles;
    try {
      dio.Response response;
      response = await dio.Dio()
          .post(url, data: dio.FormData.fromMap({"api_key": Urls.apiKey}));
      if (response.statusCode == 200) {
        return true;
      }
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type) {
      } else {}
    } catch (e) {}
  }

  static Future<Data> getProducts(body) async {
    String url = Urls.baseUrl + Urls.getProducts;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> customerKYC(body) async {
    String url = Urls.baseUrl + Urls.customerKYC;
    try {
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<String> getNotificationCount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String lastNotificationId =
        sharedPreferences.getString(UserParams.lastNotificationId) != null
            ? sharedPreferences.getString(UserParams.lastNotificationId)
            : "0";
    String customerId = sharedPreferences.getString(UserParams.id);
    if(customerId != null && customerId.isNotEmpty) {
      String url = Urls.baseUrl +
          Urls.getNotificationCount +
          lastNotificationId +
          "/" +
          customerId;
      try {
        dio.Response response;
        response = await dio.Dio()
            .post(url, data: dio.FormData.fromMap({"api_key": Urls.apiKey}));
        if (response.statusCode == 200) {
          final jsonResponse = [jsonDecode(response.data)];
          return jsonResponse[0]["count"].toString();
        }
        return null;
      } on dio.DioError catch (e) {
        if (dio.DioErrorType.DEFAULT == e.type) {
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

  }

  static Future<Data> getNotifications() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String customerId = sharedPreferences.getString(UserParams.id);
    String url = Urls.baseUrl + Urls.getNotifications + customerId;
    try {
      dio.Response response;
      response = await dio.Dio()
          .post(url, data: dio.FormData.fromMap({"api_key": Urls.apiKey}));
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> getStores() async {
    String url = Urls.baseUrl + Urls.getStores;
    try {
      dio.Response response;
      response = await dio.Dio()
          .post(url, data: dio.FormData.fromMap({"api_key": Urls.apiKey}));
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static void getConfig() async {
    String url = Urls.baseUrl + Urls.getConfig;
    try {
      dio.Response response;
      response = await dio.Dio()
          .post(url, data: dio.FormData.fromMap({"api_key": Urls.apiKey}));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.data);
        final data = [jsonResponse["data"]];
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(UserParams.config, jsonEncode(data));
      }
      return null;
    } on dio.DioError catch (e) {
      if (dio.DioErrorType.DEFAULT == e.type) {
        Fluttertoast.showToast(msg: "No internet connection");
      } else {}
    } catch (e) {}
  }

  static Future<Data> getReports() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String customerId = sharedPreferences.getString(UserParams.id);
    String url = Urls.baseUrl + Urls.getReports;
    try {
      dio.Response response;
      response = await dio.Dio().post(url,
          data: dio.FormData.fromMap(
              {"api_key": Urls.apiKey, "customer_id": customerId}));
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> rateApp({String rate, String message}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String customerId = sharedPreferences.getString(UserParams.id);
    String url = Urls.baseUrl + Urls.appRate;
    try {
      dio.Response response;
      response = await dio.Dio().post(url,
          data: dio.FormData.fromMap(
              {"api_key": Urls.apiKey, "customer_id": customerId, "rate" : rate, "comment" : message}));
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> weeklyReport() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String customerId = sharedPreferences.getString(UserParams.id);
    String url = Urls.baseUrl + Urls.weeklyReport;
    try {
      dio.Response response;
      response = await dio.Dio().post(url,
          data: dio.FormData.fromMap(
              {"api_key": Urls.apiKey, "customer_id": customerId}));
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        print(e);
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        print(e);
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      print(e);
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        print(e);
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        print(e);
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      print(e);
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        print(e);
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        print(e);
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      print(e);
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<Data> trackDeliveryInfo({String trackNo, String bookingDate}) async {
    var headers = {
      'Content-Type': 'text/plain',
      'Username': 'maruticourier',
      'Password': '17322463b3e529f1ee3184444b7e0d61',
      'TOKEN': 'ABX78952-081E-41D4-8C86-FB410EF83123',
    };
    try {
      dio.Response response = await dio.Dio().post(Urls.trackGiftBaseUrl,
          data: jsonEncode({
            "data": {"barcode_no": "$trackNo", "type": "delivery", "booking_date" : "$bookingDate"}
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        print(e);
        Data data = Data(
            message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        print(e);
        Data data = Data(message: errorMessage, response: null, data: null);
        return data;
      }
    } catch (e) {
      print(e);
      Data data = Data(message: errorMessage, response: null, data: null);
      return data;
    }
  }

  static Future<bool> checkUsersPurchase(
      {String mobile, String fromDate, String toDate}) async {
    try {
      dio.Response response;
      response = await dio.Dio().get(Urls.checkUsersPurchaseBPGS +
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
      if (dio.DioErrorType.DEFAULT == e.type) {
        Fluttertoast.showToast(msg: "No internet connection !!!");
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
