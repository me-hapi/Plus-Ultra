import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioCard extends StatefulWidget {
  final String audioPath;
  final Function onDelete;

  const AudioCard({
    Key? key,
    required this.audioPath,
    required this.onDelete,
  }) : super(key: key);

  @override
  _AudioCardState createState() => _AudioCardState();
}

class _AudioCardState extends State<AudioCard> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Store the subscription
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
        } else if (state.playing) {
          _isPlaying = true;
        } else {
          _isPlaying = false;
        }
      });
    });
  }

  @override
  void dispose() {
    try {
      if (_audioPlayer.playing) {
        _audioPlayer.stop(); // Stop playback if ongoing
      }
      _playerStateSubscription.cancel(); // Cancel stream subscription
      _audioPlayer.dispose(); // Release resources
    } catch (e) {
      print('Error during dispose: $e');
    }
    super.dispose();
  }

  void _togglePlayPause() async {
    try {
      if (!File(widget.audioPath).existsSync()) {
        throw Exception(
            "Audio file does not exist at path: ${widget.audioPath}");
      }

      if (_isPlaying) {
        await _audioPlayer.pause(); // Pause playback
        print('Playback paused');
      } else {
        if (_audioPlayer.processingState == ProcessingState.completed) {
          // Reset playback to the start if completed
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.setFilePath(widget.audioPath); // Load the file
        await _audioPlayer.play(); // Start playback
        print('Playback started');
      }
    } catch (e) {
      print("Error playing audio: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error playing audio: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.audioPath),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) => widget.onDelete(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text("Audio Wave"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 36,
                color: Colors.blue,
              ),
              onPressed: _togglePlayPause,
            ),
          ],
        ),
      ),
    );
  }
}
