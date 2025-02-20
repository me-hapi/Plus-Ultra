import 'package:flutter/material.dart';
import 'dart:async';

import 'package:lingap/core/const/colors.dart';

class MindfulPlayer extends StatefulWidget {
  final String songName;
  final int minutes;
  final int seconds;

  const MindfulPlayer({
    Key? key,
    required this.songName,
    required this.minutes,
    required this.seconds,
  }) : super(key: key);

  @override
  _MindfulPlayerState createState() => _MindfulPlayerState();
}

class _MindfulPlayerState extends State<MindfulPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;
  double _progress = 0.0;
  bool _isPlaying = false;
  late int totalTimeInSeconds;

  @override
  void initState() {
    super.initState();
    totalTimeInSeconds = (widget.minutes * 60) + widget.seconds;

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _startProgress();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _startProgress();
    } else {
      _timer?.cancel();
    }
  }

  void _startProgress() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _progress += 1 / totalTimeInSeconds;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _isPlaying = false;
          _timer?.cancel();
        }
      });
    });
  }

  String _formatTime(double progress) {
    int elapsedSeconds = (progress * totalTimeInSeconds).toInt();
    int minutes = elapsedSeconds ~/ 60;
    int seconds = elapsedSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          bool expanding = _controller.status == AnimationStatus.forward;
          Color? backgroundColor =
              expanding ? empathyOrange['Orange40'] : serenityGreen['Green50'];

          List<Color?> rippleColors = expanding
              ? [
                  empathyOrange['Orange50'],
                  empathyOrange['Orange60'],
                  empathyOrange['Orange70'],
                  empathyOrange['Orange80'],
                ]
              : [
                  serenityGreen['Green60'],
                  serenityGreen['Green70'],
                  serenityGreen['Green80'],
                  serenityGreen['Green90'],
                ];

          return Container(
            color: backgroundColor,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: List.generate(rippleColors.length, (index) {
                    return Container(
                      width: 300 * _animation.value - (index * 50),
                      height: 300 * _animation.value - (index * 50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: rippleColors[index],
                      ),
                    );
                  }),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      widget.songName,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatTime(_progress),
                                  style: const TextStyle(color: Colors.white)),
                              Text(_formatTime(1.0),
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                          Slider(
                            value: _progress,
                            min: 0,
                            max: 1,
                            onChanged: (value) {},
                            activeColor: Colors.white,
                            inactiveColor: Colors.white30,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10,
                              color: Colors.white, size: 36),
                          onPressed: () {
                            setState(() {
                              _progress = (_progress - 10 / totalTimeInSeconds)
                                  .clamp(0.0, 1.0);
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 48),
                          onPressed: _togglePlayPause,
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10,
                              color: Colors.white, size: 36),
                          onPressed: () {
                            setState(() {
                              _progress = (_progress + 10 / totalTimeInSeconds)
                                  .clamp(0.0, 1.0);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
