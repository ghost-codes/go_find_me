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
    this.lastSeen,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.v,
  });

  List<String>? imgs;
  List<dynamic>? contributions;
  List<dynamic>? privilleged;
  String? status;
  String? userId;
  int? shares;
  String? id;
  String? desc;
  String? title;
  LastSeen? lastSeen;
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
        userId: json["user_id"],
        desc: json["desc"],
        title: json["title"],
        lastSeen: LastSeen.fromJson(json["last_seen"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "last_seen": lastSeen!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class LastSeen {
  LastSeen({
    this.location,
    this.date,
  });

  String? location;
  DateTime? date;

  factory LastSeen.fromRawJson(String str) =>
      LastSeen.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LastSeen.fromJson(Map<String, dynamic> json) => LastSeen(
        location: json["location"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "date": date!.toIso8601String(),
      };
}
