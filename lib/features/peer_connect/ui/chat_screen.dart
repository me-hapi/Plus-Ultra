import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/utils/security/encryption.dart';
import 'package:lingap/features/peer_connect/data/supabase_db.dart';
import 'package:lingap/features/peer_connect/ui/meeting_screen.dart';
import 'package:lingap/features/peer_connect/logic/message_controller.dart';
import 'package:lingap/features/peer_connect/models/message_model.dart';
import 'package:lingap/features/peer_connect/ui/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final int id;
  final String name;
  final String avatarUrl;

  ChatScreen(
      {required this.roomId,
      required this.id,
      required this.name,
      required this.avatarUrl});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late Stream<List<MessageModel>> _messageStream;
  final Encryption encrypt = Encryption();
  final SupabaseDB supabase = SupabaseDB(client);

  Map<int, bool> _showTimestamp = {}; // Track visibility for each message

  @override
  void initState() {
    super.initState();
    _messageStream = MessageController().getMessages(widget.id);
    supabase.markMessageAsRead(widget.id);
  }

  void _toggleTimestamp(int index) {
    setState(() {
      _showTimestamp[index] = !(_showTimestamp[index] ?? false);
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await MessageController()
          .sendMessage(_messageController.text.trim(), widget.id);
      _messageController.clear();
    }
  }

  void _unsendMessage(int messageId) async {
    await MessageController().unsendMessage(messageId);
  }

  void _showUnsendModal(BuildContext context, int messageId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.delete, color: presentRed['Red50']),
                title: Text('Unsend Message',
                    style: TextStyle(color: presentRed['Red50'])),
                onTap: () {
                  _unsendMessage(messageId);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mindfulBrown['Brown80'],
        toolbarHeight: 50.0,
        title: Row(
          children: [
            Icon(Icons.arrow_back_ios),
            SizedBox(width: 5,),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white, // White border
                  width: 3.0, // Border width
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: ClipOval(
                  child: Image.asset(
                    widget.avatarUrl,
                    fit: BoxFit.cover,
                    width: 30, // Match the diameter of the CircleAvatar
                    height: 30,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8,),
            Text(widget.name,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.push('/meeting-screen', extra: {
                'roomId': widget.roomId,
                'id': widget.id,
                'name': widget.name,
                'cam': true
              });
            },
            child:
                Image.asset('assets/peer/videocall.png', width: 25, height: 25),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              context.push('/meeting-screen', extra: {
                'roomId': widget.roomId,
                'id': widget.id,
                'name': widget.name,
                'cam': false
              });
            },
            child: Image.asset('assets/peer/call.png', width: 20, height: 20),
          ),
          SizedBox(width: 20),
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
                      final decryptedMessage = encrypt.decryptMessage(
                          message.content, widget.id.toString());
                      final formattedTime =
                          TimeOfDay.fromDateTime(message.created_at)
                              .format(context);

                      return GestureDetector(
                        onTap: () => _toggleTimestamp(index),
                        onLongPress: () =>
                            _showUnsendModal(context, message.id),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_showTimestamp[index] == true)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  formattedTime,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: optimisticGray['Gray50']),
                                ),
                              ),
                            ChatBubble(
                              message: message.unsent
                                  ? 'Unsent message'
                                  : decryptedMessage,
                              isSentByMe: message.sender == uid,
                            ),
                          ],
                        ),
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
                      hintStyle: TextStyle(color: mindfulBrown['Brown80']),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: serenityGreen['Green30']!,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                    ),
                    style: TextStyle(color: mindfulBrown['Brown80']),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: serenityGreen['Green50'],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/peer/send.png',
                        width: 20.0,
                        height: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
