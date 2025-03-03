import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/const/loading_screen.dart';
import 'package:lingap/features/mindfulness/data/supabase.dart';
import 'package:lingap/features/mindfulness/services/recommender_api.dart';

class NewExercisePage extends StatefulWidget {
  @override
  _NewExercisePageState createState() => _NewExercisePageState();
}

class _NewExercisePageState extends State<NewExercisePage> {
  int selectedMinutes = 0;
  int selectedSeconds = 0;
  String selectedOption = 'Breathing';

  final SupabaseDB supabase = SupabaseDB(client);
  final RecommenderApi recommenderApi = RecommenderApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mindfulBrown['Brown10'],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Exercise',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: mindfulBrown['Brown80'],
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Choose your mindful exercise",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: mindfulBrown['Brown80'],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Exercise Options
                    buildExpandableCard(
                      title: "Breathing",
                      description:
                          "Controlled breathing exercises help calm the mind and reduce stress. Example: Inhale for 4 seconds, hold for 4 seconds, and exhale for 4 seconds.",
                      color: serenityGreen['Green50']!,
                      value: "Breathing",
                    ),
                    buildExpandableCard(
                      title: "Relaxation",
                      description:
                          "Relaxation techniques such as progressive muscle relaxation reduce tension and anxiety. Example: Tense and relax each muscle group from toes to head.",
                      color: empathyOrange['Orange50']!,
                      value: "Relaxation",
                    ),
                    buildExpandableCard(
                      title: "Sleep",
                      description:
                          "Sleep exercises improve rest quality and combat insomnia. Example: Try a guided body scan before bed to ease into sleep.",
                      color: mindfulBrown['Brown50']!,
                      value: "Sleep",
                    ),
                    buildExpandableCard(
                      title: "Meditation",
                      description:
                          "Meditation improves focus and reduces stress. Example: Close your eyes and focus on your breath, letting thoughts pass without judgment.",
                      color: zenYellow['Yellow50']!,
                      value: "Meditation",
                    ),

                    SizedBox(height: 40),

                    Center(
                      child: Text(
                        "How many minutes do you need?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: mindfulBrown['Brown80'],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    _buildDuration(),

                    SizedBox(height: 40),

                    // Create Button - Fixed Overflow Issue
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          LoadingScreen.show(context);
                          final response = await recommenderApi.queryResponse(
                              selectedOption, selectedMinutes);
                          await supabase.insertMindfulness(
                              // goal.text,
                              selectedSeconds,
                              selectedMinutes,
                              // response['recommended_exercise'],
                              selectedOption,
                              response['soundtrack_id'],
                              uid);

                          LoadingScreen.hide(context);
                          context.go('/bottom-nav');
                          Future.microtask(() {
                            context.push('/mindful-home');
                            context.push('/mindful-player', extra: {
                              'song': response['sound_name'],
                              'min': selectedMinutes,
                              'sec': selectedSeconds,
                              'url': response['soundtrack_url']
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mindfulBrown['Brown80'],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildExpandableCard({
    required String title,
    required String description,
    required Color color,
    required String value,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
      color: color,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedOption = value;
          });
        },
        child: ExpansionTile(
          initiallyExpanded: selectedOption == value,
          tilePadding: EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: EdgeInsets.all(16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Radio<String>(
                value: value,
                groupValue: selectedOption,
                onChanged: (newValue) {
                  setState(() {
                    selectedOption = newValue!;
                  });
                },
                activeColor: Colors.white, // White radio button
                fillColor: MaterialStateProperty.all(Colors.white),
              ),
            ],
          ),
          trailing: SizedBox.shrink(), // Remove the arrow
          onExpansionChanged: (isExpanded) {
            setState(() {
              selectedOption = value;
            });
          },
          children: [
            Text(description, style: TextStyle(color: Colors.white,
              fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDuration() {
    return SizedBox(
      height: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Minutes Wheel
          _buildWheel((index) {
            setState(() {
              selectedMinutes = index;
            });
          }, selectedMinutes),
          Text(":",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          // Seconds Wheel
          _buildWheel((index) {
            setState(() {
              selectedSeconds = index;
            });
          }, selectedSeconds),
        ],
      ),
    );
  }

  Widget _buildWheel(Function(int) onSelected, int selectedValue) {
    return SizedBox(
      width: 80,
      height: 240,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 80,
        perspective: 0.005,
        diameterRatio: 2.5,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelected,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final double difference =
                (index - selectedValue).abs().toDouble(); // Use selectedValue
            final double scaleFactor = 1.0 - (difference * 0.2).clamp(0.0, 0.4);
            final double opacityFactor =
                1.0 - (difference * 0.3).clamp(0.0, 0.6);

            return Transform.scale(
              scale: scaleFactor,
              child: Opacity(
                opacity: opacityFactor,
                child: Center(
                  child: Text(
                    '${index.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: difference == 0
                          ? mindfulBrown['Brown80']
                          : optimisticGray['Gray50'],
                      fontSize: 54 * scaleFactor, // Scale text size dynamically
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: 60,
        ),
      ),
    );
  }
}
