import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Models/notification.dart';
import 'notification_item.dart';

class NotificationListThisWeek extends StatelessWidget {
  final List<NotificationModel> notiList;

   NotificationListThisWeek({super.key, required this.notiList});
  List thisWeek = <NotificationModel>[];

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: notiList.length,
        itemBuilder: (context, index) {
          return  NotificationItem(noti: notiList[index]);
        });
  }
}

class NotificationListToday extends StatelessWidget {
  final List<NotificationModel> notiList;

  List today = <NotificationModel>[];

  NotificationListToday({super.key, required this.notiList});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(padding: EdgeInsets.all(8),
        child: Text('Today',style: Theme.of(context).textTheme.caption!.copyWith(
          fontSize: 22
        ),),),
        ListView.builder(
            itemCount: notiList.length,
            itemBuilder: (context, index) {
              return NotificationItem(noti: notiList[index]);
            }),
      ],
    );
  }
}
