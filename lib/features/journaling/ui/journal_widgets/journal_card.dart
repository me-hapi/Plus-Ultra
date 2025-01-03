import 'package:flutter/material.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';
import 'package:lingap/features/journaling/ui/audio_card.dart';
import 'dart:io';
import 'package:lingap/features/journaling/ui/journal_detail.dart';

class JournalCard extends StatelessWidget {
  final String emotion;
  final String title;
  final String date;
  final String time;
  final List<JournalItem> journalItems;

  const JournalCard({
    Key? key,
    required this.emotion,
    required this.title,
    required this.date,
    required this.time,
    required this.journalItems,
  }) : super(key: key);

  Widget _buildPreviewContent() {
    if (journalItems.isEmpty) {
      return const Text(
        "No content available",
        style: TextStyle(color: Colors.grey),
      );
    }

    final firstItem = journalItems.first;
    switch (firstItem.type) {
      case 'text':
        return Text(
          firstItem.text ?? "",
          style: const TextStyle(color: Colors.black54, fontSize: 16),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        );
      case 'image':
        return firstItem.imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  firstItem.imageFile!,
                  fit: BoxFit.cover,
                  height: 80, // Matches the container height
                  width: double.infinity,
                ),
              )
            : const SizedBox.shrink();
      case 'audio':
        return firstItem.audioPath != null
            ? SizedBox(
                height: 80, // Matches the container height
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8), // Ensure rounded corners
                  child: Row(
                    children: [
                      Flexible(
                        child: AudioCard(
                          audioPath: firstItem.audioPath!,
                          onDelete: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink();

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JournalDetailPage(
                    emotion: emotion,
                    date: date,
                    time: time,
                    title: title,
                    journalItems: journalItems)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Emoji Circle
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: const Center(
                    child: Text(
                      "😊", // Placeholder emoji
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),

                const Spacer(),

                // Emotion Label
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    emotion,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            // Content without gradient overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 60, // Reduced height for preview
                child: _buildPreviewContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
