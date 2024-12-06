import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:lingap/features/peer_connect/logic/matchmaking.dart';
import 'package:lingap/features/peer_connect/data/supabase_db.dart';
import 'package:lingap/features/peer_connect/services/api_service.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/peer_connect/ui/chat_screen.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final SupabaseDB _supabaseDB = SupabaseDB(client);
  final Matchmaking match = Matchmaking();
  final APIService api = APIService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    findMatch();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> findMatch() async {
    final availRooms = await _supabaseDB.fetchAvailableRooms();
    if (availRooms.isEmpty) {
      String roomId = await api.createRoomId();
      await _supabaseDB.insertRoom(roomId, 'available', 1, uid);

      await for (String status in _supabaseDB.isFull(roomId)) {
        if (status == 'unavailable') {
          break;
        }
      }

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChatScreen(roomId: roomId)),
      );
    } else {
      String? roomId = await match.findRoom(uid);
      await _supabaseDB.updateRoom(roomId!, 'unavailable', uid);
      await _supabaseDB.incrementParticipants(roomId);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChatScreen(roomId: roomId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RotationTransition(
          turns: _controller,
          child: Icon(
            Icons.search,
            size: 100.0,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
