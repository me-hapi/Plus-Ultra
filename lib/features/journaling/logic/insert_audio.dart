import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class InsertAudio extends StatefulWidget {
  final Function(String) onAudioInserted;

  InsertAudio({required this.onAudioInserted});

  @override
  _InsertAudioState createState() => _InsertAudioState();
}

class _InsertAudioState extends State<InsertAudio> {
  final RecorderController _recorderController = RecorderController();
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _recorderController.checkPermission();
  }

  @override
  void dispose() {
    _recorderController.dispose();
    super.dispose();
  }

  Future<String> _getAudioPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> _startRecording() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        _audioPath = await _getAudioPath();
        await _recorderController.record(
          path: _audioPath,
          androidEncoder: AndroidEncoder.aac,
          androidOutputFormat: AndroidOutputFormat.mpeg4,
          iosEncoder: IosEncoder.kAudioFormatMPEG4AAC,
        );
        setState(() {
          _isRecording = true;
        });
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
      if (_isRecording) {
        await _recorderController.stop();
        setState(() {
          _isRecording = false;
        });
        _saveRecording();
      }
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
                  maxHeight: 300,
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AudioWaveforms(
                      recorderController: _recorderController,
                      size: Size(MediaQuery.of(context).size.width, 100),
                      shouldCalculateScrolledPosition: false,
                      waveStyle: WaveStyle(
                        waveThickness: 5,
                        showMiddleLine: false,
                        waveColor: mindfulBrown['Brown60']!,
                        showDurationLabel: false,
                        durationStyle: TextStyle(color: Colors.black),
                      ),
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
                            print('Error in GestureDetector: $e\n$stackTrace');
                          }
                        },
                        child: Image.asset(
                          _isRecording
                              ? 'assets/journal/stop.png'
                              : 'assets/journal/record.png',
                        ),
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
      shape: const CircleBorder(),
      backgroundColor: Colors.white,
      elevation: 0,
      heroTag: 'voice_button',
      onPressed: () => _showAudioOptions(context),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset('assets/journal/mic.png'),
      ),
    );
  }
}
