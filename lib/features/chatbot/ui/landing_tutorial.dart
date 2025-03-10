import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class LandingTutorial {
  /// Call this static method to show the coach mark on the provided button.
  static Future<void> show(BuildContext context, GlobalKey buttonKey) async {
    final globalSupabase = GlobalSupabase(client);

    // Check asynchronously if the chatbot tutorial has been finished.
    bool isChatbotFinished = await globalSupabase.chatbotFinish();
    if (isChatbotFinished) {
      return;
    }

    final targets = <TargetFocus>[
      TargetFocus(
        identify: "NewConversationButton",
        keyTarget: buttonKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              child: const Text(
                "Tap here to start a new conversation!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
    ];

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black54,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("Tutorial finished");
        globalSupabase.updateChatbot();
      },
      onSkip: () {
        print("Tutorial skipped");
        // Call updateChatbot() without awaiting as onSkip must be synchronous.
        globalSupabase.updateChatbot();
        return true;
      },
    ).show(context: context);
  }
}
