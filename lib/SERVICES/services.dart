import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import '../Constant/userdata.dart';
import '../SERVICES/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/data.dart';
class Services{
  static String errorMessage = "Something went wrong !!!";

  static Future<Data> signIn(body) async{
    String url = Urls.baseUrl + Urls.signIn;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        if(jsonResponse["data"].length != 0){
          data.data = [jsonResponse["data"]];
        } else {
          data.data = [];
        }
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> signUp(body) async{
    String url = Urls.baseUrl + Urls.signUp;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
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
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> category(body) async{
    String url = Urls.baseUrl + Urls.category;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> gift(body) async{
    String url = Urls.baseUrl + Urls.gift;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> redeemedGifts(body) async{
    String url = Urls.baseUrl + Urls.redeemedGifts;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> banners(body) async{
    String url = Urls.baseUrl + Urls.banners;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> sms(body) async{
    try{
      dio.Response response;
      response = await dio.Dio().post(Urls.smsBaseUrl, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["ErrorMessage"];
        data.response = jsonResponse["ErrorCode"];
        data.data = jsonResponse["MessageData"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> giftCategory(body) async{
    String url = Urls.baseUrl + Urls.giftCategory;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> addComplain(body) async{
    String url = Urls.baseUrl + Urls.addComplain;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body,);
      Data data = Data();
      final jsonResponse = jsonDecode(response.toString());
      data.message = jsonResponse["message"];
      data.response = jsonResponse["status"];
      data.data = [jsonResponse["data"]];
      return data;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> serviceRequests(body) async{
    String url = Urls.baseUrl + Urls.getComplain;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> trackComplaint(body) async{
    String url = Urls.baseUrl + Urls.trackComplaint;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> redeemGift(body) async{
    String url = Urls.baseUrl + Urls.redeemGift;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = [jsonResponse["data"]];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> getUserData() async{
    String url = Urls.baseUrl + Urls.getUserData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString(UserParams.id);
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: dio.FormData.fromMap({"api_key" : Urls.apiKey, "id" : id}));
      if(response.statusCode == 200){
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
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> getPinData(String pinCode) async{
    String url = Urls.pinCodeData + pinCode;
    try{
      dio.Response response;
      response = await dio.Dio().get(url);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = response.data;
        data.message = jsonResponse[0]["Message"];
        data.response = jsonResponse[0]["Status"];
        data.data = jsonResponse[0]["PostOffice"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> forgotPassword(body) async{
    String url = Urls.baseUrl + Urls.forgotPassword;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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

  static Future<Data> getEarnedPoints(body) async{
    String url = Urls.baseUrl + Urls.getEarnedPoints;
    try{
      dio.Response response;
      response = await dio.Dio().post(url, data: body);
      if(response.statusCode == 200){
        Data data = Data();
        final jsonResponse = jsonDecode(response.data);
        data.message = jsonResponse["message"];
        data.response = jsonResponse["status"];
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
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
}