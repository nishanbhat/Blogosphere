import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkHandler {
   String baseurl =
    "http://192.168.2.48:5000"; // instead localhost add your ip address here
  // String baseurl =
  //     "http://192.168.1.72:5000"; // add your ngrok forwarding to connect to real device
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future get(String url) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.body);
        return json.decode(response.body);
      }
      log.i(response.body);
      log.i(response.statusCode);
    } catch (err) {
      return null;
    }
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    log.d(body);
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body),
      );
      return response;
    } catch (err) {
      return null;
    }
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    print("patching");
    log.d(body);
    try {
      var response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body),
      );
      return response;
    } catch (err) {
      return null;
    }
  }

  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    url = formater(url);
    String token = await storage.read(key: "token");
    try {
      var request = http.MultipartRequest('PATCH', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath("img", filepath));
      request.headers.addAll({
        "Content-type": "multipart/form-data",
        "Authorization": "Bearer $token"
      });
      var response = request.send();
      return response;
    } catch (err) {
      return null;
    }
  }

  String formater(String url) {
    return baseurl + url;
  }

  NetworkImage getImage(String url) {
    return NetworkImage(url);
  }

  // delete
  Future<http.Response> delete(String url) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      return response;
    } catch (err) {
      return null;
    }
  }

  // update
  Future<http.Response> update(String url, Map<String, dynamic> body) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    log.d(body);
    try {
      var response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body),
      );
      return response;
    } catch (err) {
      return null;
    }
  }
}
