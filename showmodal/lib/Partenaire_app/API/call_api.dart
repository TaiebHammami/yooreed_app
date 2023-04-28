import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:showmodal/AdherentApp/API/result_api/offer%20_result_api.dart';
import 'package:showmodal/Partenaire_app/Models/offer_partenaire.dart';
import 'package:showmodal/Service/service_const.dart';

import '../../AdherentApp/API/servie_api.dart';
import '../../AdherentApp/Models/notification.dart';
import '../../cache/shared_preference.dart';
import 'package:http/http.dart' as http;

import '../Models/create_offre.dart';
import '../Models/notification_partenaire.dart';

class PartenaireApi {
  final String globalUrl = "http://10.0.2.2:8000/api/";

  /// Create OFFRE
  Future<Create> createOffre(CreateOffer offer) async {
    final url = '${globalUrl}offre/';
    Create result;
    var token = await _getToken();
    var id = await _getIdUser();
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(_setHeaders(token));
      request.files
          .add(await http.MultipartFile.fromPath('image', offer.image.path));
      request.fields['user_id'] = id.toString();
      request.fields['title'] = offer.title;
      request.fields['description'] = offer.description;
      request.fields['prix'] = offer.price;
      request.fields['promo'] = offer.promo;
      request.fields['date_debut'] = offer.dateDebut;
      request.fields['date_fin'] = offer.dateFin;
      request.fields['type_id'] = offer.typeId.toString();
      var response = await request.send();

      if (response.statusCode == HttpStatus.created) {
        result = Create(HttpStatus.ok, 'OFFER_SUCCESS'.tr);
      } else {
        result = Create(HttpStatus.ok, 'OFFER_FAILURE'.tr);
      }
    } on SocketException {
      result = Create(HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = Create(HttpStatus.SERVICE_UNAVAILABLE, 'FORMAT'.tr);
    } catch (exception) {
      result = Create(HttpStatus.BAD_REQUEST, 'TRY_LATER'.tr);
    }
    return result;
  }

  Future<PartenaireOfferResult> getPartenaireOffre() async {
    PartenaireOfferResult result;
    List<PartenaireOfferModel> list = [];
    var token = await _getToken();
    var id = await _getIdUser() as int;

    try {
      final url = "http://10.0.2.2:8000/api/offre/$id";
      var response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      print(response.statusCode);
      final offers = json.decode(response.body)['data'];

      var offer;
      for (offer in offers) {
        var myOffer = PartenaireOfferModel.fromJson(offer);

        list.add(myOffer);
      }
      result = PartenaireOfferResult(list, HttpStatus.ok, '');
    } on SocketException {
      result =
          PartenaireOfferResult(list, HttpStatus.BAD_GATEWAY, 'CONNECTION'.tr);
    } on FormatException {
      result = PartenaireOfferResult(
          list, HttpStatus.serviceUnavailable, 'FORMAT'.tr);
    } catch (exception) {
      print(exception);
      result =
          PartenaireOfferResult(list, HttpStatus.badRequest, 'CONNECTION'.tr);
    }
    return result;
  }

  /// delete offre
  Future<FavorieDelete> deleteOffre(int offreId) async {
    var token = await _getToken();
    var userId = await _getIdUser() as int;
    FavorieDelete result;
    final url = "${ServiceConst.globalUrl}/offre/delete/$offreId";

    try {
      await http.delete(Uri.parse(url), headers: _setHeaders(token));
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

  /// function

  _setHeaders(token) => {
        HttpHeaders.contentTypeHeader: 'application/vnd.api+json',
        HttpHeaders.acceptHeader: 'application/vnd.api+json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };


    Future<NotificationResult> getLoggedNotification() async {
    var token = await _getToken();
    var userId = await _getIdUser();
    List<NotificationModelPartenaire> notiList = [];
    NotificationResult result;
    final url = "${ServiceConst.globalUrl}/partenaire-notification/$userId";
    try {
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      final notifications = json.decode(response.body)['data'];
      print(response.body);
      var noti;
      // list offer
      for (noti in notifications) {
        var myNoti = NotificationModelPartenaire.fromJson(noti);
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

























  Future<NotificationResult> getNotification() async {
    var token = await _getToken();
    var userId = await _getIdUser();
    List<NotificationModelPartenaire> notiList = [];
    NotificationResult result;
    final url = "${ServiceConst.globalUrl}/partenaire-notification/all/$userId";
    try {
      final response =
          await http.get(Uri.parse(url), headers: _setHeaders(token));
      final notifications = json.decode(response.body)['data'];
      print(response.body);
      var noti;
      // list offer
      for (noti in notifications) {
        var myNoti = NotificationModelPartenaire.fromJson(noti);
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

  _getToken() async {
    var token = await MyCache.getUser();

    return token;
  }

  _getIdUser() async {
    var userId = await MyCache.getUserId();

    return userId;
  }
}

class Create {
  final int code;

  final String errorMessage;

  Create(this.code, this.errorMessage);
}
