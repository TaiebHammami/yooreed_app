import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showmodal/AdherentApp/screen/partenaire_profile.dart';
import 'package:showmodal/AdherentApp/screen/secteur_partenaire_shimmer_effect.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../Authentification/authProvider/api_result.dart';
import '../../animation/fade_animation.dart';
import '../API/servie_api.dart';
import '../Models/partenaire.dart';

class SecteurParteanire extends StatelessWidget {
  final int id;

  List<Partenaire> users = <Partenaire>[];

  SecteurParteanire({super.key, required this.id});

  Future<void> makePhoneCall(String phoneNumber) async {
    final String telUrl = 'tel:$phoneNumber';
    if (await canLaunch(telUrl)) {
      await launch(telUrl);
    } else {
      throw 'Could not launch $telUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme
            .of(context)
            .bottomAppBarColor,
      ),
      body: FutureBuilder(
          future: AdherentApi().getPartenaireBySecteur(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              users.addAll(snapshot.data!.data);
              return PartenaireList(
                users: users,
              );
            }else if(snapshot.hasError){
                          return SecteurPartenaireShimmer();

            }
            return SecteurPartenaireShimmer();
          }),
    );
  }
}

class PartenaireList extends StatelessWidget {
  final List<Partenaire> users;

  PartenaireList({super.key, required this.users});

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.separated(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            Partenaire user = users[index];
            return FadeAnimation(1.2, Item(user: user));
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 8,
            );
          },
          itemCount: users.length),
    );
  }
}

class Item extends StatelessWidget {
  final Partenaire user;

  const Item({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      color: Theme
          .of(context)
          .shadowColor,
      opacity: 0.15,
      offset: Offset(0, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftJoined,
                  child: PartenaireOffres(),
                  childCurrent: PartenaireList(
                    users: [],
                  )));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme
                      .of(context)
                      .bottomAppBarColor,
                ),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              errorWidget: (context, url, _) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(Icons.error_outline),
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
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                );
                              },
                              imageUrl: user.image,
                              imageBuilder: (context, image) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(image: image)),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.prenom ?? 'default',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(fontSize: 16)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(user.adresse ?? 'adresse',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                          fontSize: 14,
                                          color: Get.isDarkMode
                                              ? Colors.white60
                                              : Colors.grey[600])),
                                ]),
                          )
                        ]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Container(
                              padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade200),
                              child: Text(
                                user.profession ?? 'profession',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(user.specialite ?? 'specialite',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(fontSize: 14)),
                            ),
                          ])
                        ],
                      ))
                ])),
            Positioned(
              right: 30,
              child: Container(
                margin: EdgeInsets.all(8),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green.withAlpha(30)),
                child: Center(
                  child: ZoomTapAnimation(
                    end: 0.1,
                    onTap: () async {
    final String telUrl = 'tel:${user.numero.toString()}';
    if (await canLaunch(telUrl)) {
      await launch(telUrl);
    } else {
      throw 'Could not launch $telUrl';
    }
  },
                    child: Icon(
                      Icons.phone,
                      size: 29,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
