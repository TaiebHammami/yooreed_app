import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/Authentification/modelUserAuth/password_confirmation.dart';
import 'package:showmodal/Authentification/widget/sign_in_button.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../main.dart';
import '../../theme/app_theme.dart';
import '../authProvider/auth_provider.dart';

class ResetPassword extends StatefulWidget {
  static String routeName = '/reset_password';

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // textField controlller
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmationController;

  // password modelConfirmation
  late PasswordConfirmation CreatePassword;

  late AuthProvider _authProvider;
  late String email;

  @override
  void initState() {
    _authProvider = AuthProvider();
    email = _authProvider.user!.email;
    CreatePassword = PasswordConfirmation('', '');
    _passwordController = TextEditingController();
    _passwordConfirmationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  var key = GlobalKey<FormState>();

  savePassword() async {
    var valid = key.currentState?.validate();
    if (!valid!) {
      return;
    }
    key.currentState!.save();

    if (CreatePassword.password != CreatePassword.passwordConfirmation) {
      Fluttertoast.showToast(msg: 'CONFIRM_PASSWORD');
    } else {
      await _authProvider.resetPassword(context, CreatePassword.password,
          CreatePassword.passwordConfirmation);
    }
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 0.7,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text('CREATE_NEW_PASSWORD'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 30)),
              const SizedBox(
                height: 8,
              ),
              Text('RESET_PASSWORD'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 15)),
              const SizedBox(
                height: 8,
              ),
              Form(
                  key: key,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (password) {
                          CreatePassword = PasswordConfirmation(
                              password!, CreatePassword.passwordConfirmation);
                        },
                        validator: (password) {
                          if (password!.isEmpty) {
                            return 'Required';
                          }
                        },
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: Theme.of(context).bottomAppBarColor,
                            filled: true,
                            helperText: 'PASSWORD_RULES'.tr,
                            helperStyle: Theme.of(context).textTheme.bodySmall,
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey[500])),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onSaved: (passwordConfirmation) {
                          CreatePassword = PasswordConfirmation(
                              CreatePassword.password, passwordConfirmation!);
                        },
                        validator: (password) {
                          if (password!.isEmpty) {
                            return 'Required';
                          }
                        },
                        controller: _passwordConfirmationController,
                        obscureText: true,
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: Theme.of(context).bottomAppBarColor,
                            filled: true,
                            helperText: 'PASSWORD_CONFIRMATION'.tr,
                            helperStyle: Theme.of(context).textTheme.bodySmall,
                            hintText: 'Password confirmation',
                            hintStyle: TextStyle(color: Colors.grey[500])),
                      ),
                    ],
                  )),


              Spacer(),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 8),
                child: SimpleShadow(
                  color: Theme.of(context).shadowColor,
                  opacity: 0.1,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: HexColor('#E9564B'),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        highlightColor: Colors.transparent,
                        onTap: () {
                          savePassword();
                        },
                        child: Center(
                          child: Text(
                            'Apply',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
