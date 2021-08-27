import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class Api {
  var dio = Dio();

  // createPost(Map<String, dynamic> map) async {
  //   var postUri = Uri.parse('https://go-find-me.herokuapp.com/api/posts/');
  //   var request = new http.MultipartRequest("POST", postUri);

  //   request.fields["desc"] = map["desc"];
  //   request.files.add(new http.MultipartFile.fromBytes(
  //       "uploads", await map["uploads"][0].readAsBytes()));

  //   var response = await request.send();
  //   print(response.statusCode);
  // }

  createPost(Map<String, dynamic> map) async {
    try {
      List<MultipartFile> imgs = [];
      List<MultipartFile> files = map["uploads"];
      final formdata = FormData.fromMap(map);

      var response = await dio
          .post('https://go-find-me.herokuapp.com/api/posts/', data: formdata);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<dynamic>> getFeed() async {
    Response response =
        await dio.get("https://go-find-me.herokuapp.com/api/posts/");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [];
    }
  }
}
