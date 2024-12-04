import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/features/peer_communication/ui/chat_bubble.dart';
import 'package:videosdk/videosdk.dart';

class ChatScreen extends ConsumerWidget {
  final VoidCallback onSendMessage;
  final TextEditingController messageController;
  final String localParticipantId;
  final List<PubSubMessage> messages;

  const ChatScreen({
    Key? key,
    required this.onSendMessage,
    required this.messageController,
    required this.localParticipantId,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // Trigger Video Call
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Trigger Audio Call
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text('No messages yet'))
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatBubble(
                        isUser: message.senderId == localParticipantId,
                        message: message.message,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: onSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
