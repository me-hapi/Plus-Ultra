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

    // Listen for player state changes
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
        _audioPlayer.stop();
      }
      _playerStateSubscription.cancel();
      _audioPlayer.dispose();
    } catch (e) {
      print('Error during dispose: $e');
    }
    super.dispose();
  }

  void _handleDelete() async {
    try {
      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }
      await _audioPlayer.dispose();
      widget.onDelete();
    } catch (e) {
      print('Error during deletion: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting audio: $e")),
      );
    }
  }

  void _togglePlayPause() async {
    try {
      if (!File(widget.audioPath).existsSync()) {
        throw Exception(
            "Audio file does not exist at path: ${widget.audioPath}");
      }

      if (_isPlaying) {
        await _audioPlayer.pause();
        print('Playback paused');
      } else {
        if (_audioPlayer.processingState == ProcessingState.completed) {
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.setFilePath(widget.audioPath);
        await _audioPlayer.play();
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
      onDismissed: (direction) => _handleDelete(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Flexible widget for the "Audio Wave" placeholder
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Audio Wave",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),

              // Spacing between elements
              const SizedBox(width: 8),

              // Play/Pause button
              SizedBox(
                  height: 30,
                  child: GestureDetector(
                      onTap: _togglePlayPause,
                      child: Padding(
                        padding:
                            _isPlaying ? EdgeInsets.all(2) : EdgeInsets.all(5),
                        child: _isPlaying
                            ? Image.asset('assets/journal/pause.png')
                            : Image.asset('assets/journal/play.png'),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
