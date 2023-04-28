import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showmodal/Partenaire_app/Widget/update_widget.dart';
import 'package:showmodal/Partenaire_app/provider/partenaire_offre.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../expandile.dart';
import '../../main.dart';
import '../Models/offer_partenaire.dart';

class OfferItem extends StatelessWidget {
  final PartenaireOfferModel offer;
  late PartenaireOffre partenaireOffre;

  OfferItem({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    partenaireOffre = Provider.of<PartenaireOffre>(context);
    return Padding(
      padding: const EdgeInsets.all(3),
      child: expandile2(context),
    );
  }

  Widget expandile2(BuildContext context) {
    return Expandile(
      primaryColor: Theme.of(context).bottomAppBarColor,
      leading: _leading(),
      title: offer.title,
      description: offer.description,
      maxDescriptionLines: 1,
      children: <Widget>[
        imgWidget(),
        debutTimeText(context),
        timeText(context),
        price(context),
         promo(context),
      ],
      footer: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: actionButtons(context),
      ),
    );
  }

  Widget _leading() {
    return CircleAvatar(
      child: Icon(
        FontAwesomeIcons.bagShopping,
        color: HexColor('#E9564B'),
      ),
      backgroundColor: Colors.redAccent.withAlpha(30),
    );
  }

  ///Children1 of the widget
  Widget imgWidget() {
    return CachedNetworkImage(
      placeholder: (context, _) {
        return Center(
          child: Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: Container(

                height: 350,
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                    child: Center(
                child: Icon(FontAwesomeIcons.warning,
                  size: 28,
                  color: HexColor('#E9564B') ,),
              )
              )),
        );
      },
      imageUrl: offer.image,
      imageBuilder: (context, imageProvider) {
        return Center(
          child: Card(
            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),

            ),
            elevation: 1,
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: NetworkImage(offer.image), fit: BoxFit.fill)),
            ),
          ),
        );
      },
      errorWidget: (context, _, __) {
        return Center(
            child: Container(
                height: 350,
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
              child: Center(
                child: Icon(FontAwesomeIcons.warning,
                  size: 28,
                  color: HexColor('#E9564B') ,),
              )));
      },
    );
  }

  ///Children2 of the widget
   Widget debutTimeText(BuildContext context) {
    int createdAt = DateTime.now().millisecondsSinceEpoch - 10000;
    return detailsCard('START_DATE'.tr + ' ' + offer.dateDebut, context);
  }

  Widget timeText(BuildContext context) {
    int createdAt = DateTime.now().millisecondsSinceEpoch - 10000;
    return detailsCard('LAST_DATE'.tr + ' ' + offer.dateFin, context);
  }

  Widget price(BuildContext context) {
    return detailsCard(
        'PRICE'.tr + ' ' + ':' + ' ' + offer.price + '.', context);
  }
  Widget promo(BuildContext context) {
    String promo = offer.promo.toString() ;
    if(!offer.promo.toString().contains('%')){
      promo = '${offer.promo}%';
    }
    return detailsCard(
        'PROMO'.tr + ' ' + ':' + ' ' + promo + '.', context);
  }
  ///A reusable txt widget, which is to be used inside [Children] widgets
  Widget detailsCard(String text, context) {
    return Inkk(
      spalshColor: Colors.blue,
      onTap: openDetailsFn,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  ///Footer widgets
  ///Some list of buttons which will not hide itself
  Widget actionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        editButton(context),
        SizedBox(
          width: 8,
        ),
        deleteButton(context),
      ],
    );
  }

  Widget editButton(BuildContext context) {
    return Expanded(
        child: ZoomTapAnimation(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(70, 40),
            backgroundColor: HexColor('#E9564B'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)))),
        onPressed: () {
          Get.bottomSheet(Container(
            padding: EdgeInsets.all(16),
            height: 320,
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                    child: Column(
                  children: [TextFormField()],
                ))
              ],
            ),
          ));
        },
        child: Text('EDIT'.tr),
      ),
    ));
  }

  Widget deleteButton(BuildContext context) {
    return Expanded(
        child: ZoomTapAnimation(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(70, 40),
            backgroundColor: HexColor('#E9564B'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)))),
        onPressed: () {
          Get.defaultDialog(
              barrierDismissible: false,
              cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black,
              confirmTextColor: Colors.white,
              radius: 12,
              title: 'Delete'.tr,
              titlePadding: EdgeInsets.only(top: 16, bottom: 8),
              textConfirm: 'OK'.tr,
              buttonColor: HexColor('#E9564B'),
              textCancel: 'NO'.tr,
              titleStyle: Theme.of(context).textTheme.titleLarge,
              middleTextStyle: Theme.of(context).textTheme.titleMedium,
              middleText: 'DELETE_MESSAGE'.tr,
              onConfirm: () async {
                print("""object""");
                await partenaireOffre
                    .removeOffer(offer.id, context)
                    .then((value) {
                  Navigator.pop(context);
                });
              },
              onCancel: () {
                Navigator.pop(context);
              });
        },
        child: Text('Delete'.tr),
      ),
    ));
  }



  void openDetailsFn() {
    ///To open the details page of the content
  }
}
