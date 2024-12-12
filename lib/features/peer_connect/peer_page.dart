import 'package:flutter/material.dart';
import 'package:lingap/features/peer_connect/ui/chat_home.dart';

class PeerConnectPage extends StatelessWidget {
  const PeerConnectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChatHome());
  }
}
