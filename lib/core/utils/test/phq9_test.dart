import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final phqCurrentQuestionIndexProvider = StateProvider<int>((ref) => 0);
final phqResponsesProvider = StateProvider<List<int>>((ref) => List.filled(9, 0));

class PHQTest extends ConsumerWidget {
  final List<String> questions = [
    "Little interest or pleasure in doing things.",
    "Feeling down, depressed, or hopeless.",
    "Trouble falling or staying asleep, or sleeping too much.",
    "Feeling tired or having little energy.",
    "Poor appetite or overeating.",
    "Feeling bad about yourself - or that you are a failure or have let yourself or your family down.",
    "Trouble concentrating on things, such as reading the newspaper or watching television.",
    "Moving or speaking so slowly that other people could have noticed. Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual.",
    "Thoughts that you would be better off dead or of hurting yourself in some way."
  ];

  void _nextQuestion(WidgetRef ref, int response) {
    final currentQuestionIndex = ref.read(phqCurrentQuestionIndexProvider);
    final responses = ref.read(phqResponsesProvider.notifier);

    responses.state[currentQuestionIndex] = response;
    if (currentQuestionIndex < questions.length - 1) {
      ref.read(phqCurrentQuestionIndexProvider.notifier).state++;
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
              ref.read(phqCurrentQuestionIndexProvider.notifier).state = 0;
              ref.read(phqResponsesProvider.notifier).state = List.filled(9, 0);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestionIndex = ref.watch(phqCurrentQuestionIndexProvider);
    final responses = ref.watch(phqResponsesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("PHQ-9 Assessment"),
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