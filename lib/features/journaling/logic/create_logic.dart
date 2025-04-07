import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/journaling/data/supabse_db.dart';
import 'package:lingap/features/journaling/logic/journal_processor.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';
import 'package:lingap/features/journaling/ui/audio_card.dart';

class CreateJournalLogic {
  final journalProcessor = JournalProcessor();
  final SupabaseDB supabase = SupabaseDB(client);
  final TextEditingController titleController =
      TextEditingController(text: 'Untitled');
  final List<JournalItem> journalItems = [];
  final Map<int, TextEditingController> textControllers = {};

  void insertPromptText(String text) {
    final controller = TextEditingController(text: text);

    // Insert new journal item at the beginning
    journalItems.insert(0, JournalItem(type: 'text', text: text));

    // Rebuild the textControllers map with shifted indices
    final updatedControllers = <int, TextEditingController>{};
    updatedControllers[0] = controller;

    for (int i = 0; i < textControllers.length; i++) {
      updatedControllers[i + 1] = textControllers[i]!;
    }

    textControllers
      ..clear()
      ..addAll(updatedControllers);
  }

  void addTextField({String initialText = ''}) {
    final index = journalItems.length;
    textControllers[index] = TextEditingController(text: initialText);
    journalItems.add(JournalItem(type: 'text', text: initialText));
  }

  void updateText(int index, String newText) {
    journalItems[index] = JournalItem(type: 'text', text: newText);
  }

  void insertImage(File image) {
    journalItems.add(JournalItem(type: 'image', imageFile: image));
  }

  void addAudio(String audioPath) {
    journalItems.add(JournalItem(type: 'audio', audioPath: audioPath));
  }

  void removeAudio(String audioPath) {
    journalItems.removeWhere((item) => item.audioPath == audioPath);
  }

  Future<Map<String, dynamic>> saveJournal() async {
    int id =
        await supabase.insertJournal(uid, titleController.text, journalItems);
    Map<String, dynamic> result =
        await journalProcessor.processJournal(journalItems);

    String response =
        await uploadAudio(id.toString(), result['text'], result['audio']);
    print('UPLOAD: $response');
    // Use RegExp to extract the value after 'emotion: '
    RegExp regex = RegExp(r'emotion:\s*(\w+)');
    Match? match = regex.firstMatch(response);

    // Extract the matched group (emotion)
    String? emotion = match?.group(1);
    return {'id': id, 'emotion': emotion!};
  }

  Future<String> uploadAudio(String id, String text, String? audioPath) async {
    try {
      print("Uploading audio from: $audioPath");

      // API URL
      String url = 'https://lingap-rag.onrender.com/classify-emotion';

      // Create FormData
      FormData formData = FormData.fromMap({
        'id': id,
        'text': text,
      });

      // Attach audio if it exists
      if (audioPath != null) {
        File audioFile = File(audioPath);
        if (audioFile.existsSync()) {
          formData.files.add(MapEntry(
            'audio',
            await MultipartFile.fromFile(audioPath,
                filename: 'merged_audio.m4a'),
          ));
        } else {
          print("Audio file not found: $audioPath");
        }
      }

      // Configure Dio
      Dio dio = Dio();
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'accept': 'application/json',
          },
        ),
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Audio uploaded successfully: ${response.data}");
        return response.data["classification"] ?? "error";
      } else {
        print(
            "Failed to upload audio: ${response.statusCode} - ${response.data}");
        return "error";
      }
    } catch (e) {
      print("Error uploading audio: $e");
      return "error";
    }
  }

  bool shouldShowTapPrompt() {
    if (journalItems.isEmpty) return false;
    final lastItem = journalItems.last;
    return lastItem.type == 'image' || lastItem.type == 'audio';
  }

  void dispose() {
    titleController.dispose();
    textControllers.values.forEach((controller) => controller.dispose());
  }
}
