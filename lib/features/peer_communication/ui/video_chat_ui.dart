import 'package:flutter/material.dart';
import 'package:lingap/features/peer_communication/test/participant_tile.dart'; // Import ParticipantTile
import 'package:lingap/features/peer_communication/test/meeting_control.dart'; // Import MeetingControls
import 'package:videosdk/videosdk.dart';

class VideoChatUI extends StatefulWidget {
  final Room room;
  final Map<String, Participant> participants;

  const VideoChatUI({Key? key, required this.room, required this.participants}) : super(key: key);

  @override
  _VideoChatUIState createState() => _VideoChatUIState();
}

class _VideoChatUIState extends State<VideoChatUI> {
  bool micEnabled = true;
  bool camEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end),
            onPressed: () {
              widget.room.leave(); // Leave the room when the call ends
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Video feed will go here
          GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 300,
            ),
            itemBuilder: (context, index) {
              final participant = widget.participants.values.elementAt(index);
              return ParticipantTile(
                key: Key(participant.id),
                participant: participant,
              );
            },
            itemCount: widget.participants.length,
          ),
          // Meeting Controls at the bottom
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: MeetingControls(
              onToggleMicButtonPressed: () {
                setState(() {
                  micEnabled ? widget.room.muteMic() : widget.room.unmuteMic();
                  micEnabled = !micEnabled;
                });
              },
              onToggleCameraButtonPressed: () {
                setState(() {
                  camEnabled ? widget.room.disableCam() : widget.room.enableCam();
                  camEnabled = !camEnabled;
                });
              },
              onLeaveButtonPressed: () {
                widget.room.leave();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
