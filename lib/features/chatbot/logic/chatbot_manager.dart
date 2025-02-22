import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/const/das_interpretation.dart';
import 'package:lingap/features/chatbot/data/supabase_db.dart';
import 'package:lingap/features/chatbot/logic/utils.dart';
import 'package:lingap/features/chatbot/services/chatbot.dart';
import 'package:lingap/features/chatbot/services/rag_model.dart';

final chatbotProvider =
    StateNotifierProvider.family<ChatbotNotifier, List<Message>, int>(
        (ref, sessionID) {
  return ChatbotNotifier(sessionID);
});

class ChatbotNotifier extends StateNotifier<List<Message>> {
  // bool _hasIntroduced = false;
  final Chatbot chatbot = Chatbot();
  final RAGModel rag = RAGModel();
  final int sessionID;
  final SupabaseDB supabaseDB;
  final TextEditingController messageController = TextEditingController();
  final DASInterpreter interpreter = DASInterpreter();
  int index = 0;
  List responses = [];
  String emotion = 'Not available yet';
  final List<String> questions = [
    "I found it hard to wind down.",
    "I was aware of dryness of my mouth.",
    "I couldn't seem to experience any positive feeling at all.",
    "I experienced breathing difficulty.",
    "I found it difficult to work up the initiative to do things.",
    "I tended to over-react to situations.",
    "I experienced trembling (e.g., in the hands).",
    "I felt that I was using a lot of nervous energy.",
    "I was worried about situations in which I might panic and make a fool of myself.",
    "I felt that I had nothing to look forward to.",
    "I found myself getting agitated.",
    "I found it difficult to relax.",
  ];

