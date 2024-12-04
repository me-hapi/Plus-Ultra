import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:videosdk/videosdk.dart';

class APIService {
  Future<String> createRoomId() async {
    try {
      String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI3ODRiMzQ3NC1jMjJhLTRmZGItYTJkYS03ODg3OWVlNjhhZDgiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTczMjk2NzU1MCwiZXhwIjoxNzQ4NTE5NTUwfQ.qPnbGJaff3HY4RE58iHUwC2LLTyiW3p1dEi9MW_Nixo";
      final http.Response httpResponse = await http.post(
        Uri.parse("https://api.videosdk.live/v2/rooms"),
        headers: {'Authorization': token},
      );

      final roomId = json.decode(httpResponse.body)['roomId'];
      return roomId;
    } catch (e) {
      throw Exception('Failed to create room ID: $e');
    }
  }

  Future<Room> createMeetingRoom(String roomId, String uid) async {
    try {
      String token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI3ODRiMzQ3NC1jMjJhLTRmZGItYTJkYS03ODg3OWVlNjhhZDgiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTczMjYzNDEzMSwiZXhwIjoxNzMzMjM4OTMxfQ.kh-3NzHL9mPCCLvD0zjeoHloI19Mdtf2pf7tgqPW1Sw";

      Room room = VideoSDK.createRoom(
        roomId: roomId,
        token: token,
        displayName: "Anonymous",
        micEnabled: false,
        camEnabled: false,
        participantId: uid, // optional, default: SDK will generate
      );

      return room;
    } catch (e) {
      throw Exception('Failed to create meeting room: $e');
    }
  }
}
