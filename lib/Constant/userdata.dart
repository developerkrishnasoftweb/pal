import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
      mobile;
  Userdata(
      {this.name : "N/A",
      this.alternateMobile : "N/A",
      this.pinCode : "N/A",
      this.area : "N/A",
      this.mobile : "N/A",
      this.city : "N/A",
      this.state : "N/A",
      this.address : "N/A"});
}
