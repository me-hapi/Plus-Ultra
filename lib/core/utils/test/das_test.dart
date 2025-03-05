import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/custom_button.dart';
import 'package:lingap/modules/home/bottom_nav.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);
final responsesProvider = StateProvider<List<int>>((ref) => List.filled(21, 0));

class DASTest extends ConsumerStatefulWidget {
  final String language;

  DASTest({super.key, required this.language});

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

  final Map<String, dynamic> option = {
    'English': [
      "Did not apply to me at all",
      "Applied to me to some degree",
      "Applied to me a considerable degree",
      "Applied to me very much or most of the time"
    ],
    'French': [
      "Ne s’applique pas du tout à moi",
      "S’applique un peu à moi, ou une partie du temps",
      "S’applique beaucoup à moi, ou une bonne partie du temps",
      "S’applique entièrement à moi, ou la grande majorité du temps"
    ],
    'Korean': [
      "나에게 전혀 적용되지 않는다.",
      "나에게 약간 적용된다.",
      "나에게 상당히 많이 적용된다.",
      "나에게 매우 많이, 대부분 적용된다."
    ],
    'Chinese': ["不適用", "頗適用，或間中適用", "很適用，或經常適用", "最適用，或常常適用"],
    'Indonesian': [
      "Tidak sesuai dengan saya sama sekali.",
      "Sesuai dengan saya sampai tingkat tertentu.",
      "Sesuai dengan saya sampai batas yang dapat dipertimbangkan.",
      "Sangat sesuai dengan saya."
    ],
    'Malaysian': [
      "Tidak langsung menggambarkan keadaan saya",
      "Sedikit atau jarang-jarang menggambarkan keadaan saya.",
      "Banyak atau kerapkali menggambarkan keadaan saya.",
      "Sangat banyak atau sangat kerap menggambarkan keadaan saya."
    ],
    'Vietnamese': [
      "Không đúng gì hết với tôi",
      "Đúng với tôi ở mức độ nào đó, hoặc thỉnh thoảng xảy ra",
      "Đúng với tôi ở mức độ tương đối nhiều, hoặc thường xảy ra",
      "Rất đúng với tôi, hoặc luôn thường xảy ra"
    ],
    'Thai': [
      "ไม่ตรงกับข้าพเจ้าเลย",
      "ตรงกับข้าพเจ้าบ้าง หรือเกิดขึ้นเป็นบางครั้ง",
      "ตรงกับข้าพเจ้า หรือเกิดขึ้นบ่อย",
      "ตรงกับข้าพเจ้ามาก หรือเกิดขึ้นบ่อยมากที่สุด"
    ],
    'Filipino': [
      "Hindi nangyayari / nagaganap sa akin",
      "Paminsan-minsan nangyayari / nagaganap sa akin",
      "Pangkaraniwang nangyayari / nagaganap sa akin",
      "Madalas na nangyayari / nagaganap sa akin"
    ],
    'Japanese': ["まったくそうではない", "時々そうである", "かなりそうである", "非常にそうである"]
  };

