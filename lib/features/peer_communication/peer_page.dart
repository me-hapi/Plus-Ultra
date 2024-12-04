import 'package:flutter/material.dart';
import 'package:lingap/features/peer_communication/test/join_screen.dart';
import 'package:lingap/features/peer_communication/ui/find_peers.dart';
// import 'package:lingap/features/peer_communication/join_screen.dart';

class PeerConnectPage extends StatelessWidget {
  const PeerConnectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peer Connect'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => JoinScreen(),
              ),
            );
          },
          child: const Text(
            'Join a Meeting',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
