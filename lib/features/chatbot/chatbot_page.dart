// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lingap/features/chatbot/logic/chatbot_manager.dart';
// import 'package:lingap/features/chatbot/ui/chat_screen.dart';

// final chatbotProvider = ChangeNotifierProvider((ref) => ChatbotManager());

// class ChatbotPage extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.watch(chatbotProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chatbot Page'),
//       ),
//       body: ChatScreen(),
//     );
//   }
// }