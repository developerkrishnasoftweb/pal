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
  static String customerId = "customer_id";
  static String referralCode = "referral_code";
  static String referId = "refer_id";
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
      adhaar,
      referralCode,
      customerId,
      referId;

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
      this.totalOrder,
      this.referralCode,
      this.customerId,
      this.referId});

  Userdata.fromJSON(Map<String, dynamic> json)
      : id = json[UserParams.id],
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
        adhaar = json[UserParams.adhaar],
        customerId = json[UserParams.customerId],
        referralCode = json[UserParams.referralCode],
        referId = json[UserParams.referId];
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
      websiteLink,
      terms,
      termsTitle,
      razorPayKey,
      razorPaySecretKey,
      smsUserName,
      smsPassword,
      smsSenderId,
      smsFL,
      customerVersion,
      agentVersion,
      smsGwID,
      referralStatus;

  Config(
      {this.title,
      this.logo,
      this.contact,
      this.whatsAppNumber,
      this.email,
      this.copyright,
      this.about,
      this.apkLink,
      this.websiteLink,
      this.terms,
      this.termsTitle,
      this.razorPayKey,
      this.razorPaySecretKey,
      this.smsUserName,
      this.smsPassword,
      this.smsSenderId,
      this.smsFL,
      this.customerVersion,
      this.agentVersion,
      this.smsGwID,
      this.referralStatus});

  Config.fromJson(Map<String, dynamic> json)
      : title = json['title'].toString(),
        logo = json['logo'].toString(),
        contact = json['contact'].toString(),
        whatsAppNumber = json['whatsapp_number'].toString(),
        email = json['email'].toString(),
        copyright = json['copyright'].toString(),
        about = json['about'].toString(),
        apkLink = json['apk_link'] ?? "",
        websiteLink = json['web_link'] ?? "",
        terms = json['terms'].toString(),
        termsTitle = json['terms_title'].toString(),
        razorPayKey = json['razorpay_key'].toString(),
        razorPaySecretKey = json['razorpay_secret_key'].toString(),
        smsUserName = json['sms_username'].toString(),
        smsPassword = json['sms_password'].toString(),
        smsSenderId = json['sms_sender_id'].toString(),
        smsFL = json['sms_fl'].toString(),
        customerVersion = json['customer_version'].toString(),
        agentVersion = json['agent_version'].toString(),
        smsGwID = json['sms_gwid'].toString(),
        referralStatus = json['referral_status']?.toString();
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

  GiftData.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? " ",
        title = json['title'] ?? " ",
        image = json['image'] ?? " ",
        points = json['point'] ?? " ",
        desc = json['description'] ?? " ",
        specs = json['specification'] ?? " ",
        rating = json['rating'] ?? " ";
}
