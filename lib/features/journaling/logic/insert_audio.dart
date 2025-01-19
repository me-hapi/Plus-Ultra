import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'dart:io';

class InsertAudio extends StatefulWidget {
  final Function(String) onAudioInserted;

  InsertAudio({required this.onAudioInserted});

  @override
  _InsertAudioState createState() => _InsertAudioState();
}

class _InsertAudioState extends State<InsertAudio> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;

  Future<String> _getAudioPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> _startRecording() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        _audioPath = await _getAudioPath();
        final recordConfig = RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        );

        if (await _recorder.hasPermission()) {
          await _recorder.start(
            recordConfig,
            path: _audioPath!,
          );
          setState(() {
            _isRecording = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission is required')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission is required')),
        );
      }
    } catch (e, stackTrace) {
      print('Error in _startRecording: $e\n$stackTrace');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _recorder.stop();
      setState(() {
        _isRecording = false;
      });
    } catch (e, stackTrace) {
      print('Error in _stopRecording: $e\n$stackTrace');
    }
  }

  void _saveRecording() {
    if (_audioPath != null) {
      widget.onAudioInserted(_audioPath!);
      Navigator.pop(context);
    }
  }

  void _showAudioOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxHeight: 200,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 5,
                      decoration: BoxDecoration(
                        color: optimisticGray['Gray50'],
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      _isRecording ? 'Recording...' : 'Tap to Record',
                      style: TextStyle(
                          color: mindfulBrown['Brown80'],
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                          onTap: () async {
                            try {
                              if (_isRecording) {
                                await _stopRecording();
                                setModalState(() {
                                  _isRecording = false;
                                });
                                setState(() {
                                  _isRecording = false;
                                });
                                _saveRecording();
                              } else {
                                await _startRecording();
                                setModalState(() {
                                  _isRecording = true;
                                });
                                setState(() {
                                  _isRecording = true;
                                });
                              }
                            } catch (e, stackTrace) {
                              print(
                                  'Error in GestureDetector: $e\n$stackTrace');
                            }
                          },
                          child: SizedBox(
                            height: 50,
                            child: _isRecording
                                ? Image.asset('assets/journal/stop.png')
                                : Image.asset('assets/journal/record.png'),
                          )
                          // CircleAvatar(
                          //   radius: 40,
                          //   backgroundColor:
                          //       _isRecording ? Colors.red : Colors.green,
                          //   child: Icon(
                          //     _isRecording ? Icons.stop : Icons.mic,
                          //     color: Colors.white,
                          //     size: 30,
                          //   ),
                          // ),
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(), // Ensures the button is circular
      backgroundColor: Colors.white, // Sets the background color to white
      elevation: 0, // No shadow
      heroTag: 'voice_button',
      onPressed: () => _showAudioOptions(context),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Image.asset('assets/journal/mic.png'),
      ), // Your microphone icon
    );
  }
}
