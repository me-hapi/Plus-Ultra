import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dart_openai/dart_openai.dart';

class PineconeRetriever {
  final String pineconeApiKey;
  final String indexEndpoint;
  final String namespace;

  PineconeRetriever({
    required this.pineconeApiKey,
    required this.indexEndpoint,
    this.namespace = "mental-health",
  });

  Future<String?> convertToEmbeddingAndQuery(String text,
      {int topK = 3, Map<String, dynamic>? filter}) async {
    try {
      print(pineconeApiKey);
      final embedding = await OpenAI.instance.embedding.create(
        model: "text-embedding-3-small",
        input: text,
      );

      List<double> vector = embedding.data.first.embeddings;
      List<Map<String, dynamic>>? results =
          await queryPinecone(vector, topK: topK, filter: filter);

      if (results == null || results.isEmpty) {
        return null;
      }

      return results.map((e) => e.toString()).join(" ");
    } catch (e) {
      print("Error generating embedding or querying Pinecone: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> queryPinecone(List<double> vector,
      {int topK = 3, Map<String, dynamic>? filter}) async {
    final uri = Uri.parse("$indexEndpoint/query");
    final headers = {
      "Api-Key": pineconeApiKey,
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "namespace": namespace,
      "vector": vector,
      "topK": topK,
      "includeValues": true,
      "includeMetadata": true,
      if (filter != null) "filter": filter,
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Extracting metadata from the response
        List<Map<String, dynamic>> metadataList = [];
        if (jsonResponse["matches"] != null) {
          for (var match in jsonResponse["matches"]) {
            if (match["metadata"] != null) {
              metadataList.add(match["metadata"]);
            }
          }
        }

        return metadataList;
      } else {
        print(
            "Pinecone query failed: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error querying Pinecone: $e");
      return null;
    }
  }
}
