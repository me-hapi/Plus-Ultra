import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class PeerTutorial {
  final BuildContext context;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  PeerTutorial(this.context);

  /// Initializes tutorial targets with the provided GlobalKeys.
  void initTargets(
    GlobalKey keyAppBar,
    GlobalKey keySearch,
    GlobalKey keyFAB,
    GlobalKey keyBottomTabs,
  ) {
    targets.addAll([
      TargetFocus(
        identify: "appbar",
        keyTarget: keyAppBar,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildContent(
              "Chat Home",
              "Welcome to the chat page. Here you can view your active conversations.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "search",
        keyTarget: keySearch,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildContent(
              "Search",
              "Use this bar to search for chats or users.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "floatingButton",
        keyTarget: keyFAB,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildContent(
              "Quick Action",
              "Tap this button for quick access to additional features.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "bottomTabs",
        keyTarget: keyBottomTabs,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildContent(
              "Toggle Tabs",
              "Switch between 'Messages' and 'Connect' to view different chats.",
            ),
          ),
        ],
      ),
    ]);
  }

  Future<void> updatePeer() async {
    await GlobalSupabase(client).updatePeer();
  }

  /// Displays the tutorial overlays.
  Future<void> showTutorial() async {
    if (targets.isEmpty) {
      print("No targets set for PeerTutorial!");
      return;
    }

    final isPeerFinish = await GlobalSupabase(client).peerFinish();

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "Skip",
      textStyleSkip:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      paddingFocus: 10,
      onFinish: () {
        updatePeer();
      },
      onClickTarget: (target) => print("Clicked target: ${target.identify}"),
      onClickOverlay: (target) =>
          print("Clicked overlay on: ${target.identify}"),
      onSkip: () {
        print("Peer tutorial skipped");
        updatePeer();
        return true;
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isPeerFinish) {
        tutorialCoachMark.show(context: context);
      }
    });
  }

  /// Builds the overlay content.
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
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(description, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
