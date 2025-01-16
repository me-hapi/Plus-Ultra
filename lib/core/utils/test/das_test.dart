import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/modules/home/bottom_nav.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);
final responsesProvider = StateProvider<List<int>>((ref) => List.filled(21, 0));

class DASTest extends ConsumerStatefulWidget {
  @override
  _DASTestState createState() => _DASTestState();
}

class _DASTestState extends ConsumerState<DASTest> {
  late GlobalSupabase _supabase;
  late SupabaseClient _client;

  @override
  void initState() {
    super.initState();
    _client = Supabase.instance.client;
    _supabase = GlobalSupabase(_client);
  }

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
    "I felt down-hearted and blue.",
    "I was intolerant of anything that kept me from getting on with what I was doing.",
    "I felt I was close to panic.",
    "I was unable to become enthusiastic about anything.",
    "I felt I wasn't worth much as a person.",
    "I felt that I was rather touchy.",
    "I was aware of the action of my heart in the absence of physical exertion.",
    "I felt scared without any good reason.",
    "I felt that life was meaningless."
  ];

  void _nextQuestion(int response) {
    print(response);
    final currentQuestionIndex = ref.read(currentQuestionIndexProvider);
    final responses = ref.read(responsesProvider.notifier);

    responses.state[currentQuestionIndex] = response;
    if (currentQuestionIndex < questions.length - 1) {
      ref.read(currentQuestionIndexProvider.notifier).state++;
    } else {
      context.go('/dasresult', extra: _computeScores());
    }
  }

  Map<String, int> _computeScores() {
    final responses = ref.read(responsesProvider);

    // Depression: Questions 3, 5, 10, 13, 16, 17, 21
    int depressionScore = responses[2] +
        responses[4] +
        responses[9] +
        responses[12] +
        responses[15] +
        responses[16] +
        responses[20];

    // Anxiety: Questions 2, 4, 7, 9, 15, 19, 20
    int anxietyScore = responses[1] +
        responses[3] +
        responses[6] +
        responses[8] +
        responses[14] +
        responses[18] +
        responses[19];

    // Stress: Questions 1, 6, 8, 11, 12, 14, 18
    int stressScore = responses[0] +
        responses[5] +
        responses[7] +
        responses[10] +
        responses[11] +
        responses[13] +
        responses[17];

    _supabase.insertMhScore(
        uid: _client.auth.currentUser!.id,
        depression: depressionScore,
        anxiety: anxietyScore,
        stress: stressScore);
    return {
      'depression': depressionScore,
      'anxiety': anxietyScore,
      'stress': stressScore,
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestionIndex = ref.watch(currentQuestionIndexProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
              width: 280,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: mindfulBrown['Brown20'],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: Colors.transparent,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(serenityGreen['Green50']!),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "Question ${currentQuestionIndex + 1} of ${questions.length}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Center(
                child: Text(
              questions[currentQuestionIndex],
              style: TextStyle(fontSize: 36),
            )),
            Spacer(),
            Column(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _nextQuestion(index + 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mindfulBrown['Brown80'],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        [
                          "Did not apply to me at all",
                          "Applied to me to some degree",
                          "Applied to me a considerable degree",
                          "Applied to me very much or most of the time"
                        ][index],
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
