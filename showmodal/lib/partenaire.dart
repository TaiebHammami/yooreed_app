import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/Authentification/authProvider/api_result.dart';
import 'package:showmodal/theme/app_theme.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'AdherentApp/API/result_api/offer _result_api.dart';
import 'AdherentApp/API/servie_api.dart';
import 'AdherentApp/Models/offre_model.dart';
import 'AdherentApp/Provider/offer_provider.dart';
import 'main.dart';

class DetailScreen extends StatefulWidget {
  final Offer offer;

  const DetailScreen({super.key, required this.offer});

  @override
  _DetailScreenState createState() => _DetailScreenState(offer);
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  final Offer offer;

  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  _DetailScreenState(this.offer);
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {

    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });


  }

  @override
  Widget build(BuildContext context) {
  //  final user = Provider.of<OfferProvider>(context).getUserById(offer.id);
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    print(Provider.of<OfferProvider>(context).userByOffer.responsable);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Hero(
                    tag: offer.id,
                    child: Image.network(
                      offer.image,
                      fit: BoxFit.fill,
                    )),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.57,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).bottomAppBarColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(offset: const Offset(1.1, 1.1), blurRadius: 10.0),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: infoHeight,
                        maxHeight:
                            tempHeight > infoHeight ? tempHeight : infoHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                    //           child: Row(
                    //             children: [
                    //               SimpleShadow(
                    // offset: Offset(0, 0),
                    // sigma: 1,
                    // opacity: 0.1,
                    // child: CircleAvatar(
                    //   backgroundColor:
                    //       Get.isDarkMode ? HexColor('#E9564B') : Colors.white,
                    //   radius: 24,
                    //   child: CircleAvatar(
                    //     radius: 22.5,
                    //     backgroundImage:   NetworkImage(usersResult.data == null ? '':usersResult.data.image),
                    //   ),
                    // )),
                    //               SizedBox(width: 8,),
                    //
                    //               Text(usersResult.data == null ? '':usersResult.data.responsable,
                    //                 style: Theme.of(context).textTheme.caption,)
                    //
                    //             ],
                    //           )
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, left: 18, right: 16),
                          child: Text(offer.title,
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                      letterSpacing: 0.27,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 8, top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                offer.price,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 22,
                                  letterSpacing: 0.27,
                                ),
                              ),
                              LikeButton(
                                size: 30,
                                circleColor: CircleColor(
                                    start: Color(0xff00ddff),
                                    end: Color(0xff0099cc)),
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor: Color(0xff33b5e5),
                                  dotSecondaryColor: Color(0xff0099cc),
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    Icons.thumb_up_alt_sharp,
                                    color:
                                        offer.liked ? Colors.blue : Colors.grey,
                                    size: 30,
                                  );
                                },
                                likeCount: offer.like,
                              ),
                            ],
                          ),
                        ),
                        // AnimatedOpacity(
                        //   duration: const Duration(milliseconds: 500),
                        //   opacity: opacity1,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8),
                        //     child: Row(
                        //       children: <Widget>[
                        //         getTimeBoxUI('24', 'Classe'),
                        //         getTimeBoxUI('2hours', 'Time'),
                        //         getTimeBoxUI('24', 'Seat'),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              child: Text(
                                offer.description,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14,
                                  letterSpacing: 0.27,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: opacity3,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, bottom: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 48,
                                  height: 48,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(16.0),
                                      ),
                                      border: Border.all(),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                // Expanded(
                                //   child: Container(
                                //     height: 48,
                                //     decoration: BoxDecoration(
                                //       borderRadius: const BorderRadius.all(
                                //         Radius.circular(16.0),
                                //       ),
                                //       boxShadow: <BoxShadow>[
                                //         BoxShadow(
                                //             offset: const Offset(1.1, 1.1),
                                //             blurRadius: 10.0),
                                //       ],
                                //     ),
                                //     child: Center(
                                //       child: Text(
                                //         'Join Course',
                                //         textAlign: TextAlign.left,
                                //         style: TextStyle(
                                //           fontWeight: FontWeight.w600,
                                //           fontSize: 18,
                                //           letterSpacing: 0.0,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.53,
            right: 35,
            child: ScaleTransition(
              alignment: Alignment.center,
              scale: CurvedAnimation(
                  parent: animationController!, curve: Curves.fastOutSlowIn),
              child: Consumer<OfferProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                return ZoomTapAnimation(
                  onTap: (){

                            if (offer.isFavorite) {
                              offer.toggleFavorite();
                              value.removeFav(offer.id, offer);
                            } else {
                              offer.toggleFavorite();
                              value.addFav(offer.id, offer);
                            }

                  },
                  child: Card(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    elevation: 10.0,
                    child: Container(
                        width: 60,
                        height: 60,
                        child: Center(
                            child:  Icon(
                            offer.isFavorite!
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: HexColor('#E9564B'),
                              size: 28,
                          ),
                        )),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SizedBox(
              width: AppBar().preferredSize.height,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.nearlyBlack,
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget getTimeBoxUI(String text1, String txt2) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: AppTheme.nearlyBlack,
  //         borderRadius: const BorderRadius.all(Radius.circular(16.0)),
  //         boxShadow: <BoxShadow>[
  //           BoxShadow(
  //               color: AppTheme.nearlyBlack.withOpacity(0.2),
  //               offset: const Offset(1.1, 1.1),
  //               blurRadius: 8.0),
  //         ],
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.only(
  //             left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               text1,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 14,
  //                 letterSpacing: 0.27,
  //                 color: AppTheme.nearlyBlack,
  //               ),
  //             ),
  //             Text(
  //               txt2,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.w200,
  //                 fontSize: 14,
  //                 letterSpacing: 0.27,
  //                 color: AppTheme.nearlyBlack,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
