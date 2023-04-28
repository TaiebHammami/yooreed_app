


import 'package:showmodal/AdherentApp/Models/offre_model.dart';

import '../../../Partenaire_app/Models/offer_partenaire.dart';
import '../../Models/favorite.dart';
import '../../Models/secteur.dart';

class OfferResult {

  final List<Offer>? data ;
  final int code ;
  final errorMessage;

  OfferResult(this.data, this.code, this.errorMessage);


}
class PartenaireOfferResult {

  final List<PartenaireOfferModel> data ;
  final int code ;
  final errorMessage;

  PartenaireOfferResult(this.data, this.code, this.errorMessage);


}
class FavoriteResult {

  final List<Favorite> data ;
  final int code ;
  final errorMessage;

  FavoriteResult(this.data, this.code, this.errorMessage);


}

class SecteurResult {

  final List<Secteur>? data ;
  final int code ;
  final errorMessage;

  SecteurResult(this.data, this.code, this.errorMessage);


}


class UsersResult {
final dynamic? data ;
final int code ;
final String errorMessage ;

  UsersResult(this.data, this.code, this.errorMessage);




}