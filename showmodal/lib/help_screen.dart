import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showmodal/AdherentApp/API/servie_api.dart';
import 'package:showmodal/theme/app_theme.dart';

import 'main.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top, left: 16, right: 16),
              child: Image.asset('assets/helpImage.png'),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'How can we help you?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isLightMode ? Colors.black : Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'It looks like you are experiencing problems\nwith our sign up process. We are here to\nhelp so please get in touch with us',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: isLightMode ? Colors.black : Colors.white),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#E9564B'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(26),
                          bottomRight: Radius.circular(26),
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(26),
                        )),
                        maximumSize:
                            Size(MediaQuery.of(context).size.width * 0.85, 65),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.8, 55),
                      ),
                      onPressed: ()async {
                        await AdherentApi().getOffersByType(1);
                      },
                      child: Text(
                        'CHAT_WITH_US'.tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget BottomSheet(){
    return Container(

    );
  }

}
