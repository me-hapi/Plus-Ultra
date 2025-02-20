import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<void> insertMindfulness(String goal, int seconds, String exercise,
      String song, String uid) async {
    try {
      final response = await _client.from('mindfulness').insert({
        'goal': goal,
        'seconds': seconds,
        'exercise': exercise,
        'song': song,
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
