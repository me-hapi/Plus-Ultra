import 'package:flutter/material.dart';
import 'package:lingap/features/peer_connect/ui/search_page.dart';

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
                builder: (context) => SearchPage(),
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
