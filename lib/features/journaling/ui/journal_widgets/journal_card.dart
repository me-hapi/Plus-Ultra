import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';
import 'package:lingap/features/journaling/ui/audio_card.dart';
import 'dart:io';
import 'package:lingap/features/journaling/ui/journal_detail.dart';

class JournalCard extends StatelessWidget {
  final int id;
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
    required this.id,
  }) : super(key: key);

  Map<String, dynamic> getAsset(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'cheerful':
        return {
          'font': serenityGreen['Green50'],
          'bg': serenityGreen['Green10'],
          'asset': 'assets/journal/cheerful_frame.png'
        };
      case 'happy':
        return {
          'font': zenYellow['Yellow50'],
          'bg': zenYellow['Yellow10'],
          'asset': 'assets/journal/happy_frame.png'
        };
      case 'neutral':
        return {
          'font': mindfulBrown['Brown60'],
          'bg': mindfulBrown['Brown10'],
          'asset': 'assets/journal/neutral_frame.png'
        };
      case 'sad':
        return {
          'font': empathyOrange['Orange60'],
          'bg': empathyOrange['Orange10'],
          'asset': 'assets/journal/sad_frame.png'
        };
      case 'awful':
        return {
          'font': kindPurple['Purple40'],
          'bg': kindPurple['Purple10'],
          'asset': 'assets/journal/awful_frame.png'
        };
      default:
        return {
          'font': mindfulBrown['Brown60'],
          'bg': mindfulBrown['Brown10'],
          'asset': 'assets/journal/neutral_frame.png'
        };
    }
  }

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
          style: TextStyle(color: optimisticGray['Gray60'], fontSize: 16),
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
                    id: id,
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
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 55,
                  child: Image.asset(getAsset(emotion)['asset']),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: getAsset(emotion)['bg'],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    emotion,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: getAsset(emotion)['font'],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: mindfulBrown['Brown80'],
              ),
            ),

            // Content without gradient overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 40, // Reduced height for preview
                child: _buildPreviewContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
