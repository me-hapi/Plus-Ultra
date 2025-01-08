import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  int _currentIndex = 0;

  final List<String> images = [
    'assets/splashscreen/splash1.png',
    'assets/splashscreen/splash2.png',
    'assets/splashscreen/splash3.png',
    'assets/splashscreen/splash4.png',
    'assets/splashscreen/splash5.png',
    'assets/splashscreen/splash6.png',
    'assets/splashscreen/splash7.png',
  ];

  final List<String> titles = [
    'Personalize Your Mental Health State With AI',
    'Intelligent Mood Tracking & Emotion Improvement',
    'Empathic Therapy Chatbot For All',
    'Hassle-Free Therapist Appointment',
    'Mental Health Journal & Self-Reflection',
    'Mindful Resources That Make You Happy',
    'Loving & Supportive Community',
  ];

  final List<Color> backgroundColors = [
    serenityGreen['Green10']!,
    empathyOrange['Orange10']!,
    mindfulBrown['Brown10']!,
    presentRed['Red10']!,
    optimisticGray['Gray10']!,
    zenYellow['Yellow10']!,
    kindPurple['Purple10']!,
  ];

  void _onLeftArrowPressed() {
    if (_currentIndex == 0) {
      context.go('/get-started');
    } else {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _onRightArrowPressed() {
    if (_currentIndex == images.length - 1) {
      context.go('/signup');
    } else {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors[_currentIndex],
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            top: -175,
            child: Image.asset(
              images[_currentIndex],
            ),
          ),

          // Bottom Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              child: CustomPaint(
                painter: ArcPainter(),
                child: Container(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Progress Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100.0),
                        child: LinearProgressIndicator(
                          minHeight: 10,
                          value: (_currentIndex + 1) / images.length,
                          borderRadius: BorderRadius.circular(30),
                          backgroundColor: optimisticGray['Gray20'],
                          valueColor: AlwaysStoppedAnimation<Color>(
                              optimisticGray['Gray60']!),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          titles[_currentIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 30,
                            color: mindfulBrown['Brown80'],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Arrows
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 120,
                              width: 160,
                              child: ElevatedButton(
                                onPressed: _onLeftArrowPressed,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: mindfulBrown['Brown80'],
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 120,
                              width: 160,
                              child: ElevatedButton(
                                onPressed: _onRightArrowPressed,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: mindfulBrown['Brown80'],
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw the shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3) // Semi-transparent shadow
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10); // Blur effect

    final shadowPath = Path();
    shadowPath.moveTo(0, 0);
    shadowPath.quadraticBezierTo(size.width / 2, -90, size.width, 0);
    shadowPath.lineTo(size.width, size.height);
    shadowPath.lineTo(0, size.height);
    shadowPath.close();

    canvas.drawPath(shadowPath, shadowPaint);

    // Draw the arc
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, -90, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
