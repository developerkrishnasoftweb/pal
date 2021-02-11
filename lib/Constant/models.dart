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
  static String vehicleType = "vehicle_type";
  static String adhaar = "adhaar";
  static String config = "config";
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
      vehicleType,
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
      this.vehicleType,
      this.totalOrder});
}

class Config {
  final String title,
      logo,
      contact,
      email,
      copyright,
      about,
      terms,
      termsTitle,
      razorPayKey,
      razorPaySecretKey,
      smsUserName,
      smsPassword,
      smsSenderId,
      smsFL,
      smsGwID;

  Config(
      {this.title,
      this.logo,
      this.contact,
      this.email,
      this.copyright,
      this.about,
      this.terms,
      this.termsTitle,
      this.razorPayKey,
      this.razorPaySecretKey,
      this.smsUserName,
      this.smsPassword,
      this.smsSenderId,
      this.smsFL,
      this.smsGwID});
}
