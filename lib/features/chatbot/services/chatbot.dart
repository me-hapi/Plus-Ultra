import 'dart:convert';
import 'package:http/http.dart' as http;

// Define conversation states
enum ConversationState { Greeting, Assessment, OngoingSupport, Crisis }

class Chatbot {
  final String apiUrl = 'https://lingap-rag.onrender.com/chat';
  final String apiKey = '1';

  // Function to create response based on current state
  Future createResponse(String prompt, List<String> history) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode({
          'query': prompt,
          'history': history,
          'apikey': apiKey
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['response']; 
      } else {
        final jsonData = json.decode(response.body);
        return 'Error: ${jsonData['error']}'; // Corrected error key
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
