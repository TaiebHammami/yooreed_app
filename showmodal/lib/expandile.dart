import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'main.dart';

///An Expansion style [ListTile] card which will look much better than
///traditional ExpansionTile, with some customization options
class Expandile extends StatefulWidget {
  ///Primary color of the [title], card, arrow widgets;
  final Color primaryColor;

  ///Custom text color on valid values;
  final Color? validTextColor;

  ///Title widget to be shown
  final String title;

  ///Optional description widget to be shown
  final String? description;

  ///Children to be shown when expanded
  final List<Widget> children;

  ///OPtional static widget to be shown on the footer even on closed state
  final Widget? footer;

  ///To automatically hide the expandile based on requirement
  final bool autoHide;

  ///Time to auto hide the expandile widget in [milliseconds]
  final int autoHideDuration;

  ///Function to be executed when tapping the [ListTile]
  final VoidCallback? onTap;

  ///Optional [Widget] or [IconData] to be used as [Leading]
  final dynamic leading;

  ///Card elevation value
  final double elevation;

  ///Padding to be given between [ListTile] children
  final EdgeInsetsGeometry? contentPadding;

  ///To expand the widget initially
  final bool initialyExpanded;

  ///MaxLines to control the description length
  final int? maxDescriptionLines;

  ///If the content or function is executed and the selection is valid,
  ///so we need to make the [ListTile] as currently selected/completed/done.
  final bool isValid;

  ///Outter padding of the widget
  final EdgeInsets? padding;

  const Expandile(
      {Key? key,
      required this.primaryColor,
      this.validTextColor,
      required this.title,
      this.description,
      this.children = const <Widget>[],
      this.footer,
      this.autoHide = false,
      this.autoHideDuration = 5000,

      ///5 Seconds
      this.onTap,
      this.leading,
      this.elevation = 0.0,
      this.contentPadding,
      this.initialyExpanded = false,
      this.maxDescriptionLines,
      this.isValid = false,
      this.padding})
      : super(key: key);

  @override
  State<Expandile> createState() => _ExpandileState();
}

class _ExpandileState extends State<Expandile> {
  bool expanded = false;

  Color get cardColor => widget.primaryColor;
  Color get textColor =>
      widget.isValid ? (widget.validTextColor ?? Colors.white) : widget.primaryColor;

  @override
  void initState() {
    expanded = widget.initialyExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 12),
      child: Card(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        color: cardColor,
        elevation: widget.isValid ? 50 : 1,
        child: Column(
          children: <Widget>[
            infoTile(),
            childrenWidgets(),
            footerWidget(),
          ],
        ),
      ),
    );
  }

  ///Where the basic information is shown, even the widget is not expanded
  Widget infoTile() {
    return ListTile(
      contentPadding: widget.contentPadding,
      onTap: widget.onTap ?? changeExpansionFn,
      leading: _leading(),
      title: _infoTitle(),
      subtitle: _infoSubtitle(),
      trailing: _expansionButton(),
    );
  }

  Widget? _leading() {
    if (widget.leading is Widget) return widget.leading as Widget;
    if (widget.leading is IconData) {
      final Icon icon = Icon(
        widget.leading as IconData,
        color: textColor,
      );
      return widget.description == null ? icon : IconButton(icon: icon, onPressed: () {  },);
    }
    return null;
  }

  Widget _infoTitle() {
    return Text(widget.title,style: Theme.of(context).textTheme.caption!.copyWith(
      fontSize: 17
    ),);
  }

  Widget? _infoSubtitle() {
    if (widget.description == null) return null;
    return Text(widget.description!,maxLines:  widget.maxDescriptionLines ?? 3,
        style: Theme.of(context).textTheme.caption!.copyWith(
          fontSize: 12
        ),);
  }

  Widget _expansionButton() {
    return IconButton(
      icon: Widgets.arrow(
        angle: expanded? 270 : 90,
        color: HexColor('#E9564B'),
      ),
      onPressed: changeExpansionFn,
    );
  }

  Widget childrenWidgets() {
    return CrossFade(
      useCenter: false,
      show: expanded,
      child: ListView(
        shrinkWrap: true,
        children: widget.children,
      ),
    );
  }

  Widget footerWidget() {
    if (widget.footer == null) return Container();
    return widget.footer!;
  }

  ///Function to change the expansion state automatically
  Future<void> changeExpansionFn() async {
    if (widget.autoHide) {
      ///If already expanded, then don't allow to expand again!
      if (expanded) return;

      if (mounted) setState(() => expanded = true);
     // await Widgets.wait(widget.autoHideDuration);
      if (mounted) setState(() => expanded = false);
    } else {
      if (mounted) setState(() => expanded = !expanded);
    }
  }
}
class CrossFade extends StatelessWidget {
  final Widget child;
  final Widget? hiddenChild;
  final bool show;
  final EdgeInsets? padding;
  final bool useCenter;

