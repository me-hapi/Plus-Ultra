import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final Duration duration;
  final VoidCallback onTextUpdate;

  AnimatedText(this.text,
      {this.duration = const Duration(milliseconds: 50), required this.onTextUpdate});

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charCount;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * 50),
      vsync: this,
    );

    _charCount = IntTween(begin: 0, end: widget.text.length).animate(_controller)
      ..addListener(() {
        if (mounted) {
          setState(() {});
          widget.onTextUpdate(); // Ensure scrolling when text updates
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Properly dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text.substring(0, _charCount.value),
      style: TextStyle(fontSize: 16, color: mindfulBrown['Brown80']),
    );
  }
}
