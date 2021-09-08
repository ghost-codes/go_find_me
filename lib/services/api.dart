import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class Api {
  var dio = Dio();

  createPost(Map<String, dynamic> map) async {
    try {
      final formdata = FormData.fromMap(map);

      var response = await dio
          .post('https://go-find-me.herokuapp.com/api/posts/', data: formdata);
      if (response.statusCode == 200) {
        print(json.encode(response.data));
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  contribution(Map<String, dynamic> map) async {
    try {
      var response = await dio.post(
          'https://go-find-me.herokuapp.com/api/contributions/',
          data: map);
      if (response.statusCode == 200) {
        print(json.encode(response.data));
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  editPost(Map<String, dynamic> map, String postId) async {
    try {
      final formdata = FormData.fromMap(map);

      Response response = await dio.put(
          "https://go-find-me.herokuapp.com/api/posts/$postId",
          data: formdata);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  deletePost(String postId) async {
    try {
      Response response = await dio
          .delete("https://go-find-me.herokuapp.com/api/posts/post/$postId");
      if (response.statusCode == 200) {
        return true;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<List<dynamic>> getFeed() async {
    Response response =
        await dio.get("https://go-find-me.herokuapp.com/api/posts/");

    if (response.statusCode == 200) {
      print(response.data);
      return response.data;
    } else {
      return [];
    }
  }
}
