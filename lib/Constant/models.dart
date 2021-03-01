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
  static String lastNotificationId = "lastNotificationId";
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
  Userdata.fromJSON(Map<String, dynamic> json) : id = json[UserParams.id],
        name = json[UserParams.name],
        mobile = json[UserParams.mobile],
        email = json[UserParams.email],
        image = json[UserParams.image],
        gender = json[UserParams.gender],
        password = json[UserParams.password],
        status = json[UserParams.status],
        point = json[UserParams.point],
        token = json[UserParams.token],
        memDetNo = json[UserParams.memDetNo],
        branchName = json[UserParams.branchName],
        address = json[UserParams.address],
        pinCode = json[UserParams.pinCode],
        area = json[UserParams.area],
        city = json[UserParams.city],
        state = json[UserParams.state],
        dob = json[UserParams.dob],
        maritalStatus = json[UserParams.maritalStatus],
        anniversary = json[UserParams.anniversary],
        altMobile = json[UserParams.altMobile],
        branchCode = json[UserParams.branchCode],
        totalOrder = json[UserParams.totalOrder],
        membershipSeries = json[UserParams.membershipSeries],
        kyc = json[UserParams.kyc],
        vehicleType = json[UserParams.vehicleType],
        adhaar = json[UserParams.adhaar];
}

class Config {
  final String title,
      logo,
      contact,
      whatsAppNumber,
      email,
      copyright,
      about,
      apkLink,
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
        this.whatsAppNumber,
        this.email,
        this.copyright,
        this.about,
        this.apkLink,
        this.terms,
        this.termsTitle,
        this.razorPayKey,
        this.razorPaySecretKey,
        this.smsUserName,
        this.smsPassword,
        this.smsSenderId,
        this.smsFL,
        this.smsGwID});

  Config.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        logo = json['logo'],
        contact = json['contact'],
        whatsAppNumber = json['whatsapp_number'],
        email = json['email'],
        copyright = json['copyright'],
        about = json['about'],
        apkLink = json['apk_link'],
        terms = json['terms'],
        termsTitle = json['terms_title'],
        razorPayKey = json['razorpay_key'],
        razorPaySecretKey = json['razorpay_secret_key'],
        smsUserName = json['sms_username'],
        smsPassword = json['sms_password'],
        smsSenderId = json['sms_sender_id'],
        smsFL = json['sms_fl'],
        smsGwID = json['sms_gwid'];
}

class GiftData {
  final String specs, rating, points, desc, image, title, id;
  GiftData(
      {this.id,
      this.title,
      this.image,
      this.points,
      this.desc,
      this.specs,
      this.rating});
}