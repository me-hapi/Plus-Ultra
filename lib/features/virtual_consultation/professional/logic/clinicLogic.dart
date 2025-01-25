import 'dart:convert';
import 'package:http/http.dart' as http;

class ClinicLogic {
  Future<List<dynamic>> geocode(String address) async {
    try {
      String api_key = '672e07ea23e47657998620siu5f26db';
      String formattedAddress = "$address PH";

      String encodedAddress = Uri.encodeComponent(formattedAddress);

      // API call
      final String apiUrl =
          'https://geocode.maps.co/search?q=$encodedAddress&api_key=$api_key';
      final response = await http.get(Uri.parse(apiUrl));

      // Handle response

      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to geocode address. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while geocoding: $e');
    }
  }
}
