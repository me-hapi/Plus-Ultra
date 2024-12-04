import 'package:flutter/material.dart';
import 'package:lingap/features/peer_communication/ui/video_chat_ui.dart';
import 'package:videosdk/videosdk.dart';

class ChatView extends StatefulWidget {
  final Room room;
  final Map<String, Participant> participants;

  const ChatView({Key? key, required this.room, required this.participants}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}


class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();

  // PubSubMessages
  PubSubMessages messages = PubSubMessages(messages: []);

  @override
  void initState() {
    super.initState();
    // Subscribing to 'CHAT' Topic

    print(widget.room.id);
    widget.room.pubSub
        .subscribe("CHAT", messageHandler)
        .then((value) => setState((() => messages = value)))
        .catchError((e) {
      print("[ERROR] Subscription failed: $e");
    });
  }

  // Handler which will be called when new message is received
  void messageHandler(PubSubMessage message) {
    setState(() => messages.messages.add(message));
    print("RECEIVED $message");
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final messageText = _messageController.text;

      try {
        // Publish message to the 'CHAT' topic
        widget.room.pubSub.publish(
          "CHAT",
          messageText,
          const PubSubPublishOptions(persist: true),
        );
        print("[DEBUG] Published message: $messageText");

        // Add the message locally to the list of messages
        // final newMessage = PubSubMessage(
        //   id: UniqueKey().toString(),
        //   message: messageText,
        //   topic: "CHAT",
        //   senderId: widget.room.localParticipant.id,
        //   senderName: widget.room.localParticipant.displayName,
        //   timestamp: DateTime.now(),
        //   payload: {},
        // );

        // setState(() {
        //   messages.messages.add(newMessage);
        // });

        print(messages.messages[0].message);
      } catch (e) {
        print("[ERROR] Failed to publish message: $e");
        return;
      }

      _messageController.clear();
    } else {
      print("[ERROR] Message text is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoChatUI(room: widget.room, participants: widget.participants,),
                ),
              );
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
            child: ListView.builder(
              itemCount: messages.messages.length,
              itemBuilder: (context, index) {
                final message = messages.messages[index];
                final isLocalParticipant =
                    message.senderId == widget.room.localParticipant.id;

                return Align(
                  alignment: isLocalParticipant
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isLocalParticipant
                          ? Colors.blueAccent.withOpacity(0.7)
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isLocalParticipant)
                          Text(
                            message.senderName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        SizedBox(height: 5),
                        Text(
                          message.message,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.blueAccent,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   // Unsubscribe if messages are initialized
  //   widget.room.pubSub.unsubscribe("CHAT", messageHandler);
  //   _messageController.dispose();
  //   super.dispose();
  // }
}
