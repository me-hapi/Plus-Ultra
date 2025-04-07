import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/journaling/data/supabse_db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JournalPromptService {
  final String openaiApiKey =
      "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";
  final String model = "gpt-4o";

  late final SupabaseDB _supabase = SupabaseDB(client);

  Future<String> generatePersonalizedPrompt() async {
    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] = "Bearer $openaiApiKey";
      dio.options.headers['Content-Type'] = 'application/json';

      final moodData = await _supabase.fetchMood();
      final mood = moodData.isNotEmpty ? moodData.first['mood'] ?? 'neutral' : 'neutral';

      final sleepData = await _supabase.fetchSleep();
      final sleepQuality = sleepData.isNotEmpty
          ? sleepData.first['quality'] ?? 'okay'
          : 'okay';

      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(Duration(days: 7));
      final journalData = await _supabase.getJournalsWithItems(
        uid: uid,
        startDate: sevenDaysAgo,
        endDate: now,
      );

      final previousEntryText = journalData.expand((journal) {
        return (journal['journalItems'] as List)
            .where((item) => item['content_type'] == 'text')
            .map((item) => "- ${item['content']}")
            .toList();
      }).join('\n');

      final hour = now.hour;
      print('HOUR: $hour');
      final timeOfDay = hour < 12
          ? "morning"
          : hour < 18
              ? "afternoon"
              : "evening";

      final prompt = '''
You are a journaling assistant for a Filipino mental health app called Lingap. Your goal is to generate warm, reflective, and helpful journal prompts for users based on their current mood, sleep quality, time of day, and mental health goal. Responses should be short (1–2 sentences), compassionate, and optionally include Filipino or Taglish for relatability. If journal history is available, use it to suggest continuity in reflection.

User Mood: $mood  
Time of Day: $timeOfDay  
Sleep Quality: $sleepQuality  

Recent Journal Entries:  
${previousEntryText.isNotEmpty ? previousEntryText : "No recent journal entries."}

Generate a journal prompt based on this information.
Only return the prompt as plain text.
''';

      final messages = [
        {"role": "user", "content": prompt}
      ];

      final requestBody = {
        "model": model,
        "messages": messages,
      };

      final response = await dio.post(
        "https://api.openai.com/v1/chat/completions",
        data: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('JOURNAL: $data');
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        print("Error: ${response.statusCode} ${response.statusMessage}");
        return "Sorry, we couldn't generate a prompt right now.";
      }
    } catch (e) {
      print("JournalPromptService Error: $e");
      return "Something went wrong while generating your journal prompt.";
    }
  }
}
