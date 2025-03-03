import 'package:fl_chart/fl_chart.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/mindfulness/data/supabase.dart' as mindful;
import 'package:lingap/features/mood_tracker/data/supabase_db.dart' as mood;
import 'package:lingap/features/sleep_tracker/data/supabase.dart' as sleep;
import 'package:lingap/features/wearable_device/data/supabase_db.dart'
    as wearable;
import 'package:lingap/features/wearable_device/logic/health_connect.dart';

class HomeLogic {
  final wearable.SupabaseDB wearable_db = wearable.SupabaseDB();
  final mood.SupabaseDB mood_db = mood.SupabaseDB(client);
  final sleep.SupabaseDB sleep_db = sleep.SupabaseDB(client);
  final mindful.SupabaseDB mindful_db = mindful.SupabaseDB(client);
  bool isConnected = false;
  final HealthLogic healthLogic = HealthLogic();
  String? name;
  String? imageUrl;

  Map<String, dynamic> healthDataMap = {};

  Future<Map<String, double>> fetchMindfulness() async {
    final result = await mindful_db.fetchMindfulness();
    return convert(result);
  }

  Map<String, double> convert(List<Map<String, dynamic>> result) {
    // Initialize exercise totals (in seconds)
    Map<String, int> exerciseSeconds = {
      'Breathing': 0,
      'Relaxation': 0,
      'Sleep': 0,
      'Meditation': 0,
    };

    // Sum up total seconds for each exercise category
    for (var entry in result) {
      String exerciseType =
          entry['exercise'] ?? ''; // Ensure exercise key exists
      int minutes = entry['minutes'] ?? 0;
      int seconds = entry['seconds'] ?? 0;

      if (exerciseSeconds.containsKey(exerciseType)) {
        exerciseSeconds[exerciseType] =
            exerciseSeconds[exerciseType]! + (minutes * 60) + seconds;
      }
    }

    // Convert total seconds to hours (double)
    Map<String, double> exerciseHours = {
      for (var key in exerciseSeconds.keys)
        key: exerciseSeconds[key]! / 3600 // Convert seconds to hours
    };

    return exerciseHours;
  }

  Future<Map<String, dynamic>> fetchMood() async {
    final result = await mood_db.getPastWeekMoods();

    if (result.isEmpty) {
      return {'spots': [], 'average': null};
    }

    print('MOOD: $result');

    final Map<String, int> moodIndexes = {
      "cheerful": 0,
      "happy": 1,
      "neutral": 2,
      "sad": 3,
      "awful": 4,
    };

    List<FlSpot> spots = [];
    Map<int, int> moodCount = {}; // Store mood frequencies
    String latestMood = 'neutral'; // Default if no valid moods are found

    for (int i = 0; i < result.length; i++) {
      final moodData = result[i];
      final String mood = moodData['mood'].toLowerCase();
      final DateTime date = DateTime.parse(moodData['created_at']);

      if (!moodIndexes.containsKey(mood)) continue;

      final int moodIndex = moodIndexes[mood]!;
      spots.add(FlSpot(i.toDouble(), moodIndex.toDouble()));

      // Count occurrences of each mood index
      moodCount[moodIndex] = (moodCount[moodIndex] ?? 0) + 1;

      // Store the latest mood (the last entry in the dataset)
      latestMood = mood;
    }

    print('Mood Frequency Map: $moodCount');

    int mostFrequentMood = moodIndexes['neutral']!; // Default to 'neutral'

    if (moodCount.isNotEmpty) {
      // Get the highest frequency
      int maxFrequency = moodCount.values.reduce((a, b) => a > b ? a : b);

      // Get all moods with this max frequency
      List<int> candidates = moodCount.entries
          .where((entry) => entry.value == maxFrequency)
          .map((entry) => entry.key)
          .toList();

      print('Candidates with max frequency: $candidates');

      // Select the highest index in case of a tie
      mostFrequentMood = candidates.reduce((a, b) => a > b ? a : b);
    }

    // If no mood is dominant, use the latest mood
    String averageMood = moodCount.isNotEmpty
        ? moodIndexes.entries
            .firstWhere((entry) => entry.value == mostFrequentMood,
                orElse: () =>
                    MapEntry(latestMood, moodIndexes[latestMood] ?? 2))
            .key
        : latestMood;

    print('Final Selected Mood: $averageMood');

    return {
      'spots': spots,
      'average': averageMood,
    };
  }

  Future<Map<String, dynamic>> fetchSleep() async {
    final result = await sleep_db.getPastWeeksleeps();

    if (result.isEmpty) {
      return {'spots': [], 'average': 0.0};
    }

    List<FlSpot> spots = [];
    double totalSleep = 0.0;

    for (int i = 0; i < result.length; i++) {
      final sleepData = result[i];
      final double sleepHour = sleepData['sleep_hour'].toDouble() ?? 0.0;
      final DateTime date = DateTime.parse(sleepData['created_at']);

      spots.add(FlSpot(i.toDouble(), sleepHour));
      totalSleep += sleepHour;
    }

    double averageSleep = totalSleep / result.length;

    return {
      'spots': List<FlSpot>.from(spots),
      'average': averageSleep,
    };
  }

  double _extractNumericValue(dynamic value) {
    if (value is num) {
      return value.toDouble(); // Directly return if it's already numeric
    }

    if (value is String) {
      if (value.contains('/')) {
        // Handle blood pressure (systolic/diastolic format)
        List<String> parts = value.split('/');
        double systolic = double.tryParse(parts[0]) ?? 0.0;
        double diastolic = double.tryParse(parts[1]) ?? 0.0;
        return systolic - diastolic; // Return Pulse Pressure
      } else {
        // Handle single numeric string
        return double.tryParse(value) ?? 0.0;
      }
    }

    return 0.0; // Default fallback
  }

  Map<String, dynamic> convertData(List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> categorizedData = {};
    List<FlSpot> flSpots = [];

    for (var entry in data) {
      String type = entry['type'];
      DateTime date = DateTime.parse(entry['date']);
      String rawValue =
          entry['value'].toString(); // Keep the raw value for latest
      double numericValue =
          _extractNumericValue(entry['value']); // Convert only for spots

      if (!categorizedData.containsKey(type)) {
        categorizedData[type] = [];
      }

      categorizedData[type]!.add({
        'date': date,
        'value': numericValue, // Use numeric value for spots
        'rawValue': rawValue, // Store raw value separately
      });
    }

    Map<String, dynamic> result = {};

    categorizedData.forEach((key, value) {
      // Sort by time (earliest to latest)
      value.sort((a, b) => a['date'].compareTo(b['date']));

      // Convert to FlSpot
      flSpots = value.map((data) {
        double x = data['date'].millisecondsSinceEpoch.toDouble();
        double y = data['value']; // Use extracted numeric value
        return FlSpot(x, y);
      }).toList();

      // Latest metric (most recent value as raw string)
      String latestMetric = value.isNotEmpty ? value.last['rawValue'] : 'N/A';

      result[key] = {
        'spots': flSpots,
        'latest': latestMetric, // Use raw string for latest
      };
    });

    print('HOME Data: $result');

    if (flSpots.isEmpty) {
      return {};
    }

    return result;
  }
}
