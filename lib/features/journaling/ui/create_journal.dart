import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/loading_screen.dart';
import 'package:lingap/features/journaling/logic/create_logic.dart';
import 'package:lingap/features/journaling/logic/insert_audio.dart';
import 'package:lingap/features/journaling/logic/insert_image.dart';
import 'package:lingap/features/journaling/ui/audio_card.dart';
import 'package:lingap/features/journaling/ui/journal_detail.dart';

class CreateJournalPage extends StatefulWidget {
  @override
  _CreateJournalPageState createState() => _CreateJournalPageState();
}

class _CreateJournalPageState extends State<CreateJournalPage> {
  late CreateJournalLogic _logic;
  String mergedAudio = '';

  @override
  void initState() {
    super.initState();
    _logic = CreateJournalLogic();
    _logic.addTextField(); // Initialize with the first text field
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'New Journal',
          style: TextStyle(fontSize: 22, color: mindfulBrown['Brown80']),
        ),
        centerTitle: true, // Centers the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mergedAudio != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AudioCard(
                        audioPath: mergedAudio,
                        onDelete: () => setState(() {
                          _logic.removeAudio(mergedAudio);
                        }),
                      ),
                    ),
                  // Title Field
                  TextField(
                    controller: _logic.titleController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Untitled',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    style: TextStyle(
                        color: mindfulBrown['Brown80'],
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                  // Render Journal Items Dynamically
                  ..._logic.journalItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    if (item.type == 'text') {
                      return GestureDetector(
                        onTap: () {
                          // Ensure the TextField is activated when tapped
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: TextField(
                          controller: _logic.textControllers[index],
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write your journal here...',
                            hintStyle:
                                TextStyle(color: optimisticGray['Gray60']),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          style: TextStyle(fontSize: 20),
                          onChanged: (value) => _logic.updateText(index, value),
                        ),
                      );
                    } else if (item.type == 'image') {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 200),
                          child: Image.file(
                            item.imageFile!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ));
                    } else if (item.type == 'audio') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: AudioCard(
                          audioPath: item.audioPath!,
                          onDelete: () => setState(() {
                            _logic.removeAudio(item.audioPath!);
                          }),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }).toList(),

                  // Tap Area to Add a New Text Field
                  if (_logic.shouldShowTapPrompt())
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _logic.addTextField();
                        });
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tap here to continue writing...',
                          style: TextStyle(
                              color: optimisticGray['Gray60'], fontSize: 20),
                        ),
                      ),
                    ),

                  if (_logic.journalItems.isNotEmpty) SizedBox(height: 500),
                ],
              ),
            ),
          ),
          // Footer Actions
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InsertAudio(onAudioInserted: (audioPath) {
                        setState(() {
                          _logic.addAudio(audioPath);
                        });
                      }),
                      SizedBox(width: 16),
                      InsertImage(onImageInserted: (image) {
                        setState(() {
                          _logic.insertImage(image);
                        });
                      }),
                    ],
                  ),

                  SizedBox(
                    height: 60,
                    child: GestureDetector(
                      onTap: () async {
                        // Show loading screen
                        LoadingScreen.show(context);

                        // Call the saveJournal function
                        String emotion = await _logic.saveJournal();
                        LoadingScreen.hide(context);

                        context.go('/journal-success', extra: {
                          'emotion': emotion,
                          'date': DateTime.now().toString(),
                          'time': DateTime.now()
                              .toLocal()
                              .toIso8601String()
                              .split('T')[1]
                              .substring(0, 5),
                          'title': _logic.titleController.text,
                          'journalItems': _logic.journalItems
                        });
                      },
                      child: Image.asset('assets/journal/save.png'),
                    ),
                  ),

                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Save journal logic
                  //     final title = _logic.titleController.text;
                  //     final content = _logic.journalItems
                  //         .where((item) => item.type == 'text')
                  //         .map((item) => item.text ?? '')
                  //         .join('\n');
                  //     // Add save logic here
                  //     print('Title: $title');
                  //     print('Content: $content');

                  //     _logic.saveJournal();

                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => JournalDetailPage(
                  //                   emotion: 'Neutral',
                  //                   date: DateTime.now().toString(),
                  //                   time: DateTime.now()
                  //                       .toLocal()
                  //                       .toIso8601String()
                  //                       .split('T')[1]
                  //                       .substring(
                  //                           0, 5), // Converts to HH:mm format
                  //                   title: title,
                  //                   journalItems: _logic.journalItems,
                  //                 )));
                  //   },
                  //   child: Text('Save'),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
