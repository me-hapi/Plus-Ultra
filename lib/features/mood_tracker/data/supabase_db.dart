import 'dart:async';
import 'package:lingap/core/const/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<List<Map<String, dynamic>>> getPastWeekMoods() async {
    final int daysToSubtract = DateTime.now().weekday;
    final DateTime weekAgo =
        DateTime.now().subtract(Duration(days: daysToSubtract-1));

    print('DAY MINUS: $daysToSubtract');

    // Fetch moods from the mood table
    final List<Map<String, dynamic>> moods = await _client
        .from('mood')
        .select('mood, created_at')
        .eq('uid', uid)
        .gte('created_at', weekAgo.toIso8601String());

    // Fetch emotions from the journal table
    final List<Map<String, dynamic>> emotions = await _client
        .from('journal')
        .select('emotion, created_at')
        .eq('uid', uid)
        .gte('created_at', weekAgo.toIso8601String());

    // Combine both lists, treating 'emotion' as 'mood'
    final List<Map<String, dynamic>> combined = [
      ...moods.map((m) => {'mood': m['mood'], 'created_at': m['created_at']}),
      ...emotions
          .map((e) => {'mood': e['emotion'], 'created_at': e['created_at']}),
    ];

    // Sort by created_at in descending order (latest first)
    combined.sort((a, b) => DateTime.parse(b['created_at'])
        .compareTo(DateTime.parse(a['created_at'])));

    // Keep only the latest mood for each day
    final Map<String, Map<String, dynamic>> latestPerDay = {};

    for (var entry in combined) {
      final String dateKey = DateTime.parse(entry['created_at'])
          .toLocal()
          .toString()
          .split(' ')[0]; // Extract date part
      if (!latestPerDay.containsKey(dateKey)) {
        latestPerDay[dateKey] = entry;
      }
    }

    return latestPerDay.values.toList();
  }

  Future<void> insertOrUpdateMood(String mood) async {
    try {
      // Get today's date in UTC in YYYY-MM-DD format
      String today = DateTime.now().toUtc().toIso8601String().split('T')[0];

// Check if there is already a mood entry for today
      final existingMood = await _client
          .from('mood')
          .select('id') // Select only the ID
          .eq('uid', uid)
          .gte('created_at', '$today 00:00:00+00')
          .lt('created_at', '$today 23:59:59+00')
          .maybeSingle();

      if (existingMood != null) {
        // Update the existing mood entry
        await _client
            .from('mood')
            .update({'mood': mood}).eq('id', existingMood['id']);
      } else {
        // Insert a new mood entry
        await _client.from('mood').insert({'uid': uid, 'mood': mood});
      }
    } catch (e) {
      print('Error inserting/updating mood: $e');
    }
  }
}
