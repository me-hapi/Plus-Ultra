import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';

class TestIntro extends StatefulWidget {
  @override
  _TestIntroState createState() => _TestIntroState();
}

class _TestIntroState extends State<TestIntro> {
  String selectedLanguage = 'English';

  final Map<String, String> translations = {
    'English': 'Depression, Anxiety, and Stress Scale-12 (DASS-12)',
    'French': 'Échelle de Dépression, Anxiété et Stress-12 (DASS-12)',
    'Indonesian': 'Skala Depresi, Kecemasan, dan Stres-12 (DASS-12)',
    'Malaysian': 'Skala Kemurungan, Kebimbangan, dan Tekanan-12 (DASS-12)',
    'Thai': 'มาตรวัดความเครียด ความวิตกกังวล และภาวะซึมเศร้า-12 (DASS-12)',
    'Vietnamese': 'Thang đo Trầm cảm, Lo âu và Căng thẳng-12 (DASS-12)',
    'Japanese': '抑うつ、不安、ストレス尺度-12 (DASS-12)',
    'Chinese': '抑郁、焦虑和压力量表-12 (DASS-12)',
    'Korean': '우울증, 불안 및 스트레스 척도-12(DASS-12)',
    'Filipino': 'Sukat ng Depresyon, Pag-aalala, at Stress-12 (DASS-12)',
  };

  final Map<String, String> theTranslation = {
    'English': 'The ',
    'Filipino': 'Ang ',
    'French': 'Le ',
  };

