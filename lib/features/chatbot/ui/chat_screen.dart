import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/chatbot/logic/chatbot_manager.dart';
import 'package:lingap/features/chatbot/ui/chat_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final int sessionID;

  ChatScreen({required this.sessionID});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatbotProvider(widget.sessionID));

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mindfulBrown['Brown80'],
        toolbarHeight: 50.0,
        title: Text('AI Chat',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/peer/call.png',
              width: 20,
              height: 20,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(10.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(
                  isUser: message.isUser,
                  message: message.message,
                  onTextUpdate: _scrollToBottom, // Pass scroll trigger
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
                    controller: ref
                        .read(chatbotProvider(widget.sessionID).notifier)
                        .messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(
                        color: mindfulBrown['Brown80'],
                      ),
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
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                    ),
                    style: TextStyle(
                      color: mindfulBrown['Brown80'],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(chatbotProvider(widget.sessionID).notifier)
                        .sendMessage();
                    _scrollToBottom(); // Scroll to bottom after sending
                  },
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
