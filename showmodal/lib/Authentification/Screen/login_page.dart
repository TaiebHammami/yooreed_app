import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/Authentification/authProvider/auth_provider.dart';
import 'package:showmodal/Authentification/widget/sign_in_button.dart';
import 'package:showmodal/Authentification/widget/textfield_sign_in.dart';
import 'package:showmodal/cache/shared_preference.dart';
import 'package:showmodal/theme/app_theme.dart';

import '../modelUserAuth/user_auth.dart';


class LoginPage extends StatefulWidget {
    static String routeName = '/login';

  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // model user
  late UserAuthentification user;

  // text editing controllers

  late TextEditingController usernameController;

  late TextEditingController passwordController;
  late AuthProvider _authProvider;

  @override
  void initState() {
    _authProvider = AuthProvider();

    usernameController = TextEditingController();
    passwordController = TextEditingController();
    user = UserAuthentification('', '');
    super.initState();
  }

  // sign user in method
  var key = GlobalKey<FormState>();

  void signUserIn() async {
    var valid = key.currentState?.validate();
    if (!valid!) {
      return;
    }
    key.currentState!.save();
    var data = {'email': user.email, 'password': user.password};
    await _authProvider.login(data, context);
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                const SizedBox(height: 50),
                Container(
                    margin: EdgeInsets.only(left: 22, right: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SIGN_IN'.tr,
                            style: AppTheme.display1.copyWith(fontSize: 42)),
                        const SizedBox(
                          height: 30,
                        ),
                        // welcome back, you've been missed!
                        Text('Credentials'.tr,
                            style: AppTheme.headline.copyWith(fontSize: 20)),
                      ],
                    )),

                const SizedBox(height: 25),

                // form
                Form(
                    key: key,
                    child: Column(
                      children: [
                        // username textfield
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            onSaved: (email) {
                              user =
                                  UserAuthentification(email!, user.password);
                            },
                            validator: (email) {
                              if (!EmailValidator.validate(email!)) {
                                return 'Required';
                              }
                            },
                            controller: usernameController,
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                hintText: 'E-mail'.tr,
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),
                        ),

                        SizedBox(height: 10),

                        // password textfield
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            onSaved: (password) {
                              user =
                                  UserAuthentification(user.email, password!);
                            },
                            validator: (password) {
                              if (password!.isEmpty) {
                                return 'Required';
                              }
                            },
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                hintText: 'PASSWORD'.tr,
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'FORGOT_PASSWORD'.tr,
                          style: AppTheme.body2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Get.isDarkMode
                                ? Theme.of(context).canvasColor
                                : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            maximumSize: Size(double.infinity, 60),
                            minimumSize: Size(double.infinity, 60)),
                        onPressed: () async{
                        signUserIn();
                          var role = await MyCache.getUserRole();
                          print(role);
                        },
                        child: Row(
                          children: [
                            _authProvider.loadingLogin == AuthState.loadingLogin
                                ? CircularProgressIndicator(
                                    color: Theme.of(context)
                                        .progressIndicatorTheme
                                        .color,
                                  )
                                : Text(''),
                            Text('SIGN_IN'.tr),
                          ],
                        ))),
                const SizedBox(
                  height: 150,
                ),

                // not a member? register now
              ],
            ),
          ),
        ),
      ),
    );
  }
}
