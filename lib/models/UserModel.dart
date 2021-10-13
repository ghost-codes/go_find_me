import 'dart:convert';

class UserModel {
  UserModel({
    this.id,
    this.email,
    this.photoUrl,
    this.username,
  });

  String? username;
  String? id;
  String? email;
  String? photoUrl;

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json["email"],
        photoUrl: json["photo_url"],
        username: json["username"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "photo_url": photoUrl,
        "username": username,
      };
}
