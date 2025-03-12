import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/loading_screen.dart';

class StressDialog extends StatelessWidget {
  final Future<void> Function() onStressDetected;

  const StressDialog({super.key, required this.onStressDetected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(
                    Icons.close,
                    color: presentRed['Red50'],
                  ))
            ]),
            Image.asset(
              'assets/utils/stress.png', // Replace with your asset image path
              height: 220.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'Stress Detected',
              style: TextStyle(
                color: mindfulBrown['Brown80'],
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "We have detected signs of stress.\nWould you like to talk to Ligaya for some support?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: optimisticGray['Gray60'],
              ),
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: serenityGreen['Green50'],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      LoadingScreen.show(context);
                      context.pop();
                      await onStressDetected();
                      LoadingScreen.hide(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Talk to Ligaya",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showStressDialog(
    BuildContext context, Future<void> Function() onStressDetected) {
  showDialog(
    context: context,
    builder: (BuildContext context) => StressDialog(
      onStressDetected: onStressDetected,
    ),
  );
}
