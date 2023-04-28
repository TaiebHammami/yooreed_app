import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/AdherentApp/Provider/offer_provider.dart';
import 'package:showmodal/AdherentApp/screen/edit_profile.dart';
import 'package:showmodal/help_screen.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../../Authentification/authProvider/auth_provider.dart';
import '../../../main.dart';

class PartenaireProfile extends StatefulWidget {
  @override
  State<PartenaireProfile> createState() => _PartenaireProfileState();
}

class _PartenaireProfileState extends State<PartenaireProfile>
    with TickerProviderStateMixin {
  var opacity = 0.08;
  var opacityText = 0.1;
  late double _deviceWidth;
  late AuthProvider authProvider;

  late double _deviceHeight;
  File? _image;
  ImagePicker image = ImagePicker();

  late Locale currentLocal;
  late String currentTheme;

  @override
  void initState() {
    authProvider = AuthProvider();
    super.initState();
    setState(() {
      currentLocal = Get.locale!;
      print(currentLocal);
    });
  }

  late TextTheme theme;
  late TextStyle titleTheme;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(img);
      setState(() {
        _image = img!;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    switch (AdaptiveTheme.of(context).mode) {
      case AdaptiveThemeMode.light:
        currentTheme = 'LIGHT';
        break;
      case AdaptiveThemeMode.dark:
        currentTheme = 'DARK';

        break;
      case AdaptiveThemeMode.system:
        currentTheme = 'SYSTEME';

        break;
    }
    print(currentTheme);
    theme = Theme.of(context).textTheme;
    titleTheme = Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 19);

    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 0.7,
        title: SimpleShadow(
          color: Theme.of(context).shadowColor,
          opacity: opacityText,
          child: Text(
            'SETTINGS'.tr,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 26,
                ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: FadeInUp(child: Setting(context)),
      ),
    );
  }

  Widget Setting(BuildContext context) {
    final user = Provider.of<OfferProvider>(context).user;
    return ListView(
      children: [
        SizedBox(
          height: _deviceHeight * 0.01,
        ),
        SimpleShadow(
          opacity: opacityText,
          color: Theme.of(context).shadowColor,
          child: Text(
            'ACCOUNT'.tr,
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 19),
          ),
        ),
        SizedBox(
          height: _deviceHeight * 0.05,
        ),
        Column(
          children: [
            Center(
              child: SimpleShadow(
                offset: Offset(0, 0),
                opacity: 0.2,
                color: Theme.of(context).shadowColor,
                child: CircleAvatar(
                    backgroundColor:
                        Get.isDarkMode ? HexColor('#E9564B') : Colors.white,
                    radius: 70,
                    child: _image == null
                        ? CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(user.image))
                        : CircleAvatar(
                            radius: 65, backgroundImage: FileImage(_image!))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: _deviceHeight * 0.04,
        ),
        _buildListTile("ACCOUNT".tr, CupertinoIcons.profile_circled, '',
            CupertinoColors.inactiveGray, Theme.of(context), onTab: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftJoined,
                  child: EditProfile(),
                  childCurrent: PartenaireProfile()));
        }),
        SizedBox(height: 8),
        _buildListTile("APPERANCE".tr, Icons.dark_mode, currentTheme.tr,
            Colors.purple, Theme.of(context), onTab: () {
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
                Text(
                  'SELECT_THEME'.tr,
                  style: theme.subtitle1,
                ),
                SizedBox(height: 32),
                ListTile(
                  leading: Icon(
                    Icons.brightness_5,
                    color: Colors.blue,
                  ),
                  title: Text("LIGHT".tr, style: theme.bodyText1),
                  onTap: () {
                    AdaptiveTheme.of(context).setLight();
                    Get.back();
                  },
                  trailing: Icon(Icons.check,
                      color: currentTheme == 'LIGHT'
                          ? Colors.blue
                          : Colors.transparent),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    Icons.brightness_2,
                    color: Colors.orange,
                  ),
                  title: Text("DARK".tr, style: theme.bodyText1),
                  onTap: () {
                    AdaptiveTheme.of(context).setDark();
                    Get.back();
                  },
                  trailing: Icon(Icons.check,
                      color: currentTheme == 'DARK'
                          ? Colors.orange
                          : Colors.transparent),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    Icons.brightness_6,
                    color: Colors.blueGrey,
                  ),
                  title: Text("SYSTEME".tr, style: theme.bodyText1),
                  onTap: () {
                    AdaptiveTheme.of(context).setSystem();
                    Get.back();
                  },
                  trailing: Icon(Icons.check,
                      color: currentTheme == 'SYSTEME'
                          ? Colors.blueGrey
                          : Colors.transparent),
                ),
              ],
            ),
          ));
        }),
        SizedBox(height: 8),
        _buildListTile(
            currentLocal.toString() == 'fr' ? 'LANGUAGE'.tr : 'LANGUAGE'.tr,
            Icons.language,
            currentLocal.toString() == 'fr' ? 'FRENCH'.tr : 'ENGLISH'.tr,
            Colors.orange,
            Theme.of(context), onTab: () {
          Get.bottomSheet(
              Container(
                width: _deviceWidth,
                height: _deviceHeight * 0.2,
                decoration:  BoxDecoration(
                                   color: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 18, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //         topSheet(),
                      Text(
                        'SELECT_LANGUAGE'.tr,
                        style: theme.subtitle1,
                      ),
                      const Spacer(),
                      ListTile(
                          onTap: () {
                            Get.updateLocale(Locale('fr'));
                            currentLocal = Get.locale!;
                            Get.back();
                          },
                          leading: Image.asset(
                            'assets/france.png',
                            width: 25,
                            height: 25,
                          ),
                          title: Text('FRENCH'.tr, style: theme.bodyText1),
                          trailing: currentLocal.toString() == 'fr'
                              ? Icon(
                                  CupertinoIcons.checkmark_alt,
                                  color: Colors.lightBlue,
                                )
                              : null),

                      ListTile(
                          onTap: () {
                            Get.updateLocale(Locale('en'));
                            setState(() {
                              currentLocal = Get.locale!;
                            });
                            Get.back();
                          },
                          leading: Image.asset(
                            'assets/united-kingdom.png',
                            width: 25,
                            height: 25,
                          ),
                          title: Text('ENGLISH'.tr, style: theme.bodyText1),
                          trailing: currentLocal.toString() == 'en'
                              ? Icon(
                                  CupertinoIcons.checkmark_alt,
                                  color: Colors.lightBlue,
                                )
                              : null),
                    ],
                  ),
                ),
              ),
              backgroundColor:
                  Theme.of(context).bottomSheetTheme.backgroundColor);
        }),
        SizedBox(height: 8),
        _buildListTile('NOTIFICATION'.tr, Icons.notifications_outlined, '',
            Colors.blue, Theme.of(context),
            onTab: () {}),
        SizedBox(height: 8),
        _buildListTile('Help', Icons.help, '', Colors.green, Theme.of(context),
            onTab: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftJoined,
                  child: HelpScreen(),
                  childCurrent: PartenaireProfile()));
        }),
        SizedBox(height: 8),
        _buildListTile(
            'LOG_OUT'.tr, Icons.exit_to_app, '', Colors.red, Theme.of(context),
            onTab: () {
          Get.defaultDialog(
              barrierDismissible: false,
              cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black,
              confirmTextColor: Colors.white,
              radius: 12,
              title: 'LOG_OUT'.tr,
              titlePadding: EdgeInsets.only(top: 16, bottom: 8),
              textConfirm: 'YES'.tr,
              buttonColor: HexColor('#E9564B'),
              textCancel: 'NO'.tr,
              titleStyle: Theme.of(context).textTheme.titleLarge,
              middleTextStyle: Theme.of(context).textTheme.titleMedium,
              middleText: 'LOGOUT_MESSAGE'.tr,
              onConfirm: () async {
                await authProvider.logout(context);
              },
              onCancel: () {
                Navigator.pop(context);
              });
        }),
      ],
    );
  }

  Widget _buildListTile(
      String title, IconData icon, String trailing, Color color, theme,
      {onTab}) {
    return SimpleShadow(
      offset: Offset(0, 0),
      color: Theme.of(context).shadowColor,
      opacity: 0.06,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor,
            borderRadius: BorderRadius.circular(18)),
        child: ListTile(
          shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(18)
          ),
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              margin: EdgeInsets.all(8),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: color.withAlpha(30)),
              child: Center(
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
            ),
            title: SimpleShadow(
                offset: Offset(0, 0),
                color: Theme.of(context).shadowColor,
                opacity: opacityText,
                child: Text(title, style: theme.textTheme.subtitle1)),
            trailing: Container(
              margin: EdgeInsets.only(right: 12),
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(trailing,
                      style: theme.textTheme.bodyText1
                          ?.copyWith(color: Colors.grey.shade600)),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
            onTap: onTab),
      ),
    );
  }



  Widget topSheet() {
    return Align(
      child: Container(
        width: 60,
        height: 9,
        decoration: BoxDecoration(
            color: CupertinoColors.systemGrey,
            borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.only(bottom: 22),
      ),
    );
  }
}
