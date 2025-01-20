import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:lingap/core/const/colors.dart';

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
  late just_audio.AudioPlayer _audioPlayer;
  late PlayerController _waveformController;
  bool _isPlaying = false;
  bool _isDisposed = false;
  late final StreamSubscription<just_audio.PlayerState>
      _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = just_audio.AudioPlayer();
    _waveformController = PlayerController();

    _waveformController.preparePlayer(
      path: widget.audioPath,
      shouldExtractWaveform: true,
    );

    _playerStateSubscription =
        _audioPlayer.playerStateStream.listen((state) async {
      if (mounted) {
        setState(() {
          if (state.processingState == just_audio.ProcessingState.completed) {
            _isPlaying = false;
            _audioPlayer.stop();
            _waveformController.seekTo(0);
          } else if (state.playing) {
            _isPlaying = true;
          } else {
            _isPlaying = false;
          }
        });

        // Force refresh by rebuilding the waveform widget
        if (state.processingState == just_audio.ProcessingState.completed) {
          // Ensure the widget rebuilds
          await Future.delayed(
              Duration(milliseconds: 100)); // Allow time for updates
          setState(() {});
        }
      }
    });

    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        _waveformController.seekTo(position.inMilliseconds);
      }
    });
  }

  @override
  void dispose() {
    if (!_isDisposed) {
      try {
        if (_audioPlayer.playing) {
          _audioPlayer.stop();
        }
        _playerStateSubscription.cancel();
        _audioPlayer.dispose();
        _waveformController.dispose();
      } catch (e) {
        print('Error during dispose: $e');
      }
      _isDisposed = true;
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
    if (!mounted) return;

    try {
      if (!File(widget.audioPath).existsSync()) {
        throw Exception(
            "Audio file does not exist at path: ${widget.audioPath}");
      }

      if (_isPlaying) {
        await _audioPlayer.pause();
        print('Playback paused');
      } else {
        if (_audioPlayer.processingState ==
            just_audio.ProcessingState.completed) {
          await _audioPlayer.seek(Duration.zero);
          _waveformController.seekTo(0);
        }
        await _audioPlayer.setFilePath(widget.audioPath);
        await _audioPlayer.play();
        print('Playback started');
      }
    } catch (e) {
      if (mounted) {
        print("Error playing audio: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error playing audio: $e")),
        );
      }
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Audio waveform widget
              Expanded(
                child: AudioFileWaveforms(
                  waveformType: WaveformType.fitWidth,
                  playerController: _waveformController,
                  size: Size(MediaQuery.of(context).size.width * 0.7, 40),
                  playerWaveStyle: PlayerWaveStyle(
                      fixedWaveColor: mindfulBrown['Brown60']!,
                      seekLineColor: mindfulBrown['Brown80']!,
                      showSeekLine: true),
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
                    padding: _isPlaying
                        ? const EdgeInsets.all(2)
                        : const EdgeInsets.all(5),
                    child: _isPlaying
                        ? Image.asset('assets/journal/pause.png')
                        : Image.asset('assets/journal/play.png'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
