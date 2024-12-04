import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lingap/features/peer_communication/data/supabase_db.dart';
import 'package:lingap/features/peer_communication/logic/chat_logic.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:videosdk/videosdk.dart';
import 'package:lingap/features/peer_communication/services/setup_meeting.dart';

class PeerManager {
  late SupabaseDB supabaseDb;
  late APIService api;
  Room? _room;
  Map<String, Participant> participants = {};
  final uid = Supabase.instance.client.auth.currentUser?.id;

  PeerManager() {
    _initialize();
  }

  void _initialize() {
    final client = Supabase.instance.client;
    supabaseDb = SupabaseDB(client);
    api = APIService();
  }

  Future<void> findPeerAndJoinRoom(BuildContext context) async {
    try {
      print('peermanger');
      final roomId = await supabaseDb.getFirstAvailableRoomId();
      if (roomId != null) {
        print(roomId);
        if (uid != null) {
          _room = await api.createMeetingRoom(roomId, uid!);
          await _joinRoom(context);
        }
      } else {
        print('create');
        String newRoomId = await api.createRoomId();
        print(newRoomId);
        await supabaseDb.insertRoom(newRoomId, 'available', 1);
        await supabaseDb.insertRoomParticipant(newRoomId, uid!);
        _room = await api.createMeetingRoom(newRoomId, uid!);
        await _joinRoom(context);
      }
    } catch (e) {
      debugPrint('Error finding peer: $e');
    }
  }

  Future<void> _joinRoom(BuildContext context) async {
    if (_room != null) {
      print('before set meeting');
      setMeetingEventListener();
      print('after set meeting');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatView(room: _room!, participants: participants),
        ),
      );
    } else {
      print('No room created');
      debugPrint("Error: Room is null when attempting to join.");
    }
  }

  void setMeetingEventListener() {
    if (_room == null) return;

    _room!.on(Events.roomJoined, () {
      participants.putIfAbsent(
        _room!.localParticipant.id,
        () => _room!.localParticipant,
      );
    });

    _room!.on(Events.participantJoined, (Participant participant) {
      participants.putIfAbsent(participant.id, () => participant);
    });

    _room!.on(Events.participantLeft, (String participantId) {
      participants.remove(participantId);
    });

    _room!.on(Events.roomLeft, () {
      participants.clear();
    });
  }

  void leaveRoom() {
    _room?.leave();
  }
}

// peer_manager.dart (add this below the PeerManager class)

final peerManagerProvider = Provider<PeerManager>((ref) => PeerManager());
