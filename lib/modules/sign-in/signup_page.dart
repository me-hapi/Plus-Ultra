import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/const/loading_screen.dart';
import 'package:lingap/modules/sign-in/sign_logic.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignLogic signLogic = SignLogic(client);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  bool isVisible = false;
  bool isVisibleCon = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
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
                      SizedBox(
                        height: 80,
                      ),
                      Image.asset('assets/logo.png', height: 60),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Center(
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 32,
                  color: mindfulBrown['Brown80'],
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Email Address',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: mindfulBrown['Brown80']),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                        decoration: InputDecoration(
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Password',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: mindfulBrown['Brown80']),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Password Confirmation',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: mindfulBrown['Brown80']),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                        controller: _passwordConfirmationController,
                        obscureText: !isVisibleCon,
                        obscuringCharacter: '•',
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisibleCon = !isVisibleCon;
                              });
                            },
                            child: Icon(isVisibleCon
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          border: InputBorder.none,
                          hintText: 'Enter your password',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Check if email, password, and password confirmation fields are not empty
                    if (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty &&
                        _passwordConfirmationController.text.isNotEmpty) {
                      final password = _passwordController.text;

                      // Check if the passwords match
                      if (password == _passwordConfirmationController.text) {
                        // Check if the password meets the criteria
                        if (RegExp(
                                r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                            .hasMatch(password)) {
                          LoadingScreen.show(
                              context); // Show the loading screen

                          try {
                            // Attempt to sign up the user
                            if (await signLogic.signUpWithEmail(
                              _emailController.text,
                              password,
                              context,
                            )) {
                              // Navigate to the next screen after successful signup
                              context.push('/otpsetup',
                                  extra: _emailController.text);
                            } else {
                              // Handle signup failure (e.g., show an error message)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Signup failed. Please try again.'),
                                ),
                              );
                            }
                          } finally {
                            LoadingScreen.hide(
                                context); // Hide the loading screen
                          }
                        } else {
                          // Show a SnackBar if the password doesn't meet the criteria
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Password must contain at least 8 characters, an uppercase letter, a lowercase letter, a number, and a special character.'),
                            ),
                          );
                        }
                      } else {
                        // Show a SnackBar if passwords do not match
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Passwords do not match.'),
                          ),
                        );
                      }
                    } else {
                      // Show a SnackBar if email or password fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Email, password, and password confirmation cannot be empty.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        mindfulBrown['Brown80'], // Set background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold, // Optional for emphasis
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      color: optimisticGray['Gray60']!),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(
                        color: serenityGreen['Green50']!,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.go('/signin');
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
