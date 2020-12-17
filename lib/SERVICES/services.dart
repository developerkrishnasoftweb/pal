import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import '../services/urls.dart';
import '../services/data.dart';
class Services{
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
        Data data = Data(message: "Something went wrong !!!", response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: "Something went wrong.", response: null, data: null);
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
        data.data = jsonResponse["data"];
        return data;
      }
      return null;
    } on dio.DioError catch (e) {
      if(dio.DioErrorType.DEFAULT == e.type){
        Data data = Data(message: "No internet connection !!!", response: null, data: null);
        return data;
      } else {
        Data data = Data(message: e.toString(), response: null, data: null);
        return data;
      }
    } catch (e) {
      Data data = Data(message: e.toString(), response: null, data: null);
      return data;
    }
  }
}