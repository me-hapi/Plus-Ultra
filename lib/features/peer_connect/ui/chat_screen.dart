import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/utils/security/encryption.dart';
import 'package:lingap/features/peer_connect/ui/meeting_screen.dart';
import 'package:lingap/features/peer_connect/logic/message_controller.dart';
import 'package:lingap/features/peer_connect/models/message_model.dart';
import 'package:lingap/features/peer_connect/ui/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;

  ChatScreen({required this.roomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late Stream<List<MessageModel>> _messageStream;
  final Encryption encrypt = Encryption();

  @override
  void initState() {
    super.initState();
    _messageStream = MessageController().getMessages(widget.roomId);
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await MessageController()
          .sendMessage(_messageController.text.trim(), widget.roomId);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mindfulBrown['Brown30'],
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {
              // Video call functionality to be implemented
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MeetingScreen(roomId: widget.roomId, token: token),
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Audio call functionality to be implemented
            },
          ),
        ],
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages yet'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      return ChatBubble(
                        message: encrypt.decryptMessage(
                            message.content, widget.roomId),
                        isSentByMe: message.sender == uid,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