  final Map<String, dynamic> questions = {
    'English': [
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
      "I found it difficult to relax."
    ],
    'French': [
      "Je me suis aperçu(e) que des choses insignifiantes me troublaient.",
      "J’ai été conscient(e) d’avoir la bouche sèche.",
      "J’ai eu l’impression de ne pas pouvoir ressentir d’émotion positive.",
      "J’ai eu de la difficulté à respirer.",
      "J’ai eu de la difficulté à initier de nouvelles activités.",
      "J’ai eu tendance à réagir de façon exagérée.",
      "Je me suis senti(e) faible (par exemple, les jambes qui allaient se dérober sous moi).",
      "J’ai eu de la difficulté à me détendre.",
      "Je me suis trouvé(e) dans des situations qui me rendaient anxieux(se).",
      "J’ai eu le sentiment de ne rien envisager avec plaisir.",
      "Je me suis aperçu(e) que j’étais assez facilement contrarié(e).",
      "J’ai eu de la difficulté à me relaxer."
    ],
    'Korean': [
      "나는 긴장을 풀고 휴식을 취하기가 힘들었다.",
      "나는 입안이 마르는 것을 느꼈다.",
      "나는 전혀 긍정적인 감정을 느끼지 못했던 것 같다.",
      "나는 호흡하는 데 어려움을 경험했다.",
      "나는 새로운 일을 시작하기가 어려웠다.",
      "나는 상황들에서 과잉반응을 하는 경향이 있었다.",
      "나는 떨림을 경험했다.",
      "나는 신경을 너무 많이 쓰고 있음을 느꼈다.",
      "나는 내가 심리적으로 공황상태가 되는 상황들에 대한 걱정을 했다.",
      "나는 아무것도 기대할 것이 없다고 느꼈다.",
      "나는 내 자신이 동요되는 것을 느꼈다.",
      "나는 긴장을 풀기가 어려웠다."
    ],
    'Chinese': [
      "我覺得很難讓自己安靜下來。",
      "我感到口乾。",
      "我好像不能再有任何愉快、舒暢的感覺。",
      "我感到呼吸困難。",
      "我感到很難自動去開始工作。",
      "我對事情往往作出過敏反應。",
      "我感到顫抖（例如手震）。",
      "我覺得自己消耗很多精神。",
      "我憂慮一些令自己恐慌或出醜的場合。",
      "我覺得自己對將來沒有甚麼可盼望。",
      "我感到忐忑不安。",
      "我感到很難放鬆自己。"
    ],
    'Indonesian': [
      "Saya merasa bahwa diri saya menjadi marah karena hal-hal sepele.",
      "Saya merasa bibir saya sering kering.",
      "Saya sama sekali tidak dapat merasakan perasaan positif.",
      "Saya mengalami kesulitan bernafas.",
      "Saya sepertinya tidak kuat lagi untuk melakukan suatu kegiatan.",
      "Saya cenderung bereaksi berlebihan terhadap suatu situasi.",
      "Saya merasa goyah.",
      "Saya merasa sulit untuk bersantai.",
      "Saya menemukan diri saya berada dalam situasi yang sangat cemas.",
      "Saya merasa tidak ada hal yang dapat diharapkan di masa depan.",
      "Saya menemukan diri saya mudah merasa kesal.",
      "Saya merasa sulit untuk beristirahat."
    ],
    'Malaysian': [
      "Saya dapati diri saya sukar ditenteramkan.",
      "Saya sedar mulut saya terasa kering.",
      "Saya tidak dapat mengalami perasaan positif sama sekali.",
      "Saya mengalami kesukaran bernafas.",
      "Saya sukar untuk mendapatkan semangat bagi melakukan sesuatu perkara.",
      "Saya cenderung untuk bertindak keterlaluan dalam sesuatu keadaan.",
      "Saya rasa menggeletar.",
      "Saya rasa saya menggunakan banyak tenaga dalam keadaan cemas.",
      "Saya bimbang keadaan di mana saya mungkin menjadi panik.",
      "Saya rasa saya tidak mempunyai apa-apa untuk diharapkan.",
      "Saya dapati diri saya semakin gelisah.",
      "Saya rasa sukar untuk relaks."
    ],
    'Vietnamese': [
      "Tôi thấy mình thường lo lắng ngay cả với những việc bình thường.",
      "Tôi nhận thấy miệng mình khô.",
      "Dường như tôi không hề thấy bất kỳ một cảm giác tích cực nào.",
      "Tôi đã từng cảm thấy khó thở.",
      "Dường như tôi cảm thấy không thể tiếp tục được nữa.",
      "Tôi có xu hướng phản ứng quá mức.",
      "Tôi có một cảm giác run.",
      "Tôi thấy khó thư giãn.",
      "Tôi thấy mình trong những tình huống làm tôi quá lo lắng.",
      "Tôi cảm thấy rằng tôi không có gì để hướng tới nữa.",
      "Tôi thấy mình bức tức tương đối dễ dàng.",
      "Tôi cảm thấy rất khó để thư giãn."
    ],
    'Thai': [
      "ข้าพเจ้ารู้สึกว่ายากที่จะผ่อนคลายอารมณ์.",
      "ข้าพเจ้าทราบว่าข้าพเจ้ามีอาการปากแห้ง.",
      "ข้าพเจ้ารู้สึกไม่ดีขึ้นเลย.",
      "ข้าพเจ้ามีอาการหายใจลำบาก.",
      "ข้าพเจ้ารู้สึกทำกิจกรรมด้วยตนเองได้ค่อนข้างลำบาก.",
      "ข้าพเจ้ามีปฏิกิริยาตอบสนองต่อสิ่งต่าง ๆ มากเกินไป.",
      "ข้าพเจ้ามีอาการสั่น.",
      "ข้าพเจ้ารู้สึกว่าข้าพเจ้าวิตกกังวลมาก.",
      "ข้าพเจ้ารู้สึกกังวลกับเหตุการณ์ที่อาจทำให้ข้าพเจ้ารู้สึกตื่นกลัว.",
      "ข้าพเจ้ารู้สึกว่าไม่มีเป้าหมาย.",
      "ข้าพเจ้าเริ่มรู้สึกว่าข้าพเจ้ามีอาการกระวนกระวายใจ.",
      "ข้าพเจ้ารู้สึกไม่ผ่อนคลาย."
    ],
    'Filipino': [
      "Nahihirapan akong tumimo.",
      "Batid ko ang panunuyo ng aking bibig.",
      "Hindi ko man lang maranasan ang makaramdam ng mabuti.",
      "Nakakaranas ako ng hirap na paghinga.",
      "Nahihirapan akong magkusa na gumawa.",
      "Masyado akong nagiging intimidida sa mga situasyon.",
      "Nakaranas ako ng panginginig.",
      "Naramdaman ko na masyado akong gumagamit ng aking nevous energy.",
      "Nangangamba ako sa mga situasyong kung saan maaari akong matuliro.",
      "Nararamdaman ko na wala naman akong inaasahan.",
      "Nakita ko na lang ang sarili na masaya.",
      "Nahihirapan akong magrelaks."
    ],
    'Japanese': [
      "緊張をとくのが難しかった。",
      "口の中が乾く感じがすることがあった。",
      "前向きな気持ちになることは全くないように思った。",
      "呼吸困難な感じがした。",
      "何かするのに率先してやるのは難しかった。",
      "状況に過剰に反応しやすかった。",
      "震えを感じることがあった（例えば手が震えるなど）。",
      "神経のエネルギーをたくさん使っているように感じた。",
      "慌てたり、失敗して人に笑われることになるのではないかと心配していた。",
      "期待できるものは何もないと思った。",
      "すぐ腹が立った。",
      "リラックスするのが難しかった。"
    ]
  };

