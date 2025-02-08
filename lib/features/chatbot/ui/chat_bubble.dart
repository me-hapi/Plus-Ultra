import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/chatbot/ui/animated_text.dart';
import 'package:lingap/features/chatbot/ui/typing_indicator.dart';

class ChatBubble extends ConsumerWidget {
  final bool animateText;
  final bool isUser;
  final String message;
  final VoidCallback onTextUpdate;
  String emotion;
  final VoidCallback? onCompleted;
  final Function(String)? onOptionSelected; // <-- New callback

  ChatBubble({
    required this.isUser,
    required this.message,
    required this.onTextUpdate,
    required this.animateText,
    this.emotion = 'neutral',
    this.onCompleted,
    this.onOptionSelected, // <-- Initialize callback
  });

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
              bottomRight: isUser ? Radius.circular(0) : Radius.circular(30.0),
            ),
          ),
          child: message == 'option'
              ? Column(
                  children: [
                    _buildOptionButton(
                        "Did not apply to me at all", onOptionSelected),
                    SizedBox(
                      height: 5,
                    ),
                    _buildOptionButton(
                        "Applied to me to some degree", onOptionSelected),
                    SizedBox(
                      height: 5,
                    ),
                    _buildOptionButton("Applied to me a considerable degree",
                        onOptionSelected),
                    SizedBox(
                      height: 5,
                    ),
                    _buildOptionButton(
                        "Applied to me very much or most of the time",
                        onOptionSelected),
                  ],
                )
              : isUser
                  ? message == 'close'
                      ? Column(
                          children: [
                            _buildOptionButton("Oo", onOptionSelected),
                            SizedBox(
                              height: 5,
                            ),
                            _buildOptionButton("Hindi", onOptionSelected),
                          ],
                        )
                      : Text(
                          message,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        )
                  : message == "Typing..."
                      ? TypingIndicator()
                      : animateText
                          ? AnimatedText(
                              message,
                              onTextUpdate: onTextUpdate,
                              emotion: emotion,
                              onCompleted: onCompleted,
                            )
                          : Text(message,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: mindfulBrown['Brown80'])),
        ),
      ),
    );
  }

  // Helper function to create option buttons
  Widget _buildOptionButton(String optionText, Function(String)? callback) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: mindfulBrown['Brown80'],
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
        ),
        onPressed: () {
          if (callback != null) {
            callback(optionText); // Pass the selected option to the callback
          }
        },
        child: Text(optionText, textAlign: TextAlign.center),
      ),
    );
  }
}
