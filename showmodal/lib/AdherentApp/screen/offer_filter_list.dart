import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/AdherentApp/Models/offre_model.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../main.dart';
import '../Provider/offer_provider.dart';

class OfferListFilter extends StatelessWidget {
  OfferListFilter(
      {Key? key,
      this.offer,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback? callback;
  final Offer? offer;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    DateTime? fin = DateTime.tryParse(offer!.dateFin);
    print(fin);
    // DateTime now = DateTime.now();
    // String difference = fin!.difference(now).toString();
    // //String differeneFormat = DateFormat().format(difference);
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: callback,
                child: SimpleShadow(
                  opacity: 0.1,
                  color: Theme.of(context).shadowColor,
                  offset: Offset(0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: <BoxShadow>[],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 2,
                                child: CachedNetworkImage(
                                  imageUrl: offer!.image,
                                  imageBuilder: (context, imageProvider) {
                                    return Hero(
                                        tag: offer!.id,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover)),
                                        ));
                                  },
                                  errorWidget: (context, _, __) {
                                    return Icon(CupertinoIcons
                                        .exclamationmark_triangle);
                                  },
                                ),
                              ),
                              Container(
                                color: Theme.of(context).bottomAppBarColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, top: 8, bottom: 8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                offer!.title,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 22,
                                                ),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    offer!.price,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey
                                                            .withOpacity(0.8)),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Icon(
                                                    FontAwesomeIcons.dollarSign,
                                                    size: 12,
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Row(
                                                  children: <Widget>[],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 16, top: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            '/per night',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey
                                                    .withOpacity(0.8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Consumer<OfferProvider>(
                                  builder: (BuildContext context, value,
                                      Widget? child) {
                                    return ZoomTapAnimation(
                                      child: IconButton(
                                        onPressed: () {
                                          if (offer!.isFavorite) {
                                            offer!.toggleFavorite();
                                            value.removeFav(offer!.id, offer);
                                          } else {
                                            offer!.toggleFavorite();
                                            value.addFav(offer!.id, offer);
                                          }
                                        },
                                        icon: Icon(
                                          offer!.isFavorite
                                              ? CupertinoIcons.heart_fill
                                              : CupertinoIcons.heart,
                                          size: 27,
                                          color: HexColor('#E9564B'),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
