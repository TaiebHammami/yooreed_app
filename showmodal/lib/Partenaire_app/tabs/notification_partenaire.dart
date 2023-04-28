import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showmodal/AdherentApp/Models/notification.dart';
import 'package:showmodal/Partenaire_app/Models/notification_partenaire.dart';
import 'package:showmodal/Service/service_const.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../main.dart';
import '../API/call_api.dart';

class PartenaireNotification extends StatefulWidget {
  @override
  State<PartenaireNotification> createState() => _PartenaireNotificationState();
}

class _PartenaireNotificationState extends State<PartenaireNotification> {
  void initState() {
    super.initState();
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
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
  }

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) => print(value));
  }

  List<NotificationModelPartenaire> notificationToday = [];
  List<NotificationModelPartenaire> notificationThisWeek = [];

  String image =
      "https://cdn.dribbble.com/users/386883/screenshots/5395283/14102018-dribbble_4x.png?compress=1&resize=1000x750&vertical=top";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).bottomAppBarColor,
          elevation: 0.7,
          title: SimpleShadow(
            color: Theme.of(context).shadowColor,
            opacity: 0.06,
            child: Text(
              'NOTIFICATION'.tr,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 26,
                  ),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
            future: PartenaireApi().getNotification(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                List<NotificationModelPartenaire> notifications = [];
                notifications.addAll(snapshot.data.data);

                notifications.map((e) {
                  if (DateFormat.yMMMEd()
                          .format(DateTime.parse(e.date))
                          .toString() ==
                      DateFormat.yMMMEd().format(DateTime.now()).toString()) {
                    notificationToday.add(e);
                  } else {
                    notificationThisWeek.add(e);
                  }
                  print(notificationThisWeek);
                });
                return NotificationList(notification: notifications);

                return NotificationList(notification: snapshot.data.data);
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}

class NotificationList extends StatelessWidget {
  final List<NotificationModelPartenaire> notification;

  const NotificationList({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notification.length,
        itemBuilder: (context, index) {
          return item(
            noti: notification[index],
            type: 0,
          );
        });
  }
}

class NotificationListThisWeek extends StatelessWidget {
  final List<NotificationModelPartenaire> notification;

  const NotificationListThisWeek({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: notification.length,
        itemBuilder: (context, index) {
          return item(
            noti: notification[index],
            type: 1,
          );
        });
  }
}

class item extends StatelessWidget {
  final NotificationModelPartenaire noti;
  final int type;

  item({super.key, required this.noti, required this.type});

  @override
  Widget build(BuildContext context) {
    String format = ' ';

      DateTime date = DateTime.parse(noti.date);
      format = DateFormat.jm().format(date).toString();

    final day = DateTime.parse(noti.date);

    final difference = day.difference(DateTime.now());
    final hours = difference.inHours;
    final days = difference.inDays;
    final minute = difference.inMinutes;
    print(hours);
    print(DateTime.now());
     print(day);
    var current = '';
    if(days ==0){
      if(hours ==0){
        current = minute.toString() + 'min';
      }else{
        current = hours.toString() + 'h';
      }
    }else{
      current = days.toString() + 'd';
    }


    String image = noti.image;

    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 6),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 0.4,
        color: Get.isDarkMode ? Colors.black.withOpacity(0.65) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                          width: 3,
                          color:
                              noti.status == ServiceConst.OFFRE_STATUS_ACCEPTED
                                  ? Colors.greenAccent
                                  : Colors.redAccent),
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: ListTile(
                          leading: Text('Yooreed on $format',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 15)),
                          trailing: SizedBox(
                            width: 80,
                            child: Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: noti.status ==
                                              ServiceConst.OFFRE_STATUS_ACCEPTED
                                          ? Colors.greenAccent
                                          : Colors.redAccent),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(noti.status ==
                                        ServiceConst.OFFRE_STATUS_ACCEPTED
                                    ? 'accepter'.tr
                                    : 'refuser'.tr)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 2,
                        thickness: 0.5,
                        color: Theme.of(context).dividerColor,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: image,
                              imageBuilder: (context, imageProvider) {
                                return SimpleShadow(
                                  sigma: 1,
                                  opacity: 0.04,
                                  child: Container(
                                    height: double.infinity,
                                    margin: const EdgeInsets.all(10.0),
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                            image: NetworkImage(image),
                                            fit: BoxFit.fill)),
                                  ),
                                );
                              },
                              errorWidget: (context, _, __) {
                                return Icon(
                                    CupertinoIcons.exclamationmark_triangle);
                              },
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  noti.title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )),
                            Container(
                              width:
                              60,
                              height: 30,
                              child: Text(current),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
