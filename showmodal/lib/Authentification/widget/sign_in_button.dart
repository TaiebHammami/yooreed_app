import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showmodal/Authentification/authProvider/auth_provider.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final AuthState isLoading;

  const MyButton(
      {super.key,
      required this.onTap,
      required this.title,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:
                Get.isDarkMode ? Theme.of(context).canvasColor : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            maximumSize: Size(double.infinity, 60),
            minimumSize: Size(double.infinity, 60)),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading == AuthState.loadingReset
                ? CircularProgressIndicator(
                    color: Theme.of(context).progressIndicatorTheme.color,
                  )
                : Text(''),
            Text(title),
          ],
        ));
  }
}
