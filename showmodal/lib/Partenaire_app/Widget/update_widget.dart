import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../main.dart';

class SignInForm extends StatefulWidget {
  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  var key = GlobalKey<FormState>();
  void _presentDatePicker() {
    var date = DateTime.now().year;
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        // startOffer = value;
        // endOffer = startOffer.add(Duration(days: 365));
        // showpicker = 1;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: Column(
        children: [
          Text('Sign In', style: Theme.of(context).textTheme.headline4),
          ListTile(
            onTap:_presentDatePicker,
            tileColor: Theme.of(context).bottomAppBarColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6)
            ),
            leading: Text('Choose date fin'),
            trailing: Icon(FontAwesomeIcons.calendar
            ),
          ),
          SizedBox(height: 8,),
          Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                            SimpleShadow(
                  opacity: 0.06,
                  color: Theme.of(context).shadowColor,

                  child: TextFormField(
                    onSaved: (password) {

                    },
                    validator: (password) {
                      if (password!.isEmpty) {
                        return 'Required';
                      }
                    },
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
                        hintText: 'TITLE'.tr,
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),

              SizedBox(
                height: 8,
              ),
                SimpleShadow(
                  opacity: 0.06,
                  color: Theme.of(context).shadowColor,

                  child: TextFormField(
                            maxLines: 3,
                              textInputAction: TextInputAction.newline,
                    onSaved: (password) {

                    },
                    validator: (password) {
                      if (password!.isEmpty) {
                        return 'Required';
                      }
                    },
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
                        hintText: 'DESCRIPTION'.tr,
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),
              SizedBox(
                height: 8,
              ),
                              SimpleShadow(
                  opacity: 0.06,
                  color: Theme.of(context).shadowColor,

                  child: TextFormField(
                    onSaved: (password) {

                    },
                    validator: (password) {
                      if (password!.isEmpty) {
                        return 'Required';
                      }
                    },
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
                        hintText: 'PRICE'.tr,
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),

              SizedBox(
                height:8 ,
              ),
                              SimpleShadow(
                  opacity: 0.06,
                  color: Theme.of(context).shadowColor,

                  child: TextFormField(
                    onSaved: (password) {

                    },
                    validator: (password) {
                      if (password!.isEmpty) {
                        return 'Required';
                      }
                    },
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
                        hintText: 'PROMO'.tr,
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),
    SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(CupertinoIcons.arrow_right),
                label: Text('Edit'.tr),
                style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('#FD5445'),
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(25),
                    ))),
              ),
            ],
          )),
        ],
      ),
    );
  }
}