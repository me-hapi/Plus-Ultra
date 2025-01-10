import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/services/auth_services/google_auth.dart';

class LandingPageButtons extends StatelessWidget {
  final Animation<Offset> buttonAnimation;

  const LandingPageButtons({
    Key? key,
    required this.buttonAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: buttonAnimation,
      child: Column(
        children: [
          ElevatedButton(
            key: Key('guestButton'),
            onPressed: () {
              context.go('/bottom-nav');
            },
            style: ElevatedButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              minimumSize: Size(150, 50),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text("Guest"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            key: Key('loginButton'),
            onPressed: () {
              context.go('/signin');
            },
            style: ElevatedButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              minimumSize: Size(150, 50),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text("Login"),
          ),
          SizedBox(height: 100),
          Text(
            "Don't have an account yet?",
            key: Key('signupText'),
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            key: Key('googleSignupButton'),
            onPressed: () {
              final googleAuthService = GoogleAuthService(context);
              googleAuthService.setupAuthListener();
              googleAuthService.googleSignIn();
            },
            style: ElevatedButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              minimumSize: Size(150, 50),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 24);
              },
            ),
            label: Text("Google"),
          ),
        ],
      ),
    );
  }
}
