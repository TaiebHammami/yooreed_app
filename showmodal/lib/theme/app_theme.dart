import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

class AppTheme {
  AppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'WorkSans';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}

class Yooreed {
  Yooreed._();

  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Roboto';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}

class Themes {
  /// screen background color
  static Color darkBack = HexColor('#111315');
  static  Color background = HexColor('#f5f6fb');
  /// text backGround color
  /// dark
  static const Color nearlyWhite = Color(0xFFFAFAFA);
   /// light
  static Color darkBackText = HexColor('#121212');


  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color shadow = Color(0xFF313A44);
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Roboto';

  static ThemeData lightTheme = ThemeData(
    shadowColor:Colors.black ,
      scaffoldBackgroundColor: background,
      canvasColor: Colors.black,
      brightness: Brightness.light,
      backgroundColor: background,
      buttonColor: Colors.black,
      appBarTheme: AppBarTheme(
          titleTextStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey.shade50,
          elevation: 0),
      bottomAppBarColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          hintStyle: TextStyle(
            fontSize: 14,
          )),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.red),

      textTheme: TextTheme(
          headline1: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 48,
            letterSpacing: 0.4,
            height: 0.9,
            color: darkBack,
          ),
          headline2:GoogleFonts.ubuntu(
              letterSpacing: -1.0,
              fontSize: 40,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          headline3:GoogleFonts.ubuntu(
              letterSpacing: -1.0,
              fontSize: 32,
              color: darkBack,
              fontWeight: FontWeight.bold),
          headline4:GoogleFonts.ubuntu(
              letterSpacing: -1.0,
              color: darkBack,
              fontSize: 28,
              fontWeight: FontWeight.w600),
          headline5: GoogleFonts.ubuntu(
              letterSpacing: -1.0,
              color:darkBack,
              fontSize: 24,
              fontWeight: FontWeight.w500),
          headline6: GoogleFonts.ubuntu(
              color: darkBack,
              fontSize: 18,
              fontWeight: FontWeight.w500),
          subtitle1: GoogleFonts.ubuntu(
              color: darkBack,
              fontSize: 16,
              fontWeight: FontWeight.w500),
          subtitle2:GoogleFonts.ubuntu(
              color: darkBack,
              fontSize: 14,
              fontWeight: FontWeight.w500),
          bodyText1:GoogleFonts.ubuntu(

              color: darkBack,
              fontSize: 16,
              fontWeight: FontWeight.w400),
          bodyText2:GoogleFonts.ubuntu(

              color: darkBack,
              fontSize: 14,
              fontWeight: FontWeight.w400),
          button: GoogleFonts.ubuntu(

              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600),
          caption:GoogleFonts.ubuntu(

              color: Colors.grey.shade800,
              fontSize: 12,
              fontWeight: FontWeight.w400),
          overline:GoogleFonts.ubuntu(
              color: Colors.grey.shade700,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.5)));

  static ThemeData darkTheme = ThemeData(
    primaryColor: nearlyWhite,
        shadowColor:background ,

    canvasColor: nearlyWhite,
    primarySwatch: Colors.blue,
    buttonColor: nearlyWhite,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBack,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.gray900,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
     // HexColor('#1b1c1e')
    bottomAppBarColor:Colors.blue.shade50.withOpacity(.05),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
        hintStyle: TextStyle(
          fontSize: 14,
        )),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.white),
    textTheme: TextTheme(
        headline1: GoogleFonts.ubuntu(

            letterSpacing: -1.5,
            fontSize: 48,
            color: nearlyWhite,
            fontWeight: FontWeight.bold),
        headline2:  GoogleFonts.ubuntu(
            letterSpacing: -1.0,
            fontSize: 40,

            color: nearlyWhite,
            fontWeight: FontWeight.bold),
        headline3: GoogleFonts.ubuntu(
            letterSpacing: -1.0,
            fontSize: 32,

            color: nearlyWhite,
            fontWeight: FontWeight.bold),
        headline4:  GoogleFonts.ubuntu(
            letterSpacing: -1.0,
            color: nearlyWhite,
            fontSize: 28,

            fontWeight: FontWeight.w600),
        headline5:  GoogleFonts.ubuntu(
            letterSpacing: -1.0,
            color: nearlyWhite,

            fontSize: 24,
            fontWeight: FontWeight.w500),
        headline6:  GoogleFonts.ubuntu(
            color: nearlyWhite,
            fontSize: 18,
            fontWeight: FontWeight.w500),
        subtitle1: GoogleFonts.ubuntu(
            color: nearlyWhite,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        subtitle2:  GoogleFonts.ubuntu(
            color: background,
            fontSize: 14,
            fontWeight: FontWeight.w500),
        bodyText1:  GoogleFonts.ubuntu(
            color: background,
            fontSize: 16,
            fontWeight: FontWeight.w400),
        bodyText2:  GoogleFonts.ubuntu(
            color: background,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        button:  GoogleFonts.ubuntu(
          color: background,
          fontSize: 14,
          fontWeight: FontWeight.w600,

        ),
        caption: GoogleFonts.ubuntu(
            color: background,
            fontSize: 12,

            fontWeight: FontWeight.w500),
        overline:  GoogleFonts.ubuntu(
            color: background,
            fontSize: 10,
            fontWeight: FontWeight.w400)),
  );
}

class ColorConstants {
  static Color gray50 = hexToColor('#e9e9e9');
  static Color gray100 = hexToColor('#bdbebe');
  static Color gray200 = hexToColor('#929293');
  static Color gray300 = hexToColor('#666667');
  static Color gray400 = hexToColor('#505151');
  static Color gray500 = hexToColor('#242526');
  static Color gray600 = hexToColor('#202122');
  static Color gray700 = hexToColor('#191a1b');
  static Color gray800 = hexToColor('#121313');
  static Color gray900 = hexToColor('#0e0f0f');
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));

  return Color(int.parse(hex.substring(1), radix: 16) +
      (hex.length == 7 ? 0xFF000000 : 0x00000000));
}
