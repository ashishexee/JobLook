import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  final String id;
  final String profile;
  final String userToken;
  final String uid;
  final String username;

  LoginResponseModel({
    required this.id,
    required this.profile,
    required this.userToken,
    required this.uid,
    required this.username,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        id: json["user"]["_id"],
        profile: json["user"]["profile"],
        userToken: json["userToken"],
        uid: json["user"]["uid"] ?? "", 
        username: json["user"]["username"],
      );
}
