import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPadding; // New parameter with a default value of true

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPadding = true, // Default value set to true
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.50,
      upperBound: 1.0, // Fixed upper bound
    );
    _scaleAnimation = _controller.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateButton() async {
    await _controller.forward();
    if (mounted) await _controller.reverse(); // Ensure it runs only if widget is mounted
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = SizedBox(
      height: 55,
      width: double.infinity,
      child: GestureDetector(
        onTap: _animateButton,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: ElevatedButton(
            onPressed: _animateButton,
            style: ElevatedButton.styleFrom(
              backgroundColor: mindfulBrown['Brown80'], // Fixed color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    return widget.isPadding
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: button,
          )
        : button;
  }
}
