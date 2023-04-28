import 'package:animate_do/animate_do.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/AdherentApp/Models/offre_model.dart';
import 'package:showmodal/AdherentApp/Provider/offer_provider.dart';
import 'package:showmodal/AdherentApp/Provider/secteur_provider.dart';
import 'package:showmodal/theme/app_theme.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../Connectivity/connection.dart';
import '../../../partenaire.dart';
import '../../API/servie_api.dart';
import '../../Models/secteur.dart';
import '../../Provider/offer_provider.dart';
import '../../Provider/offer_provider.dart';
import '../../homeWidget/secteur_gridview.dart';
import '../../homeWidget/tab_bar_view_child.dart';
import '../filter_screen.dart';
import '../secteur partenaire.dart';
import '../secteur_partenaire_shimmer_effect.dart';
import '../../../cache/shared_preference.dart';
import '../../../main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // List<HomeList> homeList = HomeList.homeList;
  AnimationController? animationController;
  bool multiple = true;

  late final TabController tabController;
  late List<Offer> searchResult;

  @override
  void initState() {
    searchResult = [];
    print(_getIdUser());
    tabController = TabController(length: 3, vsync: this);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  _getIdUser() async {
    var userId = await MyCache.getUserId();

    return userId;
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  var opacityText = 0.1;

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  _getToken() async {
    var token = await MyCache.getUser();
    print(token);
    return token;
  }

  var opacity = 0.08;
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final connectivity = Provider.of<ConnectivityStatus>(context);
    final offerProvider = Provider.of<OfferProvider>(context);
    final secteurProvider = Provider.of<SecteurProvider>(context);
    print(offerProvider.frameTimeItems);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    print(offerProvider.user.email);
    print(offerProvider.peopleAlsoLikesItems);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.list_bullet),
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 0.7,
        centerTitle: true,
        title: SimpleShadow(
          offset: Offset(0, 0),
          opacity: opacity,
          color: Theme.of(context).shadowColor,
          child: Image.asset(
            'assets/yooreed.png',
            width: 100,
            height: 45,
          ),
        ),
        actions: [
          Center(
            child: Padding(
                padding: const EdgeInsets.only(right: 22, bottom: 0),
                child: SimpleShadow(
                    offset: Offset(0, 0),
                    sigma: 1,
                    opacity: opacity,
                    child: CircleAvatar(
                      backgroundColor:
                          Get.isDarkMode ? HexColor('#E9564B') : Colors.white,
                      radius: 24,
                      child: CircleAvatar(
                        radius: 22.5,
                        backgroundImage: NetworkImage(offerProvider.user.image),
                      ),
                    ))),
          )
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: offerProvider.isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.03,
                              right: size.width * 0.03,
                              bottom: size.height * 0.01,
                              top: size.height * 0.03),
                          child: SimpleShadow(
                            offset: const Offset(0, 0),
                            opacity: 0.02,
                            color: Theme.of(context).shadowColor,
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.75,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: TextField(
                                    onChanged: (search) async {
                                      await AdherentApi()
                                          .offerSearch(search)
                                          .then((value) {
                                        setState(() {
                                          searchResult = value;
                                        });
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 20),
                                      filled: true,
                                      fillColor:
                                          Theme.of(context).bottomAppBarColor,
                                      prefixIcon: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                      ),
                                      hintText: "Discover Offer",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: SimpleShadow(
                                    offset: const Offset(0, 0),
                                    opacity: 0.02,
                                    color: Theme.of(context).shadowColor,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).bottomAppBarColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          Get.to(() => FiltersScreen());
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.slider_horizontal_3,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      searchResult.isNotEmpty
                          ? search(searchResult)
                          : FadeInUp(
                              delay: const Duration(milliseconds: 400),
                              child: Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                width: size.width,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: TabBar(
                                    unselectedLabelStyle:
                                        GoogleFonts.ubuntu(fontSize: 20),
                                    labelStyle:
                                        GoogleFonts.ubuntu(fontSize: 22),
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    labelPadding: EdgeInsets.only(
                                        left: size.width * 0.05,
                                        right: size.width * 0.05),
                                    controller: tabController,
                                    labelColor: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    unselectedLabelColor: Get.isDarkMode
                                        ? Colors.white60
                                        : Colors.grey,
                                    isScrollable: true,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicator: CircleTabBarIndicator(
                                      color: HexColor('#E9564B'),
                                      radius: 4,
                                    ),
                                    tabs: const [
                                      Tab(
                                        text: "Yooreed",
                                      ),
                                      Tab(text: "fullYear"),
                                      Tab(text: "Popular"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        child: Container(
                          margin: EdgeInsets.only(top: size.height * 0.01),
                          width: size.width,
                          height: size.height * 0.4,
                          child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: tabController,
                              children: [
                                TabViewChild(
                                  list: offerProvider.yooreedItems,
                                ),
                                TabViewChild(list: offerProvider.fullYearItems),
                                TabViewChild(
                                    list: offerProvider.frameTimeItems),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeInUp(
                          delay: const Duration(milliseconds: 600),
                          child: Text(
                            'SECTOR'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 25.5),
                          )),
                      Container(
                        margin: EdgeInsets.only(top: size.height * 0.01),
                        width: size.width,
                        height: size.height * 0.12,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: secteurProvider.secteurItems.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              Secteur current =
                                  secteurProvider.secteurItems[index];
                              return FadeInRight(
                                delay: const Duration(milliseconds: 100),
                                child: ZoomTapAnimation(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftJoined,
                                          child:
                                              SecteurParteanire(id: current.id),
                                          childCurrent: MyHomePage()),
                                    );
                                  },
                                  enableLongTapRepeatEvent: false,
                                  longTapRepeatDuration:
                                      const Duration(milliseconds: 100),
                                  begin: 1.0,
                                  end: 0.93,
                                  beginDuration:
                                      const Duration(milliseconds: 20),
                                  endDuration:
                                      const Duration(milliseconds: 120),
                                  beginCurve: Curves.decelerate,
                                  endCurve: Curves.fastOutSlowIn,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10.0),
                                        width: size.width * 0.16,
                                        height: size.height * 0.07,
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent.shade200
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Image(
                                            image: NetworkImage(
                                              current.image,
                                            ),
                                          ),
                                        ),
                                      ),
                                      AppText(
                                        text: current.nom,
                                        size: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),

                      // FadeInUp(
                      //     delay: const Duration(milliseconds: 600),
                      //     child: const MiddleAppText(text: "Find More")),
                      // FadeInUp(
                      //   delay: const Duration(milliseconds: 700),
                      //   child: Container(
                      //     margin: EdgeInsets.only(top: size.height * 0.01),
                      //     width: size.width,
                      //     height: size.height * 0.12,
                      //     child: ListView.builder(
                      //         scrollDirection: Axis.horizontal,
                      //         itemCount: categoryComponents.length,
                      //         physics: const BouncingScrollPhysics(),
                      //         itemBuilder: (context, index) {
                      //           Category current = categoryComponents[index];
                      //           return Column(
                      //             children: [
                      //               Container(
                      //                 margin: const EdgeInsets.all(10.0),
                      //                 width: size.width * 0.16,
                      //                 height: size.height * 0.07,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.deepPurpleAccent
                      //                       .withOpacity(0.2),
                      //                   borderRadius: BorderRadius.circular(15),
                      //                 ),
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(20.0),
                      //                   child: Image(
                      //                     image: AssetImage(
                      //                       current.image,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //               AppText(
                      //                 text: current.name,
                      //                 size: 14,
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.w400,
                      //               )
                      //             ],
                      //           );
                      //         }),
                      //   ),
                      // ),

                      FadeInUp(
                          delay: const Duration(milliseconds: 1000),
                          child: Text(
                            'PEOPLE'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 25.5),
                          )),
                      FadeInUp(
                        delay: const Duration(milliseconds: 1100),
                        child: Container(
                          margin: EdgeInsets.only(top: size.height * 0.01),
                          width: size.width,
                          height: size.height * 0.68,
                          child: ListView.builder(
                              itemCount:
                                  offerProvider.peopleAlsoLikesItems.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Offer current =
                                    offerProvider.peopleAlsoLikesItems[index];
                                return GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    width: size.width,
                                    height: size.height * 0.15,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: current.id,
                                          child: Container(
                                            margin: const EdgeInsets.all(8.0),
                                            width: size.width * 0.28,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  current.image,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: size.width * 0.02),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: size.height * 0.035,
                                              ),
                                              AppText(
                                                text: current.title,
                                                size: 17,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                height: size.height * 0.005,
                                              ),
                                              AppText(
                                                text: current.title,
                                                size: 14,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget search(List<Offer> searchList) {
    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: ListView.builder(
          itemCount: searchList.length,
          itemBuilder: (context, index) {
            var current = searchList[index];
            return GestureDetector(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                width: size.width,
                height: size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: current.id,
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        width: size.width * 0.28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(
                              current.image,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.035,
                          ),
                          AppText(
                            text: current.title,
                            size: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          AppText(
                            text: current.title,
                            size: 14,
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class CircleTabBarIndicator extends Decoration {
  final Color color;
  final double radius;

  const CircleTabBarIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  double radius;

  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = color;
    _paint.isAntiAlias = true;
    final Offset circleOffset = Offset(
        configuration.size!.width / 2 - radius / 2,
        configuration.size!.height - radius / 2);
    canvas.drawCircle(offset + circleOffset, radius, _paint);
  }
}

class AppText extends StatelessWidget {
  const AppText(
      {super.key,
      required this.text,
      required this.size,
      required this.color,
      required this.fontWeight});

  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.ubuntu(
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
