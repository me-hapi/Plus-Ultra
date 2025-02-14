import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lingap/features/peer_connect/models/message_model.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<List<Map<String, dynamic>>> fetchAvailableRooms() async {
   final response = await _client
    .from('match_room')
    .select('id, room_id, status, sender, receiver')
    .eq('status', 'available')
    .not('sender', 'is', null) // Ensures sender is not null
    .not('receiver', 'is', null, 'or') // OR ensures receiver is not null
    .order('id', ascending: false); // Sort match_room by latest first

// Fetch the latest mh_score for each match
for (var match in response) {
  String? userId = match['sender'] ?? match['receiver']; // Get non-null sender/receiver
  if (userId != null) {
    final mhScoreResponse = await _client
        .from('mh_score')
        .select('uid, depression, anxiety, stress')
        .eq('uid', userId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle(); // Get the latest mh_score entry
    
    if (mhScoreResponse != null) {
      match['mh_score'] = mhScoreResponse; // Attach latest mh_score
    }
  }
}

    // Limit to 1 latest mh_score row per match
    print('DATA: $response');
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
    final supabase = Supabase.instance.client;

    final roomStream = supabase
        .from('room')
        .stream(primaryKey: ['room_id']).eq('room_id', roomId);

    return roomStream.map((rooms) {
      if (rooms.isNotEmpty) {
        return rooms.first['status'] as String;
      }
      return 'unknown';
    });
  }

  Future<void> markMessageAsRead(int roomId) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('peer_messages')
          .update({'read': true}).match({'room_id': roomId});
    } catch (e) {
      print('Error: $e');
    }
  }

  Stream<List<MessageModel>> getPeerMessagesStream(int id) {
    final stream = _client
        .from('peer_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', id)
        .map((data) => data.map((e) => MessageModel.fromMap(e)).toList());

    return stream;
  }

  Future<void> insertPeerMessage(MessageModel message) async {
    final response = await _client.from('peer_messages').insert({
      'created_at': message.created_at.toIso8601String(),
      'room_id': message.roomId,
      'sender': message.sender,
      'content': message.content,
      'read': false
    });
  }

  Future<int> insertRoom(
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
    return response['id'] as int;
  }

  Future<int> insertToPeerRoom(String roomId, String uid, String userId) async {
    final response = await _client
        .from('peer_room')
        .insert({'room_id': roomId, 'sender': uid, 'receiver': userId})
        .select('id')
        .single();

    return response['id'] as int;
  }

  Future<void> updateRoom(String roomId, String roomStatus, String uid) async {
    final response = await _client
        .from('room')
        .update({'status': roomStatus})
        .eq('room_id', roomId)
        .select('id')
        .single();

    await insertRoomParticipant(response['id'] as int, uid);
  }

  Future<void> incrementParticipants(String roomId) async {
    final selectResponse = await _client
        .from('room')
        .select('participants')
        .eq('room_id', roomId)
        .single();

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

  Stream<List<Map<String, dynamic>>> fetchUnknownUsers(String uid) async* {
    // Fetch all matched user IDs from peer_rooms where the current uid is involved
    final matchedUsersResponse = await _client
        .from('peer_room')
        .select('sender, receiver')
        .or('sender.eq.$uid, receiver.eq.$uid');

    // Collect matched user IDs
    final Set<String> matchedUserIds = {};
    for (var row in matchedUsersResponse) {
      matchedUserIds.add(row['sender'] as String);
      matchedUserIds.add(row['receiver'] as String);
    }

    // Remove the current user from the set
    matchedUserIds.remove(uid);

    // Stream all profiles and filter out matched ones manually
    yield* _client
        .from('profile')
        .stream(primaryKey: ['id'])
        .neq('id', uid) // Ensure the current user is excluded
        .map((profiles) => profiles
            .where((profile) => !matchedUserIds.contains(profile['id']))
            .map((p) => p)
            .toList());
  }

  Stream<List<Map<String, dynamic>>> fetchConnectedUsers(String myUid) async* {
    try {
      yield* _client
          .from('peer_room')
          .select('''
          id, room_id, sender, receiver, 
          peer_messages(created_at, room_id, sender, content, read),
          sender_profile:profile!peer_room_sender_fkey(name, imageUrl), 
          receiver_profile:profile!peer_room_receiver_fkey(name, imageUrl)
        ''')
          .or('sender.eq.$myUid,receiver.eq.$myUid')
          .asStream()
          .map((data) => List<Map<String, dynamic>>.from(data.map((room) {
                bool isSender = room['sender'] == myUid;
                String otherUserId =
                    isSender ? room['receiver'] : room['sender'];

                Map<String, dynamic> otherUserProfile = isSender
                    ? room['receiver_profile']
                    : room['sender_profile'];

                List<dynamic> messages = List.from(room['peer_messages'] ?? []);

// Sort messages by latest timestamp (descending order)
                messages
                    .sort((a, b) => b['created_at'].compareTo(a['created_at']));

// Get the most recent message (regardless of sender)
                Map<String, dynamic> lastMessage = messages.isNotEmpty
                    ? messages.first
                    : <String, dynamic>{
                        'content': null,
                        'created_at': null,
                        'read': null
                      };
                print('ROOM: $room');
                return {
                  'id': room['id'],
                  'roomId': room['room_id'],
                  'name': otherUserProfile['name'],
                  'imageUrl': otherUserProfile['imageUrl'],
                  'last_message': lastMessage!['content'],
                  'time': lastMessage['created_at'],
                  'read': lastMessage['read'],
                };
              })));
    } catch (e) {
      print('ERROR: $e');
      yield [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchLatestMessages(
      List<int> roomIds) async {
    if (roomIds.isEmpty) return [];

    try {
      final response = await _client
          .from('messages')
          .select('room_id, created_at, content, read')
          .inFilter('room_id', roomIds)
          .order('created_at',
              ascending: false) // Get the latest messages first
          .limit(1); // Fetch only the latest message per room

      return (response as List)
          .map((msg) => {
                'roomId': msg['room_id'],
                'created_at': msg['created_at'],
                'content': msg['content'],
                'read': msg['read']
              })
          .toList();
    } catch (error) {
      print('Error fetching latest messages: $error');
      return [];
    }
  }
}
