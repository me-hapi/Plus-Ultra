import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ChatTutorial {
  final BuildContext context;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  ChatTutorial(this.context);

  void initTargets(
    GlobalKey keyAppBar,
    GlobalKey keyChatList,
    GlobalKey keyFAB,
  ) {
    targets.addAll([
      TargetFocus(
        identify: "appbar",
        keyTarget: keyAppBar,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildContent(
              "My AI Chats",
              "This is the main area where your AI chat sessions are displayed.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "chatList",
        keyTarget: keyChatList,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildContent(
              "Chat List",
              "Browse through your previous conversations here. Tap a card to view details.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "fab",
        keyTarget: keyFAB,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildContent(
              "New Chat",
              "Tap this button to start a new chat session with the AI.",
            ),
          ),
        ],
      ),
    ]);
  }

  void showTutorial() {
    if (targets.isEmpty) {
      print("No targets set for ChatTutorial!");
      return;
    }

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "Skip",
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      paddingFocus: 10,
      onFinish: () => print("Chat tutorial finished"),
      onClickTarget: (target) => print("Clicked target: ${target.identify}"),
      onClickOverlay: (target) =>
          print("Clicked overlay on: ${target.identify}"),
      onSkip: () {
        print("Chat tutorial skipped");
        return true;
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      tutorialCoachMark.show(context: context);
    });
  }

  Widget _buildContent(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
