import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String mandatoryChar = "*";
const String lastNotificationId = "last_notification_id";

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
  static String membershipSeries = "membership_series";
  static String kyc = "kyc";
  static String userData = "userdata";
  static String adhaar = "adhaar";
  static String config = "config";
}

Future<void> userData(List<dynamic> data) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var password = sharedPreferences.getString(UserParams.password);
  if (password != null && password == data[0][UserParams.password]) {
    sharedPreferences.setString(UserParams.id, data[0][UserParams.id]);
    sharedPreferences.setString(UserParams.point, data[0][UserParams.point]);
    sharedPreferences.setString(
        UserParams.password, data[0][UserParams.password]);
    sharedPreferences.setString(UserParams.userData, jsonEncode(data));
  }
}

class Userdata {
  final String id,
      name,
      mobile,
      email,
      image,
      gender,
      password,
      status,
      point,
      token,
      memDetNo,
      branchName,
      address,
      pinCode,
      area,
      city,
      state,
      dob,
      maritalStatus,
      anniversary,
      altMobile,
      branchCode,
      totalOrder,
      membershipSeries,
      kyc,
      adhaar;
  Userdata(
      {this.maritalStatus,
      this.area,
      this.anniversary,
      this.altMobile,
      this.adhaar,
      this.address,
      this.state,
      this.city,
      this.pinCode,
      this.id,
      this.status,
      this.name,
      this.image,
      this.password,
      this.email,
      this.dob,
      this.branchCode,
      this.branchName,
      this.gender,
      this.kyc,
      this.membershipSeries,
      this.memDetNo,
      this.mobile,
      this.point,
      this.token,
      this.totalOrder});
}
