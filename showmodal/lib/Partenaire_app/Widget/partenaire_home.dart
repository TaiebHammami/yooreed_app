import 'package:flutter/material.dart';

import '../Models/offer_partenaire.dart';
import 'offer_item.dart';

class PartenaireHomeList extends StatelessWidget {
  final List<PartenaireOfferModel> offerList;

  const PartenaireHomeList({super.key, required this.offerList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
        itemCount: offerList.length,
        itemBuilder: (context, index) {
          return OfferItem(
            offer: offerList[index],
          );
        });
  }
}
