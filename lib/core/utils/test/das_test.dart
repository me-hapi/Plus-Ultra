import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);
final responsesProvider = StateProvider<List<int>>((ref) => List.filled(21, 0));

class DASTest extends ConsumerWidget {
  final List<String> questions = [
    "I found it hard to wind down.",
    "I was aware of dryness of my mouth.",
    "I couldn't seem to experience any positive feeling at all.",
    "I experienced breathing difficulty (e.g., excessively rapid breathing, breathlessness in the absence of physical exertion).",
    "I found it difficult to work up the initiative to do things.",
    "I tended to over-react to situations.",
    "I experienced trembling (e.g., in the hands).",
    "I felt that I was using a lot of nervous energy.",
    "I was worried about situations in which I might panic and make a fool of myself.",
    "I felt that I had nothing to look forward to.",
    "I found myself getting agitated.",
    "I found it difficult to relax.",
    "I felt down-hearted and blue.",
    "I was intolerant of anything that kept me from getting on with what I was doing.",
    "I felt I was close to panic.",
    "I was unable to become enthusiastic about anything.",
    "I felt I wasn't worth much as a person.",
    "I felt that I was rather touchy.",
    "I was aware of the action of my heart in the absence of physical exertion (e.g., sense of heart rate increase, heart missing a beat).",
    "I felt scared without any good reason.",
    "I felt that life was meaningless."
  ];

  void _nextQuestion(WidgetRef ref, int response) {
    final currentQuestionIndex = ref.read(currentQuestionIndexProvider);
    final responses = ref.read(responsesProvider.notifier);

    responses.state[currentQuestionIndex] = response;
    if (currentQuestionIndex < questions.length - 1) {
      ref.read(currentQuestionIndexProvider.notifier).state++;
    } else {
      _showResults(ref);
    }
  }

  void _showResults(WidgetRef ref) {
    // Display results (this can be expanded for detailed feedback)
    showDialog(
      context: ref.context,
      builder: (context) => AlertDialog(
        title: Text("Assessment Completed"),
        content: Text("Thank you for completing the assessment."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(currentQuestionIndexProvider.notifier).state = 0;
              ref.read(responsesProvider.notifier).state = List.filled(21, 0);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestionIndex = ref.watch(currentQuestionIndexProvider);
    final responses = ref.watch(responsesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("DASS-21 Assessment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Question ${currentQuestionIndex + 1} of ${questions.length}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              questions[currentQuestionIndex],
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Column(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    onPressed: () => _nextQuestion(ref, index),
                    child: Text(
                      [
                        "Did not apply to me at all",
                        "Applied to me to some degree",
                        "Applied to me a considerable degree",
                        "Applied to me very much or most of the time"
                      ][index],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
            ),
          ],
        ),
      ),
    );
  }
}
