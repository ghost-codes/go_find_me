// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

class Post {
  Post({
    this.imgs,
    this.contributions,
    this.privilleged,
    this.status,
    this.shares,
    this.id,
    this.desc,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<String>? imgs;
  List<dynamic>? contributions;
  List<dynamic>? privilleged;
  String? status;
  int? shares;
  String? id;
  String? desc;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        imgs: List<String>.from(json["imgs"].map((x) => x)),
        contributions: List<dynamic>.from(json["contributions"].map((x) => x)),
        privilleged: List<dynamic>.from(json["privilleged"].map((x) => x)),
        status: json["status"],
        shares: json["shares"],
        id: json["_id"],
        desc: json["desc"],
        title: json["title"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "imgs": List<dynamic>.from(imgs!.map((x) => x)),
        "contributions": List<dynamic>.from(contributions!.map((x) => x)),
        "privilleged": List<dynamic>.from(privilleged!.map((x) => x)),
        "status": status,
        "shares": shares,
        "_id": id,
        "desc": desc,
        "title": title,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}
