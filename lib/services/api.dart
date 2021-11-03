import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/models/UserModel.dart';
import 'package:project_android/services/sharedPref.dart';

class Api {
  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();
  Dio dio = Dio(BaseOptions(
    baseUrl: 'https://go-find-me.herokuapp.com/api',
  ));

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
        return handler.next(e);
      }
    }));
  }

  Future<UserModel?> tokenAuthentication() async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.get('/users/login/token_auth');
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        UserModel user = UserModel.fromJson(response.data ?? {});

        return user;
      } else {
        return Future.error("Error Occured");
      }
    } catch (err) {
      return Future.error(err);
    }
  }

  // Authentication Apis
  Future<UserModel?> emailLogin(Map<String, dynamic> map) async {
    try {
      Response response = await dio.post('/users/login/email/', data: map);

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        UserModel user = UserModel.fromJson(response.data?["user"] ?? {});
        await sharedPref.addStringToSF(
            "accessToken", response.data?["accessToken"]);
        await sharedPref.addStringToSF(
            "refreshToken", response.data?["refreshToken"]);

        return user;
      } else {
        return Future.error("Error Occured");
      }
    } on DioError catch (err) {
      return Future.error(err);
    }
  }

  Future<UserModel?> googleSignUp(Map<String, dynamic> data) async {
    try {
      Response response =
          await dio.post('/users/sign_up/google_auth', data: data);
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        UserModel user = UserModel.fromJson(response.data?["user"] ?? {});
        await sharedPref.addStringToSF(
            "accessToken", response.data?["accessToken"]);
        await sharedPref.addStringToSF(
            "refreshToken", response.data?["refreshToken"]);

        return user;
      } else {
        return Future.error("Login Error");
      }
    } on DioError catch (err) {
      return Future.error(err);
    }
  }

  Future<UserModel?> googleSignInAip(Map<String, dynamic> data) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.post('/users/login/google_auth', data: data);
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        UserModel user = UserModel.fromJson(response.data?["user"] ?? {});
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

  Future<UserModel?> emailSignUp(Map<String, dynamic> data) async {
    try {
      Response response = await dio.post('/users/sign_up/email', data: data);

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        UserModel user = UserModel.fromJson(response.data?["user"] ?? {});
        await sharedPref.addStringToSF(
            "accessToken", response.data?["accessToken"]);
        await sharedPref.addStringToSF(
            "refreshToken", response.data?["refreshToken"]);

        return user;
      } else {
        return Future.error("Error Occured");
      }
    } on DioError catch (err) {
      return Future.error(err);
    }
  }

  ///////////////////////////////////////////////////////

  Future<Post?> createPost(Map<String, dynamic> map) async {
    try {
      print(map);
      final formdata = FormData.fromMap(map);

      var response = await dio.post('/posts/', data: formdata);
      if (response.statusCode == 200) {
        return Post.fromJson(response.data);
      } else {
        return Future.error("Unexpected error occured try again");
      }
    } catch (e) {
      return Future.error("Unexpected error occured try again");
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

  Future<List<Post?>> getFeed() async {
    try {
      Response response = await dio.get("/posts/");

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        List resultData = response.data;
        List<Post?> posts = resultData.map((e) => Post.fromJson(e)).toList();
        return posts;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return Future.error("Unexpected Error");
    }
  }
}