  void _nextQuestion(int response) {
    print('SCORE: $response');
    final currentQuestionIndex = ref.read(currentQuestionIndexProvider);
    final responses = ref.read(responsesProvider.notifier);

    responses.state[currentQuestionIndex] = response;
    if (currentQuestionIndex < questions[widget.language].length - 1) {
      ref.read(currentQuestionIndexProvider.notifier).state++;
    } else {
      context.go('/dasresult', extra: _computeScores());
    }
  }

  void _previousQuestion() {
    final currentQuestionIndex = ref.read(currentQuestionIndexProvider);

    if (currentQuestionIndex > 0) {
      ref.read(currentQuestionIndexProvider.notifier).state--;
    } else {
      Navigator.pop(context);
    }
  }

  Map<String, int> _computeScores() {
    final responses = ref.read(responsesProvider);

    // Depression: Questions 3, 5, 10, 13, 16, 17, 21
    int depressionScore =
        responses[4] + responses[7] + responses[8] + responses[11];

    // Anxiety: Questions 2, 4, 7, 9, 15, 19, 20
    int anxietyScore =
        responses[1] + responses[3] + responses[9] + responses[10];

    // Stress: Questions 1, 6, 8, 11, 12, 14, 18
    int stressScore = responses[0] + responses[2] + responses[5] + responses[6];

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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // IconButton(
            //   icon: Icon(Icons.arrow_back),
            //   onPressed: _previousQuestion,
            // ),
            GestureDetector(
              onTap: _previousQuestion,
              child: Image.asset(
                'assets/utils/brownBack.png',
                width: 25,
                height: 25,
              ),
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
                  value: (currentQuestionIndex + 1) /
                      questions[widget.language].length,
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
                "Question ${currentQuestionIndex + 1} of ${questions[widget.language].length}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mindfulBrown['Brown80']),
              ),
            ),
            SizedBox(height: 20),
            Center(
                child: Text(
              questions[widget.language][currentQuestionIndex],
              style: TextStyle(fontSize: 36, color: mindfulBrown['Brown80']),
            )),
            Spacer(),
            Column(
              children: List.generate(4, (index) {
                int reversedIndex = 3 - index;
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomButton(
                      text: option[widget.language][reversedIndex],
                      onPressed: () => _nextQuestion(reversedIndex),
                      fontSize: 16,
                    )
                    // SizedBox(
                    //   height: 60,
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     onPressed: () => _nextQuestion(index),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: mindfulBrown['Brown80'],
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(30),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       option[widget.language][index],
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontSize: 16, color: Colors.white),
                    //     ),
                    //   ),
                    // ),

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
