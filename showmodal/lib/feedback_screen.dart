import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/AdherentApp/API/servie_api.dart';
import 'package:showmodal/theme/app_theme.dart';

import 'AdherentApp/Provider/offer_provider.dart';
import 'AdherentApp/screen/favorite/favorite_list.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final offerProvider = Provider.of<OfferProvider>(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      color: isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
      child: SafeArea(
        top: false,
        child: Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 16),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "    You have ${offerProvider.favoriteOfferItems.length} favorites")),
              ),
              title: const Text('My favorite'),
              titleTextStyle:
                  Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 25),
              elevation: 0.7,
              backgroundColor: Theme.of(context).bottomAppBarColor,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                child: FavoriteList(
                  listOffer: offerProvider.favoriteOfferItems,
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: TextField(
                maxLines: null,
                onChanged: (String txt) {},
                style: const TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  color: AppTheme.dark_grey,
                ),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your feedback...'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
