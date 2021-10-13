import 'dart:convert';

class UserModel {
  UserModel({
    this.email,
    this.photoUrl,
    this.username,
  });

  String? username;
  String? email;
  String? photoUrl;

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json["email"],
        photoUrl: json["photo_url"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "photo_url": photoUrl,
        "username": username,
      };
}
