import 'package:flutter/material.dart';
import 'package:showmodal/AdherentApp/Models/notification.dart';

class NotificationItem extends StatelessWidget{
  final NotificationModel noti ;

  const NotificationItem({super.key, required this.noti});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container
        (
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: BoxShape.circle,
          image: DecorationImage(
            image:  AssetImage('assets/yooreed.png',),
            fit: BoxFit.contain
          )
        ),


      ),
      title: Text(noti.title,style: Theme.of(context).textTheme.caption,),
    );
  }

}