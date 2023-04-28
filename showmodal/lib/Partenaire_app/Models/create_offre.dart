import 'dart:io';

import 'package:flutter/material.dart';

class CreateOffer {
  late  int typeId;
  final String title;
  final String description;
  late  File image;
  late  String dateDebut;
  late  String dateFin;
  final String price;
  final String promo;

  CreateOffer({
    required this.typeId,
    required this.title,
    required this.description,
    required this.image,
    required this.dateDebut,
    required this.dateFin,
    required this.price,
    required this.promo,
  });
}
