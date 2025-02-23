import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/modules/sign-in/sign_logic.dart';
import 'package:lingap/services/auth_services/google_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final SignLogic signLogic = SignLogic(client);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CustomPaint(
                size: const Size(double.infinity, 150),
                painter: ConvexArcPainter(),
                child: Container(
                  height: 180,
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Image.asset('assets/logo.png', height: 60),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Center(
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 32,
                  color: mindfulBrown['Brown80'],
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: mindfulBrown['Brown80'],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Focus(
                child: Builder(
                  builder: (context) {
                    final isFocused = Focus.of(context).hasFocus;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: isFocused
                              ? serenityGreen['Green50']!
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: isFocused
                            ? [
                                BoxShadow(
                                  color: serenityGreen['Green20']!,
                                  spreadRadius: 5,
                                  blurRadius: 0,
                                ),
                              ]
                            : [],
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          border: InputBorder.none,
                          hintText: 'Enter your email',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: mindfulBrown['Brown80'],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Focus(
                child: Builder(
                  builder: (context) {
                    final isFocused = Focus.of(context).hasFocus;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: isFocused
                              ? serenityGreen['Green50']!
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: isFocused
                            ? [
                                BoxShadow(
                                  color: serenityGreen['Green20']!,
                                  spreadRadius: 5,
                                  blurRadius: 0,
                                ),
                              ]
                            : [],
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !isVisible,
                        obscuringCharacter: '•',
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: Icon(isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          border: InputBorder.none,
                          hintText: 'Enter your password',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                        style: TextStyle(
                            fontSize: 16, color: mindfulBrown['Brown80']),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Handle sign-in logic here
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');

                    if (await signLogic.signInWithEmail(_emailController.text,
                        _passwordController.text, context)) {
                      context.go('/bottom-nav');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mindfulBrown['Brown80'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    final googleAuthService = GoogleAuthService(context);
                    googleAuthService.setupAuthListener();
                    googleAuthService.googleSignIn();
                  },
                  child: CircleAvatar(
                    radius: 30, // Circle size
                    backgroundColor:
                        Colors.white, // Set background color to white
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo/google.png',
                        width: 30, // Adjust the logo size
                        height: 30, // Adjust the logo size
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {
                    await signLogic.signInAnonymously();
                    context.go('/data');
                  },
                  child: CircleAvatar(
                    radius: 30, // Circle size
                    backgroundColor:
                        Colors.white, // Set background color to white
                    child: Image.asset(
                      'assets/logo/incognity.png',
                      width: 25, // Adjust the logo size
                      height: 25, // Adjust the logo size
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 45),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(
                    fontSize: 14,
                    color: optimisticGray['Gray60']!,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        color: serenityGreen['Green50']!,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.go('/signup');
                        },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle Forgot Password
                  print('Forgot Password tapped');
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: serenityGreen['Green50']!,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConvexArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = mindfulBrown['Brown20']!
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 30)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + 30,
        size.width,
        size.height - 30,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
