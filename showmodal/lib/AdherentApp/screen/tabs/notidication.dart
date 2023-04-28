import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showmodal/AdherentApp/API/servie_api.dart';
import 'package:showmodal/AdherentApp/screen/notification_list.dart';
import 'package:showmodal/firebaseApi/firebaseApi.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../../main.dart';
import '../../Models/notification.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _counter = 0;
  late List thisWeek;
  late  List today ;
  @override
  void initState() {
    super.initState();

thisWeek = <NotificationModel>[];
 today = <NotificationModel>[];
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: SimpleShadow(
          color: Theme.of(context).shadowColor,
          opacity: 0.06,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NOTIFICATION'.tr,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 26,
                    ),
              ),
                SizedBox(height: 6,),
             Row(
               children: [
                 Text('You have '),
                 Text('3 notifications '),
                 Text('today')
               ],
             )
            ],
          ),
        ),

      ),
      body: FutureBuilder(
        future: AdherentApi().getNotification(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {

          }
          return  Center(child: CircularProgressIndicator(color: Get.isDarkMode ? Colors.white : Colors.black,));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await FirebaseApi().addFcm();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
