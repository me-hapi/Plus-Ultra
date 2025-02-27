import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lingap/features/chatbot/logic/utils.dart';
import 'package:lingap/features/chatbot/services/rag_model.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:web_socket_channel/web_socket_channel.dart';

class CallLogic {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isMuted = false;
  String _text = "Listening...";
  String _response = "";
  List<String> callHistory = [];
  late RAGModel rag;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String elevenLabsApiKey =
      "sk_b1212189c293af2565baa2ccf97c79e504b4d279d997ed4b";
  String voiceId = "u0P5zPuh3SvxTi9vSTCn";

  CallLogic(int sessionID) {
    rag = RAGModel(sessionID);
  }

  bool get isListening => _isListening;
  String get displayedText => _text.isNotEmpty ? _text : _response;

  void setMute(bool mute) {
    _isMuted = mute;
  }

  Future<void> startListening(Function() onUpdate) async {
    if (_isListening) return;

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "notListening" || status == "done") {
          _text = "Didn't hear any speech";
          _isListening = false;
          onUpdate();
          Future.delayed(Duration(seconds: 1), () => startListening(onUpdate));
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
      listenFor: Duration(seconds: 10),
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
      onUpdate();

      await Future.delayed(Duration(milliseconds: 500));
      await _speakResponse(onUpdate);
    }
  }

  Future<void> _speakResponse(Function() onUpdate) async {
    if (_response.isNotEmpty && _response != "Thinking..." && !_isMuted) {
      print('speak');
      await _streamElevenLabsTTS(_response);
    }

    _text = "Listening...";
    _isListening = false;
    onUpdate();
    await Future.delayed(Duration(milliseconds: 500));
    startListening(onUpdate);
  }

  Future<void> _streamElevenLabsTTS(String text) async {
    final String url =
        "wss://api.elevenlabs.io/v1/text-to-speech/$voiceId/stream-input";
    final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(url));

    print("Connecting to Eleven Labs WebSocket...");

    channel.sink.add(jsonEncode({
      "xi-api-key": elevenLabsApiKey,
      "text": text, // Directly send the text
      "voice_settings": {"stability": 0.5, "similarity_boost": 0.8}
    }));

    channel.stream.listen(
      (message) async {
        try {
          Map<String, dynamic> response = jsonDecode(message);

          if (response.containsKey("audio")) {
            print("Received audio data from Eleven Labs.");

            String audioBase64 = response["audio"];
            Uint8List audioBytes = base64Decode(audioBase64);

            // Write to a temporary file
            Directory tempDir = Directory.systemTemp;
            String filePath = "${tempDir.path}/output.mp3";
            File tempAudioFile = File(filePath);
            await tempAudioFile.writeAsBytes(audioBytes);

            // Debug log to confirm the file exists
            if (await tempAudioFile.exists()) {
              print("Audio file saved at: $filePath");

              // Play the audio
              await _audioPlayer.setFilePath(filePath);
              await _audioPlayer.play();
            } else {
              print("Failed to save audio file.");
            }
          } else {
            print("No audio key found in response: $response");
          }
        } catch (e) {
          print("Error processing TTS response: $e");
        }
      },
      onDone: () {
        print("WebSocket connection closed.");
        channel.sink.close();
      },
      onError: (error) {
        print("WebSocket Error: $error");
      },
    );
  }
}
