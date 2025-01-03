import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';
import 'package:lingap/features/journaling/ui/audio_card.dart';
import 'package:intl/intl.dart';

class JournalDetailPage extends StatelessWidget {
  final String emotion;
  final String date;
  final String time;
  final String title;
  final List<JournalItem> journalItems;

  const JournalDetailPage({
    Key? key,
    required this.emotion,
    required this.date,
    required this.time,
    required this.title,
    required this.journalItems,
  }) : super(key: key);

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('MMM d, yyyy').format(parsedDate);
  }

  String _formatTime(String time) {
    final parsedTime = DateFormat('HH:mm').parse(time);
    return DateFormat('h:mm a').format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Journal Detail'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.green,
                            child: const Icon(
                              Icons.sentiment_satisfied,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          Positioned(
                            bottom: -50,
                            child: Text(
                              emotion,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildRoundedRectangle(context, _formatDate(date)),
                          _buildRoundedRectangle(context, _formatTime(time)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Ensure items align to the left
                        children: [
                          ...journalItems.map((item) {
                            switch (item.type) {
                              case 'text':
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Align(
                                    alignment: Alignment
                                        .centerLeft, // Force alignment to the left
                                    child: Text(
                                      item.text ?? '',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                );
                              case 'image':
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Align(
                                    alignment: Alignment
                                        .centerLeft, // Force alignment to the left
                                    child: item.imageFile != null
                                        ? Image.file(item.imageFile!,
                                            fit: BoxFit.cover)
                                        : const SizedBox.shrink(),
                                  ),
                                );
                              case 'audio':
                                return Align(
                                  alignment: Alignment
                                      .centerLeft, // Force alignment to the left
                                  child: AudioCard(
                                    audioPath: item.audioPath!,
                                    onDelete: () {
                                      // Handle deletion if required
                                    },
                                  ),
                                );
                              default:
                                return const SizedBox.shrink();
                            }
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedRectangle(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.black87),
      ),
    );
  }
}
