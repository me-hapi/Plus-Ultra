import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/custom_button.dart';

class DataPrivacyScreen extends StatefulWidget {
  @override
  _DataPrivacyScreenState createState() => _DataPrivacyScreenState();
}

class _DataPrivacyScreenState extends State<DataPrivacyScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text(
              'Data Privacy',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mindfulBrown['Brown80'],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            Image.asset(
              'assets/splashscreen/data_privacy.png',
              height: 250,
            ),
            // Text(
            //   '100% Secure',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            SizedBox(height: 20),
            Text(
              'Welcome to Lingap\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: mindfulBrown['Brown80']),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'In the next step, we\'ll ask a few questions to assess your mental health '
                'and gather some personal information for a more personalized experience. '
                'Rest assured, your privacy and data security are our top priorities.\n\n'
                'Before proceeding, kindly review our privacy terms below and confirm to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: mindfulBrown['Brown80']),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isChecked = !isChecked;
                    });
                  },
                  child: Image.asset(
                    isChecked
                        ? 'assets/splashscreen/checked.png'
                        : 'assets/splashscreen/unchecked.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    text: 'I Agree to the ',
                    style: TextStyle(
                        fontFamily: 'Urbanist',
                        color: mindfulBrown['Brown80'],
                        fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: serenityGreen['Green50'],
                          fontWeight: FontWeight.bold,
                        ),
                        // Add gesture recognizer if needed for navigation
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // CustomButton(
            //     text: 'Continue',
            //     onPressed: () {
            //       if (isChecked) {
            //         context.push('/assessment');
            //       }
            //     })
            SizedBox(
              width: 330, // Set the desired width
              height: 50, // Set the desired height
              child: ElevatedButton(
                onPressed: isChecked
                    ? () {
                        context.push('/assessment');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isChecked ? mindfulBrown['Brown80'] : Colors.grey,
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                      color:
                          isChecked ? Colors.white : optimisticGray['Gray50'],
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
