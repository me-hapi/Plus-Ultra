import 'package:lingap/core/const/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GlobalSupabase {
  final SupabaseClient _client;

  GlobalSupabase(this._client);

  Future<int> createSession(String uid) async {
    try {
      final response = await _client
          .from('session')
          .insert({'uid': uid, 'open': true})
          .select('id') // Fetch the inserted id
          .single();

      return response['id']; // Return the inserted id
    } catch (e) {
      print('Error inserting session: $e');
      return 0; // Return null if insertion fails
    }
  }

  Future<bool> homeFinish() async {
    try {
      final result =
          await _client.from('profile').select().eq('id', uid).maybeSingle();

      return result!['home_tutorial'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> chatbotFinish() async {
    try {
      final result =
          await _client.from('profile').select().eq('id', uid).maybeSingle();

      return result!['chatbot_tutorial'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> journalFinish() async {
    try {
      final result =
          await _client.from('profile').select().eq('id', uid).maybeSingle();

      return result!['journal_tutorial'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> teleconsultFinish() async {
    try {
      final result =
          await _client.from('profile').select().eq('id', uid).maybeSingle();

      return result!['teleconsult_tutorial'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> peerFinish() async {
    try {
      final result =
          await _client.from('profile').select().eq('id', uid).maybeSingle();

      return result!['peer_tutorial'];
    } catch (e) {
      return false;
    }
  }

  Future<void> updatePeer() async {
    try {
      final result = await _client
          .from('profile')
          .update({'peer_tutorial': true}).eq('id', uid);
    } catch (e) {
      print('Erroe $e');
    }
  }

  Future<void> updateTeleconsult() async {
    try {
      final result = await _client
          .from('profile')
          .update({'teleconsult_tutorial': true}).eq('id', uid);
    } catch (e) {
      print('Erroe $e');
    }
  }

  Future<void> updateJournal() async {
    try {
      final result = await _client
          .from('profile')
          .update({'journal_tutorial': true}).eq('id', uid);
    } catch (e) {
      print('Erroe $e');
    }
  }

  Future<void> updateHome() async {
    try {
      final result = await _client
          .from('profile')
          .update({'home_tutorial': true}).eq('id', uid);
    } catch (e) {
      print('Erroe $e');
    }
  }

  Future<void> updateChatbot() async {
    try {
      final result = await _client
          .from('profile')
          .update({'chatbot_tutorial': true}).eq('id', uid);
    } catch (e) {
      print('Erroe $e');
    }
  }

  Future<bool> isSleepEmpty() async {
    // Get today's date and define the start and end of the day.
    final nowUtc = DateTime.now().toUtc();
    final startOfDay = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Query the "sleep" table filtering rows based on the created_at field.
    final response = await client
        .from('sleep')
        .select()
        .eq('uid', uid)
        .gte('created_at', startOfDay.toIso8601String())
        .lt('created_at', endOfDay.toIso8601String());

    // If the returned data list is not empty, a row exists for today.
    final data = response as List;
    return data.isEmpty;
  }

  Future<bool> isMoodEmpty() async {
    final nowUtc = DateTime.now().toUtc();
    final startOfDay = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Query the "sleep" table filtering rows based on the created_at field.
    final response = await client
        .from('mood')
        .select()
        .eq('uid', uid)
        .gte('created_at', startOfDay.toIso8601String())
        .lt('created_at', endOfDay.toIso8601String());

    // If the returned data list is not empty, a row exists for today.
    final data = response as List;
    return data.isEmpty;
  }

  Future<int> fetchNotificationValue() async {
    try {
      final response = await _client
          .from('notification')
          .select()
          .eq('uid', uid)
          .eq('read', false);

      return response.length;
    } catch (e) {
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllMhScore() async {
    final response = await _client.from('mh_score').select().eq('uid', uid);

    return response;
  }

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
      final requiredKeys = [
        'name',
        'age',
        'weight',
        'mood',
        'sleepQuality',
        'profilePicture'
      ];
      for (String key in requiredKeys) {
        if (!responses.containsKey(key)) {
          throw Exception('Missing required key: $key');
        }
      }

      // Insert the data into the 'profile' table
      final response = await _client
          .from('profile')
          .insert({
            'name': responses['name'],
            'age': responses['age'],
            'weight': responses['weight']['weight'],
            'weight_lbl': responses['weight']['unit'],
            'mood': responses['mood'],
            'sleep_quality': responses['sleepQuality'],
            'imageUrl': responses['profilePicture']
          })
          .select('id')
          .maybeSingle();

      final category = {
        'Excellent': 8,
        'Good': 6,
        'Fair': 5,
        'Poor': 4,
        'Worst': 3,
        'Cheerful': 5,
        'Happy': 4,
        'Neutral': 3,
        'Sad': 2,
        'Awful': 1
      };

      final uid = response!['id'];
      final insertSleep = await _client.from('sleep').insert(
          {'uid': uid, 'sleep_hour': category[responses['sleepQuality']]});

      final insertMood = await _client
          .from('mood')
          .insert({'uid': uid, 'mood': responses['mood']});

      print('Data inserted successfully');
      return true;
    } catch (e) {
      print('Error inserting data: $e');
      return false;
    }
  }
}
