import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/chatbot/data/supabase_db.dart';
import 'package:lingap/features/chatbot/ui/conversation_card.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final SupabaseDB supabase = SupabaseDB(client);
  late Stream<List<Map<String, dynamic>>> chatStream;

  @override
  void initState() {
    super.initState();
    chatStream = supabase.streamChats(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error loading chats'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No chats available'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final chat = snapshot.data![index];
                String icon = chat['icon'] ?? 'abstract';
                return ConversationCard(
                  sessionID: chat['id'],
                  animate: false,
                  imagePath: 'assets/chatbot/icon/$icon.png',
                  title: chat['title'] ?? 'Unknown Chat',
                  total: '${chat['count'] ?? 0} messages',
                  emotion: chat['emotion'] ?? 'Neutral',
                  isSessionOpen: chat['open'],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Container(
        width: 72,
        height: 72,
        child: FloatingActionButton(
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
