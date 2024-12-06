import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lingap/features/peer_connect/logic/meeting_controller.dart';
import 'package:lingap/features/peer_connect/ui/chat_screen.dart';
import 'package:lingap/features/peer_connect/ui/participant_tile.dart';
import 'package:videosdk/videosdk.dart';

class MeetingScreen extends StatefulWidget {
  final String roomId;
  final String token;

  const MeetingScreen({super.key, required this.roomId, required this.token});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
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
        token: widget.token,
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
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ChatScreen(roomId: widget.roomId)),
      );
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
          title: const Text('VideoSDK QuickStart'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(widget.roomId),
              //render all participant
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 300,
                    ),
                    itemBuilder: (context, index) {
                      return ParticipantTile(
                          key: Key(participants.values.elementAt(index).id),
                          participant: participants.values.elementAt(index));
                    },
                    itemCount: participants.length,
                  ),
                ),
              ),
              MeetingController(
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
            ],
          ),
        ),
      ),
    );
  }
}
