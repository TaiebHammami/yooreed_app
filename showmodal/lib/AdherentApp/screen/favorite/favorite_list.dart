import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/favorite.dart';
import '../../Models/offre_model.dart';
import 'favorite_item.dart';

class FavoriteList extends StatelessWidget {
  final List<Offer> listOffer;

   FavoriteList({super.key, required this.listOffer});


  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: ListView.builder(
          itemCount: listOffer.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ChangeNotifierProvider.value(
              value: listOffer[index],
              child: FavoriteItem(),
            );
          }),

    );
  }
}
