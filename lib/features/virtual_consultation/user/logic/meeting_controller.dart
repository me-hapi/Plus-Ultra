import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MeetingController extends StatelessWidget {
  final bool micEnabled;
  final bool camEnabled;
  final VoidCallback onToggleMicButtonPressed;
  final VoidCallback onToggleCameraButtonPressed;
  final VoidCallback onLeaveButtonPressed;

  const MeetingController({
    Key? key,
    required this.micEnabled,
    required this.camEnabled,
    required this.onToggleMicButtonPressed,
    required this.onToggleCameraButtonPressed,
    required this.onLeaveButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: mindfulBrown['Brown80'],
          child: IconButton(
            icon: Icon(
              micEnabled ? LucideIcons.mic : LucideIcons.micOff,
              color: Colors.white,
            ),
            onPressed: onToggleMicButtonPressed,
            tooltip: 'Mute/Unmute',
          ),
        ),
        CircleAvatar(
          radius: 40,
          backgroundColor: empathyOrange['Orange50'],
          child: IconButton(
            icon: const Icon(
              LucideIcons.phoneOff,
              color: Colors.white,
              size: 30,
            ),
            onPressed: onLeaveButtonPressed,
            tooltip: 'Leave Call',
          ),
        ),
        CircleAvatar(
          radius: 30,
          backgroundColor: mindfulBrown['Brown80'],
          child: IconButton(
            icon: Icon(
              camEnabled ? LucideIcons.video : LucideIcons.videoOff,
              color: Colors.white,
            ),
            onPressed: onToggleCameraButtonPressed,
            tooltip: 'Video/No Video',
          ),
        ),
      ],
    );
  }
}
