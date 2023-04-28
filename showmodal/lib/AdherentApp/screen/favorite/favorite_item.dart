import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showmodal/AdherentApp/Models/favorite.dart';
import 'package:showmodal/AdherentApp/Models/offre_model.dart';
import 'package:showmodal/AdherentApp/Provider/offer_provider.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../screen/tabs/home_screen.dart';

class FavoriteItem extends StatefulWidget {
  @override
  State<FavoriteItem> createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  @override
  Widget build(BuildContext context) {
    final current = Provider.of<Offer>(context);
    final fav = Provider.of<OfferProvider>(context);
    return SimpleShadow(
      offset: Offset(0,0),
      color: Theme.of(context).shadowColor,
      opacity: 0.1,
      child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).bottomAppBarColor,
             ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, _) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.error_outline),
                          );
                        },
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.white,
                            child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                          );
                        },
                        imageUrl: current.image,
                        imageBuilder: (context, image) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(image: image,fit: BoxFit.fill)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(current.title,
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontSize: 18
                                ),),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              current.description.length > 100
                                  ? '${current.description.substring(0, 100)} ...'
                                  : current.description,
                              style: Theme.of(context).textTheme.caption,
                              textAlign: TextAlign.start,
                            ),
                          ]),
                    ),
                  ]),
                ),
                Consumer<OfferProvider>(
                  builder: (context, value, _) {
                    return ZoomTapAnimation(
                      child: GestureDetector(
                          onTap: () {
                            current.toggleFavorite();
                            value.removeFav(current.id, current);
                          },
                          child: AnimatedContainer(
                              height: 35,
                              padding: const EdgeInsets.all(5),
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.red.shade100)),
                              child: const Center(
                                  child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )))),
                    );
                  },
                ),
              ],
            ),
            //       SizedBox(height: 20,),
            //       Container(
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Row(
            //               children: [
            //                 Container(
            //                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(12),
            //                     color: Colors.grey.shade200
            //                   ),
            //                   child: Text('Specialité', style: TextStyle(color: Colors.black),),
            //                 ),
            //                 SizedBox(width: 10,),
            //                 Container(
            //                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(12),
            //
            //                   ),
            //                   child: Text('Profession',),),
            //  ]
            //                 )
            //               ],
            //             )
            // )
          ])),
    );
  }
}