  const CrossFade({
    Key? key,
    required this.child,
    this.hiddenChild,
    this.show = false,
    this.padding,
    this.useCenter = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        child: AnimatedCrossFade(
          firstChild: hiddenChild ?? Container(),
          secondChild: childX(),
          duration: Duration(milliseconds: 500),
          crossFadeState: show ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ));
  }

  Widget childX() {
    if (useCenter)return Center(child: child);
    return child;
  }

}


class Inkk extends StatelessWidget {
  final Widget child;
  final Color? spalshColor;
  final double? radius;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool disable;

  const Inkk(
      {Key? key,
      required this.child,
      this.onTap,
      this.radius,
      this.spalshColor,
      this.tooltip,
      this.disable = false,
      })
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(radius ?? 8);
    return Semantics(
       label: tooltip??"Button",
        child: ClipRRect(
        borderRadius: borderRadius,
         clipBehavior: Clip.antiAlias,
          child: stack(borderRadius),
       ),
     );
  }

  Widget stack(BorderRadius borderRadius){
    return Stack(
              children: [
                child,
                 if(disable==false) Positioned.fill(
                 child: Material(
                  elevation: 0,
                  color: Colors.transparent,
                  child: InkWell(
                    highlightColor: (spalshColor?? Colors.blue).withOpacity(0.35),
                    splashColor: (spalshColor?? Colors.grey).withOpacity(0.25),
                    onTap: onTap?? (){},
                  ),
                  borderRadius: borderRadius,
                )
              ),
              ],
            );
  }
}


@Deprecated('Use Widgets.instance')
class Common {
  Common._privateConstructor();
  static final Common _instance = Common._privateConstructor();
  static Common get instance => _instance;
}

class FadePageRoute extends PageRouteBuilder {
  final Widget widget;
  FadePageRoute({required this.widget})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: ((context, animation, secondaryAnimation, child) {
              return SlideTransition(
                  transformHitTests: false,
                  position:
                      Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(animation),
                  child: new SlideTransition(
                      position: new Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, -1.0))
                          .animate(secondaryAnimation),
                      child: child));
            }));
}

class Widgets {
  Widgets._privateConstructor();
  static final Widgets _instance = Widgets._privateConstructor();
  static Widgets get instance => _instance;

  static String avatar(String phoneNumberOrRemoteKey) {
    String fileName = phoneNumberOrRemoteKey.replaceAll("+", "%2B");
    return "https://firebasestorage.googleapis.com/v0/b/service-ad14a.appspot.com/o/avatars%2F$fileName.jpg?alt=media";
  }

