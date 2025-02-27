import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lingap/features/chatbot/logic/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:lingap/features/chatbot/services/rag_model.dart';

class CallLogic {
  stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  bool _isMuted = false; // Controls whether speech is allowed
  String _text = "Listening...";
  String _response = "";
  List<String> callHistory = [];
  late RAGModel rag;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String apiKey =
      "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"; // Replace with your OpenAI API Key

  CallLogic(int sessionID) {
    OpenAI.apiKey = apiKey;
    _initializeTTS();
    rag = RAGModel(sessionID);
  }

  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("fil-PH");
    await _flutterTts.setPitch(1.0);
  }

  bool get isListening => _isListening;
  String get displayedText => _text.isNotEmpty ? _text : _response;

  void setMute(bool mute) {
    _isMuted = mute;
  }

  Future<void> _speakResponse(Function() onUpdate) async {
    if (_response.isNotEmpty && _response != "Thinking..." && !_isMuted) {
      // Directory appDir = await getApplicationDocumentsDirectory();
      // String outputDirPath = "${appDir.path}/speechOutput";
      // Directory outputDir = Directory(outputDirPath);

      // if (!(await outputDir.exists())) {
      //   await outputDir.create(recursive: true);
      // }

      // File speechFile = await OpenAI.instance.audio.createSpeech(
      //   model: "tts-1",
      //   input: _response,
      //   voice: "sage",
      //   responseFormat: OpenAIAudioSpeechResponseFormat.mp3,
      //   outputDirectory: outputDir,
      //   outputFileName: "test",
      // );

      // await _audioPlayer.setFilePath(speechFile.path);
      // await _audioPlayer.play();
      // await _audioPlayer.playerStateStream.firstWhere(
      //     (state) => state.processingState == ProcessingState.completed);
      _flutterTts.speak(_response);
    }

    // Reset to "Tap the mic to speak" and restart listening
    _text = "Listening...";
    _isListening = false;
    onUpdate();
    await Future.delayed(Duration(microseconds: 500));
    startListening(onUpdate);
  }

  Future<void> startListening(Function() onUpdate) async {
    if (_isListening) return;

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "notListening" || status == "done") {
          _text = "Didn't hear any speech";
          _isListening = false;
          onUpdate();
          Future.delayed(Duration(seconds: 1),
              () => startListening(onUpdate)); // Restart listening
        }
      },
    );

    if (!available) return;

    _isListening = true;
    onUpdate();

    _speech.listen(
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          _text = result.recognizedWords;
          onUpdate();

          if (result.finalResult) {
            callHistory.add("User: $_text");
            _sendMessageToChatbot(onUpdate);
          }
        }
      },
      listenFor: Duration(seconds: 20),
      cancelOnError: false,
      partialResults: true,
    );
  }

  Future<void> stopListening(Function() onUpdate) async {
    await _speech.stop();
    _isListening = false;
    onUpdate();
  }

  Future<void> _sendMessageToChatbot(Function() onUpdate) async {
    if (_text.isNotEmpty && _text != "Listening...") {
      String fullResponse = await rag.queryResponse(_text, callHistory);
      Map mapResponse = Utils().parseResponse(fullResponse);

      _response = mapResponse['response'];
      callHistory.add("Chatbot: $_response");

      // Force UI update before playing the response
      onUpdate();

      // Delay to ensure UI updates before playing response
      await Future.delayed(Duration(milliseconds: 500));

      _speakResponse(onUpdate); // Speak response and restart listening
    }
  }
}
