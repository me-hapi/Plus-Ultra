import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Embedder {
  final String apiKey =
      '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';
  final String apiUrl = 'https://integrate.api.nvidia.com/v1/embeddings';

  Future<Float64List?> createEmbedding(String text) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    var requestBody = jsonEncode({
      'model': 'baai/bge-m3',
      'input': text,
      'encoding_format': 'float',
      'truncate': 'NONE'
    });

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: utf8.encode(requestBody));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        
        List<dynamic> embeddingData = jsonResponse['data'][0]['embedding'];
        List<double> doubleEmbeddingData = embeddingData.cast<num>().map((e) => e.toDouble()).toList();
        Float64List embedding = Float64List.fromList(doubleEmbeddingData);

        return embedding;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }

    return null;
  }
}
