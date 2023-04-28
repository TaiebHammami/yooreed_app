import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../main.dart';

class PartenaireOffres extends StatelessWidget {
  late double _deviceHeight;

  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SimpleShadow(
                  offset: Offset(0, 0),
                  opacity: 0.2,
                  color: Theme.of(context).shadowColor,
                  child: CircleAvatar(
                      backgroundColor:
                          Get.isDarkMode ? HexColor('#E9564B') : Colors.white,
                      radius: 70,
                      child: const CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage('user.image'))),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text('Nom Responsable'),
                    SizedBox(
                      height: 12,
                    ),
                    Text('Nom Responsable'),
                  ],
                ),
                CupertinoButton(
                    child: Icon(CupertinoIcons.phone_solid), onPressed: () {})
              ],
            ),
            SizedBox(height: 26,),
            Expanded(
              child: SimpleShadow(
                color: Theme.of(context).shadowColor,
                sigma: 0.1,
                opacity: 0.01,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).bottomAppBarColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(32),topRight: Radius.circular(32))
                  ),
                  child: Column(
                    children: [
                           Container(
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballScaleMultiple,
                  colors: [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.deepPurple],
                  strokeWidth: 2,
                ),
              ),
              Container(
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  colors: [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.deepPurple],
                  strokeWidth: 2,
                ),
              ),
              Container(
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.pacman,
                  colors: [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.deepPurple],
                  strokeWidth: 2,
                ),
              ),
              Container(
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineScale,
                  colors: [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.deepPurple],
                  strokeWidth: 2,
                ),
              ),
              Container(
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  colors: [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.deepPurple],
                  strokeWidth: 2,
                ),
              ),
              Container(
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotate,
                  colors: [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.deepPurple],
                  strokeWidth: 2,
                ),
              ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