  static Widget loadingCircle({Color? color, double size = 26}) {
    return Material(
      type: MaterialType.circle,
      color: color,
      elevation: 0,
      child: SizedBox(
        height: size,
        width: size,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: CircularProgressIndicator(
            strokeWidth: 5,
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ),
    );
  }

  ///This will return the darken color of the given value
  static Color darkenColor(Color color, double value) =>
      HSLColor.fromColor(color).withLightness(value).toColor();




  static const Duration duration = Duration(milliseconds: 350);
  static const Duration duration1Sec = Duration(seconds: 1);
  static const Duration duration2Sec = Duration(seconds:2);
  static const Duration duration3Sec = Duration(seconds:3);

  static const Curve curve = Curves.easeIn;



  static List<String> generateTags(List sentences) {
    List<String> _tags = [];
    sentences.forEach((sentence) {
      if (sentence != null) {
        List words = '$sentence'.toLowerCase().split(' ');
        words.forEach((word) {
          if (_tags.contains(word) == false) _tags.add(word);
        });
      }
    });
    return _tags
      ..sort((b, a) => a.length.compareTo(b.length))
      ..removeWhere((element) => element.length < 3);
  }


  ///An [Ios] style tiny arrow widget, which can be used on [ListTile] widgets with customizations
  static Widget arrow({Color? color, bool back = false, double angle = 90}) {
    final Color _color = color ?? Colors.grey.shade200;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Transform.rotate(
        angle: angle * math.pi / 180,
        child: Icon(
          back ? Icons.chevron_left : Icons.chevron_right,
          size: 18,
          color: _color,
        ),
      ),
    );
  }

  static List<String> generateListString(List? list) {
    if (list == null) return [];
    return List<String>.generate((list).length, (index) => "${list[index]}");
  }

  // static List<Logg> generateLogs(List? list) {
  //   if (list == null) return [];
  //   return List<Logg>.generate((list).length, (index) => Logg.fromJson(list[index]));
  // }

  static String get today => "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  // static Future<bool?> call(String number) async {
  // return await FlutterPhoneDirectCaller.callNumber(number);
  // }

  // static Future<void> sendSMS(String phoneNumber, {required String text}) async {
  //   String url = 'sms:$phoneNumber?body=$text';
  //   await launchurl(url);
  // }


  // static RichTxt staffLabel(StaffType type, {String? prefix, int? time}) {
  //   return RichTxt(maxLines: 1, richStrings: [
  //     RichString(_staffTypeLabel(type)),
  //     if (prefix != null) RichString(prefix, color: Colors.grey),
  //     if (time != null) RichString(ago(time), color: Colors.grey),
  //   ]);
  // }

  // static Widget _staffTypeLabel(StaffType type) {
  //   return Container(
  //       child: Txt(
  //         text: type.viewer,
  //         fontSize: 8,
  //         color: Colors.white,
  //       ),
  //       padding: EdgeInsets.all(2),
  //       decoration: BoxDecoration(
  //         color: type.color,
  //         borderRadius: BorderRadius.circular(4),
  //       ));
  // }

  static String ago(int millisecondsSinceEpoch, {bool numericDates = true}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 8) {
      return dateTime.toString().substring(0, 10);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }



  static bool isLight(BuildContext context) => Theme.of(context).brightness == Brightness.light;

  // static Future<bool> sendEmail(String email) async {
  //   bool success = false;
  //   email = email.toLowerCase();
  //   if (email.contains('@')) {
  //     success = true;
  //     await launch("mailto:$email", forceSafariVC: false, forceWebView: false);
  //   } else {
  //     showToast("Email address not found");
  //   }
  //   return success;
  // }



  // static void debugToast(dynamic message) {
  //   if (debugging) showToast(message);
  // }

  // static void showToast(dynamic message) {
  //   if (debugging) print("$message");
  //   try {
  //     Fluttertoast.showToast(
  //       msg: '$message',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       backgroundColor: Colorz.primaryColor,
  //       textColor: Colors.white,
  //       fontSize: 16,
  //     );
  //   } catch (e) {
  //     print("Error showing Toast: $e");
  //   }
  // }

  ///[filter] Removes all the special characters and spaces
  static String filter(String text) {
    return (text.replaceAll(new RegExp(r'[^\w\s]+'), '').replaceAll(' ', '').replaceAll('_', ''));
  }

