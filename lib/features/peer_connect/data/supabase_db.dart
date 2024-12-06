import 'dart:async';
import 'dart:ffi';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lingap/features/peer_connect/models/message_model.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<List<Map<String, dynamic>>> fetchAvailableRooms() async {
    final response = await _client.from('room').select('''
            id, room_id, 
            room_participant!inner(
              profile!inner(
                id, 
                mh_score!inner(depression, anxiety, stress)
              )
            )
            ''').eq('status', 'available');

    final data = response as List<dynamic>;
    return data
        .map((e) {
          // Extracting room participant and mh_score, considering they are lists.
          final roomParticipants = e['room_participant'] as List<dynamic>;
          if (roomParticipants.isNotEmpty) {
            final profile = roomParticipants[0]['profile'];
            final mhScores = profile['mh_score'] as List<dynamic>;
            if (mhScores.isNotEmpty) {
              final mhScore = mhScores[0];
              return {
                'id': e['id'],
                'room_id': e['room_id'],
                'depression': mhScore['depression'],
                'anxiety': mhScore['anxiety'],
                'stress': mhScore['stress'],
              };
            }
          }
          return null; // Handle case where mh_score or room_participant is empty
        })
        .where((element) => element != null) // Filter out null values
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Future<Map<String, dynamic>?> fetchMHScore(String uid) async {
    final response = await _client
        .from('mh_score')
        .select()
        .eq('uid', uid)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      return null;
    }
    return response;
  }

  Stream<String> isFull(String roomId) {
    // Access the Supabase client
    final supabase = Supabase.instance.client;

    // Create a stream that listens to changes in the 'room' table
    final roomStream = supabase
        .from('room')
        .stream(primaryKey: ['room_id']).eq('room_id', roomId);

    // Transform the stream to yield the 'status' field as a String
    return roomStream.map((rooms) {
      if (rooms.isNotEmpty) {
        return rooms.first['status'] as String;
      }
      return 'unknown'; // Default value if no room is found
    });
  }

  Stream<List<MessageModel>> getMessagesStream(String roomId) {
    final stream = _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .map((data) => data.map((e) => MessageModel.fromMap(e)).toList());

    return stream;
  }

  Future<void> insertMessage(MessageModel message) async {
    final response = await _client.from('messages').insert({
      'created_at': message.created_at.toIso8601String(),
      'room_id': message.roomId,
      'sender': message.sender,
      'content': message.content,
    });
  }

  Future<void> insertRoom(
      String roomId, String roomStatus, int participants, String uid) async {
    final response = await _client
        .from('room')
        .insert({
          'room_id': roomId,
          'status': roomStatus,
          'participants': participants,
        })
        .select('id')
        .single();

    await insertRoomParticipant(response['id'] as int, uid);
  }

  Future<void> updateRoom(String roomId, String roomStatus) async {
    final response =
        await _client.from('room').update({'status': roomStatus}).eq('room_id', roomId);
  }

  Future<void> incrementParticipants(String roomId) async {
    final selectResponse =
        await _client.from('room').select('participants').eq('room_id', roomId).single();

    int currentParticipants = selectResponse['participants'];
    final updateResponse = await _client.from('room').update({
      'participants': currentParticipants + 1,
    }).eq('room_id', roomId);

  }

  Future<void> insertRoomParticipant(int roomId, String userId) async {
    final response = await _client.from('room_participant').insert({
      'room_id': roomId,
      'uid': userId,
      'joined_at': DateTime.now().toIso8601String(),
    });
  }
}
