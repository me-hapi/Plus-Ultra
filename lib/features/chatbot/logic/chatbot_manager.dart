import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/chatbot/data/supabase_db.dart';
import 'package:lingap/features/chatbot/services/chatbot.dart';

final chatbotProvider =
    StateNotifierProvider.family<ChatbotNotifier, List<Message>, int>(
        (ref, sessionID) {
  return ChatbotNotifier(sessionID);
});

class ChatbotNotifier extends StateNotifier<List<Message>> {
  final Chatbot chatbot = Chatbot();
  final int sessionID;
  final SupabaseDB supabaseDB;
  final TextEditingController messageController = TextEditingController();

  ChatbotNotifier(this.sessionID)
      : supabaseDB = SupabaseDB(client),
        super([]) {
    _loadCachedMessages();
    _listenToMessages();
  }

  Future<void> _loadCachedMessages() async {
    final cached =
        await client.from('chatbot_convo').select().eq('sessionID', sessionID);
    state = cached
        .map((row) => Message(isUser: row['user'], message: row['content']))
        .toList();
  }

  void _listenToMessages() {
    supabaseDB.streamChatbotConversations(sessionID.toString()).listen((data) {
      final newMessages = data
          .map((row) => Message(isUser: row['user'], message: row['content']))
          .toList();

      // Check if messages are truly new to prevent unnecessary rebuilds
      if (newMessages.length > state.length) {
        state = List.from(state)..addAll(newMessages.skip(state.length));
      }
    });
  }

  void sendMessage() async {
  String userInput = messageController.text.trim();
  if (userInput.isEmpty) return;

  state = [...state, Message(isUser: true, message: userInput)];
  messageController.clear();

  // Add "Typing..." message
  state = [...state, Message(isUser: false, message: "Typing...")];

  List<String> history = state
      .map((msg) =>
          msg.isUser ? "User: ${msg.message}" : "System: ${msg.message}")
      .toList();

  Map response = await chatbot.createResponse(userInput, history);

  String responseText = response['response'];
  String title = response['title'];
  String icon = response['icon'];
  String emotion = response['emotion'];
  int count = history.length;

  print('title: $title \n icon: $icon \n emotion: $emotion, history: $count');

  await supabaseDB.insertMessages(sessionID, userInput, true);
  await supabaseDB.insertMessages(sessionID, responseText, false);
  await supabaseDB.updateCount(sessionID, count);

  if (history.length <= 2) {
    supabaseDB.updateSession(sessionID, title, emotion, icon);
  }

  // Replace "Typing..." with the actual response and animate it
  state = [...state.sublist(0, state.length - 1), Message(isUser: false, message: responseText)];
}

}

class Message {
  final bool isUser;
  final String message;

  Message({required this.isUser, required this.message});
}
