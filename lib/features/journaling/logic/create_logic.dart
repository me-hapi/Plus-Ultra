import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/journaling/data/supabse_db.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';
import 'package:lingap/features/journaling/ui/audio_card.dart';

class CreateJournalLogic {
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

  void saveJournal() {
    supabase.insertJournal(uid, titleController.text, journalItems);

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
