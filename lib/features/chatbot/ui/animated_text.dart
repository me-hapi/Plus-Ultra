import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final Duration duration;
  final VoidCallback onTextUpdate;
  final VoidCallback? onCompleted;
  String emotion;

  AnimatedText(
    this.text, {
    this.duration = const Duration(milliseconds: 50),
    required this.onTextUpdate,
    this.emotion = 'neutral',
    this.onCompleted,
  });

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
      duration: Duration(milliseconds: widget.text.length * 30),
      vsync: this,
    );

    _charCount =
        IntTween(begin: 0, end: widget.text.length).animate(_controller)
          ..addListener(() {
            if (mounted) {
              setState(() {});
              widget.onTextUpdate(); // Ensure scrolling when text updates
            }
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              // Only call once, and let `onCompleted` handle specific actions
              widget.onCompleted?.call();
            }
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Properly dispose of the animation controller
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
