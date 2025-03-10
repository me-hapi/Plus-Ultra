import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TeleconsultTutorial {
  final BuildContext context;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  TeleconsultTutorial(this.context);

  /// Initializes the tutorial targets using the provided GlobalKeys.
  void initTargets(
    GlobalKey keyAppBar,
    GlobalKey keySearch,
    GlobalKey keyIssues,
    GlobalKey keyRecommendation,
    GlobalKey keyAllProfessionals,
  ) {
    targets.addAll([
      TargetFocus(
        identify: "appbar",
        keyTarget: keyAppBar,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildContent(
              "Find Therapist",
              "Welcome to the teleconsultation page. Use the back button to navigate or access your appointment history from the top right.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "search_bar",
        keyTarget: keySearch,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildContent(
              "Search",
              "Type here to search for therapists by name or specialty.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "issues_row",
        keyTarget: keyIssues,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildContent(
              "Browse by Issues",
              "Select an issue to filter therapists by expertise.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "recommendation",
        keyTarget: keyRecommendation,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildContent(
              "Recommendation",
              "This section shows a personalized therapist recommendation based on your location.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "all_professionals",
        keyTarget: keyAllProfessionals,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildContent(
              "All Professionals",
              "Browse through all available professionals below.",
            ),
          ),
        ],
      ),
    ]);
  }

  Future<void> updateTeleconsult() async {
    await GlobalSupabase(client).updateTeleconsult();
  }

  /// Displays the tutorial overlays.
  Future<void> showTutorial() async {
    if (targets.isEmpty) {
      print("No targets set for TeleconsultTutorial!");
      return;
    }

    final isConsultFinish = await GlobalSupabase(client).teleconsultFinish();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "Skip",
      textStyleSkip:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      paddingFocus: 10,
      onFinish: () {
        updateTeleconsult();
      },
      onClickTarget: (target) => print("Clicked target: ${target.identify}"),
      onClickOverlay: (target) =>
          print("Clicked overlay on: ${target.identify}"),
      onSkip: () {
        print("Teleconsult tutorial skipped");
        updateTeleconsult();
        return true;
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isConsultFinish) {
        tutorialCoachMark.show(context: context);
      }
    });
  }

  /// Helper method to build the content displayed in each overlay.
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
