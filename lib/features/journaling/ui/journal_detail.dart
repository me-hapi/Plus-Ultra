import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/journaling/data/supabse_db.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';
import 'package:lingap/features/journaling/ui/audio_card.dart';
import 'package:intl/intl.dart';
import 'package:lingap/features/journaling/ui/journal_widgets/delete_journal.dart';

class JournalDetailPage extends StatefulWidget {
  final int id;
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
    required this.id,
  }) : super(key: key);

  @override
  _JournalDetailPageState createState() => _JournalDetailPageState();
}

class _JournalDetailPageState extends State<JournalDetailPage> {
  final SupabaseDB supabase = SupabaseDB(client);
  late String formattedDate;
  late String formattedTime;

  @override
  void initState() {
    super.initState();
    print("ID: ${widget.id}");
    formattedDate = _formatDate(widget.date);
    formattedTime = _formatTime(widget.time);
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('MMM d, yyyy').format(parsedDate);
  }

  String _formatTime(String time) {
    final parsedTime = DateFormat('HH:mm').parse(time);
    return DateFormat('h:mm a').format(parsedTime);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mindfulBrown['Brown10'],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Journal Detail',
            style: TextStyle(
                color: mindfulBrown['Brown80'],
                fontSize: 24,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              color: getAsset(widget.emotion)['bg'],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              widget.emotion,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: getAsset(widget.emotion)['font'],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRoundedRectangle(context, formattedDate),
                              _buildRoundedRectangle(context, formattedTime),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.title,
                                  style: TextStyle(
                                      color: mindfulBrown['Brown80'],
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: optimisticGray['Gray30'],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...widget.journalItems.map((item) {
                                switch (item.type) {
                                  case 'text':
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(item.text ?? '',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    optimisticGray['Gray60'])),
                                      ),
                                    );
                                  case 'image':
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: item.imageFile != null
                                            ? Image.file(item.imageFile!,
                                                fit: BoxFit.cover)
                                            : const SizedBox.shrink(),
                                      ),
                                    );
                                  case 'audio':
                                    return Align(
                                      alignment: Alignment.centerLeft,
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
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 80,
                    child: GestureDetector(
                        onTap: () {
                          showDeleteJournalDialog(context, () async {
                            await supabase.deleteJournal(widget.id);
                          });
                        },
                        child: Image.asset('assets/journal/remove.png')),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Positioned(
                top: -50,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: mindfulBrown['Brown10']!, // Border color
                        width: 10.0, // Border thickness
                      ),
                    ),
                    child: Image.asset(
                      getAsset(widget.emotion)['asset'],
                      fit: BoxFit.contain, // Adjust as needed
                    ),
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
      child: Text(text,
          style: TextStyle(color: optimisticGray['Gray60'], fontSize: 14)),
    );
  }
}
