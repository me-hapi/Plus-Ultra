import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/features/peer_connect/logic/matchmaking.dart';
import 'package:lingap/features/peer_connect/data/supabase_db.dart';
import 'package:lingap/features/peer_connect/services/api_service.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/peer_connect/ui/match_modal.dart';

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
  int id_room = 0;
  bool roomsFound = false;

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

  void showMatchModal(
      BuildContext context, List<Map<String, dynamic>> matches) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return MatchModal(matches: matches);
      },
    );
  }

  Future<void> findMatch() async {
    final availRooms = await _supabaseDB.fetchAvailableRooms();
    if (availRooms.isEmpty) {
      String roomId = await api.createRoomId();
      final id = await _supabaseDB.insertMatchRoom(roomId, 'available', uid);
      id_room = id;
      late Map<String, dynamic> receiver;
      bool isMatched = false;

      try {
        await for (String status
            in _supabaseDB.isFull(roomId).timeout(Duration(seconds: 10))) {
          print('Received status: $status'); // Debugging print

          if (status == 'unavailable') {
            receiver = await _supabaseDB.fetchReceiver(id);
            isMatched = true;
            break;
          }
        }
      } catch (e) {
        print('Stream timeout: No match found within 10 seconds');
      }

      if (!isMatched) {
        await _supabaseDB.deleteMatchRoom(id);
        if (mounted) {
          Navigator.pop(context);
        }
      } else if (mounted) {
        print('Mounted');
        Navigator.pop(context);

        String name = receiver['anonymous'] ? 'Anonymous' : receiver['name'];
        context.push('/peer-chatscreen', extra: {
          'roomId': roomId,
          'id': id,
          'name': name,
          'avatar': receiver['imageUrl']
        });
      }
    } else {
      List<Map<String, dynamic>> matches = await match.findTopRooms(uid);
      print(matches);
      setState(() {
        roomsFound = true;
      });

      showMatchModal(context, matches);
      // await _supabaseDB.updateRoom(result['roomId'], 'unavailable', uid);
      // String name = result['anonymous'] ? "Anonymous" : result['name'];
      // if (mounted) {
      //   Navigator.pop(context); // Close modal

      //   context.push('/peer-chatscreen', extra: {
      //     'roomId': result['roomId'],
      //     'id': result['id'],
      //     'name': name,
      //     'avatar': result['imageUrl']
      //   });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (id_room != 0) {
              _supabaseDB.deleteMatchRoom(id_room);
            }
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.transparent, // Transparent background
          ),
        ),
        if (!roomsFound)
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
