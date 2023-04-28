import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:showmodal/Partenaire_app/tabs/new_offer.dart';
import 'package:showmodal/Service/service_const.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../AdherentApp/screen/tabs/profile.dart';
import '../../firebaseApi/firebaseApi.dart';
import '../../main.dart';
import '../provider/partenaire_offre.dart';
import '../scan_controller.dart';
import '../tabs/notification_partenaire.dart';
import '../tabs/partenaire_home.dart';
import '../tabs/partenaire_profile.dart';

class HomePagePartenaire extends StatefulWidget {
  static String routeName = '/home_page';

  HomePagePartenaire({Key? key}) : super(key: key);

  @override
  State<HomePagePartenaire> createState() => _HomePageState();
}

class _HomePageState extends State<HomePagePartenaire> {
  late PageController _pageController;
  late int selected = 0;

  Future firebase() async {
    await FirebaseApi().addFcm();
  }

  late PartenaireOffre offerProvider;

  @override
  void initState() {
    offerProvider = PartenaireOffre();
    offerProvider.showNotification();
    firebase();
    _pageController = PageController(initialPage: 0);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.white,
                onlyAlertOnce: false,
                audioAttributesUsage: AudioAttributesUsage.notificationEvent,
                playSound: true,
                icon: '@drawable/app_icon',
              ),
            ));
      }
    });

    super.initState();
  }

  void showNotification() {
    if (offerProvider.notiList.isNotEmpty) {
      for (int i = 0; i < offerProvider.notiList.length; i++) {
        flutterLocalNotificationsPlugin.show(
            offerProvider.notiList[i].id,
            offerProvider.notiList[i].title,
            offerProvider.notiList[i].status ==
                    ServiceConst.OFFRE_STATUS_ACCEPTED
                ? 'Offre Accepted '
                : 'Offer Refused',
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.white,
                onlyAlertOnce: false,
                audioAttributesUsage: AudioAttributesUsage.notificationEvent,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  List<Widget> pages = [
    PartenaireHome(),
    NewOffer(),
    PartenaireNotification(),
    PartenaireProfile()
  ];
  ScanController controller = Get.put(ScanController());

  @override
  Widget build(BuildContext context) {
    offerProvider = Provider.of<PartenaireOffre>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            elevation: 1,
            onPressed: () {
              controller.scanQr();
            },
            child: Icon(
              CupertinoIcons.qrcode_viewfinder,
              color: Get.isDarkMode ? HexColor('#E9564B') : Colors.black,
            )),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          elevation: 18,
          notchMargin: 10,
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _bottomAppBarItem(icon: CupertinoIcons.house_alt, page: 0),
                Padding(
                  padding: const EdgeInsets.only(right: 36),
                  child: _bottomAppBarItem(
                      icon: CupertinoIcons.add_circled, page: 1),
                ),
                _bottomAppBarItem(icon: CupertinoIcons.bell, page: 2),
                _bottomAppBarItem(icon: CupertinoIcons.settings, page: 3),
              ],
            ),
          ),
        ),
        body: PageView(
          onPageChanged: (index) => setState(() {
            selected = index;
          }),
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [...pages],
        ));
  }

  Widget _bottomAppBarItem({icon, page}) {
    return ZoomTapAnimation(
      onTap: () => _pageController.jumpToPage(page),
      child: Icon(
        icon,
        color: selected == page ? HexColor('#E9564B') : Colors.grey,
        size: 24,
      ),
    );
  }
}
