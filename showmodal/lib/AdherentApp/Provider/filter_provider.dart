import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../API/result_api/offer _result_api.dart';
import '../API/servie_api.dart';
import '../Models/gouvernerat.dart';
import '../Models/offre_model.dart';
import '../Models/partenaire.dart';

class FilterProvider with ChangeNotifier {
  late AdherentApi api;
  List<Gouvernerat> gouverneratList = [];
  List<Partenaire> partenaires = [];
  List<Offer> offers = [];
  bool isLoading = true;

  FilterProvider() {
    api = AdherentApi();
    getGouvernerat();
  }
  void clear(){
    partenaires.clear();
    offers.clear();
    notifyListeners();
  }




  Future getGouvernerat() async {
    await api.getGouvernerats().then((value) {
      value is Location;
      notifyListeners();
      switch (value.code) {
        case HttpStatus.ok:
          {
            gouverneratList = value.data;
            gouverneratList.insert(
                0, Gouvernerat(id: 0, name: 'Select gouvernerat'));
            isLoading = false;
            notifyListeners();
          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            print(value.Message);
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
            print(value.Message);
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            print(value.Message);
          }
          break;
      }
    });
  }

  /// filter offers

  Future getOffersByType(int? secteurId, minPrice, maxPrice, typeOffer,
      BuildContext context) async {
    await api
        .offerFilter(secteurId, minPrice, maxPrice, typeOffer)
        .then((value) {
      value is OfferResult;
      notifyListeners();
      switch (value.code) {
        case HttpStatus.ok:
          {
            offers = value.data!;
            notifyListeners();
            if (offers.isEmpty) {
              AnimatedSnackBar(
                builder: ((context) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).bottomAppBarColor,
                        borderRadius: BorderRadius.circular(8)),
                    height: 50,
                    child: Text('filter_empty'.tr,style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 15
                    ),),
                  );
                }),
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            }
          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            AnimatedSnackBar.rectangle('warning', value.errorMessage,
                    type: AnimatedSnackBarType.warning,
                    brightness: Brightness.light,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom)
                .show(
              context,
            );
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
            AnimatedSnackBar.rectangle('Error', value.errorMessage,
                    type: AnimatedSnackBarType.error,
                    brightness: Brightness.light,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom)
                .show(
              context,
            );
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            AnimatedSnackBar.rectangle('warning', value.errorMessage,
                    type: AnimatedSnackBarType.warning,
                    brightness: Brightness.light,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom)
                .show(
              context,
            );
          }
          break;
      }
    });
  }

  Future getpartenaireByFilter(int? secteurId,int? gouverneratId ,int? villeId, BuildContext context) async {
    await api
        .partenaireFilter(secteurId, gouverneratId, villeId)
        .then((value) {
      value is UsersResult;
      switch (value.code) {
        case HttpStatus.ok:
          {
            partenaires = value.data!;
            notifyListeners();
            if (partenaires.isEmpty) {
              AnimatedSnackBar(
                builder: ((context) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).bottomAppBarColor,
                        borderRadius: BorderRadius.circular(8)),
                    height: 50,
                    child: Text('filter_empty'.tr,style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 15
                    ),),
                  );
                }),
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            }
          }
          break;
        case HttpStatus.BAD_GATEWAY:
          {
            AnimatedSnackBar.rectangle('warning', value.errorMessage,
                    type: AnimatedSnackBarType.warning,
                    brightness: Brightness.light,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom)
                .show(
              context,
            );
          }
          break;
        case HttpStatus.SERVICE_UNAVAILABLE:
          {
            AnimatedSnackBar.rectangle('Error', value.errorMessage,
                    type: AnimatedSnackBarType.error,
                    brightness: Brightness.light,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom)
                .show(
              context,
            );
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            AnimatedSnackBar.rectangle('warning', value.errorMessage,
                    type: AnimatedSnackBarType.warning,
                    brightness: Brightness.light,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom)
                .show(
              context,
            );
          }
          break;
      }
    });
  }
  List<Gouvernerat> get gouverneratListItems {
    return [...gouverneratList];
  }

  List<Offer> get filterOfferListItems {
    return [...offers];
  }
    List<Partenaire> get filterGetPartenaires {
    return [...partenaires];
  }
}
