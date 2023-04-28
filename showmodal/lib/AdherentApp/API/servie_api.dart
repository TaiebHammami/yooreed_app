import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:showmodal/AdherentApp/API/result_api/offer%20_result_api.dart';
import 'package:showmodal/AdherentApp/Models/notification.dart';
import 'package:showmodal/AdherentApp/Models/offre_model.dart';
import 'package:showmodal/AdherentApp/Models/secteur.dart';
import 'package:showmodal/AdherentApp/Models/ville.dart';
import 'package:showmodal/Authentification/authProvider/api_result.dart';

import '../../Service/service_const.dart';
import '../../cache/shared_preference.dart';
import '../../firebaseApi/firebaseApi.dart';
import '../Models/favorite.dart';
import '../Models/gouvernerat.dart';
import '../Models/partenaire.dart';

class AdherentApi {
  /// get offers by type Yooreed , full year ...
  Future<OfferResult> getOffersByType(int id) async {
    var token = await _getToken();
    var userId = await _getIdUser() as int;
    final url = "${ServiceConst.globalUrl}/offre/$id/$userId";
    OfferResult result;

    try {
      final listOffer = <Offer>[];
      // response
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      final offers = json.decode(response.body)['data'];
      var offer;
      print(response.body);
      // list offer
      for (offer in offers) {
        var myOffer = Offer.fromJson(offer);
        listOffer.add(myOffer);
      }

      result = OfferResult(
          listOffer, HttpStatus.ok, json.decode(response.body)['message']);
    } on SocketException {
      result = OfferResult(null, HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = OfferResult(
          null, HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = OfferResult(null, HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  ///get people also likes
  Future<OfferResult> getPeopleAlsoLikes() async {
    var token = await _getToken();
    var userId = await _getIdUser() as int;
    final url = "${ServiceConst.globalUrl}/like/$userId";
    OfferResult result;

    try {
      final listOffer = <Offer>[];
      // response
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      final offers = json.decode(response.body)['data'];
      var offer;
      // list offer
      for (offer in offers) {
        var myOffer = Offer.fromJson(offer);
        listOffer.add(myOffer);
      }

      result = OfferResult(
          listOffer, HttpStatus.ok, json.decode(response.body)['message']);
    } on SocketException {
      result = OfferResult(null, HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = OfferResult(
          null, HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = OfferResult(null, HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  /// get secteurs
  Future<SecteurResult> getSecteurs() async {
    var token = await _getToken();
    final url = "${ServiceConst.globalUrl}/secteur";
    SecteurResult result;
    try {
      final listSecteur = <Secteur>[];
      // response
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      final secteurs = json.decode(response.body)['data'];

      var secteur;
      // list offer

      for (secteur in secteurs) {
        var MySector = Secteur.fromJson(secteur);
        listSecteur.add(MySector);
      }

      result = SecteurResult(
          listSecteur, HttpStatus.ok, json.decode(response.body)['message']);
    } on SocketException {
      result = SecteurResult(null, HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = SecteurResult(
          null, HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result =
          SecteurResult(null, HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  /// get partenaire by secteur
  Future<UsersResult> getPartenaireBySecteur(int secteurId) async {
    var token = await _getToken();
    final url = "${ServiceConst.globalUrl}/secteur/partenaire/$secteurId";
    UsersResult result;
    try {
      final listUsers = <Partenaire>[];
      // response
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      final users = json.decode(response.body)['data'];
      print(users);

      var user;
      // list offer

      for (user in users) {
        var MyUser = Partenaire.fromJson(user);
        listUsers.add(MyUser);
      }

      result = UsersResult(
          listUsers, HttpStatus.ok, json.decode(response.body)['message']);
    } on SocketException {
      result = UsersResult(null, HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = UsersResult(
          null, HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = UsersResult(null, HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  Future<OfferResult> getFavoriteOffer() async {
    var token = await _getToken();
    var userId = await _getIdUser() as int;
    final url = "${ServiceConst.globalUrl}/favorites-offers/$userId";
    OfferResult result;

    try {
      final listOffer = <Offer>[];
      // response
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      final offers = json.decode(response.body)['data'];
      print(response.body);
      var offer;
      // list offer
      for (offer in offers) {
        var myOffer = Offer.fromJson(offer);
        listOffer.add(myOffer);
      }

      result = OfferResult(
          listOffer, HttpStatus.ok, json.decode(response.body)['message']);
    } on SocketException {
      result = OfferResult([], HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = OfferResult(
          [], HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      print(exception.toString());
      result = OfferResult([], HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  /// function
  _setHeaders(token) => {
        HttpHeaders.contentTypeHeader: 'application/vnd.api+json',
        HttpHeaders.acceptHeader: 'application/vnd.api+json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

  _getToken() async {
    var token = await MyCache.getUser();

    return token;
  }

  _getIdUser() async {
    var userId = await MyCache.getUserId();

    return userId;
  }

  /// delete favorite offer
  Future<FavorieDelete> deleteFavorie(int favId) async {
    var token = await _getToken();
    var userId = await _getIdUser() as int;
    FavorieDelete result;
    final url =
        "${ServiceConst.globalUrl}/favorites-offers/delete/$userId/$favId";

    try {
      // response
      final response =
          await http.delete(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      // list offer
      result = FavorieDelete(HttpStatus.ok, 'ok');
    } on SocketException {
      result = FavorieDelete(HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result =
          FavorieDelete(HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = FavorieDelete(HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  Future<UsersResult> getUser() async {
    var token = await _getToken();
    var userId = await _getIdUser() as int;
    final url = "${ServiceConst.globalUrl}/auth/user/$userId";
    UsersResult result;
    try {
      // response
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      final user = json.decode(response.body)['data'];

      // list offer
      var MyUser = User.fromJson(user);
      print(MyUser.nom);

      result = UsersResult(
          MyUser, HttpStatus.ok, json.decode(response.body)['message']);
    } on SocketException {
      result = UsersResult(null, HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = UsersResult(
          null, HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = UsersResult(null, HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  /// Add Favorite
  Future<FavorieDelete> AddFavorite(int favId) async {
    var token = await _getToken();
    var userId = await _getIdUser() as int;
    FavorieDelete result;
    final url = "${ServiceConst.globalUrl}/favorites-offers/add/$userId/$favId";

    try {
      final response =
          await http.post(Uri.parse(url), headers: _setHeaders(token));

      result = FavorieDelete(HttpStatus.ok, 'ok');
    } on SocketException {
      result = FavorieDelete(HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result =
          FavorieDelete(HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = FavorieDelete(HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  /// get notification
  Future<NotificationResult> getNotification() async {
    var token = await _getToken();
    List<NotificationModel> notiList = [];
    NotificationResult result;
    final url = "${ServiceConst.globalUrl}/notification/adherent";

    try {
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      final notifications = json.decode(response.body)['data'];
      print(response.body);
      var noti;
      // list offer
      for (noti in notifications) {
        var myNoti = NotificationModel.fromJson(noti);
        notiList.add(myNoti);
      }

      result = NotificationResult(HttpStatus.ok, 'ok', notiList);
    } on SocketException {
      result = NotificationResult(HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr, '');
    } on FormatException {
      result = NotificationResult(
          HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr, '');
    } catch (exception) {
      result =
          NotificationResult(HttpStatus.BAD_REQUEST, exception.toString(), '');
    }
    return result;
  }

  /// get ville
  Future<Location> getGouvernerats() async {
    var token = await _getToken();
    List<Gouvernerat> gouverneratList = [];
    Location result;
    final url = "${ServiceConst.globalUrl}/filter/";

    try {
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      final all = json.decode(response.body)['data'];
      print(response.body);
      var gouvernerat;
      // list offer
      for (gouvernerat in all) {
        var myGouvernerat = Gouvernerat.fromJson(gouvernerat);
        gouverneratList.add(myGouvernerat);
      }

      result = Location(HttpStatus.ok, '', gouverneratList);
    } on SocketException {
      result = Location(HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr, '');
    } on FormatException {
      result =
          Location(HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr, '');
    } catch (exception) {
      result = Location(HttpStatus.BAD_REQUEST, exception.toString(), '');
    }
    return result;
  }

  Future<Location> getVille(int id) async {
    var token = await _getToken();
    List<Ville> VilleList = [];
    Location result;
    final url = "${ServiceConst.globalUrl}/filter/$id";

    try {
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      final all = json.decode(response.body)['data'];
      print(response.body);
      var ville;

      for (ville in all) {
        var myGouvernerat = Ville.fromJson(ville);
        VilleList.add(myGouvernerat);
      }

      result = Location(HttpStatus.ok, '', VilleList);
    } on SocketException {
      result = Location(HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr, '');
    } on FormatException {
      result =
          Location(HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr, '');
    } catch (exception) {
      result = Location(HttpStatus.BAD_REQUEST, exception.toString(), '');
    }
    return result;
  }

  /// offer filter

  Future<OfferResult> offerFilter(
      int? secteurId, double minPrice, double maxPrice, int typeOffer) async {
    var token = await _getToken();
    var userId = await _getIdUser() as int;
    var url;
    if (secteurId == null) {
      url =
          '${ServiceConst.globalUrl}/offre/filter/$userId/?typeId=${typeOffer}&priceRange=$minPrice-$maxPrice';
    } else {
      url =
          '${ServiceConst.globalUrl}/offre/filter/$userId/?secteurId=$secteurId&typeId=${typeOffer}&priceRange=$minPrice-$maxPrice';
    }

    OfferResult result;

    try {
      final listOffer = <Offer>[];
      // response
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      final offers = json.decode(response.body)['data'];
      var offer;
      print(response.body);
      // list offer
      for (offer in offers) {
        var myOffer = Offer.fromJson(offer);
        listOffer.add(myOffer);
      }

      result = OfferResult(
          listOffer, HttpStatus.ok, json.decode(response.body)['message']);
    } on SocketException {
      result = OfferResult(null, HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = OfferResult(
          null, HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = OfferResult(null, HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  /// search by title
  Future<List<Offer>> offerSearch(String searchKey) async {
    var token = await _getToken();
    var userId = await _getIdUser() as int;
    var url = '${ServiceConst.globalUrl}/offre/filter/$userId/$searchKey';
    OfferResult result;

    try {
      final listOffer = <Offer>[];
      // response
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      final offers = json.decode(response.body)['data'];
      var offer;
      print(response.body);
      // list offer
      for (offer in offers) {
        var myOffer = Offer.fromJson(offer);
        listOffer.add(myOffer);
      }

      return listOffer;
    } catch (exception) {
      throw Exception(exception);
    }
  }

  Future<UsersResult> getUserById(Id) async {
    var token = await _getToken();
    final url = "${ServiceConst.globalUrl}/auth/user/$Id";
    UsersResult result;
    try {
      // response
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      final user = json.decode(response.body)['data'];

      // list offer
      var MyUser = User.fromJson(user);
      print(MyUser.nom);

      result = UsersResult(
          MyUser, HttpStatus.ok, json.decode(response.body)['message']);
    } on SocketException {
      result = UsersResult(null, HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = UsersResult(
          null, HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = UsersResult(null, HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }

  /// partenaire filter
  /// ////////////////////////////////////

  Future<UsersResult> partenaireFilter(
      int? secteurId, int? gouverneratId, int? villeId) async {
    var token = await _getToken();

    var url;
    if (secteurId == null && villeId == null) {
      url =
          "${ServiceConst.globalUrl}/filter/partenaire?gouverneratId=$gouverneratId";
    }
    if (secteurId == null && villeId != null && gouverneratId != null) {
      url =
          "${ServiceConst.globalUrl}/filter/partenaire?gouverneratId=$gouverneratId&villeId=$villeId";
    }
    if (secteurId != null && villeId == null && gouverneratId == null) {
      url = "${ServiceConst.globalUrl}/filter/partenaire?secteurId=$secteurId";
    }
    UsersResult result;
    try {
      final listUsers = <Partenaire>[];
      // response
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      // json to offer object$

      final users = json.decode(response.body)['data'];
      print(users);

      var user;
      // list offer

      for (user in users) {
        var MyUser = Partenaire.fromJson(user);
        listUsers.add(MyUser);
      }
      result = UsersResult(
          listUsers, HttpStatus.ok, json.decode(response.body)['message']);
    } on SocketException {
      result = UsersResult([], HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = UsersResult(
          null, HttpStatus.SERVICE_UNAVAILABLE, 'CHECK_CREDENTIALS'.tr);
    } catch (exception) {
      result = UsersResult([], HttpStatus.BAD_REQUEST, exception.toString());
    }
    return result;
  }
}

class FavorieDelete {
  final int code;

  final String Message;

  FavorieDelete(this.code, this.Message);
}

class Location {
  final int code;
  final dynamic data;
  final String Message;

  Location(this.code, this.Message, this.data);
}

class NotificationResult {
  final int code;
  final String message;
  final dynamic data;

  NotificationResult(this.code, this.message, this.data);
}