  final Map<String, String> bodyTranslations = {
    'English':
        ''' is a brief yet effective psychological assessment tool designed to measure emotional states related to depression, anxiety, and stress. It consists of 12 self-report questions, with four questions dedicated to each emotional dimension. This short format provides a practical and reliable assessment of mental health while maintaining robust validity.

At Lingap, the DASS-12 is an integral part of our commitment to providing personalized and holistic mental health care. This assessment serves several important purposes:

Initial Assessment: Establishes a baseline understanding of the client’s mental health in order to tailor interventions to their emotional needs.
Ongoing Monitoring: Periodic reassessments help track changes over time, identifying trends in emotional well-being.
Personalized Recommendations: Based on the test results, Lingap provides targeted advice, therapeutic exercise guides, and selected resources tailored to the user's emotional state.
Support from Professionals: For those who require more in-depth intervention, DASS-12 results can be used as a basis for counseling or referral to licensed mental health professionals within Lingap.

By integrating the DASS-12 into Lingap, we aim to empower users to have the right knowledge and proactive support for their mental health, ensuring that they receive the care they need in a personalized and effective manner.''',
    'Filipino':
        ''' ay isang maikli ngunit epektibong kasangkapan sa sikolohikal na pagtatasa na idinisenyo upang sukatin ang mga emosyonal na estado na may kaugnayan sa depresyon, pagkabalisa, at stress. Binubuo ito ng 12 tanong sa sariling pagtatasa, kung saan apat na tanong ang nakalaan para sa bawat emosyonal na dimensyon. Ang maikling format na ito ay nagbibigay ng isang praktikal at maaasahang pagsusuri ng kalusugang pangkaisipan habang pinapanatili ang matibay na bisa.

Sa Lingap, ang DASS-12 ay isang mahalagang bahagi ng aming pangako na magbigay ng personalisado at holistikong pangangalaga sa mental na kalusugan. Ang pagtatasa na ito ay may maraming mahahalagang layunin:

    Paunang Pagsusuri: Itinatakda ang batayang pag-unawa sa kalusugan ng isip ng gumagamit upang maiakma ang mga interbensyon ayon sa kanilang emosyonal na pangangailangan.
    Patuloy na Pagsubaybay: Ang mga pana-panahong muling pagsusuri ay tumutulong sa pagsubaybay sa mga pagbabago sa paglipas ng panahon, natutukoy ang mga uso sa emosyonal na kagalingan.
    Personal na Rekomendasyon: Batay sa mga resulta ng pagsusuri, nagbibigay ang Lingap ng mga naka-target na payo, mga gabay sa therapeutic exercises, at mga napiling mapagkukunan na naaayon sa emosyonal na kalagayan ng gumagamit.
    Suporta mula sa mga Propesyonal: Para sa mga nangangailangan ng mas malalim na interbensyon, ang mga resulta ng DASS-12 ay maaaring gamitin bilang batayan sa pagpapayo o pagpapasa sa mga lisensyadong propesyonal sa kalusugan ng isip sa loob ng Lingap.

Sa pamamagitan ng pagsasama ng DASS-12 sa Lingap, layunin naming bigyan ng kapangyarihan ang mga gumagamit na magkaroon ng tamang kaalaman at maagap na suporta sa kanilang kalusugang pangkaisipan, na tinitiyak na matatanggap nila ang kinakailangang pangangalaga sa isang personalisado at epektibong paraan.''',
    'French':
        ''' est un outil d'évaluation psychologique bref mais efficace conçu pour mesurer les états émotionnels liés à la dépression, à l’anxiété et au stress. Il se compose de 12 questions d’auto-évaluation, avec quatre questions dédiées à chaque dimension émotionnelle. Ce format concis offre un aperçu pratique et fiable du bien-être mental tout en maintenant une forte validité.

Dans Lingap, le DASS-12 joue un rôle essentiel dans notre engagement à fournir des soins de santé mentale personnalisés et holistiques. Cette évaluation remplit plusieurs objectifs clés :

    Dépistage initial : Fournit une compréhension de base de la santé mentale de l’utilisateur, permettant à Lingap d’adapter les interventions à ses besoins émotionnels spécifiques.
    Suivi continu : Des réévaluations périodiques permettent de suivre les évolutions au fil du temps et d’identifier les tendances du bien-être émotionnel.
    Recommandations personnalisées : En fonction des résultats du test, Lingap propose des conseils ciblés, des exercices thérapeutiques guidés et des ressources adaptées à l’état émotionnel de l’utilisateur.
    Soutien professionnel : Pour les utilisateurs nécessitant une intervention plus approfondie, les résultats du DASS-12 peuvent servir de guide pour des références à des professionnels de santé mentale agréés au sein de Lingap.

En intégrant le DASS-12 dans Lingap, nous visons à donner aux utilisateurs des informations opportunes et un soutien proactif en matière de santé mentale, garantissant ainsi qu’ils reçoivent des soins adaptés et efficaces.''',
    'Indonesian':
        ''' adalah alat penilaian psikologis yang singkat namun efektif yang dirancang untuk mengukur kondisi emosional yang berkaitan dengan depresi, kecemasan, dan stres. Terdiri dari 12 pertanyaan laporan diri, dengan empat pertanyaan didedikasikan untuk setiap dimensi emosional. Format yang ringkas ini memberikan gambaran yang praktis dan andal tentang kesejahteraan mental dengan validitas yang kuat.

Dalam Lingap, DASS-12 menjadi bagian penting dari komitmen kami dalam menyediakan perawatan kesehatan mental yang dipersonalisasi dan holistik. Penilaian ini memiliki beberapa tujuan utama:

    Skrining Awal: Menyediakan pemahaman dasar tentang kesehatan mental pengguna, memungkinkan Lingap untuk menyesuaikan intervensi sesuai dengan kebutuhan emosional mereka.
    Pemantauan Berkelanjutan: Evaluasi berkala membantu melacak perubahan seiring waktu, mengidentifikasi tren dalam kesejahteraan emosional.
    Rekomendasi yang Dipersonalisasi: Berdasarkan hasil tes, Lingap memberikan saran yang ditargetkan, latihan terapi terpandu, dan sumber daya yang selaras dengan kondisi emosional pengguna.
    Dukungan Profesional: Bagi pengguna yang membutuhkan intervensi lebih lanjut, hasil DASS-12 dapat digunakan sebagai panduan untuk rujukan ke profesional kesehatan mental berlisensi di Lingap.

Dengan mengintegrasikan DASS-12 ke dalam Lingap, kami bertujuan untuk memberdayakan pengguna dengan wawasan yang tepat waktu dan dukungan proaktif dalam kesehatan mental mereka, memastikan mereka mendapatkan perawatan yang mereka butuhkan dengan cara yang personal dan efektif.''',
    'Malaysian':
        ''' adalah alat penilaian psikologi yang ringkas tetapi berkesan untuk mengukur keadaan emosi berkaitan dengan kemurungan, kebimbangan, dan tekanan. Ia terdiri daripada 12 soalan penilaian kendiri, dengan empat soalan dikhaskan untuk setiap dimensi emosi. Format ringkas ini memberikan gambaran yang praktikal dan boleh dipercayai mengenai kesejahteraan mental sambil mengekalkan kesahihan yang kukuh.

Dalam Lingap, DASS-12 merupakan sebahagian penting daripada komitmen kami untuk menyediakan penjagaan kesihatan mental yang diperibadikan dan menyeluruh. Penilaian ini mempunyai beberapa tujuan utama:

    Saringan Awal: Menetapkan pemahaman asas mengenai kesihatan mental pengguna, membolehkan Lingap menyesuaikan intervensi mengikut keperluan emosi mereka.
    Pemantauan Berterusan: Penilaian berkala membantu menjejaki perubahan dari semasa ke semasa dan mengenal pasti corak kesejahteraan emosi.
    Cadangan Peribadi: Berdasarkan keputusan ujian, Lingap menyediakan nasihat yang disasarkan, latihan terapi berpanduan, dan sumber yang selaras dengan keadaan emosi pengguna.
    Sokongan Profesional: Bagi pengguna yang memerlukan intervensi lebih mendalam, keputusan DASS-12 boleh digunakan sebagai panduan untuk rujukan kepada profesional kesihatan mental yang berlesen dalam Lingap.

Dengan mengintegrasikan DASS-12 ke dalam Lingap, kami berhasrat untuk memberi pengguna pemahaman yang tepat pada masanya dan sokongan proaktif terhadap kesihatan mental mereka, memastikan mereka menerima penjagaan yang diperlukan secara peribadi dan berkesan.''',
    'Thai':
        ''' เป็นเครื่องมือประเมินทางจิตวิทยาที่สั้นแต่มีประสิทธิภาพ ออกแบบมาเพื่อวัดสภาวะทางอารมณ์ที่เกี่ยวข้องกับภาวะซึมเศร้า ความวิตกกังวล และความเครียด ประกอบด้วยคำถามการประเมินตนเอง 12 ข้อ โดยแต่ละด้านอารมณ์มี 4 คำถาม รูปแบบที่กระชับนี้ให้ข้อมูลเชิงลึกที่แม่นยำและเชื่อถือได้เกี่ยวกับสุขภาพจิต

ใน Lingap DASS-12 เป็นส่วนสำคัญของความมุ่งมั่นของเราในการให้บริการดูแลสุขภาพจิตแบบเฉพาะบุคคลและครอบคลุม การประเมินนี้มีวัตถุประสงค์หลักหลายประการ:

    การคัดกรองเบื้องต้น: สร้างความเข้าใจพื้นฐานเกี่ยวกับสุขภาพจิตของผู้ใช้ ทำให้ Lingap สามารถปรับการช่วยเหลือให้เหมาะสมกับความต้องการทางอารมณ์ของพวกเขา
    การติดตามอย่างต่อเนื่อง: การประเมินเป็นระยะช่วยติดตามการเปลี่ยนแปลงของสภาวะอารมณ์เมื่อเวลาผ่านไป
    คำแนะนำเฉพาะบุคคล: ตามผลการทดสอบ Lingap ให้คำแนะนำที่เหมาะสม พร้อมแบบฝึกหัดบำบัด และแหล่งข้อมูลที่ตรงกับสภาวะอารมณ์ของผู้ใช้
    การสนับสนุนจากผู้เชี่ยวชาญ: สำหรับผู้ใช้ที่ต้องการความช่วยเหลือเพิ่มเติม ผลลัพธ์ของ DASS-12 สามารถใช้เป็นแนวทางในการส่งต่อไปยังผู้เชี่ยวชาญด้านสุขภาพจิตที่ได้รับใบอนุญาต

การรวม DASS-12 เข้ากับ Lingap มีเป้าหมายเพื่อช่วยให้ผู้ใช้มีความเข้าใจและได้รับการสนับสนุนที่รวดเร็วและตรงจุด''',
    'Vietnamese':
        ''' là một công cụ đánh giá tâm lý ngắn gọn nhưng hiệu quả, được thiết kế để đo lường trạng thái cảm xúc liên quan đến trầm cảm, lo âu và căng thẳng. Nó bao gồm 12 câu hỏi tự đánh giá, với bốn câu hỏi dành riêng cho mỗi khía cạnh cảm xúc.

Trong Lingap, DASS-12 đóng vai trò quan trọng trong cam kết cung cấp dịch vụ chăm sóc sức khỏe tâm thần toàn diện và cá nhân hóa. Đánh giá này có một số mục tiêu chính:

    Sàng lọc ban đầu: Giúp hiểu rõ tình trạng tâm lý ban đầu của người dùng để điều chỉnh các biện pháp can thiệp phù hợp.
    Giám sát liên tục: Các đánh giá định kỳ giúp theo dõi sự thay đổi trong trạng thái cảm xúc theo thời gian.
    Khuyến nghị cá nhân hóa: Dựa trên kết quả kiểm tra, Lingap cung cấp lời khuyên phù hợp, bài tập trị liệu và tài nguyên hữu ích.
    Hỗ trợ chuyên gia: Đối với những người cần can thiệp sâu hơn, kết quả DASS-12 có thể được sử dụng để giới thiệu đến các chuyên gia tâm lý có chứng nhận.

Việc tích hợp DASS-12 vào Lingap giúp cung cấp sự hỗ trợ kịp thời và hiệu quả cho sức khỏe tâm thần người dùng.''',
    'Japanese':
        ''' は、うつ、不安、ストレスに関連する感情状態を測定するために設計された、簡潔で効果的な心理評価ツールです。12 の自己評価項目で構成されており、それぞれの感情次元に 4 つの質問が割り当てられています。

Lingap では、DASS-12 を取り入れ、個別対応型の包括的なメンタルヘルスケアを提供することを目指しています。主な目的は次のとおりです:

    初期スクリーニング: ユーザーのメンタルヘルスの基礎を把握し、それに基づいて適切なサポートを提供する。
    継続的なモニタリング: 定期的な再評価により、精神状態の変化を把握し、トレンドを特定する。
    個別化された推奨: テスト結果に基づき、具体的なアドバイスやセラピーのガイド付きエクササイズを提供する。
    専門家の支援: 必要な場合、DASS-12 の結果を基にメンタルヘルス専門家への紹介を行う。

Lingap に DASS-12 を統合することで、ユーザーに適切なサポートを提供します。''',
    'Chinese':
        ''' 是一種簡短但有效的心理評估工具，旨在測量與憂鬱、焦慮和壓力相關的情緒狀態。它由 12 個自我評估問題組成，其中每個情緒維度保留 4 個問題。這種簡短的格式提供了實用且可靠的心理健康評估，同時保持了強大的有效性。

在 Lingap，DASS-12 是我們致力於提供個人化和整體心理健康護理的一個組成部分。該評估有幾個重要目標：

 初步評估：建立對客戶心理健康的基線了解，以便根據他們的情感需求制定乾預措施。
 持續監控：定期重新評估有助於追蹤一段時間內的變化，識別情緒健康的趨勢。
 個人化推薦：根據分析結果，Lingap根據使用者的情緒狀態提供有針對性的建議、治療練習指南和精選資源。
 專業人士的支持：對於需要更深入介入的人，DASS-12 結果可以作為諮詢或轉介給 Lingap 內有執照的心理健康專業人士的基礎。

透過將 DASS-12 與 Lingap 集成，我們的目標是讓使用者在心理健康方面獲得正確的知識和積極的支持，確保他們以個性化和有效的方式獲得必要的護理。''',
    'Korean':
        ''' 는 우울증, 불안, 스트레스와 관련된 감정 상태를 측정하도록 설계된 간단하지만 효과적인 심리 평가 도구입니다. 12개의 자기 평가 질문으로 구성되어 있으며, 그 중 각 감정 차원에 대해 4개의 질문이 예약되어 있습니다. 이 간략한 형식은 강력한 타당성을 유지하면서 정신 건강에 대한 실용적이고 신뢰할 수 있는 평가를 제공합니다.

Lingap에서 DASS-12는 개인화되고 전체적인 정신 건강 관리를 제공하겠다는 약속의 필수적인 부분입니다. 이 평가에는 몇 가지 중요한 목표가 있습니다.

 1. 예비 평가: 고객의 정서적 요구에 맞게 중재를 조정하기 위해 고객의 정신 건강에 대한 기본 이해를 확립합니다.
 2. 지속적인 모니터링: 주기적인 재평가는 시간에 따른 변화를 추적하고 정서적 웰빙의 추세를 파악하는 데 도움이 됩니다.
 3.개인 추천: 분석 결과를 바탕으로 Lingap은 사용자의 감정 상태에 따라 목표에 맞는 조언, 치료 운동 안내 및 선택된 리소스를 제공합니다.
 4. 전문가의 지원: 보다 심층적인 개입이 필요한 사람들의 경우 DASS-12 결과는 Lingap 내에서 자격증을 갖춘 정신 건강 전문가에게 상담하거나 의뢰하기 위한 기초로 사용될 수 있습니다.

DASS-12를 Lingap과 통합함으로써 우리는 사용자가 정신 건강에 대한 올바른 지식과 사전 지원을 받을 수 있도록 지원하여 개인화되고 효과적인 방식으로 필요한 치료를 받을 수 있도록 하는 것을 목표로 합니다.''',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: ConvexBottomClipper(),
                child: Container(
                  height: 200,
                  color: serenityGreen['Green50'],
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'DAS-12 \nPre-Assessment Tool',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// Translate Dropdown Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButton<String>(
              value: selectedLanguage,
              icon: Icon(Icons.translate, color: mindfulBrown['Brown80']),
              underline: Container(height: 2, color: mindfulBrown['Brown80']),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedLanguage = newValue;
                  });
                }
              },
              items: translations.keys.map<DropdownMenuItem<String>>(
                (String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(
                      language,
                      style: TextStyle(color: mindfulBrown['Brown80']),
                    ),
                  );
                },
              ).toList(),
            ),
          ),

          SizedBox(height: 10),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: SingleChildScrollView(
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: mindfulBrown['Brown80'],
                    ),
                    children: [
                      if (theTranslation.keys.contains(selectedLanguage))
                        TextSpan(text: theTranslation[selectedLanguage]),
                      TextSpan(
                        text: translations[selectedLanguage] ??
                            translations['English']!,
                        style: TextStyle(
                          color:
                              serenityGreen['Green50'], // Highlighted in green
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: bodyTranslations[selectedLanguage]),
                    ],
                  ),
                  textAlign: TextAlign.justify, // Justify text
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: 
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/dastest', extra: selectedLanguage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mindfulBrown['Brown80'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

/// Convex Clip for Header
class ConvexBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height + 30, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
