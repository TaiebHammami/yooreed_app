import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../cache/shared_preference.dart';

class FirebaseApi {
  Future addFcm() async {
    var data;
    var userId = await _getIdUser() as int;
   var value = await FirebaseMessaging.instance.getToken();

          data = {'userId': userId.toString(), 'fcmToken': value};

    var token = await _getToken();
    const url = "http://10.0.2.2:8000/api/firebase/";
    try {
    var response =  await http.post(Uri.parse(url),
          headers: _setHeaders(token), body: jsonEncode(data));
      print(response.statusCode);
    } on SocketException {
    } on FormatException {
    } catch (exception) {
      print(exception);
    }
  }

  _setHeaders(token) => {
        HttpHeaders.contentTypeHeader: 'application/vnd.api+json',
        HttpHeaders.acceptHeader: 'application/vnd.api+json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

  _getToken() async {
    var token = await MyCache.getUser();

    return token;
  }

  _getIdUser() async {
    var userId = await MyCache.getUserId();

    return userId;
  }
}
