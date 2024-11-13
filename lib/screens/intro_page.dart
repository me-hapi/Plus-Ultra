import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/screens/landing_page.dart';

class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<Offset> _imageAnimation;
  late Animation<Offset> _buttonAnimation;

  final List<String> _texts = [
    "Welcome to Lingap: Your partner in Mental Wellness",
    "Connect with our chatbot for 24/7 mental health support and guidance.",
    "Schedule virtual consultations with licensed mental health professionals.",
    "Join a community of users to share experiences and find support.",
    "Track your mental and physical health metrics through wearable devices.",
    "Document your thoughts and progress in a private journal",
    "Your privacy is our priority. Lingap uses encryption and secure methods to keep your data safe.",
    "Ready to begin your mental wellness journey?",
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _imageAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.7),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
    _buttonAnimation = Tween<Offset>(
      begin: Offset(0, 1.5),
      end: Offset(0, -0.1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _texts.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 900), curve: Curves.easeInOutCubic);
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _skipToEnd() {
    setState(() {
      _currentIndex = _texts.length - 1;
    });
    _pageController.animateToPage(_currentIndex,
        duration: Duration(milliseconds: 700), curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            key: Key('pageView'),
            controller: _pageController,
            physics: _currentIndex == _texts.length - 1
                ? NeverScrollableScrollPhysics()
                : null,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
                if (_currentIndex == _texts.length - 1) {
                  _animationController.forward();
                } else {
                  _animationController.reset();
                }
              });
            },
            itemCount: _texts.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                key: Key('page_$index'),
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                  }
                  return Transform(
                    transform: Matrix4.identity()..scale(value, value),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (index == _texts.length - 1)
                            SlideTransition(
                              position: _imageAnimation,
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/test.jpg',
                                    key: Key('image_$index'),
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.image_not_supported,
                                          size: 200, color: Colors.grey);
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    _texts[index],
                                    key: Key('text_$index'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          if (index != _texts.length - 1)
                            Image.asset(
                              'assets/test.jpg',
                              key: Key('image_$index'),
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image_not_supported,
                                    size: 200, color: Colors.grey);
                              },
                            ),
                          if (index != _texts.length - 1) SizedBox(height: 20),
                          if (index != _texts.length - 1)
                            Text(
                              _texts[index],
                              key: Key('text_$index'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (_currentIndex == _texts.length - 1)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: LandingPageButtons(buttonAnimation: _buttonAnimation),
            ),
          if (_currentIndex != _texts.length - 1)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                key: Key('skipButton'),
                onPressed: _skipToEnd,
                child: Text(
                  "Skip",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (_currentIndex != _texts.length - 1)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Row(
                key: Key('paginationDots'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_texts.length, (index) {
                  return AnimatedContainer(
                    key: Key('dot_$index'),
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: _currentIndex == index ? 20 : 10,
                    decoration: BoxDecoration(
                      color: _currentIndex == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
            ),
          if (_currentIndex != _texts.length - 1)
            Positioned(
              bottom: 30,
              right: 20,
              child: FloatingActionButton(
                key: Key('nextButton'),
                onPressed: _nextPage,
                child: Icon(Icons.arrow_forward),
              ),
            ),
        ],
      ),
    );
  }
}
