import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/AdherentApp/API/servie_api.dart';
import 'package:showmodal/AdherentApp/Provider/offer_provider.dart';
import 'package:showmodal/AdherentApp/screen/offer_fliter_result.dart';
import 'package:showmodal/AdherentApp/screen/range_view.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../Service/service_const.dart';
import '../../main.dart';
import '../Models/gouvernerat.dart';
import '../Models/secteur.dart';
import '../Models/ville.dart';
import '../Provider/filter_provider.dart';
import '../Provider/offer_provider.dart';
import '../Provider/secteur_provider.dart';
import 'filter_partenaires.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  RangeValues _values = const RangeValues(0, 10000);
  double distValue = 50.0;
  Gouvernerat? selectGouverneart = null;
  List<Ville> villes = [];
  bool isSelectedPartenaire = true;

  bool isSelectedOffer = false;
  int? secteurId = null;

  Ville? selectVille = null;

  int typeId = 1;

  getVilleById(int id) async {
    var data = await AdherentApi().getVille(id);
    setState(() {
      villes.clear();
      villes = data.data;
      villes.insert(0, Ville(id: 0, name: 'Select ville', gouverneratId: 0));
      villes.toList();
    });
    print(villes);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SecteurProvider>(context);
    final type = Provider.of<OfferProvider>(context);
    final filter = Provider.of<FilterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(CupertinoIcons.clear),
        ),
        elevation: 0.7,
        centerTitle: true,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        title: Text('filter'.tr),
        titleTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 26,
            ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  selectFilter(),
                  
                  const Divider(
                    height: 1,
                  ),
                  const Divider(
                    height: 1,
                  ),

                  isSelectedPartenaire
                      ? Column(
                        children: [
                          offreLocation(filter.gouverneratListItems),
                              const Divider(
                    height: 1,
                  ),
                           const Divider(
                    height: 1,
                  ),
                        ],
                      )
                      : SizedBox(),




                  allAccommodationUI(provider.secteurItems),
         const Divider(
                    height: 1,
                  ),
                           const Divider(
                    height: 1,
                  ),
                  isSelectedPartenaire
                      ? SizedBox()
                      : Column(
                        children: [
                          popularFilter(type.offerType),         const Divider(
                    height: 1,
                  ),
                           const Divider(
                    height: 1,
                  ),
                                   const Divider(
                    height: 1,
                  ),
                           const Divider(
                    height: 1,
                  ),
                        ],
                      ),

                  isSelectedPartenaire ? SizedBox() : priceBarFilter(),
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
            child: SimpleShadow(
              color: Theme.of(context).shadowColor,
              opacity: 0.1,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: HexColor('#E9564B'),
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (isSelectedOffer == true) {
                        await filter
                            .getOffersByType(secteurId, _values.start,
                                _values.end, typeId, context)
                            .then((value) {
                          if (filter.filterOfferListItems.isNotEmpty) {
                            Get.to(() => const OfferFilterResult());
                          }
                        });
                      } else {
                        if (secteurId == null &&
                            selectVille == null &&
                            selectGouverneart == null) {
                          AnimatedSnackBar(
                            builder: ((context) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).bottomAppBarColor,
                                    borderRadius: BorderRadius.circular(8)),
                                height: 50,
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.info,
                                      color: CupertinoColors.activeBlue,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      'filter_require'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(fontSize: 15),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            snackBarStrategy: RemoveSnackBarStrategy(),
                            mobileSnackBarPosition:
                                MobileSnackBarPosition.bottom,
                          ).show(context);
                        } else {
                          await filter
                              .getpartenaireByFilter(
                                  secteurId,
                                  selectGouverneart?.id,
                                  selectVille?.id,
                                  context)
                              .then((value) {
                            if (filter.filterGetPartenaires.isNotEmpty) {
                              Get.to(() => PartenairesFilter(
                                  users: filter.filterGetPartenaires));
                            }
                          });
                        }
                      }
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget selectFilter() {
    return Column(
      children: [
        ListTile(
          minLeadingWidth: 20,
          leading: Icon(
            isSelectedPartenaire
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: isSelectedPartenaire
                ? HexColor('#E9564B')
                : Colors.grey.withOpacity(0.6),
          ),
          title: Text(
            'partenaire'.tr,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 16,
                ),
          ),
          onTap: () {
            if (!isSelectedPartenaire) {
              setState(() {
                isSelectedOffer = !isSelectedOffer;
                isSelectedPartenaire = !isSelectedPartenaire;
                print(isSelectedOffer);
                print(isSelectedPartenaire);
              });
            }
          },
        ),
        ListTile(
            minLeadingWidth: 20,
            leading: Icon(
              isSelectedOffer ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelectedOffer
                  ? HexColor('#E9564B')
                  : Colors.grey.withOpacity(0.6),
            ),
            title: Text(
              'Offer'.tr,
              style: Theme.of(context).textTheme.caption!.copyWith(
                    fontSize: 16,
                  ),
            ),
            onTap: () {
              if (!isSelectedOffer) {
                setState(() {
                  isSelectedOffer = !isSelectedOffer;
                  isSelectedPartenaire = !isSelectedPartenaire;
                });
              }
            })
      ],
    );
  }

  Widget allAccommodationUI(List<Secteur> secteurs) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'SECTOR'.tr,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: MediaQuery.of(context).size.width > 360 ? 19 : 17,
                color: Get.isDarkMode ? Colors.white70 : Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getAccomodationListUI(secteurs),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  List<Widget> getAccomodationListUI(List<Secteur> secteurs) {
    final List<Widget> noList = <Widget>[];
    for (int i = 0; i < secteurs.length; i++) {
      final Secteur secteur = secteurs[i];
      noList.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            onTap: () {
              setState(() {
                if (secteur.id == secteurId) {
                  secteur.isSelected = !secteur.isSelected;
                  // secteurId = null ;
                } else {
                  for (int i = 0; i < secteurs.length; i++) {
                    secteurs[i].isSelected = false;
                  }
                }
                if (secteur.id != secteurId) {
                  secteur.isSelected = !secteur.isSelected;
                  secteurId = secteur.id;
                }
                if (secteur.isSelected == false) {
                  secteurId = null;
                }

                print(secteurId);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      secteur.nom,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: secteur.isSelected
                        ? HexColor('#E9564B')
                        : Colors.grey.withOpacity(0.6),
                    onChanged: (bool value) {
                      setState(() {});
                    },
                    value: secteur.isSelected,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      if (i == 0) {
        noList.add(const Divider(
          height: 1,
        ));
      }
    }
    return noList;
  }

  Widget popularFilter(List<typeOffer> types) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Popular filters',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: MediaQuery.of(context).size.width > 360 ? 19 : 17,
                color: Get.isDarkMode ? Colors.white70 : Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(types),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList(List<typeOffer> types) {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < types.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final typeOffer type = types[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        for (int i = 0; i < types.length; i++) {
                          types[i].isSelected = false;
                        }
                        type.isSelected = !type.isSelected;
                        typeId = type.id;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            type.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: type.isSelected
                                ? HexColor('#E9564B')
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            type.name,
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontSize: 16,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < types.length - 1) {
            count += 1;
          } else {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Price',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: MediaQuery.of(context).size.width > 360 ? 19 : 17,
                color: Get.isDarkMode ? Colors.white70 : Colors.grey),
          ),
        ),
        RangeSliderView(
          values: _values,
          onChangeRangeValues: (RangeValues values) {
            _values = values;
          },
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget offreLocation(List<Gouvernerat> listGouvernerat) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Location',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: MediaQuery.of(context).size.width > 360 ? 19 : 17,
                color: Get.isDarkMode ? Colors.white70 : Colors.grey),
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: HexColor('#E9564B'), width: 2)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Gouvernerat>(
                value: selectGouverneart,
                onChanged: (value) async {
                  setState(() {
                    if (value!.id != 0) {
                      selectGouverneart = value;
                    } else {
                      selectGouverneart = null;
                    }
                  });
                  if (value!.id != 0) {
                    await getVilleById(value.id);
                  }
                },
                hint: Center(
                    child: Text(
                  'Select gouvernerat',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 17),
                )),
                // Hide the default underline
                underline: Container(),
                // set the color of the dropdown menu
                borderRadius: BorderRadius.all(Radius.circular(8)),
                dropdownColor: HexColor('#E9564B'),
                icon: Icon(
                  Icons.arrow_downward,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
                isExpanded: true,

                // The list of options
                items: listGouvernerat
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: ListTile(
                            title: Text(
                              e.id == 0 ? '' : e.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontSize: 17),
                            ),
                          ),
                        ))
                    .toList(),

                // Customize the selected item
                selectedItemBuilder: (BuildContext context) => listGouvernerat
                    .map((e) => Center(
                          child: Text(e.name,
                              style: Theme.of(context).textTheme.titleLarge),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        selectGouverneart != null
            ? Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: HexColor('#E9564B'), width: 2)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Ville>(
                      value: selectVille,
                      onChanged: (value) {
                        setState(() {
                          if (value!.id != 0) {
                            selectVille = value;
                          } else {
                            selectVille = null;
                          }
                        });
                      },
                      hint: Center(
                          child: Text(
                        'Select Ville',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 17),
                      )),
                      // Hide the default underline
                      underline: Container(),
                      // set the color of the dropdown menu
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      dropdownColor:
                          Get.isDarkMode ? Colors.white70 : Colors.grey,
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                      isExpanded: true,

                      // The list of options
                      items: villes
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: ListTile(
                                  title: Text(
                                    e.id == 0 ? '' : e.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            fontSize: 17, color: Colors.black),
                                  ),
                                ),
                              ))
                          .toList(),

                      // Customize the selected item
                      selectedItemBuilder: (BuildContext context) => villes
                          .map((e) => Center(
                                child: Text(e.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith()),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
