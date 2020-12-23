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

  /*
  * gift category Api
  * */
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

  /*
  * add category Api
  * */
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


  /*
  * get all requested services
  * */
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


  /*
  * get all requested services
  * */
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
}