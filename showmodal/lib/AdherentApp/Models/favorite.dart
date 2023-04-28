
import 'package:flutter/foundation.dart';

class Favorite with ChangeNotifier {
  final int id;
  final int userId;
  final int like;
  final int typeId;
  final String title;
  final String description;
  final String image;
  final String dateDebut;
  final String dateFin;
  final String price;
  final int promo;

  Favorite(
      {required this.id,
      required this.userId,
      required this.like,
      required this.typeId,
      required this.title,
      required this.description,
      required this.image,
      required this.dateDebut,
      required this.dateFin,
      required this.price,
      required this.promo,
      });

  factory Favorite.fromJson(Map<String, dynamic?> json) {
    return Favorite(
      id: json['id'],
      userId: json['user_id'],
      typeId: json['type_id'],
      title: json['title'],
      description: json['description'],
      dateDebut: json['date_debut'],
      dateFin: json['date_fin'],
      price: json['prix'],
      promo: json['promo'],
      image: json['image'],
      like: json['like'],
    );
  }

}