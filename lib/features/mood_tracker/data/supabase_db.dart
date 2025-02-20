import 'dart:async';
import 'package:lingap/core/const/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<List<Map<String, dynamic>>> getPastWeekMoods() async {
    final DateTime weekAgo = DateTime.now().subtract(Duration(days: 7));

    final response = await _client
        .from('mood')
        .select()
        .eq('uid', uid)
        .gte('created_at', weekAgo.toIso8601String());

    print('RESPONSE: $response');
    return response;
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
