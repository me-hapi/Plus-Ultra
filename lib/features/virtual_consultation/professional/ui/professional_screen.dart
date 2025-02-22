import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/logic/meeting_controller.dart';
import 'package:lingap/features/virtual_consultation/user/ui/participant_tile.dart';
// import 'package:lingap/features/peer_connect/logic/meeting_controller.dart';
// import 'package:lingap/features/peer_connect/ui/participant_tile.dart';

import 'package:videosdk/videosdk.dart';

class ProfessionalScreen extends StatefulWidget {
  final String roomId;
  final String userName;
  final int appointmentId;

  const ProfessionalScreen(
      {super.key,
      required this.roomId,
      required this.userName,
      required this.appointmentId});

  @override
  State<ProfessionalScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<ProfessionalScreen> {
  late Room room;
  var micEnabled = true;
  var camEnabled = true;
  Map<String, Participant> participants = {};
  List<VideoDeviceInfo>? cameras = [];

  @override
  void initState() {
    fetchCameras();
    // Create room
    room = VideoSDK.createRoom(
      roomId: widget.roomId,
      token: token,
      displayName: widget.userName, // Set actual user name
      micEnabled: micEnabled,
      camEnabled: camEnabled,
      defaultCameraIndex: 1,
    );

    setMeetingEventListener();
    room.join();
    super.initState();
  }

  void fetchCameras() async {
    cameras = await VideoSDK.getVideoDevices();
    setState(() {});
  }

  void setMeetingEventListener() {
    room.on(Events.roomJoined, () {
      setState(() {
        participants[room.localParticipant.id] = room.localParticipant;
      });
    });

    room.on(Events.participantJoined, (Participant participant) {
      setState(() {
        participants[participant.id] = participant;
      });
    });

    room.on(Events.participantLeft, (String participantId) {
      if (participants.containsKey(participantId)) {
        setState(() {
          participants.remove(participantId);
        });
      }
    });

    room.on(Events.roomLeft, () {
      participants.clear();
      context.push('/finish', extra: widget.appointmentId);
    });
  }

  Future<bool> _onWillPop() async {
    room.leave();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<Participant> sortedParticipants = participants.values.toList();

    // Ensure there's at least one participant
    Participant? fullScreenParticipant =
        sortedParticipants.isNotEmpty ? sortedParticipants.first : null;
    Participant? smallScreenParticipant =
        sortedParticipants.length > 1 ? sortedParticipants[1] : null;

    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mindfulBrown['Brown80'],
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            widget.userName,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            // Full-screen participant
            Positioned.fill(
              child: fullScreenParticipant != null
                  ? ParticipantTile(
                      key: Key(fullScreenParticipant.id),
                      participant: fullScreenParticipant,
                    )
                  : Container(color: Colors.black), // Fallback background
            ),

            // Small preview for the second participant
            if (smallScreenParticipant != null)
              Positioned(
                top: 16,
                right: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ParticipantTile(
                      key: Key(smallScreenParticipant.id),
                      participant: smallScreenParticipant,
                    ),
                  ),
                ),
              ),

            // Meeting controls at the bottom
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MeetingController(
                  micEnabled: micEnabled,
                  camEnabled: camEnabled,
                  onToggleMicButtonPressed: () {
                    setState(() {
                      micEnabled ? room.muteMic() : room.unmuteMic();
                      micEnabled = !micEnabled;
                    });
                  },
                  onToggleCameraButtonPressed: () {
                    setState(() {
                      camEnabled ? room.disableCam() : room.enableCam();
                      camEnabled = !camEnabled;
                    });
                  },
                  onLeaveButtonPressed: () => room.leave(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
