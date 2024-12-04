import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<String?> getFirstAvailableRoomId() async {
    try {
      final response = await _client
          .from('room')
          .select()
          .eq('status', 'available')
          .limit(1);

      final rooms = response as List<dynamic>;
      if (rooms.isEmpty) {
        print('No available rooms found.');
        return null;
      }

      final roomId = rooms.first['room_id'] as String?;
      if (roomId == null) {
        print('Room ID is null.');
      }
      return roomId;
    } catch (error) {
      print('Error fetching room ID: $error');
      return null;
    }
  }

  // Insert a new room with roomId, status, and participants
  Future<void> insertRoom(
      String roomId, String roomStatus, int participants) async {
    final response = await _client.from('room').insert({
      'room_id': roomId,
      'status': roomStatus,
      'participants': participants,
    });
  }

  // Update room participants and status
  Future<void> updateRoom(
      String roomId, String roomStatus, int participants) async {
    final response = await _client.from('room').update({
      'room_status': roomStatus,
      'participants': participants,
    }).eq('room_id', roomId);
  }

  // Insert a participant into a room
  Future<void> insertRoomParticipant(String roomId, String userId) async {
    final response = await _client.from('room_participant').insert({
      'room_id': roomId,
      'uid': userId,
      'joined_at': DateTime.now().toIso8601String(),
    });
  }
}
