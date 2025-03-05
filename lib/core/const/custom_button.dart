import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPadding;
  final double fontSize;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPadding = true,
    this.fontSize = 18,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _glowAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateButton() async {
    await _controller.forward(); // Start glow animation
    if (mounted)
      await _controller
          .reverse(); // Reverse animation if widget is still present
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Material(
          elevation: 0, // Keep this 0 to let the shadow animation work
          borderRadius: BorderRadius.circular(30),
          color: mindfulBrown['Brown80'], // Fix: Background color in Material
          child: InkWell(
            onTap: _animateButton,
            borderRadius: BorderRadius.circular(30),
            splashColor:
                Colors.white.withOpacity(0.3), // Fix: Ripple effect now visible
            highlightColor: Colors.transparent,
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: mindfulBrown['Brown50']!
                        .withOpacity(_glowAnimation.value * 0.6), // Glow effect
                    blurRadius: _glowAnimation.value * 20, // Increases on tap
                    spreadRadius:
                        _glowAnimation.value * 5, // Spreads shadow outward
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  widget.text,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return widget.isPadding
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: button,
          )
        : button;
  }
}
