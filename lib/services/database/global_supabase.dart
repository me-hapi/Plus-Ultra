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

  Future<void> insertProfile(
      {required String uid, required String name}) async {
    final response = await _client.from('profile').insert({
      'id': uid,
      'name': name,
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
}
