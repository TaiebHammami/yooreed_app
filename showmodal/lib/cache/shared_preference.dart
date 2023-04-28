import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Authentification/authProvider/api_result.dart';

class MyCache {
  static String user = 'user';
  static String idUser = 'id';
  static String Role = 'role';

  static saveUser(token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(user, token);
  }

  static saveUserId(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(idUser, id);
  }

  static saveRole(role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Role, role);
  }

  static deleteUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.remove(user);
    String? token = prefs.getString(user);
    if (token != null) {
      return token;
    }
    return null;
  }

  static getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //    prefs.remove(idUser);
    int? id = prefs.getInt(idUser);

    if (id != null) {
      return id;
    }
    return null;
  }

  static getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString(Role);
    if (role != null) {
      return role;
    }
    return null;
  }
}
