import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';
import 'package:path_provider/path_provider.dart';

class JournalProcessor {
  Future<Map<String, dynamic>> processJournal(
      List<JournalItem> journalItems) async {
    // Step 1: Combine all text
    String mergedText = _mergeText(journalItems);

    // Step 2: Merge all audio files
    String? mergedAudioPath = await _mergeAudios(journalItems);

    // Step 3: Print the results
    print('Merged Text:\n$mergedText');
    if (mergedAudioPath != null) {
      print('Merged Audio File Path: $mergedAudioPath');
    } else {
      print('No audio files to merge.');
    }

    return {'text': mergedText, 'audio': mergedAudioPath};
  }

  String _mergeText(List<JournalItem> journalItems) {
    return journalItems
        .where((item) => item.type == 'text' && item.text != null)
        .map((item) => item.text!)
        .join('\n'); // Join text entries with line breaks
  }

  Future<String?> _mergeAudios(List<JournalItem> journalItems) async {
    List<String> audioPaths = journalItems
        .where((item) => item.type == 'audio' && item.audioPath != null)
        .map((item) => item.audioPath!)
        .toList();

    if (audioPaths.isEmpty) {
      return null; // No audio files to merge
    }

    Directory tempDir = await getTemporaryDirectory();
    String outputPath = '${tempDir.path}/merged_audio.m4a';

    // Create a file list for FFmpeg input
    String fileListPath = '${tempDir.path}/audio_list.txt';
    File fileList = File(fileListPath);
    String fileListContent =
        audioPaths.map((path) => "file '$path'").join('\n');
    await fileList.writeAsString(fileListContent);

    // Merge `.m4a` files correctly using AAC encoding
    await FFmpegKit.execute(
        '-f concat -safe 0 -i "$fileListPath" -c:a aac -b:a 192k "$outputPath"');

    // Verify if the file was created successfully
    if (File(outputPath).existsSync()) {
      return outputPath;
    } else {
      print("❌ Failed to merge audio files.");
      return null;
    }
  }
}
