import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:showmodal/Partenaire_app/Models/create_offre.dart';

import '../../AdherentApp/API/servie_api.dart';
import '../../Service/service_const.dart';
import '../../cache/shared_preference.dart';
import '../../firebaseApi/firebaseApi.dart';
import '../../main.dart';
import '../API/call_api.dart';
import '../Models/notification_partenaire.dart';
import '../Models/offer_partenaire.dart';

class PartenaireOffre with ChangeNotifier {
  String OFFRE_STATUS_LOADING = 'loading';
  String OFFRE_STATUS_ACCEPTED = 'accepted';
  String OFFRE_STATUS_REFUSED = 'refused';
  late PartenaireApi api;
  List<NotificationModelPartenaire> notiList = [];
  List<PartenaireOfferModel> acceptedList = [];
  List<PartenaireOfferModel> refusedList = [];
  List<PartenaireOfferModel> loadingList = [];
  List<PartenaireOfferModel> allOffers = [];

  PartenaireOffre() {
    api = PartenaireApi();
    getOffer();
    firebase();
    getNotification();
    displayNotifications(notiList);
  }

  Future firebase() async {
    await FirebaseApi().addFcm();
  }

  var result = 1;
  var a = 0;

  var r = 0;

  var l = 0;

  Future refreshHome() async {
    await getOffer();
  }

  /// create offre
  Future<int> createOffre(CreateOffer offer, BuildContext context) async {
    await api.createOffre(offer).then((value) {
      value is Create;
      switch (value.code) {
        case HttpStatus.ok:
          {
            result = 1;
            getOffer();
            AnimatedSnackBar.rectangle(
              'Succes',
              value.errorMessage,
              type: AnimatedSnackBarType.success,
              brightness: Brightness.light,
            ).show(
              context,
            );
            notifyListeners();
          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            result = 0;
            print(value.errorMessage);
            AnimatedSnackBar.rectangle(
              'warning',
              value.errorMessage,
              type: AnimatedSnackBarType.warning,
              brightness: Brightness.light,
            ).show(
              context,
            );
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
            print(value.errorMessage);
            result = 0;
            AnimatedSnackBar.rectangle(
              'error',
              value.errorMessage,
              type: AnimatedSnackBarType.error,
              brightness: Brightness.light,
            ).show(
              context,
            );
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            result = 0;
            print(value.errorMessage);
            AnimatedSnackBar.rectangle(
              'error',
              value.errorMessage,
              type: AnimatedSnackBarType.error,
              brightness: Brightness.light,
            ).show(
              context,
            );
          }
          break;
      }
    });
    return result;
  }

  Future<void> snackbarStatus(title, message, context, type) {
    return AnimatedSnackBar.rectangle(title, message,
            type: type,
            snackBarStrategy: RemoveSnackBarStrategy(),
            brightness: Brightness.light,
            duration: Duration(seconds: 4))
        .show(
      context,
    );
  }

  showNotification() async {
    if (notiList.isNotEmpty) {
      print(
        notiList[0].status,
      );
      for (int i = 0; i < notiList.length; i++) {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
          priority: Priority.high,
        );
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: iOSPlatformChannelSpecifics);

        // Schedule the notification
        await flutterLocalNotificationsPlugin.show(
          notiList[i].id,
          notiList[i].title,
          notiList[i].status == ServiceConst.OFFRE_STATUS_ACCEPTED
              ? 'Offre Accepted '
              : 'Offer Refused',
          platformChannelSpecifics,
          payload: notiList[i].id.toString(),
        );
      }
    }
  }

  Future getNotification() async {
    await api.getLoggedNotification().then((value) {
      value is PartenaireOfferModel;
      switch (value.code) {
        case HttpStatus.ok:
          {
            notiList.clear();
            notiList = value.data.cast<NotificationModelPartenaire>();
            notifyListeners();

          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            print(value.message);
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
            print(value.message);
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            print(value.message);
          }
          break;
      }
    });
  }

  Future getOffer() async {
    await api.getPartenaireOffre().then((value) {
      value is PartenaireOfferModel;
      switch (value.code) {
        case HttpStatus.ok:
          {
            int i;
            acceptedList.clear();
            refusedList.clear();
            loadingList.clear();
            for (i = 0; i < value.data.length; i++) {
              if (value.data[i].status == OFFRE_STATUS_ACCEPTED) {
                acceptedList.add(value.data[i]);
              }
              if (value.data[i].status == OFFRE_STATUS_REFUSED) {
                refusedList.add(value.data[i]);
              }
              if (value.data[i].status == OFFRE_STATUS_LOADING) {
                print(value.data[i].status);
                loadingList.add(value.data[i]);
              }
            }

            notifyListeners();
            // AnimatedSnackBar.rectangle(
            //   'Succes',
            //   value.errorMessage,
            //   type: AnimatedSnackBarType.success,
            //   brightness: Brightness.light,
            // ).show(
            //   context,
            // );
          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            result = 0;
            print(value.errorMessage);
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
            print(value.errorMessage);
            result = 0;
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            result = 0;
            print(value.errorMessage);
          }
          break;
      }
    });
  }

  Future removeOffer(int offreId, BuildContext context) async {
    await api.deleteOffre(offreId).then((value) {
      value is FavorieDelete;
      switch (value.code) {
        case HttpStatus.ok:
          {
            acceptedList.removeWhere((element) => element.id == offreId);
            loadingList.removeWhere((element) => element.id == offreId);
            refusedList.removeWhere((element) => element.id == offreId);
            notifyListeners();
            snackbarStatus(
              'Success'.tr,
              'Offre deleted successfuly'.tr,
              context,
              AnimatedSnackBarType.success,
            );
          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            print(value.Message);
            snackbarStatus(
              'ERROR'.tr,
              value.Message.tr,
              context,
              AnimatedSnackBarType.error,
            );
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
                        print(value.Message);

            snackbarStatus(
              'WARNING'.tr,
              value.Message.tr,
              context,
              AnimatedSnackBarType.warning,
            );
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
                        print(value.Message);

            snackbarStatus(
              'ERROR'.tr,
              value.Message.tr,
              context,
              AnimatedSnackBarType.error,
            );
          }
          break;
      }
    });
  }
 AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
  Future<void> displayNotifications(
      List<NotificationModelPartenaire> notifications) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    int notificationId = 0;
    var notification;
    for (notification in notiList) {
      print('rrrrrr');
      await flutterLocalNotificationsPlugin.show(
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
  }

  List<PartenaireOfferModel> get partenaireAcceptedItems {
    return [...acceptedList];
  }

  List<PartenaireOfferModel> get partenaireRefusedItems {
    return [...refusedList];
  }

  List<PartenaireOfferModel> get partenaireLoadingItems {
    return [...loadingList];
  }

  _getIdUser() async {
    var userId = await MyCache.getUserId();

    return userId;
  }
}
