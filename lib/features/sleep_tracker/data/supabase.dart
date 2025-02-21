import 'dart:async';
import 'package:lingap/core/const/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<List<Map<String, dynamic>>> getPastWeeksleeps() async {
    final DateTime weekAgo = DateTime.now().subtract(Duration(days: 7));

    final response = await _client
        .from('sleep')
        .select()
        .eq('uid', uid)
        .gte('created_at', weekAgo.toIso8601String());

    print('RESPONSE: $response');
    return response;
  }

  Future<void> insertOrUpdatesleep(double sleepHours) async {
    try {
      // Get today's date in UTC in YYYY-MM-DD format
      String today = DateTime.now().toUtc().toIso8601String().split('T')[0];

// Check if there is already a sleep entry for today
      final existingsleep = await _client
          .from('sleep')
          .select('id') // Select only the ID
          .eq('uid', uid)
          .gte('created_at', '$today 00:00:00+00')
          .lt('created_at', '$today 23:59:59+00')
          .maybeSingle();

      if (existingsleep != null) {
        // Update the existing sleep entry
        await _client
            .from('sleep')
            .update({'sleep_hour': sleepHours}).eq('id', existingsleep['id']);
      } else {
        // Insert a new sleep entry
        await _client.from('sleep').insert({'uid': uid, 'sleep_hour': sleepHours});
      }
    } catch (e) {
      print('Error inserting/updating sleep: $e');
    }
  }
}