  ChatbotNotifier(this.sessionID)
      : supabaseDB = SupabaseDB(client),
        super([]) {
    _loadCachedMessages();
    _listenToMessages();
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
        "recommended_exercise": data["recommended_exercise"],
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

  Future<void> _loadCachedMessages() async {
    final cached = await client
        .from('chatbot_convo')
        .select()
        .eq('sessionID', sessionID)
        .order('id', ascending: true); // Ensure ordering

    state = cached
        .map((row) => Message(
              isUser: row['user'],
              message: row['content'],
            ))
        .toList();
  }

  void _listenToMessages() {
    supabaseDB.streamChatbotConversations(sessionID.toString()).listen((data) {
      final newMessages = data
          .map((row) => Message(
                isUser: row['user'],
                message: row['content'],
              ))
          .toList();

      // // Ensure messages are sorted by stream_id
      // newMessages.sort((a, b) => a.stream_id.compareTo(b.stream_id));

      // Check if messages are truly new to prevent unnecessary rebuilds
      if (newMessages.length > state.length) {
        state = List.from(state)..addAll(newMessages.skip(state.length));
      }
    });
  }

  bool _sessionUpdated = false;

  void sendMessage() async {
    String userInput = messageController.text.trim();
    if (userInput.isEmpty) return;

    state = [
      ...state,
      Message(isUser: true, message: userInput),
      Message(isUser: false, message: "Typing..."),
    ];
    messageController.clear();

    List<String> history = state
        .map((msg) =>
            msg.isUser ? "User: ${msg.message}" : "System: ${msg.message}")
        .toList();

    String responseQuery = await rag.queryResponse(userInput, history);
    // Map response = Utils().parseResponse(responseQuery);
    Map response = extractRecommendation(responseQuery);

    String responseText = response['response'];
    emotion = response['emotion'];
    String title = response['title'];
    String icon = response['icon'];
    String issue = response['issue'];

    print('ISSUE: $issue');

    await supabaseDB.insertMessages(sessionID, userInput, true);
    await supabaseDB.insertMessages(sessionID, responseText, false);
    await supabaseDB.updateCount(sessionID, history.length, emotion);
    await supabaseDB.updateIssue(sessionID, issue);

    if (history.length <= 3 && !_sessionUpdated) {
      _sessionUpdated = true;
      supabaseDB.updateSession(sessionID, title, emotion, icon);
    }

    state = [
      ...state.where((msg) => msg.message != "Typing..."),
      Message(isUser: false, message: responseText, emotion: emotion),
    ];
  }

  Future<void> introduction() async {
    if (await supabaseDB.hasIntro(sessionID)) return;

    List<String> botIntroductions = [
      "Hi! Ako si Lingap, ang iyong mental health assistant. Nandito ako para makinig at sumuporta sa’yo. Pwede tayong mag-usap tungkol sa nararamdaman mo, mag-reflect sa emotions mo, at maghanap ng paraan para mas gumaan ang pakiramdam mo. Handa ka na bang magsimula?",
      "Hey! 👋 Ako si Lingap, ang iyong mental health buddy. Kamusta ka today? Kung gusto mo lang maglabas ng thoughts, or may gusto kang itanong tungkol sa mental health, nandito ako anytime para tumulong!",
      "Hello! Ako si Lingap, isang AI mental health assistant na nandito para tulungan kang maintindihan ang sarili mong damdamin. Pwede tayong mag-usap, mag-reflect, at maghanap ng paraan para mas maging okay ka. Ready ka na bang magsimula?",
      "Hi! 😊 Alam kong hindi laging madali ang mga bagay, pero gusto kong malaman mong hindi ka nag-iisa. Ako si Lingap, at nandito ako para makinig at sumuporta sa’yo. Tara, pag-usapan natin kung ano ang nasa isip mo.",
      "Magandang araw! Ako si Lingap, isang AI mental health assistant na handang tumulong sa’yo. Gusto kong bigyan ka ng safe space para i-share ang iyong saloobin. Huwag kang mag-alala, hindi kita huhusgahan. Paano kita matutulungan ngayon?",
      "Hello! Ako si Lingap, at gusto kong malaman mong safe ka dito. Kung may bumabagabag sa’yo, pwede mo itong ibahagi sa akin. Hindi ako therapist, pero kaya kitang bigyan ng suporta at gabay sa abot ng aking makakaya. Ready ka na bang magsimula?"
    ];
    final random = Random();
    int randomIndex = random.nextInt(botIntroductions.length);
    state = [
      ...state,
      Message(
        isUser: false,
        message: botIntroductions[randomIndex],
        emotion: 'intro',
      )
    ];

    await supabaseDB.insertMessages(
        sessionID, botIntroductions[randomIndex], false);
    await supabaseDB.updateCount(sessionID, 1, emotion);

    supabaseDB.updateIntro(sessionID);
  }

  Future<void> postAssessment() async {
    String script =
        "Hey, napansin kong parang medyo gumaan na ang pakiramdam mo! I’m really glad na kahit papaano, nakatulong ako sa’yo. Pero gusto ko lang siguraduhin na okay ka na talaga before tayo magtapos.\n\nPwede mo bang sagutin ang ilang tanong para mas malaman ko kung kumusta ka na ngayon?";

    state = [
      ...state,
      Message(
        isUser: false,
        message: script,
        emotion: 'script',
      )
    ];

    List<String> history = state
        .map((msg) =>
            msg.isUser ? "User: ${msg.message}" : "System: ${msg.message}")
        .toList();
    int count = history.length;

    await supabaseDB.insertMessages(sessionID, script, false);
    await supabaseDB.updateCount(sessionID, count, emotion);
  }

  Future<void> askQuestion() async {
    if (index <= 11) {
      state = [
        ...state,
        Message(
          isUser: false,
          message: questions[index],
          emotion: 'dass',
        )
      ];

      await supabaseDB.insertMessages(sessionID, questions[index], false);
    }
  }

  void sendOption() {
    // Check if the last message already contains options
    if (state.isNotEmpty && state.last.message == 'option') return;

    if (index < 12) {
      state = [
        ...state,
        Message(
          isUser: true,
          message: 'option',
          emotion: 'option',
        )
      ];
    }
  }

  Future<void> getScore(String option) async {
    List options = [
      "Did not apply to me at all",
      "Applied to me to some degree",
      "Applied to me a considerable degree",
      "Applied to me very much or most of the time"
    ];

    // Find the index of the selected option
    int optionIndex = options.indexOf(option);

    // Append the index if it exists in the options list
    if (optionIndex != -1) {
      responses.add(optionIndex);
    }

    state = [
      ...state.sublist(0, state.length - 1),
      Message(
        isUser: true,
        message: option,
      )
    ];

    List<String> history = state
        .map((msg) =>
            msg.isUser ? "User: ${msg.message}" : "System: ${msg.message}")
        .toList();
    int count = history.length;

    await supabaseDB.insertMessages(sessionID, option, true);
    await supabaseDB.updateCount(sessionID, count, emotion);
    index++;
    if (index <= 11) {
      askQuestion();
    } else {
      index = 0;
      sendInterpretation();
    }
  }

  Future<void> sendInterpretation() async {
    print('RESPONSE: $responses.length');
    int depressionScore = _computeScores()['depression']!;
    int anxietyScore = _computeScores()['anxiety']!;
    int stressScore = _computeScores()['stress']!;
    String depression =
        interpreter.getInterpretation('depression', depressionScore);
    String anxiety = interpreter.getInterpretation('depression', anxietyScore);
    String stress = interpreter.getInterpretation('depression', stressScore);

    String prompt = '''
Based on the user's DASS-12 scores, provide a meaningful and supportive interpretation. 
Here are the scores:
- Depression: $depression ($depressionScore)
- Anxiety: $anxiety ($anxietyScore)
- Stress: $stress ($stressScore)

Offer a compassionate analysis of these results, helping the user understand what they might indicate. 
Conclude by asking if they already want to end the session? 
Ensure the response is a close ended question.
''';

    print(prompt);
    List<String> history = state
        .map((msg) =>
            msg.isUser ? "User: ${msg.message}" : "System: ${msg.message}")
        .toList();

    // Add "Typing..." message
    state = [
      ...state,
      Message(
        isUser: false,
        message: "Typing...",
      )
    ];

    String responseQuery = await rag.queryResponse(prompt, history);
    // Map response = Utils().parseResponse(responseQuery);
    Map response = extractRecommendation(responseQuery);

    String responseText = response['response'];

    state = [
      ...state.sublist(0, state.length - 1),
      Message(
        isUser: false,
        message: responseText,
        emotion: 'interpretation',
      )
    ];

    history = state
        .map((msg) =>
            msg.isUser ? "User: ${msg.message}" : "System: ${msg.message}")
        .toList();

    await supabaseDB.insertMessages(sessionID, responseText, false);
    await supabaseDB.updateCount(sessionID, history.length, emotion);
  }

  Stream<Map<String, dynamic>?> isOpen() {
    return supabaseDB.listenToSession(sessionID);
  }

  void askSession() {
    state = [
      ...state,
      Message(isUser: true, message: "close", emotion: 'close')
    ];
  }

  Future<void> checkSession(String option) async {
    if (option == 'Oo') {
      state = [
        ...state.sublist(0, state.length - 1),
        Message(
          isUser: true,
          message: 'Oo',
        )
      ];
      List<String> history = state
          .map((msg) =>
              msg.isUser ? "User: ${msg.message}" : "System: ${msg.message}")
          .toList();

      await supabaseDB.insertMessages(sessionID, 'Oo', true);
      await supabaseDB.updateCount(sessionID, history.length, emotion);

      closeSession();
    } else {
      state = [
        ...state.sublist(0, state.length - 1),
        Message(
          isUser: true,
          message: 'Hindi',
        )
      ];
      List<String> history = state
          .map((msg) =>
              msg.isUser ? "User: ${msg.message}" : "System: ${msg.message}")
          .toList();

      await supabaseDB.insertMessages(sessionID, 'Hindi', true);
      await supabaseDB.updateCount(sessionID, history.length, emotion);
      staySession();
    }
  }

  void closeSession() {
    supabaseDB.closeSession(sessionID);
  }

  Future<void> staySession() async {
    state = [
      ...state,
      Message(
        isUser: false,
        message: "Typing...",
      )
    ];

    List<String> history = state
        .map((msg) =>
            msg.isUser ? "User: ${msg.message}" : "System: ${msg.message}")
        .toList();

    String responseQuery = await rag.queryResponse('Hindi', history);
    // Map response = Utils().parseResponse(responseQuery);
    Map response = extractRecommendation(responseQuery);

    String responseText = response['response'];

    state = [
      ...state.sublist(0, state.length - 1),
      Message(
        isUser: false,
        message: responseText,
      )
    ];
  }

  Map<String, int> _computeScores() {
    // Depression: Questions 3, 5, 10, 13, 16, 17, 21
    int depressionScore =
        responses[4] + responses[7] + responses[8] + responses[11];

    // Anxiety: Questions 2, 4, 7, 9, 15, 19, 20
    int anxietyScore =
        responses[1] + responses[3] + responses[9] + responses[10];

    // Stress: Questions 1, 6, 8, 11, 12, 14, 18
    int stressScore = responses[0] + responses[2] + responses[5] + responses[6];

    supabaseDB.insertMhScore(
        uid: uid,
        depression: depressionScore,
        anxiety: anxietyScore,
        stress: stressScore);
    return {
      'depression': depressionScore,
      'anxiety': anxietyScore,
      'stress': stressScore,
    };
  }
}

class Message {
  final bool isUser;
  final String message;
  String emotion;

  Message(
      {required this.isUser,
      required this.message,
      this.emotion = 'not available'});
}
