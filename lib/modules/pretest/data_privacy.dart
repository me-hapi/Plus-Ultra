import 'package:flutter/gestures.dart';
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
  bool showPrivacy = false;

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
            if (showPrivacy)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '''
Privacy PolicyEffective Date: March 2025

1. IntroductionWelcome to Lingap, an AI-driven mental health application designed to provide personalized mental health support while prioritizing user privacy and data security. This Privacy Policy outlines how we collect, use, and protect your personal information when you use Lingap.

2. Information We CollectWe collect different types of data to enhance your experience and provide personalized mental health support. The types of information we collect include:
Personal Information: Name, email address, and contact details (only when voluntarily provided for account creation and support).
Health Data: Self-reported mood, stress levels, sleep patterns, journal entries, and wearable device data (such as heart rate and blood pressure) to offer personalized recommendations.
Chatbot Conversations: Conversations with our AI chatbot for mental health assistance. These are analyzed locally on your device and, if needed, securely processed for model improvement while preserving anonymity.
Usage Data: How you interact with Lingap (e.g., features used, session duration) to enhance our services.

3. How We Use Your InformationYour data is used to:
Provide personalized mental health recommendations.
Enable chatbot interactions and virtual consultations.
Improve app functionality through AI learning mechanisms.
Maintain compliance with legal and regulatory requirements.

4. Data Storage and SecurityWe prioritize security by implementing:
End-to-End Encryption: Protects data in transit and at rest.
Secure Cloud and Local Storage: Personalization data is stored on the user’s device, while anonymized insights contribute to global improvements.
Access Control Measures: Only authorized personnel can access user data when necessary for support.

5. Data Sharing and Third PartiesLingap does not sell or share your personal data with third parties for advertising purposes. We only share data in the following situations:
With Licensed Professionals: If you engage in virtual consultations, data is securely shared with mental health professionals.
For Legal Compliance: If required by law or to protect user safety, we may disclose necessary information to authorities.
With Your Consent: In specific situations where you provide explicit permission.

6. User Rights and ControlAs a Lingap user, you have control over your data. You can:
Access and Edit Your Data: Update or modify personal information through the app settings.
Request Data Deletion: You may request the permanent deletion of your data at any time.

7. Children's PrivacyLingap is designed for users aged 18 and above. We do not knowingly collect data from children under 18. If we discover such data, we will promptly delete it.

8. Changes to This Privacy PolicyWe may update this Privacy Policy to reflect changes in our services or legal requirements. Users will be notified of significant updates.

9. Contact UsIf you have questions about this Privacy Policy or how we handle your data, please contact us at:lingap.life@gmail.com

By using Lingap, you agree to this Privacy Policy and our commitment to protecting your privacy while providing personalized mental health support.

''',
                  textAlign: TextAlign.justify,
                  style:
                      TextStyle(fontSize: 14, color: mindfulBrown['Brown80']),
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
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to privacy policy page or show dialog
                            print("Privacy Policy tapped!");
                            setState(() {
                              showPrivacy = !showPrivacy;
                            });
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            CustomButton(
                text: 'Continue',
                onPressed: () {
                  if (isChecked) {
                    context.push('/assessment');
                  }
                }),
            SizedBox(
              height: 25,
            )
            // SizedBox(
            //   width: 330, // Set the desired width
            //   height: 50, // Set the desired height
            //   child: ElevatedButton(
            //     onPressed: isChecked
            //         ? () {
            //             context.push('/assessment');
            //           }
            //         : null,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor:
            //           isChecked ? mindfulBrown['Brown80'] : Colors.grey,
            //     ),
            //     child: Text(
            //       'Continue',
            //       style: TextStyle(
            //           color:
            //               isChecked ? Colors.white : optimisticGray['Gray50'],
            //           fontWeight: FontWeight.w700),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
