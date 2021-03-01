class Data{
  dynamic message;
  dynamic response;
  List data;
  Data({this.response, this.message, this.data});
  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      message: json['message'] as String,
      response: json['success'] as bool,
      data: json['data'] as List,
    );
  }
}