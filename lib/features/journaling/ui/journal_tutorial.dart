import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class JournalTutorial {
  final BuildContext context;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  JournalTutorial(this.context);

  /// Initializes tutorial targets with the provided GlobalKeys.
  void initTargets(
    GlobalKey keyAppBar,
    GlobalKey keyJournalCount,
    GlobalKey keyStats,
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
              "Journaling Page",
              "Welcome to your journaling page. Here you can see an overview of your journals for the year.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "journal_count",
        keyTarget: keyJournalCount,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildContent(
              "Journal Count",
              "This area displays the total number of journals you've written this year.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "journal_stats",
        keyTarget: keyStats,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildContent(
              "Journal Statistics",
              "Tap 'See All' to view detailed statistics of your journaling activities.",
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
              "New Journal",
              "Tap this button to create a new journal entry.",
            ),
          ),
        ],
      ),
    ]);
  }

  Future<void> updateJournal() async {
    await GlobalSupabase(client).updateJournal();
  }

  /// Displays the tutorial if the targets are set.
  Future<void> showTutorial() async {
    if (targets.isEmpty) {
      print("No targets set for JournalTutorial!");
      return;
    }
    final isJournalFinish = await GlobalSupabase(client).journalFinish();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "Skip",
      textStyleSkip:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      paddingFocus: 10,
      onFinish: () {
        updateJournal();
      },
      onClickTarget: (target) => print("Clicked target: ${target.identify}"),
      onClickOverlay: (target) =>
          print("Clicked overlay on: ${target.identify}"),
      onSkip: () {
        print("Journal tutorial skipped");
        updateJournal();
        return true;
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isJournalFinish) {
        tutorialCoachMark.show(context: context);
      }
    });
  }

  /// Builds the content displayed inside each tutorial overlay.
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
