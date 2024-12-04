import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/features/chatbot/logic/chatbot_manager.dart';
import 'package:lingap/features/chatbot/ui/chat_bubble.dart';

final chatbotProvider = ChangeNotifierProvider((ref) => ChatbotManager());

class ChatScreen extends ConsumerStatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final chatbotManager = ref.watch(chatbotProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: chatbotManager.messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  isUser: chatbotManager.messages[index].isUser,
                  message: chatbotManager.messages[index].message,
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            color: Colors.lightBlue[50],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatbotManager.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.lightBlueAccent),
                  onPressed: () {
                    chatbotManager.sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
