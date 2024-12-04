// File: ui/find_user_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/features/peer_communication/peer_manager.dart';

class FindPeersPage extends ConsumerWidget {
  const FindPeersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using a StateProvider to hold the isAnonymous state, as it's mutable.
    final isAnonymous = ref.watch(isAnonymousProvider);
    final peerManager = ref.read(peerManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isAnonymous,
                  onChanged: (value) {
                    ref.read(isAnonymousProvider.notifier).state = value ?? false;
                  },
                ),
                const Text('Join as Anonymous'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the findPeers method from PeerManager
                peerManager.findPeerAndJoinRoom(context);
              },
              child: const Text('Start Finding Users'),
            ),
          ],
        ),
      ),
    );
  }
}

// Define a StateProvider for isAnonymous
final isAnonymousProvider = StateProvider<bool>((ref) => false);
