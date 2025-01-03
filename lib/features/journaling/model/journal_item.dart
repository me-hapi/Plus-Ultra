import 'dart:io';

class JournalItem {
  final String type; // 'text', 'image', or 'audio'
  final String? text;
  final File? imageFile;
  final String? audioPath;

  JournalItem({required this.type, this.text, this.imageFile, this.audioPath});
}