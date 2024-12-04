import 'package:flutter/material.dart';

class MeetingControls extends StatelessWidget {
  final void Function() onToggleMicButtonPressed;
  final void Function() onToggleCameraButtonPressed;
  final void Function() onLeaveButtonPressed;

  const MeetingControls({
    super.key,
    required this.onToggleMicButtonPressed,
    required this.onToggleCameraButtonPressed,
    required this.onLeaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: onLeaveButtonPressed,
          icon: const Icon(Icons.call_end),
          color: Colors.red,
          tooltip: 'Leave Meeting',
        ),
        IconButton(
          onPressed: onToggleMicButtonPressed,
          icon: const Icon(Icons.mic),
          tooltip: 'Toggle Microphone',
        ),
        IconButton(
          onPressed: onToggleCameraButtonPressed,
          icon: const Icon(Icons.videocam),
          tooltip: 'Toggle Camera',
        ),
      ],
    );
  }
}
