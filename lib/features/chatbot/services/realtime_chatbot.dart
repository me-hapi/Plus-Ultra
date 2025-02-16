import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:lingap/features/chatbot/services/pinecone_retriever.dart';
import 'package:lingap/features/chatbot/services/rag_model.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RealtimeChatbot extends StatefulWidget {
  @override
  _RealtimeChatbotState createState() => _RealtimeChatbotState();
}

class _RealtimeChatbotState extends State<RealtimeChatbot> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _text = "Tap the mic to speak...";
  String _response = "";
  late RAGModel rag;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    rag = RAGModel();
    test();
  }

  Future<void> test() async {
    // final result =
    //     await rag.queryStream('ang baba ng nakuha kong score kanina');
    // print('RESULT $result');
    // final result = await pinecone.convertToEmbeddingAndQuery('ang baba ng nakuha kogn score kanina');
    // print('RESULT $result');

    //   try {
    //   List<dynamic> languages = await _flutterTts.getLanguages;
    //   print("Available Languages: $languages");
    // } catch (e) {
    //   print("Error fetching languages: $e");
    // }

    await for (final response in rag.queryStream(
        'ang baba ng nakuha kong score sa test kanina huuhuhu', 'No history yet')) {
      print('RESULT: $response');
    }
  }

  void _initializeTTS() async {
    await _flutterTts.setLanguage("fil-PH");
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _text = "Listening...";
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      });
    }
  }

  Future<void> _stopListening() async {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
    _sendMessageToChatbot(_text);
  }

  Future<void> _sendMessageToChatbot(String userInput) async {
    setState(() {
      _response = "Thinking...";
    });

    String apiKey =
        "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"; // Replace with your OpenAI API Key
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
      setState(() {
        _response =
            jsonDecode(response.body)["choices"][0]["message"]["content"];
      });
    } else {
      setState(() {
        _response = "Error: Could not fetch response.";
      });
    }
  }

  Future<void> _speakResponse() async {
    if (_response.isNotEmpty && _response != "Thinking...") {
      await _flutterTts.speak(_response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real-time Voice Chatbot")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_text, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Icon(_isListening ? Icons.mic_off : Icons.mic, size: 36),
            ),
            SizedBox(height: 20),
            Text("Chatbot: $_response", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speakResponse,
              child: Text("Speak Response"),
            ),
          ],
        ),
      ),
    );
  }
}
