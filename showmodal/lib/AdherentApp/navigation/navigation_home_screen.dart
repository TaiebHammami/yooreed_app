import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:showmodal/firebaseApi/firebaseApi.dart';
import 'package:showmodal/theme/app_theme.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../feedback_screen.dart';
import '../screen/tabs/notidication.dart';
import '../screen/tabs/profile.dart';
import '../../drawer/drawer_user_controller.dart';
import '../../drawer/home_drawer.dart';
import '../../help_screen.dart';
import '../screen/tabs/home_screen.dart';
import '../../invite_friend_screen.dart';
import '../../main.dart';

class NavigationHomeScreen extends StatefulWidget {
  static String routeName = '/home_adherent';

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState()  {
    _pageController = PageController(initialPage: 0);
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
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
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    super.initState();
  }

  late PageController _pageController;
  late int selected = 0;

  @override
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  List<Widget> pages = [
    MyHomePage(),
    FavoritePage(),
    NotificationPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).bottomAppBarColor,
          elevation: 18,
          notchMargin: 10,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomAppBarItem(icon: CupertinoIcons.home, page: 0),
                _bottomAppBarItem(icon: CupertinoIcons.heart, page: 1),
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

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const MyHomePage();
          });
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = HelpScreen();
          });
          break;
        case DrawerIndex.Favorite:
          setState(() {
            screenView = FavoritePage();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = InviteFriend();
          });
          break;
        default:
          break;
      }
    }
  }
}
