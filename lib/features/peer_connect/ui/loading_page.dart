import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/features/peer_connect/logic/matchmaking.dart';
import 'package:lingap/features/peer_connect/data/supabase_db.dart';
import 'package:lingap/features/peer_connect/services/api_service.dart';
import 'package:lingap/core/const/const.dart';

class LoadingDialog extends StatefulWidget {
  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog>
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
      final id = await _supabaseDB.insertRoom(roomId, 'available', 1, uid);

      await for (String status in _supabaseDB.isFull(roomId)) {
        if (status == 'unavailable') {
          break;
        }
      }

      print('created');
      if (mounted) {
        
      print('mounted');
        Navigator.pop(context); // Close modal
        context.push('/peer-chatscreen', extra: {'roomId': roomId, 'id': id});
      }
    } else {
      Map result = await match.findRoom(uid);
      await _supabaseDB.updateRoom(result['roomId'], 'unavailable', uid);
      await _supabaseDB.incrementParticipants(result['roomId']);

      if (mounted) {
        Navigator.pop(context); // Close modal
        context.push('/peer-chatscreen',
            extra: {'roomId': result['roomId'], 'id': result['id']});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.transparent, // Transparent background
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 50, top: 220),
            child: SizedBox(
              width: 220,
              height: 220,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double angle = _controller.value * 2 * pi;
                  double radius = 30;
                  double dx = radius * cos(angle);
                  double dy = radius * sin(angle);

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 50 + dx,
                        top: 50 + dy,
                        child: Transform.rotate(
                          angle: angle,
                          child: Image.asset(
                            'assets/peer/search.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ))
      ],
    );
  }
}

// void showLoadingDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     barrierColor: Colors.transparent,
//     builder: (context) => WillPopScope(
//       onWillPop: () async => false, // Prevent dismissing
//       child: Stack(
//         children: [
//           Center(
//             child: RotationTransition(
//               turns: AlwaysStoppedAnimation(0),
//               child: LoadingDialog(),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
