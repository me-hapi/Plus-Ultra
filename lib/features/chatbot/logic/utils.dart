import 'dart:convert';

class Utils {
  Map<String, dynamic> extractRecommendation(String rawResponse) {
    try {
      print(rawResponse);
      String cleanedJson = rawResponse
          .trim()
          .replaceAll("```json", "") // Remove markdown-style json block markers
          .replaceAll("```", ""); // Remove closing backticks if present

      // Parse the cleaned JSON string
      Map<String, dynamic> data = jsonDecode(cleanedJson);

      // Extract the required fields
      return data;
    } catch (e) {
      print("Error parsing JSON: $e");
      return {};
    }
  }

  String _extractMatch(RegExp regex, String text) {
    Match? match = regex.firstMatch(text);
    return match != null ? match.group(1)?.trim() ?? "" : "";
  }
}
