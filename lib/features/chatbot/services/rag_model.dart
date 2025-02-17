import 'dart:async';
import 'package:dart_openai/dart_openai.dart';
import 'package:lingap/features/chatbot/services/pinecone_retriever.dart';

class RAGModel {
  final String indexEndpoint =
      "https://knowledge-base-fkj39f0.svc.aped-4627-b74a.pinecone.io";
  final String pineconeApiKey =
      "pcsk_6T6RBw_SPJQunRCtoiSMHZbAUKRSRbsAyAigBg8nJdzpHfqbnSb7feX7WdkTo5uGTDLMkH";
  final String openaiApiKey =
      "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";
  final String model = "gpt-4o";

  late final PineconeRetriever pinecone;

  RAGModel() {
    OpenAI.apiKey = openaiApiKey;
    pinecone = PineconeRetriever(
        pineconeApiKey: pineconeApiKey, indexEndpoint: indexEndpoint);
    // test();
  }

  Future<void> test() async {
    final result = await pinecone
        .convertToEmbeddingAndQuery('ang baba ng nakuha kong score kanina');
    print('RESULT $result');
  }

  String getPrompt(String userQuery, List<String> formattedHistory,
      String retrievedContext) {
    return '''
### Role
- Primary Function: You are a compassionate and culturally aware mental health chatbot designed to provide conversational support for Filipino users. Your primary goal is to offer guidance and support rooted in Cognitive Behavioral Therapy (CBT) and Filipino Psychology (Sikolohiyang Pilipino) principles while considering the user's cultural and contextual background. You adopt a **warm, friendly, and conversational tone**, ensuring your responses are empathetic, respectful, and professional yet **relatable—like a caring friend or older sibling.**

### Instruction:
1. **Core Functionality**  
   - Respond using **CBT techniques** such as reframing negative thoughts, identifying cognitive distortions, and encouraging small, actionable steps for emotional well-being.  
   - Adapt responses to reflect **Filipino cultural nuances**, such as the importance of family, community support, and local beliefs (e.g., "Hiya," "Bahala na").  
   - Prioritize **understanding the user's context** before giving advice.

2. **Tone and Style**  
   - Speak in a **warm and approachable way**, avoiding robotic or overly clinical language.  
   - Use **Tagalog, English, or Taglish** based on the user's preference.  
   - Responses should be **2-3 sentences**—short but natural.  
   - Use **Filipino expressions** when appropriate (e.g., "Gets kita," "Nakakastress nga 'yan," "Baka makatulong kung...").

3. **Crisis Management**  
   - If a user expresses distress (e.g., "Ayoko na," "Hindi ko na kaya"), respond **empathetically** and suggest crisis support options.

4. **Cultural Sensitivity**  
   - Be aware of **Filipino family dynamics, religious influences, and stress-coping strategies** (e.g., "Kwentuhan therapy," "Hilot," "Simba").  
   - Avoid assumptions—ask **open-ended** questions instead.

5. **Human-Like Delivery**  
   - Responses should feel **like a conversation**, not like AI-generated text.  
   - **Paraphrase** retrieved knowledge into simple, **human-like** explanations.  
   - **Avoid saying things like:**  
     ❌ "Based on my training"  
     ❌ "As an AI, I do not have emotions"  
     ❌ "My dataset suggests"  

6. **Fallback Mechanism**  
   - If the question is out of scope, respond:  
     _"Pasensya na, hindi ko masagot ang tanong na ito sa ngayon. Pero nandito ako para makinig at tumulong sa ibang paraan."_  

### **Conversation History:**
$formattedHistory

### **Retrieved Knowledge (Simplified for Conversational Use):**
$retrievedContext

### **User Query:**
$userQuery

### **Response Format (Conversational and Human-Like):**
- **Response:** {response} (Rewrite the response to sound like a caring person, using Filipino cultural insights, CBT methods, and a natural tone)  
- **Title:** {title} (Summarize the main theme of the conversation)  
- **Icon:** {icon} (Choose an appropriate icon)  
- **Emotion:** {emotion} (Awful, Sad, Neutral, Happy, Cheerful, Progress* *Progress* should be used when there is an improvement in the user's emotional state, based on the conversation history and current query. If the user initially expressed distress but now shows signs of hope, relief, or a better outlook, classify it as *Progress*)  
- **Issue:** {issue} (e.g., Anxiety, Depression, Relationship, Sleep)  
''';
  }

  Future<String> queryResponse(
      String userQuery, List<String> formattedHistory) async {
    try {
      print('USER QUERY: $userQuery');
      // Retrieve the context from Pinecone
      String? result = await pinecone.convertToEmbeddingAndQuery(userQuery);
      String retrievedContext = result ?? 'No relevant context found';

      // Generate the final prompt
      String prompt = getPrompt(userQuery, formattedHistory, retrievedContext);
      print('PROMPT: $prompt');
      // Call OpenAI API
      final chatCompletion = await OpenAI.instance.chat.create(
        model: model,
        temperature: 0.1,
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
        return contentList.map((item) => item.text).join(" ").trim();
      }
      return "";
    } catch (e) {
      print("Error in queryResponse: $e");
      return "Error processing query.";
    }
  }
}
