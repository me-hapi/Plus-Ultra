import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lingap/features/journaling/ui/audio_card.dart';

class JournalItem {
  final String type; // 'text', 'image', or 'audio'
  final String? text;
  final File? imageFile;
  final String? audioPath;

  JournalItem({required this.type, this.text, this.imageFile, this.audioPath});
}

class CreateJournalLogic {
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