import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeTutorial {
  final BuildContext context;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  HomeTutorial(this.context);

  void initTargets(
      GlobalKey keyGreeting,
      GlobalKey keyNotification,
      GlobalKey keySetting,
      GlobalKey keyWearable,
      GlobalKey keyMindfulness,
      GlobalKey keyHeartRate,
      GlobalKey keyBloodPressure,
      GlobalKey keySleep,
      GlobalKey keyMood) {
    targets.addAll([
      TargetFocus(
        identify: "greeting",
        keyTarget: keyGreeting,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: _buildContent("Welcome to Lingap!",
                  "This is your dashboard where you can access all features of the app."))
        ],
      ),
      TargetFocus(
        identify: "settings",
        keyTarget: keySetting,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: _buildContent("Settings",
                  "Here you can configure your preferences and personal information."))
        ],
      ),
      TargetFocus(
        identify: "notification",
        keyTarget: keyNotification,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: _buildContent("Notifications",
                  "Stay updated with important reminders and updates here."))
        ],
      ),
      TargetFocus(
        identify: "wearable",
        keyTarget: keyWearable,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: _buildContent("Wearable Data",
                  "Monitor and sync your wearable health data here."))
        ],
      ),
      TargetFocus(
        identify: "mindfulness",
        keyTarget: keyMindfulness,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: _buildContent("Mindfulness Tracker",
                  "Track your mindfulness activities, such as breathing exercises and meditation."))
        ],
      ),
      TargetFocus(
        identify: "heart_rate",
        keyTarget: keyHeartRate,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: _buildContent(
                  "Heart Rate", "Monitor your heart rate trends and insights."))
        ],
      ),
      TargetFocus(
        identify: "blood_pressure",
        keyTarget: keyBloodPressure,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: _buildContent("Blood Pressure",
                  "Check and manage your blood pressure readings."))
        ],
      ),
      TargetFocus(
        identify: "sleep",
        keyTarget: keySleep,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: _buildContent("Sleep Tracker",
                  "Review your sleep patterns and get recommendations for better rest."))
        ],
      ),
      TargetFocus(
        identify: "mood",
        keyTarget: keyMood,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: _buildContent("Mood Tracker",
                  "Track your mood changes and emotional trends over time."))
        ],
      ),
    ]);
  }

  int counter = 0;
  void showTutorial(BuildContext context, VoidCallback scrollToBottom) {
    print("Attempting to show tutorial...");

    if (targets.isEmpty) {
      print("Tutorial targets are empty!");
      return;
    }

    tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black,
        textSkip: "Skip",
        textStyleSkip:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        paddingFocus: 10,
        onFinish: () => print("Tutorial finished"),
        onClickTarget: (target) {
          print("Clicked target: ${target.identify}");
          counter++;
          print("Counter: $counter");
          if (counter == 5) {
            scrollToBottom();
          }
        },
        onClickOverlay: (target) => print("Clicked overlay"),
        onSkip: () {
          print("skip");
          return true;
        });

    Future.delayed(Duration(milliseconds: 500), () {
      tutorialCoachMark.show(context: context);
    });
  }

  Widget _buildContent(String title, String description) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(description, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
