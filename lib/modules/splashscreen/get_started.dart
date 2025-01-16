import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';

class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular Frame with Logo
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset('assets/logo.png'),
              ),
            ),
            const SizedBox(height: 20),

            // Welcome Text
            Text(
              'Welcome to Lingap',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
                color: mindfulBrown['Brown80'],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your mindful mental health AI companion\nfor everyone, anywhere 🍂',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),

            // Robot Image
            Image.asset(
              'assets/splashscreen/robot.png',
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 40),

            // Get Started Button
            SizedBox(
              width: 350,
              child: ElevatedButton(
                onPressed: () {
                  //BUTTON
                  context.go('/introduction');
                  //BUTTONv
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor:
                      mindfulBrown['Brown80'], // Customize color as needed
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Already Have an Account Text
            GestureDetector(
              onTap: () {
                // Navigate to Sign In page
                setState(() {
                  // Update the state if necessary
                });
              },
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: optimisticGray['Gray60'],
                      fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Sign in',
                      style: TextStyle(
                        color: serenityGreen['Green50'],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push('/data');
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
