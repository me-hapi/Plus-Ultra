import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:lingap/features/chatbot/services/rag_model.dart';

class CallLogic {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _text = "Tap the mic to speak...";
  String _response = "";
  late RAGModel rag;

  CallLogic() {
    _initializeTTS();
    rag = RAGModel();
  }

  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("fil-PH");
    await _flutterTts.setPitch(1.0);
  }

  bool get isListening => _isListening;
  String get recognizedText => _text;
  String get chatbotResponse => _response;

  Future<void> startListening(Function(String) onTextChange) async {
    bool available = await _speech.initialize();
    if (available) {
      _isListening = true;
      _text = "Listening...";
      _speech.listen(onResult: (result) {
        _text = result.recognizedWords;
        onTextChange(_text);
      });
    }
  }

  Future<void> stopListening(Function(String) onResponseChange) async {
    _speech.stop();
    _isListening = false;
    _sendMessageToChatbot(_text, onResponseChange);
  }

  Future<void> _sendMessageToChatbot(
      String userInput, Function(String) onResponseChange) async {
    _response = "Thinking...";
    onResponseChange(_response);

    String apiKey = "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"; // Replace with your OpenAI API Key
    String apiUrl = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": userInput},
        ],
        "temperature": 0.7
      }),
    );

    if (response.statusCode == 200) {
      _response = jsonDecode(response.body)["choices"][0]["message"]["content"];
    } else {
      _response = "Error: Could not fetch response.";
    }

    onResponseChange(_response);
  }

  Future<void> speakResponse() async {
    if (_response.isNotEmpty && _response != "Thinking...") {
      await _flutterTts.speak(_response);
    }
  }
}
