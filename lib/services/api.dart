import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_android/core/network/networkError.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/models/UserModel.dart';
import 'package:project_android/services/sharedPref.dart';

class Api {
  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();
  Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://go-find-me.herokuapp.com/api',
    ),
  );

  Api() {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (request, handler) async {
      String? token = await sharedPref.getStringValuesSF("accessToken");
      if (token != null && token != '') {
        request.headers['Authorization'] = "Bearer " + token;
      }
      return handler.next(request);
    }, onError: (DioError e, handler) async {
      if (e.response?.statusCode == 403) {
        try {
          String? refreshToken =
              await sharedPref.getStringValuesSF("refreshToken");

          if (refreshToken != null && refreshToken != '') {
            await dio.post('/users/refresh_token',
                data: {"token": refreshToken}).then((value) async {
              if (value.statusCode == 200) {
                String token = value.data["accessToken"];
                await sharedPref.addStringToSF(
                    "accessToken", value.data?["accessToken"]);
                await sharedPref.addStringToSF(
                    "refreshToken", value.data?["refreshToken"]);

                e.requestOptions.headers["Authorization"] = "Bearer " + token;

                // Create request with new access Token
                final opts = new Options(
                  method: e.requestOptions.method,
                  headers: e.requestOptions.headers,
                );
                final cloneReq = await dio.request(e.requestOptions.path,
                    options: opts,
                    data: e.requestOptions.data,
                    queryParameters: e.requestOptions.queryParameters);

                return handler.resolve(cloneReq);
              }
              // return e;
            });
            // return dio;
          }
        } catch (err) {
          print(err);
        }
      }

      return handler.next(e);
    }));
  }

  Future<UserModel?> tokenAuthentication() async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.get('/users/login/token_auth');

      UserModel user = UserModel.fromJson(response.data ?? {});

      return user;
    } on DioError catch (err) {
      throw NetworkError(err);
    }
  }

  // Authentication Apis
  Future<UserModel?> emailLogin(Map<String, dynamic> map) async {
    try {
      Response response = await dio.post('/users/login/email/', data: map);

      UserModel user = UserModel.fromJson(response.data?["user"] ?? {});
      await sharedPref.addStringToSF(
          "accessToken", response.data?["accessToken"]);
      await sharedPref.addStringToSF(
          "refreshToken", response.data?["refreshToken"]);

      return user;
    } on DioError catch (err) {
      throw NetworkError(err);
    }
  }

  Future<UserModel?> googleSignUp(Map<String, dynamic> data) async {
    try {
      Response response =
          await dio.post('/users/sign_up/google_auth', data: data);

      UserModel user = UserModel.fromJson(response.data?["user"] ?? {});
      await sharedPref.addStringToSF(
          "accessToken", response.data?["accessToken"]);
      await sharedPref.addStringToSF(
          "refreshToken", response.data?["refreshToken"]);

      return user;
    } on DioError catch (err) {
      throw NetworkError(err);
    }
  }

  Future<UserModel?> googleSignInAip(Map<String, dynamic> data) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.post('/users/login/google_auth', data: data);

      UserModel user = UserModel.fromJson(response.data?["user"] ?? {});
      await sharedPref.addStringToSF(
          "accessToken", response.data?["accessToken"]);
      await sharedPref.addStringToSF(
          "refreshToken", response.data?["refreshToken"]);

      return user;
    } on DioError catch (err) {
      throw NetworkError(err);
    }
  }

  Future<UserModel?> emailSignUp(Map<String, dynamic> data) async {
    try {
      Response response = await dio.post('/users/sign_up/email', data: data);

      UserModel user = UserModel.fromJson(response.data?["user"] ?? {});
      await sharedPref.addStringToSF(
          "accessToken", response.data?["accessToken"]);
      await sharedPref.addStringToSF(
          "refreshToken", response.data?["refreshToken"]);

      return user;
    } on DioError catch (err) {
      throw NetworkError(err);
    }
  }

  ///////////////////////////////////////////////////////

  Future<Post?> createPost(Map<String, dynamic> map) async {
    try {
      print(map);
      final formdata = FormData.fromMap(map);

      var response = await dio.post('/posts/', data: formdata);

      return Post.fromJson(response.data);
    } on DioError catch (err) {
      throw NetworkError(err);
    }
  }

  contribution(Map<String, dynamic> map) async {
    try {
      var response = await dio.post('/contributions/', data: map);

      print(json.encode(response.data));
      return response.data;
    } on DioError catch (e) {
      return NetworkError(e);
    }
  }

  editPost(Map<String, dynamic> map, String postId) async {
    try {
      final formdata = FormData.fromMap(map);

      Response response = await dio.put("/posts/$postId", data: formdata);

      return true;
    } on DioError catch (err) {
      throw NetworkError(err);
    }
  }

  deletePost(String postId) async {
    try {
      Response response = await dio.delete("/posts/post/$postId");

      return true;
    } on DioError catch (err) {
      throw NetworkError(err);
    }
  }

  Future<List<Post?>> getFeed() async {
    try {
      Response response = await dio.get("/posts/");

      List resultData = response.data;
      List<Post?> posts = resultData.map((e) => Post.fromJson(e)).toList();
      return posts;
    } on DioError catch (err) {
      throw NetworkError(err);
    }
  }
}
