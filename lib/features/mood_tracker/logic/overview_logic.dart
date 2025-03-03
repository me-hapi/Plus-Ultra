import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/mood_tracker/data/supabase_db.dart';
import 'package:lingap/core/const/colors.dart';

class OverviewLogic {
  final SupabaseDB supabase = SupabaseDB(client);
  Map<int, int> moodData = {};
  int weekMood = 0;

  List<Map<String, dynamic>> moodSelection = [
    {
      'mood': 'cheerful',
      'value': 5,
      'color': serenityGreen['Green40'],
      'image': 'assets/tracker/moodGreen.png',
      'icon': 'assets/whiteMoods/whiteGreen.png'
    },
    {
      'mood': 'happy',
      'value': 4,
      'color': zenYellow['Yellow40'],
      'image': 'assets/tracker/moodYellow.png',
      'icon': 'assets/whiteMoods/whiteYellow.png'
    },
    {
      'mood': 'neutral',
      'value': 3,
      'color': mindfulBrown['Brown40'],
      'image': 'assets/tracker/moodBrown.png',
      'icon': 'assets/whiteMoods/whiteBrown.png'
    },
    {
      'mood': 'sad',
      'value': 2,
      'color': empathyOrange['Orange40'],
      'image': 'assets/tracker/moodOrange.png',
      'icon': 'assets/whiteMoods/whiteOrange.png'
    },
    {
      'mood': 'awful',
      'value': 1,
      'color': kindPurple['Purple40'],
      'image': 'assets/tracker/moodPurple.png',
      'icon': 'assets/whiteMoods/whiteBlue.png'
    },
  ];

  String getDayLabel(int weekday) {
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return dayLabels[weekday - 1];
  }

  Future<void> fetchMoodData() async {
    List<Map<String, dynamic>> moods = await supabase.getPastWeekMoods();
    print('MOODpage: $moods');

    Map<String, int> moodIndexes = {
      "cheerful": 0,
      "happy": 1,
      "neutral": 2,
      "sad": 3,
      "awful": 4,
    };

    Map<int, int> moodCount = {};
    moodData.clear();

    for (var mood in moods) {
      int weekday = DateTime.parse(mood['created_at']).weekday;
      int moodIndex = moodIndexes[mood['mood'].toString().toLowerCase()] ?? -1;
      if (moodIndex >= 0) {
        moodData[weekday] = moodIndex;
        moodCount[moodIndex] = (moodCount[moodIndex] ?? 0) + 1;
      }
    }

    print('moodCOunt $moodCount');
    if (moodCount.isNotEmpty) {
      // Get the max frequency
      int maxValue = moodCount.values.reduce((a, b) => a > b ? a : b);

      // Get all moods with the max frequency
      List<int> candidates = moodCount.entries
          .where((entry) => entry.value == maxValue)
          .map((entry) => entry.key)
          .toList();

      // Pick the highest index if there are multiple candidates
      weekMood = candidates.reduce((a, b) => a > b ? a : b);
    }
  }
}
