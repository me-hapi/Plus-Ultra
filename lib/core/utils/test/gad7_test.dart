import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gad7CurrentQuestionIndexProvider = StateProvider<int>((ref) => 0);
final gad7ResponsesProvider = StateProvider<List<int>>((ref) => List.filled(7, 0));

class GAD7Test extends ConsumerWidget {
  final List<String> questions = [
    "Feeling nervous, anxious, or on edge.",
    "Not being able to stop or control worrying.",
    "Worrying too much about different things.",
    "Trouble relaxing.",
    "Being so restless that it is hard to sit still.",
    "Becoming easily annoyed or irritable.",
    "Feeling afraid as if something awful might happen."
  ];

  void _nextQuestion(WidgetRef ref, int response) {
    final currentQuestionIndex = ref.read(gad7CurrentQuestionIndexProvider);
    final responses = ref.read(gad7ResponsesProvider.notifier);

    responses.state[currentQuestionIndex] = response;
    if (currentQuestionIndex < questions.length - 1) {
      ref.read(gad7CurrentQuestionIndexProvider.notifier).state++;
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
              ref.read(gad7CurrentQuestionIndexProvider.notifier).state = 0;
              ref.read(gad7ResponsesProvider.notifier).state = List.filled(7, 0);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestionIndex = ref.watch(gad7CurrentQuestionIndexProvider);
    final responses = ref.watch(gad7ResponsesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("GAD-7 Assessment"),
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
                        "Not at all",
                        "Several days",
                        "More than half the days",
                        "Nearly every day"
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
