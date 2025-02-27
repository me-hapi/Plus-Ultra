import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lingap/features/chatbot/logic/utils.dart';
import 'package:lingap/features/chatbot/services/rag_model.dart';
import 'package:path_provider/path_provider.dart';
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
  String voiceId = "cgSgspJ2msm6clMCkdW9";

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
      Map mapResponse = Utils().extractRecommendation(fullResponse);

      _response = mapResponse['response'];
      print('RESPONSE on call: $_response');
      callHistory.add("Chatbot: $_response");
      onUpdate();

      await Future.delayed(Duration(milliseconds: 500));
      await _speakResponse(onUpdate);
    }
  }

  Future<void> _speakResponse(Function() onUpdate) async {
    if (_response.isNotEmpty && _response != "Thinking..." && !_isMuted) {
      print('speak');
      await _fetchElevenLabsTTS(_response);
    }

    // _text = "Listening...";
    _isListening = false;
    onUpdate();
    await Future.delayed(Duration(milliseconds: 500));
    startListening(onUpdate);
  }

  Future<void> _fetchElevenLabsTTS(String text) async {
    print('Fetching TTS for: $text');

    final String url =
        "https://api.elevenlabs.io/v1/text-to-speech/$voiceId?output_format=mp3_44100_128";

    try {
      Dio dio = Dio();
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "xi-api-key": elevenLabsApiKey,
            "Content-Type": "application/json",
          },
        ),
        data: jsonEncode({
          "text": text,
          "model_id": "eleven_flash_v2_5",
          "language_code": "fil"
        }),
      );

      if (response.statusCode == 200) {
        print("Received audio response from Eleven Labs.");

        // Ensure response data is a string
        if (response.data is String) {
          String base64String = response.data;

          // Decode Base64 to bytes
          List<int> audioBytes = base64Decode(base64String);

          // Save the MP3 file in the app's temporary directory
          Directory tempDir = await getTemporaryDirectory();
          String filePath = "${tempDir.path}/output.mp3";
          File tempAudioFile = File(filePath);
          await tempAudioFile.writeAsBytes(response.data);

          if (await tempAudioFile.exists()) {
            print("Audio file saved at: $filePath");

            // Play the audio using just_audio
            AudioPlayer _audioPlayer = AudioPlayer();
            await _audioPlayer.setFilePath(filePath);
            await _audioPlayer.play();
          } else {
            print("Failed to save audio file.");
          }
        } else {
          print("Unexpected response format: ${response.data.runtimeType}");
        }
      } else {
        print("Failed to fetch TTS: ${response.statusCode} - ${response.data}");
      }
    } catch (e) {
      print("Error fetching TTS: $e");
    }
  }
}
