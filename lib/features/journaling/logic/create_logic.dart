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

  Future<void> saveJournal() async {
    int id =
        await supabase.insertJournal(uid, titleController.text, journalItems);
    Map<String, dynamic> result =
        await journalProcessor.processJournal(journalItems);

    await uploadAudio(id.toString(), result['audio']);
  }

  Future<void> uploadAudio(String uid, String audioPath) async {
    try {
      // Server endpoint
      String url = 'https://lingap-rag.onrender.com/upload-audio';

      // Prepare file
      File audioFile = File(audioPath);
      if (!audioFile.existsSync()) {
        throw Exception("Audio file not found at: $audioPath");
      }

      // Create FormData
      FormData formData = FormData.fromMap({
        'uid': uid,
        'file': await MultipartFile.fromFile(audioPath,
            filename: 'merged_audio.m4a'),
      });

      // Send POST request
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

      // Check response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Audio uploaded successfully: ${response.data}");
      } else {
        print(
            "Failed to upload audio: ${response.statusCode} - ${response.data}");
      }
    } catch (e) {
      print("Error uploading audio: $e");
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
