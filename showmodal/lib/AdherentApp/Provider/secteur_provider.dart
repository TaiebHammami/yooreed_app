import 'dart:io';

import 'package:flutter/material.dart';
import 'package:showmodal/AdherentApp/API/result_api/offer%20_result_api.dart';
import 'package:showmodal/AdherentApp/Models/secteur.dart';

import '../API/servie_api.dart';

class SecteurProvider with ChangeNotifier {
  late AdherentApi api;

  var isLoading = true;

  List<Secteur> secteurList = <Secteur>[];

  SecteurProvider() {
    api = AdherentApi();
    getAllSeteur();
  }

  Future getAllSeteur() async {
    await api.getSecteurs().then((value) {
      value is SecteurResult;
      print(value.errorMessage);
      notifyListeners();
      switch (value.code) {
        case HttpStatus.ok:
          {
            secteurList = value.data!;
            print(secteurList);
            isLoading = false;
            notifyListeners();
          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            print(value.errorMessage);
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
            print(value.errorMessage);
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            print(value.errorMessage);
          }
          break;
      }
    });
  }

  /// getters
  List<Secteur> get secteurItems {
    return [...secteurList];
  }
}
