import 'dart:convert';
import 'package:http/http.dart' as http;

// Define conversation states
enum ConversationState { Greeting, Assessment, OngoingSupport, Crisis }

class Chatbot {
  final String apiUrl = 'https://www.chatbase.co/api/v1/chat';
  final String apiKey = '9fa34d66-b130-4c01-b533-43c697f952a0';
  ConversationState currentState = ConversationState.Greeting;

  // Function to create response based on current state
  Future<String> createResponse(String prompt) async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json'
    };

    String initialMessage;
    switch (currentState) {
      case ConversationState.Greeting:
        initialMessage = "Hi! Kamusta ka? Ano'ng maitutulong ko sa'yo ngayon?";
        break;
      case ConversationState.Assessment:
        initialMessage =
            "Okay lang bang magtanong ako ng ilang bagay para mas maintindihan ko ang pinagdadaanan mo?";
        break;
      case ConversationState.OngoingSupport:
        initialMessage =
            "Andito ako para makinig. Kamusta ka? Ano ang nararamdaman mo ngayon?";
        break;
      case ConversationState.Crisis:
        initialMessage =
            "Mukhang may mabigat kang pinagdadaanan. Andito ako para tumulong. Sabihin mo lang.";
        break;
    }

    final List<Map<String, String>> messages = [
      {"content": initialMessage, "role": "assistant"},
      // if (context.isNotEmpty)
      //   {"content": context, "role": "assistant"},
      // if (significantHistory.isNotEmpty)
      //   {"content": significantHistory, "role": "assistant"},
      // if (profile.isNotEmpty) {"content": profile, "role": "assistant"},
      {"content": prompt, "role": "user"}
    ];

    print(messages);
    
    final Map<String, dynamic> data = {
      "messages": messages,
      "chatbotId": '3eW7ETixgdeaRoMmZwu0S',
      "stream": false,
      "temperature": 0
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _updateState(prompt); // Update the state based on user response
        return jsonData['text'];
      } else {
        final jsonData = json.decode(response.body);
        return 'Error: ${jsonData['message']}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Function to update the state of the conversation
  void _updateState(String userMessage) {
    if (currentState == ConversationState.Greeting) {
      currentState = ConversationState.Assessment;
    } else if (userMessage.toLowerCase().contains("help") ||
        userMessage.toLowerCase().contains("emergency")) {
      currentState = ConversationState.Crisis;
    } else {
      currentState = ConversationState.OngoingSupport;
    }
  }

  // Function to get the current state of the conversation
  ConversationState getCurrentState() {
    return currentState;
  }
}
