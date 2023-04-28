import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../Models/secteur.dart';

class SecteurGridHome extends StatelessWidget {
  final List<Secteur> secteurs;

  const SecteurGridHome({super.key, required this.secteurs});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: secteurs.length,
        itemBuilder: (BuildContext context, int index) {
          return FadeInRight(
              delay: Duration(milliseconds: 900),
              child: SecteurItem(
                secteur: secteurs[index],
              ));
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 0,
          );
        },
      ),
    );
  }
}

class SecteurItem extends StatelessWidget {
  final Secteur secteur;

  const SecteurItem({super.key, required this.secteur});

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        print(1);
      },
      enableLongTapRepeatEvent: false,
      longTapRepeatDuration: const Duration(milliseconds: 100),
      begin: 1.0,
      end: 0.93,
      beginDuration: const Duration(milliseconds: 20),
      endDuration: const Duration(milliseconds: 120),
      beginCurve: Curves.decelerate,
      endCurve: Curves.fastOutSlowIn,
      child: AspectRatio(
        aspectRatio: 3 / 3,
        child: Container(
          margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(
              color: Colors.blue.withOpacity(0),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(secteur.image, height: 45),
                SizedBox(
                  height: 20,
                ),
                Text(
                  secteur.nom,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ]),
        ),
      ),
    );
  }
}

serviceContainer(String image, String name, int index, context) {
  return AspectRatio(
    aspectRatio: 3 / 3,
    child: Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(
          color: Colors.blue.withOpacity(0),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ZoomTapAnimation(
        enableLongTapRepeatEvent: false,
        longTapRepeatDuration: const Duration(milliseconds: 100),
        begin: 1.0,
        end: 0.93,
        beginDuration: const Duration(milliseconds: 20),
        endDuration: const Duration(milliseconds: 120),
        beginCurve: Curves.decelerate,
        endCurve: Curves.fastOutSlowIn,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(image, height: 45),
              SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.subtitle1,
              )
            ]),
      ),
    ),
  );
}
