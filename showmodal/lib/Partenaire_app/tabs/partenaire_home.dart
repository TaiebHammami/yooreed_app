import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/Authentification/authProvider/auth_provider.dart';
import 'package:showmodal/Partenaire_app/API/call_api.dart';
import 'package:showmodal/Partenaire_app/Models/offer_partenaire.dart';
import 'package:showmodal/cache/shared_preference.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../AdherentApp/Provider/offer_provider.dart';
import '../../expandile.dart';
import '../../firebaseApi/firebaseApi.dart';
import '../../main.dart';
import '../Widget/partenaire_home.dart';
import '../provider/partenaire_offre.dart';

class PartenaireHome extends StatefulWidget {
  @override
  State<PartenaireHome> createState() => _PartenaireHomeState();
}

class _PartenaireHomeState extends State<PartenaireHome>
    with TickerProviderStateMixin {
  List<String> tabs = ["Accepted", "Refused", "loading"];
  var value = 0;
  late double width;

  bool positive = true;
  bool first = false;
  bool second = true;
  late PartenaireOffre offerProvider;
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    offerProvider = PartenaireOffre();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    offerProvider = Provider.of<PartenaireOffre>(context);
    print(offerProvider.partenaireLoadingItems);
    final user = Provider.of<AuthProvider>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            for(int i = 0 ; i<5;i++){
              flutterLocalNotificationsPlugin.show(
                  0,
                  'notification.title',
                  'notification.body',
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channelDescription: channel.description,
                      color: Colors.white,
                      onlyAlertOnce: false,
                      audioAttributesUsage:
                      AudioAttributesUsage.notificationEvent,
                      playSound: true,
                      icon: '@mipmap/ic_launcher',
                    ),
                  ));
            }


          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: Icon(CupertinoIcons.list_bullet),
          backgroundColor: Theme.of(context).bottomAppBarColor,
          elevation: 0.5,
          centerTitle: true,
          title: SimpleShadow(
              opacity: 0.15,
              child: Image.asset(
                'assets/yooreed.png',
                width: 100,
                height: 45,
              )),
          actions: [
            Center(
              child: Padding(
                  padding: const EdgeInsets.only(right: 22, bottom: 0),
                  child: SimpleShadow(
                      sigma: 1,
                      opacity: 0.15,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        // child: CircleAvatar(
                        //   radius: 22,
                        //   backgroundImage: NetworkImage('user.user.image'),
                        // ),
                      ))),
            )
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            splashBorderRadius: BorderRadius.circular(6),
            labelStyle:
                Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 16),
            unselectedLabelStyle: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(fontSize: 15.85),
            indicatorColor: HexColor('#E9564B'),
            labelColor: Get.isDarkMode ? Colors.white : Colors.black,
            unselectedLabelColor: Get.isDarkMode ? Colors.white60 : Colors.grey,
            tabs: [
              Tab(
                text: 'ACCEPTED'.tr,
              ),
              Tab(
                text: 'REFUSED'.tr,
              ),
              Tab(
                text: 'IN_PROGRESS'.tr,
              )
            ],
            controller: tabController,
          ),
        ),
        body: body());
  }

  ///Body of the scaffold
  Widget body() {
    return RefreshIndicator(
      onRefresh: () async {
        await offerProvider.refreshHome();
      },
      child: ListView(
        children: <Widget>[
          SizedBox(
              width: width,
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: tabController,
                dragStartBehavior: DragStartBehavior.down,
                children: [
                  PartenaireHomeList(
                    offerList: offerProvider.partenaireAcceptedItems,
                  ),
                  PartenaireHomeList(
                    offerList: offerProvider.partenaireRefusedItems,
                  ),
                  PartenaireHomeList(
                    offerList: offerProvider.partenaireLoadingItems,
                  )
                ],
              )),
        ],
      ),
    );
  }

  ///Example 1: For developement

  ///Example 2: For customization demo
  ///It's upto you for more customzations

  Widget alternativeIconBuilder(BuildContext context, SizeProperties<int> local,
      GlobalToggleProperties<int> global) {
    int data = 0;
    switch (local.value) {
      case 0:
        data = 0;
        break;
      case 1:
        data = 1;
        break;
      case 2:
        data = 2;
        break;
    }
    return Text(tabs[data]);
  }
}
