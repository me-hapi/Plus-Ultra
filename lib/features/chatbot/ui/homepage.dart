import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/chatbot/data/supabase_db.dart';
import 'package:lingap/features/chatbot/ui/chatbot_tutorial.dart';
import 'package:lingap/features/chatbot/ui/conversation_card.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final SupabaseDB supabase = SupabaseDB(client);
  late Stream<List<Map<String, dynamic>>> chatStream;
  List<Map<String, dynamic>> chatList = [];
  final GlobalKey _keyAppBar = GlobalKey();
  final GlobalKey _keyChatList = GlobalKey();
  final GlobalKey _keyFAB = GlobalKey();
  ChatTutorial? _chatTutorial;

  @override
  void initState() {
    super.initState();
    chatStream = supabase.streamChats(uid);
    chatStream.listen((data) {
      if (mounted) {
        setState(() {
          chatList = data;
        });
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _chatTutorial = ChatTutorial(context);
    //   _chatTutorial!.initTargets(_keyAppBar, _keyChatList, _keyFAB);
    //   _chatTutorial!.showTutorial();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _keyAppBar,
        automaticallyImplyLeading: false,
        title: Text(
          'My AI Chats',
          style: TextStyle(
            color: mindfulBrown['Brown80'],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Padding(
        key: _keyChatList,
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: chatList.length,
          itemBuilder: (context, index) {
            final chat = chatList[index];
            String icon = chat['icon'] ?? 'abstract';
            return ConversationCard(
              sessionID: chat['id'],
              animate: false,
              imagePath: 'assets/chatbot/icon/$icon.png',
              title: chat['title'] ?? 'Unknown Chat',
              total: '${chat['count'] ?? 0} messages',
              emotion: chat['emotion'] ?? 'Neutral',
              isSessionOpen: chat['open'],
              onDelete: () async {
                print('CHATID: ${chat['id']}');
                await supabase.deleteSession(chat['id']);
                setState(() {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      setState(() {
                        chatList.removeWhere(
                            (element) => element['id'] == chat['id']);
                      });
                    }
                  });
                });
              },
              onClose: () async {
                await supabase.closeSession(chat['id']);
              },
            );
          },
        ),
      ),
      floatingActionButton: Container(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          key: _keyFAB,
          onPressed: () async {
            int result = await supabase.createSession(uid);
            if (result != 0) {
              context.push('/chatscreen', extra: {
                'sessionID': result,
                'animate': true,
                'intro': true,
                'open': true
              });
            }
          },
          backgroundColor: mindfulBrown['Brown80'],
          elevation: 0,
          highlightElevation: 0,
          shape: CircleBorder(
            side: BorderSide(
              color: mindfulBrown['Brown20']!,
              width: 4,
            ),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
