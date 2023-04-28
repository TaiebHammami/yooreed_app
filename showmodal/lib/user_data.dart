import 'package:flutter/material.dart';
import 'package:showmodal/AdherentApp/navigation/navigation_home_screen.dart';
import 'package:showmodal/Authentification/Screen/login_page.dart';
import 'package:showmodal/Partenaire_app/navigation/partenaire_navigation.dart';
import 'package:showmodal/cache/shared_preference.dart';

import 'Service/service_const.dart';

class GlobalNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MyCache.getUserRole(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          String role = snapshot.data;
          if (role.toLowerCase() == ServiceConst.RoleAdherent.toLowerCase()) {
            return NavigationHomeScreen();
          }
          if (role.toLowerCase() == ServiceConst.RolePartenaire.toLowerCase()) {
            return HomePagePartenaire();
          }
           if (role.toLowerCase() == ServiceConst.RoleBoth.toLowerCase()) {
            return HomePagePartenaire();
          }
        }
        return LoginPage();
      },


    );
  }

}