import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lingap/features/journaling/logic/create_logic.dart';
import 'package:lingap/features/journaling/logic/insert_audio.dart';
import 'package:lingap/features/journaling/logic/insert_image.dart';
import 'package:lingap/features/journaling/ui/audio_card.dart';

class CreateJournalPage extends StatefulWidget {
  @override
  _CreateJournalPageState createState() => _CreateJournalPageState();
}

class _CreateJournalPageState extends State<CreateJournalPage> {
  late CreateJournalLogic _logic;

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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80), // Space for header
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
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
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          style: TextStyle(fontSize: 16),
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
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),

                  if (_logic.journalItems.isNotEmpty) SizedBox(height: 500),
                ],
              ),
            ),
          ),
          // Header and Actions
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'New Journal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 48), // Placeholder for balancing layout
              ],
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
                  ElevatedButton(
                    onPressed: () {
                      // Save journal logic
                      final title = _logic.titleController.text;
                      final content = _logic.journalItems
                          .where((item) => item.type == 'text')
                          .map((item) => item.text ?? '')
                          .join('\n');
                      // Add save logic here
                      print('Title: $title');
                      print('Content: $content');
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
