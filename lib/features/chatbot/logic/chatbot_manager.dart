import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/features/chatbot/data/vector_db.dart';
import 'package:lingap/features/chatbot/services/chatbot.dart';
import 'package:lingap/features/chatbot/services/embed_doc.dart';

final chatbotProvider = ChangeNotifierProvider((ref) => ChatbotManager());

class ChatbotManager extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final List<Message> messages = [];
  final Embedder embedder = Embedder(); 
  // final VectorDB vectorDB = VectorDB('conversation'); 
  final Chatbot chatbot = Chatbot(); 

  void sendMessage() async {
    String userInput = messageController.text.trim();
    if (userInput.isEmpty) return;

    messages.add(Message(isUser: true, message: userInput));
    notifyListeners();

    messageController.clear();

    Float64List? embedding = await embedder.createEmbedding(userInput);
    // String context = vectorDB.search(embedding!, 1);
    String response = await chatbot.createResponse(userInput);
    
    // vectorDB.add(text: userInput, embedding: embedding);

    messages.add(Message(isUser: false, message: response));
    notifyListeners();
  }
}

class Message {
  final bool isUser;
  final String message;

  Message({required this.isUser, required this.message});
}