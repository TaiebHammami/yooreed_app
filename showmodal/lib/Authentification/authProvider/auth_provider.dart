import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:showmodal/Authentification/authProvider/auth_api.dart';
import 'package:showmodal/Service/service_const.dart';
import 'package:showmodal/cache/shared_preference.dart';
import 'package:showmodal/AdherentApp/navigation/navigation_home_screen.dart';
import 'package:showmodal/partenaire.dart';
import '../../Partenaire_app/navigation/partenaire_navigation.dart';
import '../../theme/app_theme.dart';
import '../Screen/login_page.dart';
import '../Screen/reset_password.dart';
import '../authebtification_result.dart';
import 'api_result.dart';

enum AuthState { loadingLogin, loadingReset, loaded }

class AuthProvider extends ChangeNotifier {
  late AuthResult user;
  late AuthResult userLogout;

  late String errorMessage;
  var loadingLogin = AuthState.loaded;
  var loadingReset = AuthState.loaded;

  void setStateLogin(AuthState) {
    loadingLogin = AuthState;
    notifyListeners();
  }

  String adherent = ServiceConst.RoleAdherent.toLowerCase();
  String partenaire = ServiceConst.RolePartenaire.toLowerCase();
  String both = ServiceConst.RoleBoth.toLowerCase();

  void setStateReset(AuthState) {
    loadingReset = AuthState;
    notifyListeners();
  }

  AuthProvider() {
    user = AuthResult(
        id: 0,
        nom: '',
        prenom: '',
        role: '',
        email: '',
        image: '',
        cin: 0,
        numero: 0,
        firstTime: 1,
        adresse: '',
        token: '');
    userLogout = AuthResult(
        id: 0,
        nom: '',
        prenom: '',
        role: '',
        email: '',
        image: '',
        cin: 0,
        numero: 0,
        firstTime: 1,
        adresse: '',
        token: '');
  }

  Future login(data, context) async {
    await AuthService().login(data).then((value) async {
      value is AuthApiResult;

      switch (value.code) {
        case HttpStatus.ok:
          {
            user = value.data;
            notifyListeners();
            await MyCache.saveRole(user.role);
            await MyCache.saveUser(user.token);
            await MyCache.saveUserId(user.id);
            if (value.data.firstTime == 1) {
              Fluttertoast.showToast(msg: 'logged');

              Navigator.pushReplacementNamed(context, ResetPassword.routeName,
                  arguments: value.data.email);
            } else if (value.data.role == ServiceConst.RoleAdherent) {
              Navigator.pushReplacementNamed(
                  context, NavigationHomeScreen.routeName);
            } else if (value.data.role == ServiceConst.RoleBoth) {
              Get.bottomSheet(
                  Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Colors.black45
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Get.isDarkMode
                                        ? Theme.of(context).canvasColor
                                        : Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    maximumSize: Size(double.infinity, 65),
                                    minimumSize: Size(double.infinity, 60)),
                                onPressed: () {
                                  Get.toNamed(NavigationHomeScreen.routeName);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('CONTINUE_AS_ADHERENT',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    const Spacer(),
                                    const Icon(CupertinoIcons.arrow_right),
                                    const SizedBox(
                                      width: 20,
                                    )
                                  ],
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Get.isDarkMode
                                        ? Theme.of(context).canvasColor
                                        : Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    maximumSize: Size(double.infinity, 65),
                                    minimumSize: Size(double.infinity, 60)),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, HomePagePartenaire.routeName);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('CONTINUE_AS_PARTENAIRE',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    const Spacer(),
                                    Icon(
                                      CupertinoIcons.arrow_right,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ))
                          ],
                        ),
                      )),
                  elevation: 10,
                  barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
                  isDismissible: false);
            } else {
              Navigator.pushReplacementNamed(
                  context, HomePagePartenaire.routeName);
            }
          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            Fluttertoast.showToast(msg: value.errorMessage);
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
            Fluttertoast.showToast(msg: value.errorMessage);
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            Fluttertoast.showToast(msg: value.errorMessage);
          }
      }
    });
  }

  /// logout

  Future logout(context) async {
    await AuthService().Logout().then((value) async {
      value is AuthApiResult;

      switch (value.code) {
        case HttpStatus.ok:
          {
            user = userLogout;
            notifyListeners();
            await MyCache.deleteUser();
            await FirebaseMessaging.instance.deleteToken();
            Get.offAllNamed(LoginPage.routeName);
          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            Fluttertoast.showToast(msg: value.errorMessage);
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
            Fluttertoast.showToast(msg: value.errorMessage);
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            Fluttertoast.showToast(msg: value.errorMessage);
          }
      }
    });
  }

  /// reset password
  ///
  ///
  Future resetPassword(context, password, passwordConfirmation) async {
    var data = {
      'email': user.email,
      'password': password,
      'password_confirmation': passwordConfirmation
    };
    await AuthService().resetPassword(data, user.token).then((value) async {
      value is AuthApiResult;

      switch (value.code) {
        case HttpStatus.ok:
          {
            Fluttertoast.showToast(msg: value.errorMessage);
            Future.delayed(Duration(seconds: 3)).then((value) {
              goHome(user.role.toLowerCase(), context);
            });
          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            Fluttertoast.showToast(msg: value.errorMessage);
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
            Fluttertoast.showToast(msg: value.errorMessage);
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            Fluttertoast.showToast(msg: value.errorMessage);
          }
      }
    });
  }

  void goHome(String role, context) {
    if (role == 'adherent') {
      Navigator.pushReplacementNamed(context, NavigationHomeScreen.routeName);
    } else if (role == 'partenaire') {
      Navigator.pushReplacementNamed(context, HomePagePartenaire.routeName);
    } else {
      Get.bottomSheet(
          Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.black45 : Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Get.isDarkMode
                                ? Theme.of(context).canvasColor
                                : Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            maximumSize: Size(double.infinity, 65),
                            minimumSize: Size(double.infinity, 60)),
                        onPressed: () {
                          Get.toNamed(NavigationHomeScreen.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('CONTINUE_AS_ADHERENT',
                                style: Theme.of(context).textTheme.bodyText1),
                            const Spacer(),
                            const Icon(CupertinoIcons.arrow_right),
                            const SizedBox(
                              width: 20,
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Get.isDarkMode
                                ? Theme.of(context).canvasColor
                                : Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            maximumSize: Size(double.infinity, 65),
                            minimumSize: Size(double.infinity, 60)),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, HomePagePartenaire.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('CONTINUE_AS_PARTENAIRE',
                                style: Theme.of(context).textTheme.bodyText1),
                            const Spacer(),
                            Icon(
                              CupertinoIcons.arrow_right,
                              color: Theme.of(context).canvasColor,
                            ),
                            const SizedBox(
                              width: 20,
                            )
                          ],
                        ))
                  ],
                ),
              )),
          elevation: 10,
          barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
          isDismissible: false);
    }
  }
}
