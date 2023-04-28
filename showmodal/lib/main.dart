import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:showmodal/AdherentApp/Provider/offer_provider.dart';
import 'package:showmodal/AdherentApp/Provider/secteur_provider.dart';
import 'package:showmodal/Authentification/Screen/login_page.dart';
import 'package:showmodal/Languages/tanslation.dart';
import 'package:showmodal/Partenaire_app/provider/partenaire_offre.dart';
import 'package:showmodal/Partenaire_app/tabs/partenaire_home.dart';
import 'package:showmodal/partenaire.dart';
import 'package:showmodal/theme/app_theme.dart';
import 'package:showmodal/user_data.dart';
import 'AdherentApp/Provider/filter_provider.dart';
import 'Authentification/Screen/reset_password.dart';
import 'Authentification/authProvider/auth_provider.dart';
import 'Connectivity/connection.dart';
import 'ForgotPassword/verification.dart';
import 'Partenaire_app/navigation/partenaire_navigation.dart';
import 'AdherentApp/navigation/navigation_home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]).then((_) => runApp(MyApp(savedThemeMode: savedThemeMode)));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiProvider(
      providers: [
        // connection provider
        StreamProvider<ConnectivityStatus>(
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
          initialData: ConnectivityStatus.Cellular,
        ),
        ChangeNotifierProvider(create: (context) => PartenaireOffre()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
        ChangeNotifierProvider(create: (context) => OfferProvider()),
        ChangeNotifierProvider(create: (context) => SecteurProvider()),
        ChangeNotifierProvider(create: (context) => PartenaireOffre()),
      ],
      child: AdaptiveTheme(
        light: Themes.lightTheme,
        dark: Themes.darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (ThemeData light, ThemeData dark) {
          return GetMaterialApp(
            routes: {
              HomePagePartenaire.routeName: (ctx) => HomePagePartenaire(),
              NavigationHomeScreen.routeName: (ctx) => NavigationHomeScreen(),
              ResetPassword.routeName: (ctx) => ResetPassword(),
              LoginPage.routeName: (ctx) => LoginPage()
            },
            locale: const Locale('en'),
            translations: Translation(),
            fallbackLocale: const Locale('fr'),
            title: 'Flutter UI',
            debugShowCheckedModeBanner: false,
            theme: light,
            darkTheme: dark,
            home: NavigationHomeScreen(),
          );
        },
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
