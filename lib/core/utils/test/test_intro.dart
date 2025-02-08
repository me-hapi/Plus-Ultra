import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';

class TestIntro extends StatelessWidget {
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
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'DAS-12 \nPre-Assessment Tool',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: SingleChildScrollView(
                child: Text(
                  '\tIntroduction to the DASS-21 Test for Lingap\n\n'
                  '\tThe Depression, Anxiety, and Stress Scale-21 (DASS-21) is a widely recognized psychological assessment tool designed to measure the emotional states of depression, anxiety, and stress. It consists of 21 self-report items, divided equally into three subscales, each aimed at evaluating one of these core emotional dimensions. The test is a shorter version of the original DASS-42, making it more practical while retaining its reliability and validity.\n\n'
                  '\tThe purpose of the DASS-21 is to provide a quick, yet comprehensive, snapshot of an individual\'s emotional well-being. By identifying the severity of symptoms associated with depression, anxiety, and stress, the test helps uncover areas that may require further attention or intervention. Its results can offer valuable insights into mental health, enabling tailored support and monitoring.\n\n'
                  '\tIn Lingap, the DASS-21 test is administered as part of our commitment to providing personalized and holistic mental health care. This assessment serves several key purposes:\n\n'
                  '\t1. Initial Screening: It helps establish a baseline understanding of the user\'s mental health, allowing the platform to tailor interventions to their specific needs.\n\n'
                  '\t2. Monitoring Progress: Repeated assessments can track changes over time, highlighting improvements or areas that may need further focus.\n\n'
                  '\t3. Personalized Recommendations: Based on the results, Lingap can offer targeted advice, therapeutic exercises, and resources that align with the user’s unique emotional state.\n\n'
                  '\t4. Professional Support: For users requiring deeper intervention, the DASS-21 results can guide referrals to licensed mental health professionals available within Lingap.\n\n'
                  '\tBy integrating the DASS-21 into Lingap, we aim to foster a proactive and user-centered approach to mental health care, ensuring that individuals receive the support they need in a timely and effective manner.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/dastest');
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
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

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
