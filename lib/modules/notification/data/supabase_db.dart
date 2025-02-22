import 'dart:async';
import 'package:lingap/core/const/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  Future<Map<String, dynamic>> fetchNotification() async {
    try {
      final result = await client
          .from('profile')
          .select(
              'id, appointment(created_at), journal(created_at), mindfulness(created_at), session(created_at), mood(created_at), sleep(created_at)')
          .eq('id', uid)
          .maybeSingle();

      final rooms = await getPeerRoomIds(uid);
      final messages = await getLatestMessagesPerRoom(rooms, uid);
      result!['messages'] = messages;

      return result;
    } catch (e) {
      print('ERROR fetching vital: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getLatestMessagesPerRoom(
      List<int> roomIds, String uid) async {
    if (roomIds.isEmpty) return [];

    try {
      final response = await client
          .from('peer_messages')
          .select('created_at, room_id')
          .neq('sender', uid)
          .inFilter('room_id', roomIds)
          .order('created_at', ascending: false);

      Map<int, Map<String, dynamic>> latestMessages = {};

      for (var msg in response) {
        int roomId = msg['room_id'];
        if (!latestMessages.containsKey(roomId)) {
          latestMessages[roomId] = msg;
        }
      }

      return latestMessages.values.toList();
    } catch (error) {
      print('Error fetching latest messages per room: $error');
      return [];
    }
  }

  Future<List<int>> getPeerRoomIds(String uid) async {
    try {
      final response = await client
          .from('peer_room')
          .select('id')
          .or('sender.eq.$uid,receiver.eq.$uid');

      return response.map((e) => e['id'] as int).toList();
    } catch (error) {
      print('Error fetching peer room IDs: $error');
      return [];
    }
  }
}
