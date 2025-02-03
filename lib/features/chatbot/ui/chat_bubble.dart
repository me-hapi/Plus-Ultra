import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/chatbot/ui/animated_text.dart';
import 'package:lingap/features/chatbot/ui/typing_indicator.dart';

class ChatBubble extends ConsumerWidget {
  final bool isUser;
  final String message;
  final VoidCallback onTextUpdate; // Add scroll trigger callback

  ChatBubble({required this.isUser, required this.message, required this.onTextUpdate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: isUser ? serenityGreen['Green50'] : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: isUser ? Radius.circular(30.0) : Radius.circular(0),
                bottomRight:
                    isUser ? Radius.circular(0) : Radius.circular(30.0),
              ),
            ),
            child: isUser
                ? Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  )
                : message == "Typing..."
                    ? TypingIndicator()
                    : AnimatedText(message, onTextUpdate: onTextUpdate),
          ),
        ));
  }
}
