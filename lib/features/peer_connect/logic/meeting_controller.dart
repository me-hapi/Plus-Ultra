import 'package:flutter/material.dart';

class MeetingController extends StatelessWidget {
  final void Function() onToggleMicButtonPressed;
  final void Function() onToggleCameraButtonPressed;
  final void Function() onLeaveButtonPressed;
  final void Function() onSwitchCameraButtonPressed;

  const MeetingController({
    Key? key,
    required this.onToggleMicButtonPressed,
    required this.onToggleCameraButtonPressed,
    required this.onLeaveButtonPressed,
    required this.onSwitchCameraButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.call_end, color: Colors.red),
          onPressed: onLeaveButtonPressed,
          tooltip: 'Leave Call',
        ),
        IconButton(
          icon: const Icon(Icons.mic_off),
          onPressed: onToggleMicButtonPressed,
          tooltip: 'Mute/Unmute',
        ),
        IconButton(
          icon: const Icon(Icons.switch_camera),
          onPressed: onSwitchCameraButtonPressed,
          tooltip: 'Switch Front/Rear Camera',
        ),
        IconButton(
          icon: const Icon(Icons.videocam_off),
          onPressed: onToggleCameraButtonPressed,
          tooltip: 'Video/No Video',
        ),
      ],
    );
  }
}
