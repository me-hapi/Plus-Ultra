import 'dart:async';

import 'package:lingap/core/const/const.dart';
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
        .order('id', ascending: false); // Sort match_room by latest first

    List<Map<String, dynamic>> formattedData = [];

    for (var match in response) {
      String? senderId = match['sender']; // Sender UID
      String? receiverId = match['receiver']; // Receiver UID

      Map<String, dynamic>? mhScore;
      Map<String, dynamic>? senderProfile;

      if (senderId != null) {
        // Fetch the latest mh_score for the sender
        mhScore = await _client
            .from('mh_score')
            .select('uid, depression, anxiety, stress')
            .eq('uid', senderId)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

        // Fetch sender profile details
        senderProfile = await _client
            .from('profile')
            .select('name, anonymous, imageUrl')
            .eq('id', senderId)
            .maybeSingle();
      }

      formattedData.add({
        'id': match['id'],
        'room_id': match['room_id'],
        'depression': mhScore?['depression'] ?? 0, // Default to 0 if null
        'anxiety': mhScore?['anxiety'] ?? 0,
        'stress': mhScore?['stress'] ?? 0,
        'name': senderProfile?['name'] ?? 'Unknown', // Default if null
        'anonymous': senderProfile?['anonymous'] ?? false, // Default to false
        'imageUrl':
            senderProfile?['imageUrl'] ?? 'assets/profileIcon/profile1.png'
      });
    }

    print('Formatted Data: $formattedData');
    return formattedData;
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
        .from('match_room')
        .stream(primaryKey: ['room_id']).eq('room_id', roomId);

    return roomStream.map((rooms) {
      if (rooms.isNotEmpty) {
        return rooms.first['status'] as String;
      }
      return 'unknown';
    });
  }

  Future<Map<String, dynamic>> fetchReceiver(int id) async {
    try {
      final uid = await _client
          .from('match_room')
          .select('receiver')
          .eq('id', id)
          .maybeSingle();

      final response = await _client
          .from('profile')
          .select()
          .eq('id', uid!['receiver'])
          .maybeSingle();

      return response!;
    } catch (e) {
      return {};
    }
  }

  Future<void> markMessageAsRead(int roomId) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('peer_messages')
          .update({'read': true}).match({'room_id': roomId}).neq('sender', uid);
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

  Future<void> unsendMessage(int messageId) async {
    final response = await _client
        .from('peer_messages')
        .update({'unsent': true}).eq('id', messageId);
  }

  Future<void> insertPeerMessage(MessageModel message) async {
    final response = await _client.from('peer_messages').insert({
      'created_at': message.created_at.toIso8601String(),
      'room_id': message.roomId,
      'sender': message.sender,
      'content': message.content,
      'read': false,
      'unsent': false
    });
  }

  Future<int> insertMatchRoom(
      String roomId, String roomStatus, String uid) async {
    final response = await _client
        .from('match_room')
        .insert({
          'room_id': roomId,
          'status': roomStatus,
          'sender': uid,
        })
        .select('id')
        .single();

    return response['id'] as int;
  }

  Future<void> deleteMatchRoom(int id) async {
    try {
      await _client.from('match_room').delete().eq('id', id);
    } catch (e) {
      print('ERROR delete match room');
    }
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
        .from('match_room')
        .update({'status': roomStatus, 'receiver': uid})
        .eq('room_id', roomId)
        .select('id')
        .single();
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

  // Future<void> insertRoomParticipant(int roomId, String userId) async {
  //   final response = await _client.from('room_participant').insert({
  //     'room_id': roomId,
  //     'uid': userId,
  //     'joined_at': DateTime.now().toIso8601String(),
  //   });
  // }

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
          peer_messages(created_at, room_id, sender, content, read, unsent),
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
                  'last_message': lastMessage['content'],
                  'sender': lastMessage['sender'],
                  'time': lastMessage['created_at'],
                  'read': lastMessage['read'],
                  'unsent': lastMessage['unsent']
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
