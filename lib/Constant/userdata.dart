import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserParams {
  static String id = "id";
  static String name = "name";
  static String mobile = "mobile";
  static String email = "email";
  static String gender = "gender";
  static String image = "image";
  static String status = "status";
  static String point = "point";
  static String token = "token";
  static String password = "password";
  static String memDetNo = "mem_det_no";
  static String branchName = "branch_name";
  static String address = "address";
  static String pinCode = "pincode";
  static String area = "area";
  static String city = "city";
  static String state = "state";
  static String dob = "dob";
  static String maritalStatus = "marital_status";
  static String anniversary = "anniversary";
  static String altMobile = "alt_mobile";
  static String branchCode = "branch_code";
  static String totalOrder = "total_order";
  // static String purchase = "purchase";
  static String membershipSeries = "membership_series";
  static String kyc = "kyc";
  static String userData = "userdata";
  static String lastNotificationId = "last_notification_id";
  static String config = "config";
}

Future<void> userData(List<dynamic> data) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(UserParams.id, data[0][UserParams.id]);
  sharedPreferences.setString(UserParams.point, data[0][UserParams.point]);
  sharedPreferences.setString(
      UserParams.password, data[0][UserParams.password]);
  sharedPreferences.setString(UserParams.userData, jsonEncode(data));
}

class Userdata {
  final String name,
      alternateMobile,
      address,
      state,
      city,
      area,
      pinCode,
      gender,
      maritalStatus,
      anniversaryDate,
      dob,
      email,
      image,
      mobile;
  Userdata(
      {this.name,
      this.alternateMobile,
      this.pinCode,
      this.area,
      this.mobile,
      this.city,
      this.state,
      this.gender,
      this.anniversaryDate,
      this.maritalStatus,
      this.dob,
      this.email,
      this.image,
      this.address});
}
