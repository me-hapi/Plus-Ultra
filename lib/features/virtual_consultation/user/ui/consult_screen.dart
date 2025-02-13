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

class ConsultScreen extends StatefulWidget {
  final String roomId;

  const ConsultScreen({super.key, required this.roomId});

  @override
  State<ConsultScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<ConsultScreen> {
  late Room room;
  var micEnabled = true;
  var camEnabled = true;
  Map<String, Participant> participants = {};
  List<VideoDeviceInfo>? cameras = [];

  @override
  void initState() {
    fetchCameras();
    // create room
    room = VideoSDK.createRoom(
        roomId: widget.roomId,
        token: token,
        displayName: "John Doe",
        micEnabled: micEnabled,
        camEnabled: camEnabled,
        defaultCameraIndex: 1);

    setMeetingEventListener();

    // Join room
    room.join();

    super.initState();
  }

  void fetchCameras() async {
    cameras = await VideoSDK.getVideoDevices();
    print('CAMERAS $cameras');
    setState(() {});
  }

  // listening to meeting events
  void setMeetingEventListener() {
    room.on(Events.roomJoined, () {
      setState(() {
        participants.putIfAbsent(
            room.localParticipant.id, () => room.localParticipant);
      });
    });

    room.on(
      Events.participantJoined,
      (Participant participant) {
        setState(
          () => participants.putIfAbsent(participant.id, () => participant),
        );
      },
    );

    room.on(Events.participantLeft, (String participantId) {
      if (participants.containsKey(participantId)) {
        setState(
          () => participants.remove(participantId),
        );
      }
    });

    room.on(Events.roomLeft, () {
      participants.clear();
    });
  }

  // onbackButton pressed leave the room
  Future<bool> _onWillPop() async {
    room.leave();
    return true;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mindfulBrown['Brown80'],
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Anonymous',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            // Full-screen participant (index 1)
            Positioned.fill(
              child: participants.length > 1
                  ? ParticipantTile(
                      key: Key(participants.values.elementAt(1).id),
                      participant: participants.values.elementAt(1),
                    )
                  : Container(color: Colors.black), // Fallback background
            ),

            // Small participant tile (index 0) at the top-right corner
            if (participants.isNotEmpty)
              Positioned(
                top: 16,
                right: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 140,
                    height: 180,
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
                      key: Key(participants.values.elementAt(0).id),
                      participant: participants.values.elementAt(0),
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
                  onSwitchCameraButtonPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
