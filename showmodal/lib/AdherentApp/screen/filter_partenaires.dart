import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/AdherentApp/Provider/filter_provider.dart';
import 'package:showmodal/AdherentApp/screen/secteur%20partenaire.dart';

import '../Models/partenaire.dart';

class PartenairesFilter extends StatelessWidget {
  final List<Partenaire> users;

  const PartenairesFilter({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final filter = Provider.of<FilterProvider>(context);
    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            filter.clear();
            Get.back();
          },
        ),
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 1,
      ),
      body: PartenaireList(
        users: filter.filterGetPartenaires,
      ),
    );
  }
}