  ///Returns the [DateTime] values in a human readable format
  static String timeAgo(
    dynamic input, {
    String? prefix,
  }) {
    DateTime? finalDateTime;

    if (input is DateTime) finalDateTime = input;
    if (input is int) finalDateTime = DateTime.fromMillisecondsSinceEpoch(input);

    ///If the input is not valid, then just return ''
    if (finalDateTime == null) return '';

    final Duration difference = DateTime.now().difference(finalDateTime);
    bool isPast = finalDateTime.millisecondsSinceEpoch <= DateTime.now().millisecondsSinceEpoch;
    String ago;

    if (difference.inDays > 8) {
      ago = finalDateTime.toString().substring(0, 10);
    } else if ((difference.inDays / 7).floor() >= 1) {
      ago = isPast ? '1 week ago' : '1 week';
    } else if (difference.inDays >= 2) {
      ago = isPast ? '${difference.inDays} days ago' : '${difference.inDays} days';
    } else if (difference.inDays >= 1) {
      ago = isPast ? 'Yesterday' : 'Tomorrow';
    } else if (difference.inHours >= 2) {
      ago = '${difference.inHours} hours ${isPast ? 'ago' : ''}';
    } else if (difference.inHours >= 1) {
      ago = '1 hour ${isPast ? 'ago' : ''}';
    } else if (difference.inMinutes >= 2) {
      ago = '${difference.inMinutes} minutes ${isPast ? 'ago' : ''}';
    } else if (difference.inMinutes >= 1) {
      ago = '1 minute ${isPast ? 'ago' : ''}';
    } else if (difference.inSeconds >= 3) {
      ago = '${difference.inSeconds} seconds ${isPast ? 'ago' : ''}';
    } else {
      ago = '${isPast ? 'Just now' : 'now'}';
    }
    return prefix == null ? ago : '$prefix $ago';
  }

  static String toDateTime(int createdAt) {
    return '${toDate(createdAt)} @ ${toTime(createdAt)}';
  }

  static String toDate(int createdAt, {bool showFullYear = true, bool showYear = true}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(createdAt);
    int day = date.day;
    int _month = date.month;
    String month = toMonth(_month);
    String year = showYear ? toYear(createdAt, showFullYear: showFullYear) : "";
    return '$day $month $year';
  }

  static String toTime(int createdAt) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(createdAt);
    int hour = date.hour > 12 ? (date.hour - 12) : date.hour;
    String minutes = date.minute < 10 ? '0${date.minute}' : '${date.minute}';
    String amPm = date.hour >= 12 ? "PM" : "AM";
    return '$hour:$minutes $amPm';
  }

  static String toYear(int createdAt, {bool showFullYear = true}) {
    int _yr = DateTime.fromMillisecondsSinceEpoch(createdAt).year;
    return showFullYear ? "$_yr" : "$_yr".substring(0, 2);
  }

  static String toMonth(int month) {
    return month > 0 ? months[month - 1] : '$month';
  }

  static const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // static Future<void> launchurl(String? url, {bool inApp = false}) async {
  //   try {
  //     if (url != null) {
  //       print("URL: $url");
  //       await launch(url, forceSafariVC: inApp, forceWebView: inApp);
  //     } else {
  //       showToast("No url!");
  //     }
  //   } catch (exception) {
  //     showToast("Error $exception");
  //   }
  // }

  static Future wait(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  static void push(Widget? child, BuildContext context) {
    if (child != null) {
      Navigator.push(context, FadePageRoute(widget: child));
    } else {
      // String _log = "No destination page found";
      // debugMode ? showToast(_log) : print(_log);
    }
  }

  @Deprecated('Use pop')
  static void close(BuildContext context) => pop(context);
  static void pop(BuildContext context) {
    try {
      Navigator.pop(context);
    } catch (e) {}
  }

  static double mheight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double mwidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Widget empty() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Icon(
            Icons.delete,
            size: 100,
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  static Widget divider({Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(
        height: 4.5,
        color: color,
      ),
    );
  }



}
