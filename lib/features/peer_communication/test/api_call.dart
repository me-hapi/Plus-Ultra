import 'dart:convert';
import 'package:http/http.dart' as http;

//Auth token we will use to generate a meeting and connect to it
String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI3ODRiMzQ3NC1jMjJhLTRmZGItYTJkYS03ODg3OWVlNjhhZDgiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTczMzI5NDg5OSwiZXhwIjoxNzQxMDcwODk5fQ.KSL8AgfmBkLs1pT6WaZzYLQYWijgtopuNPErEU-OE3U";

// API call to create meeting
Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );
print(httpResponse.body);
//Destructuring the roomId from the response
  return json.decode(httpResponse.body)['roomId'];
}