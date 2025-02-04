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
  final int id;

  ChatScreen({required this.roomId, required this.id});

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
    _messageStream = MessageController().getMessages(widget.id);
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await MessageController()
          .sendMessage(_messageController.text.trim(), widget.id);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mindfulBrown['Brown80'],
        toolbarHeight: 50.0, // Reduce the height of the AppBar
        title: Text('Chat',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/peer/videocall.png',
              width: 25,
              height: 25,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/peer/call.png',
              width: 20,
              height: 20,
            ),
          ),
          SizedBox(
            width: 20,
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
                            message.content, widget.id.toString()),
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
                      hintStyle: TextStyle(
                        color:
                            mindfulBrown['Brown80'], // Hint text color to brown
                      ),
                      filled: true, // Enable the fill color
                      fillColor: Colors.white, // Set the fill color to white
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Rounded corners
                        borderSide: BorderSide.none, // No visible border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Rounded corners
                        borderSide: BorderSide(
                          color: serenityGreen['Green30']!, // Green border when focused
                          width: 2.0, // Border width
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ), // Adjust padding
                    ),
                    style: TextStyle(
                      color:
                          mindfulBrown['Brown80'], // Input text color to brown
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 40.0, // Adjust the size of the circle
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Circular shape
                      color: serenityGreen[
                          'Green50'], // Background color (can be customized)
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/peer/send.png',
                        width: 20.0, // Adjust the image size
                        height: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
