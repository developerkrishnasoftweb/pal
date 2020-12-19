import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:pal/SERVICES/urls.dart';
import '../services/data.dart';
class Services{
  static String errorMessage = "Something went wrong !!!";
  /*
  * signIn Api
  * */
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
        List userData;
        if(jsonResponse["data"].length != 0){
          userData = [
            {
              "id" : jsonResponse["data"]["id"],
              "name" : jsonResponse["data"]["name"],
              "mobile" : jsonResponse["data"]["mobile"],
              "email" : jsonResponse["data"]["email"],
              "image" : jsonResponse["data"]["image"],
              "gender" : jsonResponse["data"]["gender"],
              "password" : jsonResponse["data"]["password"],
              "status" : jsonResponse["data"]["status"],
              "inserted" : jsonResponse["data"]["inserted"],
              "modified" : jsonResponse["data"]["modified"],
              "token" : jsonResponse["data"]["token"],
              "mem_det_no" : jsonResponse["data"]["mem_det_no"],
              "branch_name" : jsonResponse["data"]["branch_name"],
              "house_no" : jsonResponse["data"]["house_no"],
              "address" : jsonResponse["data"]["address"],
              "mem_det_no" : jsonResponse["data"]["mem_det_no"],
              "branch_code" : jsonResponse["data"]["branch_code"],
              "first_name" : jsonResponse["data"]["first_name"],
              "middle_name" : jsonResponse["data"]["middle_name"],
              "last_name" : jsonResponse["data"]["last_name"],
              "last_purchase" : jsonResponse["data"]["last_purchase"],
              "total_order" : jsonResponse["data"]["total_order"],
              "membership_series" : jsonResponse["data"]["membership_series"],
            }
          ];
        }
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

  /*
  * signUp Api
  * */
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
  /*
  * category Api
  * */
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

  /*
  * gift Api
  * */
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

  /*
  * banners Api
  * */
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

  /*
  * sms Api
  * */
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
}