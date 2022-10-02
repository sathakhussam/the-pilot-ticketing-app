// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  String userId;
  String firstName;
  String secondName;
  String email;
  String token;
  String profileUrl;
  User({
    required this.token,
    required this.userId,
    required this.firstName,
    required this.secondName,
    required this.email,
    required this.profileUrl,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        token: json["token"],
        userId: json["data"]["_id"],
        firstName: json["data"]["firstName"] ?? "",
        secondName: json["data"]["secondName"] ?? "",
        email: json["data"]["email"],
        profileUrl: json["data"]["profileUrl"] ?? "",
      );

  Map<dynamic, dynamic> toJson() => {
        "token": token,
        "data": {
          "_id": userId,
          "firstName": firstName,
          "secondName": secondName,
          "email": email,
          "profileUrl": profileUrl,
        }
      };
}

class OtherUser {
  String userId;
  String firstName;
  String secondName;
  String email;
  String profileUrl;
  OtherUser({
    required this.userId,
    required this.firstName,
    required this.secondName,
    required this.email,
    required this.profileUrl,
  });

  factory OtherUser.fromJson(Map<dynamic, dynamic> json) => OtherUser(
        userId: json["_id"],
        firstName: json["firstName"] ?? "",
        secondName: json["secondName"] ?? "",
        email: json["email"],
        profileUrl: json["profileUrl"] ?? "",
      );

  Map<dynamic, dynamic> toJson() => {
        "_id": userId,
        "firstName": firstName,
        "secondName": secondName,
        "email": email,
        "profileUrl": profileUrl,
      };
}
