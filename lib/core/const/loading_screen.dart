import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class LoadingScreen {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent background
          elevation: 0,
          child: Center(
            child: SizedBox(
              width: 70, // Set the width of the CircularProgressIndicator
              height: 70, // Set the height of the CircularProgressIndicator
              child: CircularProgressIndicator(
                strokeWidth: 6.0, // Increase the thickness
                valueColor:
                    AlwaysStoppedAnimation<Color>(serenityGreen['Green50']!),
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop(); // Dismiss the dialog
  }
}
