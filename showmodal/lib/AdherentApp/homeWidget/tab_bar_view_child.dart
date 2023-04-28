import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/AdherentApp/Models/offre_model.dart';
import 'package:showmodal/AdherentApp/Provider/offer_provider.dart';
import 'package:showmodal/AdherentApp/screen/detail_screen.dart';
import 'package:showmodal/partenaire.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../Service/service_const.dart';
import '../../main.dart';

class TabViewChild extends StatelessWidget {
  const TabViewChild({super.key, required this.list});

  final List<Offer> list;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OfferProvider>(context);
    var size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: list.length,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        Offer current = list[index];
        return GestureDetector(
          onTap: () {
            Get.to(() => DetailScreen(offer: current));
          },
          child: Stack(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                height: size.height,
                margin: const EdgeInsets.all(10.0),
                width: size.width * 0.6,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: current.image,
                  imageBuilder: (context, imageProvider) {
                    return SimpleShadow(
                      sigma: 1,
                      opacity: 0.04,
                      child: Hero(
                          tag: current.id,
                          child: Container(
                            height: size.height * 0.45,
                            margin: const EdgeInsets.all(10.0),
                            width: size.width * 0.6,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  // BoxShadow(color: Colors.black26,blurRadius: 1)
                                ],
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                    image: NetworkImage(current.image),
                                    fit: BoxFit.fill)),
                          )),
                    );
                  },
                  errorWidget: (context, _, __) {
                    return Icon(CupertinoIcons.exclamationmark_triangle);
                  },
                ),
              ),
              Positioned(
                  top: 18,
                  right: 18,
                  child: Consumer<OfferProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      return ZoomTapAnimation(
                        child: IconButton(
                          onPressed: () {
                            if (current.isFavorite) {
                              current.toggleFavorite();
                              value.removeFav(current.id, current);
                            } else {
                              current.toggleFavorite();
                              value.addFav(current.id, current);
                            }
                          },
                          icon: Icon(
                            current.isFavorite!
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: HexColor('#E9564B'),
                          ),
                        ),
                      );
                    },
                  )),
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   top: size.height * 0.2,
              //   child: Container(
              //     margin: const EdgeInsets.all(10.0),
              //     width: size.width * 0.53,
              //     height: size.height * 0.2,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(15),
              //       gradient: const LinearGradient(
              //         colors: [
              //           Color.fromARGB(153, 0, 0, 0),
              //           Color.fromARGB(118, 29, 29, 29),
              //           Color.fromARGB(54, 0, 0, 0),
              //           Color.fromARGB(0, 0, 0, 0),
              //         ],
              //         begin: Alignment.bottomCenter,
              //         end: Alignment.topCenter,
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                  left: size.width * 0.07,
                  bottom: size.height * 0.045,
                  child: Text(current.title)),
              Positioned(
                left: size.width * 0.07,
                bottom: size.height * 0.025,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    Text('title')
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
