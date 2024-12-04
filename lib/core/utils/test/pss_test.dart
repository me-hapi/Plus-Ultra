import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pssCurrentQuestionIndexProvider = StateProvider<int>((ref) => 0);
final pssResponsesProvider = StateProvider<List<int>>((ref) => List.filled(10, 0));

class PSSTest extends ConsumerWidget {
  final List<String> questions = [
    "In the last month, how often have you been upset because of something that happened unexpectedly?",
    "In the last month, how often have you felt that you were unable to control the important things in your life?",
    "In the last month, how often have you felt nervous and stressed?",
    "In the last month, how often have you felt confident about your ability to handle your personal problems?",
    "In the last month, how often have you felt that things were going your way?",
    "In the last month, how often have you found that you could not cope with all the things that you had to do?",
    "In the last month, how often have you been able to control irritations in your life?",
    "In the last month, how often have you felt that you were on top of things?",
    "In the last month, how often have you been angered because of things that were outside of your control?",
    "In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?"
  ];

  void _nextQuestion(WidgetRef ref, int response) {
    final currentQuestionIndex = ref.read(pssCurrentQuestionIndexProvider);
    final responses = ref.read(pssResponsesProvider.notifier);

    responses.state[currentQuestionIndex] = response;
    if (currentQuestionIndex < questions.length - 1) {
      ref.read(pssCurrentQuestionIndexProvider.notifier).state++;
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
              ref.read(pssCurrentQuestionIndexProvider.notifier).state = 0;
              ref.read(pssResponsesProvider.notifier).state = List.filled(10, 0);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestionIndex = ref.watch(pssCurrentQuestionIndexProvider);
    final responses = ref.watch(pssResponsesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Perceived Stress Scale (PSS) Assessment"),
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
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    onPressed: () => _nextQuestion(ref, index),
                    child: Text(
                      [
                        "Never",
                        "Almost Never",
                        "Sometimes",
                        "Fairly Often",
                        "Very Often"
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