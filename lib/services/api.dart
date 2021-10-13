import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/UserModel.dart';
import 'package:project_android/services/sharedPref.dart';

class Api {
  Dio dio = Dio(BaseOptions(baseUrl: 'https://go-find-me.herokuapp.com/api'));
  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();

  // Authentication Apis
  emailLogin(Map<String, dynamic> map) async {
    try {
      Response response = await dio.post('/users/login/email/', data: map);

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        return response.data;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  googleSignUp(Map<String, dynamic> data) async {
    try {
      Response response =
          await dio.post('/users/sign_up/google_auth', data: data);
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        return response.data;
      } else {
        return null;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<UserModel?> googleSignInAip(Map<String, dynamic> data) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.post('/users/login/google_auth', data: data);
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        UserModel user = UserModel.fromJson(response.data ?? {});
        await sharedPref.addStringToSF(
            "accessToken", response.data?["accessToken"]);
        await sharedPref.addStringToSF(
            "refreshToken", response.data?["refreshToken"]);
        return user;
      } else {
        return null;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  ///////////////////////////////////////////////////////

  createPost(Map<String, dynamic> map) async {
    try {
      final formdata = FormData.fromMap(map);

      var response = await dio.post('/posts/', data: formdata);
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
      var response = await dio.post('/contributions/', data: map);
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

      Response response = await dio.put("/posts/$postId", data: formdata);
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
      Response response = await dio.delete("/posts/post/$postId");
      if (response.statusCode == 200) {
        return true;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<List<dynamic>> getFeed() async {
    Response response = await dio.get("/api/posts/");

    if (response.statusCode == 200) {
      print(response.data);
      return response.data;
    } else {
      return [];
    }
  }
}
