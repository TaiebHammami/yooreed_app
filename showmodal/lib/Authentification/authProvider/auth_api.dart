import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showmodal/Authentification/authProvider/api_result.dart';
import 'package:showmodal/Service/service_const.dart';
import 'package:showmodal/cache/shared_preference.dart';

import '../authebtification_result.dart';
import 'package:http/http.dart' as http;

import 'auth_provider.dart';

class AuthService {
  Future<AuthApiResult> login(data) async {
    AuthApiResult result;
    final url = ServiceConst.globalUrl+ServiceConst.Auth+ServiceConst.logIn;
    try {
      final response = await http.post(Uri.parse(url),
          headers: _setHeaders(), body: jsonEncode(data));
      // if (response.statusCode == HttpStatus.ok) {
      result = AuthApiResult(AuthResult.fromJson(jsonDecode(response.body)),
          HttpStatus.ok, jsonDecode(response.body)['message']);
      // } else {
      //   result = AuthApiResult(AuthResult.fromJson(jsonDecode(response.body)),
      //       response.statusCode, jsonDecode(response.body)['message']);
      // }
    } on SocketException {
      result = AuthApiResult('', HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = AuthApiResult(
          '', HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = AuthApiResult('', HttpStatus.BAD_REQUEST, "TRY_LATER".tr);
    }
    return result;
  }

  Future<AuthApiResult> resetPassword(data, token) async {
    AuthApiResult result;
    final url =
        ServiceConst.globalUrl + ServiceConst.Auth + ServiceConst.resetPassword;
    try {
      final response = await http.post(Uri.parse(url),
          headers: _setHeaders_token(token), body: jsonEncode(data));
      print(response.body);
      if (response.statusCode == HttpStatus.ok) {
        result = AuthApiResult(
            '', HttpStatus.ok, jsonDecode(response.body)['message']);
      } else {
        result = AuthApiResult(AuthResult.fromJson(jsonDecode(response.body)),
            response.statusCode, jsonDecode(response.body)['message']);
      }
    } on SocketException {
      result = AuthApiResult('', HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result =
          AuthApiResult('', HttpStatus.SERVICE_UNAVAILABLE, 'TRY_LATER'.tr);
    } catch (exception) {
      result = AuthApiResult('', HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  _setHeaders() => {
        HttpHeaders.contentTypeHeader: 'application/vnd.api+json',
        HttpHeaders.acceptHeader: 'application/vnd.api+json',
      };

  _setHeaders_token(token) => {
        HttpHeaders.contentTypeHeader: 'application/vnd.api+json',
        HttpHeaders.acceptHeader: 'application/vnd.api+json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

  _getToken() async {
    var token = await MyCache.getUser();

    return token;
  }

  Future<AuthApiResult> Logout() async {
    AuthApiResult result;

    var fullUrl = ServiceConst.globalUrl+ServiceConst.Auth +'/logout';
    try {
      await http.post(
        Uri.parse(fullUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${await _getToken()}'
        },
      );
      result = AuthApiResult('', HttpStatus.ok, '');
    } on SocketException {
      result = AuthApiResult('', HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = AuthApiResult(
          '', HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = AuthApiResult('', HttpStatus.BAD_REQUEST, "TRY_LATER".tr);
    }
    return result;
  }
}
