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

    return response;
  }

  Future<List<Map<String, dynamic>>> getPastWeeksleeps() async {
    final DateTime weekAgo = DateTime.now().subtract(Duration(days: 7));

    final response = await _client
        .from('sleep')
        .select()
        .eq('uid', uid)
        .gte('created_at', weekAgo.toIso8601String());

    return response;
  }

  Future<List<Map<String, dynamic>>> fetchVitalData() async {
    try {
      final result = await client.from('vital').select().eq('uid', uid);

      return result;
    } catch (e) {
      print('ERROR fetching vital: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSoundTracks() async {
    try {
      final response = await _client.from('soundtracks').select();

      return response;
    } catch (error) {
      print('Error selecting data: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchMindfulness() async {
    try {
      final response =
          await _client.from('mindfulness').select('*, soundtracks(*)');

      print('RESPONSE: $response');
      return response;
    } catch (error) {
      print('Error selecting data: $error');
      return [];
    }
  }

  Future<void> insertMindfulness(String goal, int seconds, int minutes,
      String exercise, int song_id, String uid) async {
    try {
      final response = await _client.from('mindfulness').insert({
        'goal': goal,
        'seconds': seconds,
        'minutes': minutes,
        'exercise': exercise,
        'song_id': song_id,
        'uid': uid,
      });

      if (response == null) {
        print('Data inserted successfully');
      }
    } catch (error) {
      print('Error inserting data: $error');
    }
  }
}
