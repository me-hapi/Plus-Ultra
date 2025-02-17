import 'package:flutter/material.dart';
import 'package:lingap/features/chatbot/services/call_logic.dart';

class RealtimeChatbot extends StatefulWidget {
  @override
  _RealtimeChatbotState createState() => _RealtimeChatbotState();
}

class _RealtimeChatbotState extends State<RealtimeChatbot> {
  late CallLogic _callLogic;

  @override
  void initState() {
    super.initState();
    _callLogic = CallLogic();
  }

  void _updateText(String text) {
    setState(() {});
  }

  void _updateResponse(String response) {
    setState(() {});
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
            Text(_callLogic.recognizedText, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _callLogic.isListening
                  ? () => _callLogic.stopListening(_updateResponse)
                  : () => _callLogic.startListening(_updateText),
              child:
                  Icon(_callLogic.isListening ? Icons.mic_off : Icons.mic, size: 36),
            ),
            SizedBox(height: 20),
            Text("Chatbot: ${_callLogic.chatbotResponse}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _callLogic.speakResponse,
              child: Text("Speak Response"),
            ),
          ],
        ),
      ),
    );
  }
}
