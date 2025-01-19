import 'package:supabase_flutter/supabase_flutter.dart';

class GlobalSupabase {
  final SupabaseClient _client;

  GlobalSupabase(this._client);

  Future<bool?> fetchMhScore(String uid) async {
    final response = await _client
        .from('mh_score')
        .select('id')
        .eq('uid', uid)
        .maybeSingle();

    if (response != null) {
      return true;
    } else {
      print('NO RECORD');
      return false;
    }
  }

  Future<void> insertMhScore({
    required String uid,
    required int depression,
    required int anxiety,
    required int stress,
  }) async {
    final response = await _client.from('mh_score').insert({
      'uid': uid,
      'created_at': DateTime.now().toIso8601String(),
      'depression': depression,
      'anxiety': anxiety,
      'stress': stress,
    });
  }

  Future<void> insertProfile({required String uid}) async {
    final response = await _client.from('profile').insert({
      'id': uid,
      'status': 'unavailable',
      'display_name': false,
    });
  }

  Future<bool> isProfessional(String uid) async {
    final response = await _client
        .from('professional')
        .select('uid')
        .eq('uid', uid)
        .maybeSingle();

    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>?> fetchProfile(String uid) async {
    try {
      final response = await _client
          .from('profile')
          .select('name, age, weight, weight_lbl, imageUrl')
          .eq('id', uid) // Filter by uid
          .single(); // Ensure you get a single record

      return response;
    } catch (e) {
      // Handle and log the error
      print('Error fetching profile: $e');
      return null;
    }
  }

  Future<bool> insertResponses(Map<String, dynamic> responses) async {
    try {
      // Validate that all required keys are present in the responses
      final requiredKeys = ['name', 'age', 'weight', 'mood', 'sleepQuality'];
      for (String key in requiredKeys) {
        if (!responses.containsKey(key)) {
          throw Exception('Missing required key: $key');
        }
      }

      // Insert the data into the 'profile' table
      final response = await _client.from('profile').insert({
        'name': responses['name'],
        'age': responses['age'],
        'weight': responses['weight']['weight'],
        'weight_lbl': responses['weight']['unit'],
        'mood': responses['mood'],
        'sleep_quality': responses['sleepQuality'],
        'imageUrl': responses['profilePicture']
      });

      print('Data inserted successfully');
      return true;
    } catch (e) {
      print('Error inserting data: $e');
      return false;
    }
  }
}
