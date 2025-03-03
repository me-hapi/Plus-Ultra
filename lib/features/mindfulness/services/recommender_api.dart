import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/mindfulness/data/supabase.dart';

class RecommenderApi {
  final String openaiApiKey =
      "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";
  final String model = "o1-mini";
  final SupabaseDB supabase = SupabaseDB(client);
  List<Map<String, dynamic>> soundtracks = [];
  List<Map<String, dynamic>> vitalData = [];
  List<Map<String, dynamic>> sleepData = [];
  List<Map<String, dynamic>> moodData = [];

  RecommenderApi() {
    OpenAI.apiKey = openaiApiKey;
    initialize();
  }

  void initialize() async {
    final result_sound = await supabase.getSoundTracks();
    final result_mood = await supabase.getPastWeekMoods();
    final result_sleep = await supabase.getPastWeeksleeps();
    final result_vital = await supabase.fetchVitalData();

    soundtracks = result_sound;
    vitalData = result_vital;
    sleepData = result_sleep;
    moodData = result_mood;
  }

  String getPrompt(String exercise, int minutes) {
    return '''
**Prompt:**  

You are an AI assistant specializing in mental health and wellness recommendations. Based on the given user data, your task is to recommend the appropriate soundtrack from the provided list. Consider the user's ** duration, vital signs, sleep history, and mood history**.

### **User Exercise & Duration:**  
- **Exercise:** `$exercise`  
- **Duration:** `$minutes` minutes  

### **Inputs:**  
- **Available Soundtracks:** `{$soundtracks}`  
- **Vital Signs Data (Heart Rate, Blood Pressure, etc.):** `{$vitalData}`  
- **Sleep History (Sleep Duration, Sleep Quality, etc.):** `{$sleepData}`  
- **Mood History (Recent Mood, Stress Levels, etc.):** `{$moodData}`  

### **Instructions for Selection:**  

1. **Select a soundtrack** from the given list that best complements the recommended exercise.  
   - For **Breathing**, choose a track with a **steady, slow rhythm**.  
   - For **Meditation**, select **calming, ambient music**.  
   - For **Relaxation**, find something with **soft, natural sounds**.  
   - For **Sleep**, pick a **soothing, deep relaxation track**.  

### **Output Format:**  
Provide your response in the following structured format:  

```json
{
  "reasoning": "<Brief Explanation>",
  "selected_soundtrack": "<Soundtrack Details>"
}
''';
  }

  Map<String, dynamic> extractRecommendation(String rawResponse) {
    try {
      // Clean the response by removing triple backticks and any extra markers
      String cleanedJson = rawResponse
          .trim()
          .replaceAll("```json", "") // Remove markdown-style json block markers
          .replaceAll("```", ""); // Remove closing backticks if present

      // Parse the cleaned JSON string
      Map<String, dynamic> data = jsonDecode(cleanedJson);

      // Extract the required fields
      return {
        "reasoning": data["reasoning"],
        "sound_name": data["selected_soundtrack"]["name"],
        "soundtrack_url": data["selected_soundtrack"]["url"],
        "soundtrack_id": data["selected_soundtrack"]["id"],
      };
    } catch (e) {
      print("Error parsing JSON: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> queryResponse(String exercise, int minutes) async {
    try {
      String prompt = getPrompt(exercise, minutes);
      print('PROMPT: $prompt');

      // Call OpenAI API
      final chatCompletion = await OpenAI.instance.chat.create(
        model: model,
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                  'You are a compassionate mental health chatbot designed to provide support for Filipino users.'),
            ],
            role: OpenAIChatMessageRole.assistant,
          ),
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );

      // Extract and return the response text
      final contentList = chatCompletion.choices.first.message.content;
      if (contentList != null && contentList.isNotEmpty) {
        final response = contentList.map((item) => item.text).join(" ").trim();
        return extractRecommendation(response);
      }
      return {};
    } catch (e) {
      print("Error in queryResponse: $e");
      return {};
    }
  }
}
