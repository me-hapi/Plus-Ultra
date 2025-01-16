import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
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
  late final int maxScore;

  @override
  void initState() {
    super.initState();
    interpreter = DASInterpreter();
    maxScore =
        widget.depressionAmount + widget.anxietyAmount + widget.stressAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      child: _buildCircle(
                        context,
                        size: widget.depressionAmount / maxScore * 400,
                        color: kindPurple['Purple30']!,
                        value: widget.depressionAmount,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: _buildCircle(
                            context,
                            size: widget.anxietyAmount / maxScore * 400,
                            color: empathyOrange['Orange30']!,
                            value: widget.anxietyAmount,
                          ),
                        ),
                        SizedBox(width: 16),
                        Center(
                          child: _buildCircle(
                            context,
                            size: widget.stressAmount / maxScore * 400,
                            color: serenityGreen['Green30']!,
                            value: widget.stressAmount,
                          ),
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
                        interpreter.getInterpretation(
                            'depression', widget.depressionAmount),
                        kindPurple['Purple30']!),
                    _buildLegend(
                        'Anxiety',
                        interpreter.getInterpretation(
                            'anxiety', widget.anxietyAmount),
                        empathyOrange['Orange30']!),
                    _buildLegend(
                        'Stress',
                        interpreter.getInterpretation(
                            'stress', widget.stressAmount),
                        serenityGreen['Green30']!),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/bottom-nav');
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
        ],
      ),
    );
  }

  Widget _buildCircle(
    BuildContext context, {
    required double size,
    required Color color,
    required int value,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        value.toString(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
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
