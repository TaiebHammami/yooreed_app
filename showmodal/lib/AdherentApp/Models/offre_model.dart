import 'package:flutter/material.dart';

class Offer with ChangeNotifier {
  final int id;

  final int like;
  final int typeId;
  final String title;
  final String description;
  final String image;
  final String dateDebut;
  final String dateFin;
  final String price;
  final int promo;
  final bool liked;
  late bool isFavorite;

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Offer(
      {required this.id,
      required this.like,
      required this.typeId,
      required this.title,
      required this.description,
      required this.image,
      required this.dateDebut,
      required this.dateFin,
      required this.price,
      required this.promo,
      required this.liked,
      required this.isFavorite});

  factory Offer.fromJson(Map<String, dynamic?> json) {
    return Offer(
      id: json['id'],
      typeId: json['type_id'],
      title: json['title'],
      description: json['description'],
      dateDebut: json['date_debut'],
      dateFin: json['date_fin'],
      price: json['prix'],
      promo: json['promo'],
      image: json['image'],
      like: json['like'],
      liked: json['liked'],
      isFavorite: json['is_favorite'],
    );
  }
}
