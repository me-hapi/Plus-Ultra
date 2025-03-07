import 'dart:async';
import 'dart:io';
import 'package:lingap/core/const/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<String> fetchModel() async {
    try {
      final result = await _client.from('model').select().maybeSingle();
      return result?['model'] ?? 'o3-mini';
    } catch (e) {
      return 'o3-mini';
    }
  }

  Future<void> deleteSession(int sessionID) async {
    try {
      print('Deleting...');
      final response =
          await _client.from('session').delete().eq('id', sessionID);
      print('Success deleting');
    } catch (e) {
      print('Error deleting: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchHotlines() async {
    try {
      final response = await _client
          .from('hotlines')
          .select('name, phone, email')
          .eq('address', 'Online / Hotline')
          .neq('phone', 'NULL');

      return response;
    } catch (e) {
      print('Error hotlines: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchJournal(int sessionID) async {
    try {
      // Fetch the created_at timestamp of the given sessionID
      final sessionResponse = await _client
          .from('session')
          .select('created_at')
          .eq('id', sessionID)
          .single();

      if (sessionResponse == null ||
          !sessionResponse.containsKey('created_at')) {
        print('Session not found or missing created_at');
        return [];
      }

      // Parse created_at as DateTime
      DateTime createdAt = DateTime.parse(sessionResponse['created_at']);
      DateTime sevenDaysAgo = createdAt.subtract(const Duration(days: 7));
      DateTime today = DateTime.now();

      // Fetch journal entries within the filtered date range
      final response = await _client
          .from('journal')
          .select('*, journal_item(*)')
          .eq('uid', uid)
          .gte('created_at', sevenDaysAgo.toIso8601String())
          .lte('created_at', today.toIso8601String());

      return response;
    } catch (e) {
      print('Error fetching journal entries: $e');
      return [];
    }
  }

  Future<bool> hasSession(String uid) async {
    final response =
        await _client.from('session').select('id').eq('uid', uid).limit(1);
    print(response);
    return response.isNotEmpty;
  }

  Future<bool> hasIntro(int id) async {
    final response = await _client
        .from('session')
        .select('introduction')
        .eq('id', id)
        .limit(1);
    print(response);
    return response[0]['introduction'] ?? false;
  }

  Future<void> updateIntro(int id) async {
    final response = await _client
        .from('session')
        .update({'introduction': true}).eq('id', id);
  }

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

  Future<int> insertMessages(int sessionID, String message, bool user) async {
    try {
      final response = await _client.from('chatbot_convo').insert({
        'sessionID': sessionID,
        'content': message,
        'user': user,
        'animate': true,
      }).select('id');

      return response[0]['id'];
    } catch (e) {
      print('Error inserting session: $e');
      return 0; // Return null if insertion fails
    }
  }

  Future<void> updateOption(int optionID, String option) async {
    final response = await _client
        .from('chatbot_convo')
        .update({'content': option}).eq('id', optionID);
  }

  Future<void> updateAnimation(int sessionID) async {
    final response = await _client
        .from('chatbot_convo')
        .update({'animate': false}).eq('sessionID', sessionID);
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

  Stream<List<Map<String, dynamic>>> streamChatbotConversations(
      String sessionID) {
    return _client
        .from('chatbot_convo')
        .stream(primaryKey: ['id']) // Ensure 'id' is the actual primary key
        .eq('sessionID', sessionID)
        .map((event) => event.map((row) => row).toList());
  }

  Stream<List<Map<String, dynamic>>> streamChats(String uid) {
    return _client
        .from('session')
        .stream(primaryKey: ['id']) // Replace 'id' with your actual primary key
        .eq('uid', uid)
        .order('id', ascending: false)
        .map((event) => event.map((row) => row).toList());
  }

  Future<bool> updateSession(
      int sessionID, String title, String emotion, String icon) async {
    try {
      final response = await _client
          .from('session')
          .update({'title': title, 'emotion': emotion, 'icon': icon}).eq(
              'id', sessionID);

      return true;
    } catch (e) {
      print('Error updating session: $e');
      return false;
    }
  }

  Future<bool> updateIssue(int sessionID, String issue) async {
    try {
      final response = await _client
          .from('session')
          .update({'issue': issue}).eq('id', sessionID);

      return true;
    } catch (e) {
      print('Error updating session: $e');
      return false;
    }
  }

  Future<bool> updateCount(int sessionID, int count, String emotion) async {
    try {
      final response = await _client
          .from('session')
          .update({'count': count, 'emotion': emotion}).eq('id', sessionID);

      return true;
    } catch (e) {
      print('Error updating session: $e');
      return false;
    }
  }

  Future<void> closeSession(int sessionID) async {
    final response = await _client
        .from('session')
        .update({'open': false}).eq('id', sessionID);
  }

  Stream<Map<String, dynamic>?> listenToSession(int sessionID) {
    return _client
        .from('session')
        .stream(primaryKey: ['id']) // Use 'id' if it's the primary key
        .eq('id', sessionID) // Filter by sessionID
        .map((data) =>
            data.isNotEmpty ? data.first : null); // Handle empty state
  }

  Future<void> updateSessionIndex(int index, int sessionID) async {
    try {
      // Fetch existing index array
      final response = await _client
          .from('session')
          .select('index')
          .eq('id', sessionID)
          .single();

      print('UPDATE: $response');

      if (response['index'] == null) {
        // If no index exists, create a new array
        await _client.from('session').update({
          'index': [index]
        }).eq('id', sessionID);
      } else {
        List<int> currentIndexes = List<int>.from(response['index']);

        // Append only if not already present
        if (!currentIndexes.contains(index)) {
          currentIndexes.add(index);

          // Update session table
          await _client
              .from('session')
              .update({'index': currentIndexes}).eq('id', sessionID);
        }
      }
    } catch (e) {
      print('Error updating session index: $e');
    }
  }
}
