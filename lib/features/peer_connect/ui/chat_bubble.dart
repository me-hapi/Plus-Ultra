import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  ChatBubble({required this.message, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.7, // Set max width to 70% of screen width
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isSentByMe ? serenityGreen['Green50'] : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomLeft:
                  isSentByMe ? Radius.circular(30.0) : Radius.circular(0),
              bottomRight:
                  isSentByMe ? Radius.circular(0) : Radius.circular(30.0),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: isSentByMe ? Colors.white : mindfulBrown['Brown80'],
            ),
          ),
        ),
      ),
    );
  }
}
