import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class StressDetection {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Helper function to normalize a value within a given range.
  double normalize(double value, double min, double max) {
    return ((value - min) / (max - min)).clamp(0.0, 1.0);
  }

  /// Generalized method to fetch vital data (heart rate or blood oxygen) stats.
  /// Returns a map with the average, standard deviation, and a weighted average (by recency).
  Future<Map<String, double>?> fetchVitalStats(
      String userId, String type) async {
    final response = await supabase
        .from('vital')
        .select('value, created_at')
        .eq('uid', userId)
        .eq('type', type)
        .gte(
          'created_at',
          DateTime.now().toUtc().subtract(Duration(days: 1)).toIso8601String(),
        );

    if (response.isEmpty) return null;

    List<double> values = [];
    List<DateTime> times = [];

    for (var row in response) {
      double value = row['value'].toDouble();
      DateTime timestamp = DateTime.parse(row['created_at']);
      values.add(value);
      times.add(timestamp);
    }

    // Compute the average.
    double average = values.reduce((a, b) => a + b) / values.length;

    // Compute the standard deviation.
    double sumSquaredDiff =
        values.map((v) => (v - average) * (v - average)).reduce((a, b) => a + b);
    double std = sqrt(sumSquaredDiff / values.length);

    // Compute a weighted average where more recent data (based on time) counts more.
    DateTime minTime = times.reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime maxTime = times.reduce((a, b) => a.isAfter(b) ? a : b);
    double timeSpan = maxTime.difference(minTime).inSeconds.toDouble();
    double weightedSum = 0;
    double totalWeight = 0;

    for (int i = 0; i < values.length; i++) {
      // If all values have the same timestamp, use equal weight.
      double weight = timeSpan > 0
          ? times[i].difference(minTime).inSeconds.toDouble() / timeSpan
          : 1;
      weightedSum += values[i] * weight;
      totalWeight += weight;
    }
    double weightedAverage = weightedSum / totalWeight;

    return {
      "average": average,
      "std": std,
      "weightedAverage": weightedAverage,
    };
  }

  Future<Map<String, double>?> fetchHeartRateStats(String userId) async {
    return fetchVitalStats(userId, 'HEART_RATE');
  }

  Future<Map<String, double>?> fetchSpO2Stats(String userId) async {
    return fetchVitalStats(userId, 'BLOOD_OXYGEN');
  }

  // Fetch last 3 days of sleep hours from sleep table.
  Future<List<double>> fetchSleepData(String userId) async {
    final response = await supabase
        .from('sleep')
        .select('sleep_hour')
        .eq('uid', userId)
        .order('created_at', ascending: false)
        .limit(3);
    return response
        .map<double>((row) => row['sleep_hour'].toDouble())
        .toList();
  }

  // Fetch last 3 days of mood data from mood table.
  Future<List<int>> fetchMoodData(String userId) async {
    final response = await supabase
        .from('mood')
        .select('mood')
        .eq('uid', userId)
        .order('created_at', ascending: false)
        .limit(3);

    final Map<String, int> moodMapping = {
      'awful': 1,
      'sad': 2,
      'neutral': 3,
      'happy': 4,
      'cheerful': 5,
    };

    return response.map<int>((row) {
      final moodText = (row['mood'] as String).toLowerCase();
      return moodMapping[moodText] ?? 0; // Returns 0 if mood text not found.
    }).toList();
  }

  /// Calculate the overall stress level by incorporating the weighted average and variability.
  /// Returns a map containing the computed metrics and the stress classification.
  Future<Map<String, dynamic>> detectStress(String userId) async {
    // Fetch vital stats for heart rate and blood oxygen.
    final hrStats = await fetchHeartRateStats(userId);
    final spo2Stats = await fetchSpO2Stats(userId);

    // Fetch sleep and mood data.
    List<double> sleepData = await fetchSleepData(userId);
    List<int> moodData = await fetchMoodData(userId);

    // Ensure all data is available.
    if (hrStats == null ||
        spo2Stats == null ||
        sleepData.length < 3 ||
        moodData.length < 3) {
      return {"error": "Insufficient Data"};
    }

    // Use weighted averages for heart rate and SpO₂.
    double hrWeightedAvg = hrStats["weightedAverage"]!;
    double spo2WeightedAvg = spo2Stats["weightedAverage"]!;

    // Incorporate variability:
    double hrVariabilityFactor = normalize(hrStats["std"]!, 0, 15);
    double spo2VariabilityFactor = normalize(spo2Stats["std"]!, 0, 3);

    // Normalize the primary values (0-1 scale) and adjust by adding 10% of the variability factor.
    double hrScore = normalize(hrWeightedAvg, 60, 100) + 0.1 * hrVariabilityFactor;
    hrScore = hrScore.clamp(0.0, 1.0);
    double spo2Score =
        1 - normalize(spo2WeightedAvg, 90, 100) + 0.1 * spo2VariabilityFactor;
    spo2Score = spo2Score.clamp(0.0, 1.0);

    // Compute sleep and mood averages.
    double avgSleep = sleepData.reduce((a, b) => a + b) / sleepData.length;
    double avgMood = moodData.reduce((a, b) => a + b) / moodData.length;
    double sleepScore = 1 - normalize(avgSleep, 4, 12);
    double moodScore = 1 - normalize(avgMood, 1, 5);

    // Define weights for the stress calculation.
    const weights = {"hr": 0.30, "spo2": 0.20, "sleep": 0.25, "mood": 0.25};

    // Compute a combined weighted stress score.
    double stressScore = ((weights["hr"]! * hrScore) +
            (weights["spo2"]! * spo2Score) +
            (weights["sleep"]! * sleepScore) +
            (weights["mood"]! * moodScore)) *
        100;

    String stressLevel;
    if (stressScore < 40) {
      stressLevel = "Low Stress";
    } else if (stressScore < 70) {
      stressLevel = "Moderate Stress";
    } else {
      stressLevel = "High Stress";
    }

    // Return all computed data along with the stress classification.
    return {
      "hrWeightedAvg": hrWeightedAvg,
      "hrStd": hrStats["std"],
      "spo2WeightedAvg": spo2WeightedAvg,
      "spo2Std": spo2Stats["std"],
      "avgSleep": avgSleep,
      "avgMood": avgMood,
      "stressLevel": stressLevel,
    };
  }
}
