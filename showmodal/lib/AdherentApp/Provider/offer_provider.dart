import 'dart:io';

import 'package:flutter/material.dart';

import 'package:showmodal/AdherentApp/Models/offre_model.dart';
import 'package:showmodal/cache/shared_preference.dart';

import '../../Authentification/authProvider/api_result.dart';

import '../../firebaseApi/firebaseApi.dart';
import '../API/result_api/offer _result_api.dart';
import '../API/servie_api.dart';
import '../Models/favorite.dart';

class OfferProvider with ChangeNotifier {
  int yooreed = 1;
  int fullYear = 2;
  int frameTime = 3;
  String role = '';
  List<typeOffer> offerType = [
    typeOffer('Yooreed', 1),
    typeOffer('permanent', 2),
    typeOffer('par date', 3)
  ];

  Future getRole() async {
    role = await MyCache.getUserRole();
    notifyListeners();
  }

  late AdherentApi api;
  var user = User(
      id: 0,
      nom: '',
      prenom: '',
      email: '',
      image: '',
      cin: 0,
      numero: 0,
      firstTime: 0,
      adresse: '',
      responsable: '');

  var userByOffer = User(
      id: 0,
      nom: '',
      prenom: '',
      email: '',
      image: '',
      cin: 0,
      numero: 0,
      firstTime: 0,
      adresse: '',
      responsable: '');

  var isLoading = true;
  List<Offer> peopleAlsoLikes = <Offer>[];

  List<Offer> allOffer = <Offer>[];
  List<Offer> favoriteOffer = <Offer>[];
  List<Offer> yooreedOfferList = <Offer>[];
  List<Offer> fullYearOfferList = <Offer>[];
  List<Offer> frameTimeOfferList = <Offer>[];

  // Constractor
  OfferProvider() {
    getRole();
    api = AdherentApi();
    getOffersByType(yooreed);
    getOffersByType(fullYear);
    getOffersByType(frameTime);
    getFavoriteOffers();
    getPeopleAlsoLikes();
    getUser();
    firebase();
  }

  Future firebase() async {
    await FirebaseApi().addFcm();
  }

  Future getOffersByType(int id) async {
    await api.getOffersByType(id).then((value) {
      value is OfferResult;
      notifyListeners();
      switch (value.code) {
        case HttpStatus.ok:
          {
            allOffer.addAll(value.data!);
            if (id == yooreed) {
              yooreedOfferList = value.data!;
              isLoading = false;
              notifyListeners();
            }
            if (id == fullYear) {
              fullYearOfferList.addAll(value.data!);
              notifyListeners();
            }
            if (id == frameTime) {
              frameTimeOfferList.addAll(value.data!);
              notifyListeners();
            }
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

  /// people also likes
  Future getPeopleAlsoLikes() async {
    await api.getPeopleAlsoLikes().then((value) {
      value is OfferResult;
      notifyListeners();
      switch (value.code) {
        case HttpStatus.ok:
          {
            peopleAlsoLikes = value.data!;
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

  Future getFavoriteOffers() async {
    await api.getFavoriteOffer().then((value) {
      value is OfferResult;

      switch (value.code) {
        case HttpStatus.ok:
          {
            favoriteOffer.addAll(value.data!);
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

  Future getUser() async {
    await api.getUser().then((value) {
      value is UsersResult;

      switch (value.code) {
        case HttpStatus.ok:
          {
            var ser = value.data as User;
            user = User(
                id: ser.id,
                nom: ser.nom,
                prenom: ser.prenom,
                email: ser.email,
                image: ser.image,
                cin: ser.cin,
                numero: ser.numero,
                firstTime: ser.firstTime,
                adresse: ser.adresse,
                responsable: ser.responsable);
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

  Future getUserById(id) async {
    await api.getUserById(id).then((value) {
      value is UsersResult;

      switch (value.code) {
        case HttpStatus.ok:
          {
            var ser = value.data as User;
            userByOffer = User(
                id: ser.id,
                nom: ser.nom,
                prenom: ser.prenom,
                email: ser.email,
                image: ser.image,
                cin: ser.cin,
                numero: ser.numero,
                firstTime: ser.firstTime,
                adresse: ser.adresse,
                responsable: ser.responsable);
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

  /// favorie
  Future removeFav(int id, fav) async {
    await api.deleteFavorie(id).then((value) {
      value is FavorieDelete;
      switch (value.code) {
        case HttpStatus.ok:
          {
            favoriteOffer.remove(fav);
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

  void addFav(int id, fav) async {
    await api.AddFavorite(id).then((value) {
      value is FavorieDelete;
      switch (value.code) {
        case HttpStatus.ok:
          {
            favoriteOffer.add(fav);
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

  /// getters
  List<Offer> get yooreedItems {
    return [...yooreedOfferList];
  }

  List<Offer> get fullYearItems {
    return [...fullYearOfferList];
  }

  List<Offer> get frameTimeItems {
    return [...frameTimeOfferList];
  }

  List<Offer> get favoriteOfferItems {
    return [...favoriteOffer];
  }

  List<Offer> get peopleAlsoLikesItems {
    return [...peopleAlsoLikes];
  }
}

class typeOffer {
  final String name;

  final int id;

  bool isSelected = false;

  typeOffer(this.name, this.id);
}
