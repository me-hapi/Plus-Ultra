import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/custom_button.dart';
import 'package:lingap/core/const/das_interpretation.dart';

class DasResultPage extends StatefulWidget {
  final int depressionAmount;
  final int anxietyAmount;
  final int stressAmount;

  DasResultPage({
    required this.depressionAmount,
    required this.anxietyAmount,
    required this.stressAmount,
  });

  @override
  _DasResultPageState createState() => _DasResultPageState();
}

class _DasResultPageState extends State<DasResultPage> {
  late final DASInterpreter interpreter;
  final int maxDepression = 12;
  final int maxAnxiety = 12;
  final int maxStress = 12;

  @override
  void initState() {
    super.initState();
    interpreter = DASInterpreter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mindfulBrown['Brown10'],
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(
                          'DAS-21 Result',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: mindfulBrown['Brown80'],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Center(
                          child: _buildCircle(context,
                              size: ((widget.depressionAmount / maxDepression) +
                                      0.25) *
                                  150,
                              color: kindPurple['Purple50']!,
                              value: widget.depressionAmount,
                              category: 'depression'),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: _buildCircle(context,
                                  size: ((widget.anxietyAmount / maxAnxiety) +
                                          0.25) *
                                      150,
                                  color: empathyOrange['Orange50']!,
                                  value: widget.anxietyAmount,
                                  category: 'anxiety'),
                            ),
                            SizedBox(width: 16),
                            Center(
                              child: _buildCircle(context,
                                  size: ((widget.stressAmount / maxAnxiety) +
                                          0.25) *
                                      150,
                                  color: serenityGreen['Green50']!,
                                  value: widget.stressAmount,
                                  category: 'stress'),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegend(
                            'Depression',
                            interpreter.getInterpretation('depression',
                                widget.depressionAmount)['interpretation'],
                            kindPurple['Purple50']!),
                        _buildLegend(
                            'Anxiety',
                            interpreter.getInterpretation('anxiety',
                                widget.anxietyAmount)['interpretation'],
                            empathyOrange['Orange50']!),
                        _buildLegend(
                            'Stress',
                            interpreter.getInterpretation('stress',
                                widget.stressAmount)['interpretation'],
                            serenityGreen['Green50']!),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Depression',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mindfulBrown['Brown80']),
                          ),
                          Text(
                            interpreter.getInterpretation('depression',
                                widget.depressionAmount)['meanings'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: optimisticGray['Gray50']),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Anxiety',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mindfulBrown['Brown80']),
                          ),
                          Text(
                            interpreter.getInterpretation(
                                'anxiety', widget.anxietyAmount)['meanings'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: optimisticGray['Gray50']),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Stress',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mindfulBrown['Brown80']),
                          ),
                          Text(
                            interpreter.getInterpretation(
                                'stress', widget.stressAmount)['meanings'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: optimisticGray['Gray50']),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CustomButton(
                      text: 'Continue',
                      onPressed: () {
                        context.push('/bottom-nav');
                      },
                      isPadding: false,
                    ),
                    // SizedBox(
                    //   height: 60,
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       context.push('/bottom-nav');
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: mindfulBrown['Brown80'],
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(30),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'Continue',
                    //       style: TextStyle(fontSize: 18, color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),

              // Positioned(
              //   bottom: 20,
              //   left: 16,
              //   right: 16,
              //   child: SizedBox(
              //     height: 60,
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       onPressed: () {
              //         context.push('/bottom-nav');
              //       },
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: mindfulBrown['Brown80'],
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(30),
              //         ),
              //       ),
              //       child: Text(
              //         'Continue',
              //         style: TextStyle(fontSize: 18, color: Colors.white),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }

  Widget _buildCircle(BuildContext context,
      {required double size,
      required Color color,
      required int value,
      required String category}) {
    String percent = '%';
    switch (category) {
      case 'depression':
        percent = '${((value / maxDepression) * 100).toInt()}%';
        break;
      case 'anxiety':
        percent = '${((value / maxAnxiety) * 100).toInt()}%';
        break;
      case 'stress':
        percent = '${((value / maxStress) * 100).toInt()}%';
        break;
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        percent,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLegend(String label, String interpretation, Color color) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 15),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: mindfulBrown['Brown80']),
        ),
        SizedBox(height: 2),
        Text(
          interpretation,
          style: TextStyle(fontSize: 14, color: mindfulBrown['Brown80']),
        ),
      ],
    );
  }
}
