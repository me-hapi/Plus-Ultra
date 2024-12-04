import 'package:flutter/material.dart';
import 'package:lingap/features/peer_communication/test/api_call.dart';
import 'package:lingap/features/peer_communication/test/meeting_screen.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _meetingIdController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed to avoid memory leaks.
    _meetingIdController.dispose();
    super.dispose();
  }

  void onCreateButtonPressed(BuildContext context) async {
    // call api to create meeting and then navigate to MeetingScreen with meetingId, token
    await createMeeting().then((meetingId) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MeetingScreen(
            meetingId: meetingId,
            token: token,
          ),
        ),
      );
    });
  }

  void onJoinButtonPressed(BuildContext context) {
    String meetingId = _meetingIdController.text;
    var re = RegExp("\\w{4}\\-\\w{4}\\-\\w{4}");
    // check meeting id is not null or invalid
    // if meeting id is valid then navigate to MeetingScreen with meetingId, token
    if (meetingId.isNotEmpty && re.hasMatch(meetingId)) {
      _meetingIdController.clear();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MeetingScreen(
            meetingId: meetingId,
            token: token,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid meeting id"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VideoSDK QuickStart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => onCreateButtonPressed(context),
              child: const Text('Create Meeting'),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Meeting Id',
                  border: OutlineInputBorder(),
                ),
                controller: _meetingIdController,
              ),
            ),
            ElevatedButton(
              onPressed: () => onJoinButtonPressed(context),
              child: const Text('Join Meeting'),
            ),
          ],
        ),
      ),
    );
  }
}
