import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/animation/fade_animation.dart';

import '../../partenaire.dart';
import '../Models/offre_model.dart';
import '../Provider/filter_provider.dart';
import 'offer_filter_list.dart';

class OfferFilterResult extends StatefulWidget {
  const OfferFilterResult({super.key});



  @override
  State<OfferFilterResult> createState() => _OfferFilterResultState();
}

class _OfferFilterResultState extends State<OfferFilterResult>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  AnimationController? animationController;


  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final filter = Provider.of<FilterProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            filter.clear();
            Get.back();
          },
        ),
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 1,
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemCount: filter.filterOfferListItems.length,
            padding: const EdgeInsets.only(top: 8),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              final int count = filter.filterOfferListItems.length > 10 ? 10 : filter.filterOfferListItems.length;
              final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn)));
              animationController?.forward();
              return OfferListFilter(
                callback: () {
                  Get.to(() => DetailScreen(offer: filter.filterOfferListItems[index]));
                },
                offer: filter.filterOfferListItems[index],
                animation: animation,
                animationController: animationController!,
              );
            },
          ),
        ),
      ),
    );
  }
}
