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
  final SupabaseDB supabase = SupabaseDB(client);
  final RecommenderApi recommenderApi = RecommenderApi();
  TextEditingController goal = TextEditingController();

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
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text("What's your mindful exercise goal?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: mindfulBrown['Brown80'])),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(30), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12), // Padding for better spacing
                        child: TextField(
                          controller: goal,
                          style: TextStyle(
                            color: mindfulBrown['Brown80'],
                          ),
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                "Enter your goal... e.g., 'I want to feel calm' or 'I want a good nap.'",
                            hintStyle: TextStyle(
                                color: optimisticGray['Gray50'],
                                fontStyle: FontStyle.italic),
                            border: InputBorder.none, // No border
                            enabledBorder:
                                InputBorder.none, // No border when not focused
                            focusedBorder:
                                InputBorder.none, // No border when focused
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: Text("How many minutes do you need?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: mindfulBrown['Brown80'])),
                      ),
                      SizedBox(height: 8),
                      Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0,
                          child: SizedBox(
                            height:
                                220, // Ensuring enough height for visibility
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Minutes Wheel
                                ClipRect(
                                  child: SizedBox(
                                    width: 80,
                                    height: 240,
                                    child: ListWheelScrollView.useDelegate(
                                      itemExtent: 80,
                                      physics: FixedExtentScrollPhysics(),
                                      perspective:
                                          0.005, // Slight perspective for depth
                                      diameterRatio:
                                          2.5, // Controls how much the items shrink
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          selectedMinutes = index;
                                        });
                                      },
                                      childDelegate:
                                          ListWheelChildBuilderDelegate(
                                        builder: (context, index) {
                                          final double difference =
                                              (index - selectedMinutes)
                                                  .abs()
                                                  .toDouble();
                                          final double scaleFactor = 1.0 -
                                              (difference * 0.2)
                                                  .clamp(0.0, 0.4);
                                          final double opacityFactor = 1.0 -
                                              (difference * 0.3)
                                                  .clamp(0.0, 0.6);

                                          return Transform.scale(
                                            scale: scaleFactor,
                                            child: Opacity(
                                              opacity: opacityFactor,
                                              child: Center(
                                                child: Text(
                                                  '${index.toString().padLeft(2, '0')}',
                                                  style: TextStyle(
                                                    color: difference == 0
                                                        ? mindfulBrown[
                                                            'Brown80']
                                                        : optimisticGray[
                                                            'Gray50'],
                                                    fontSize: 54 *
                                                        scaleFactor, // Scale text size dynamically
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
                                  ),
                                ),
                                Text(
                                  ":",
                                  style: TextStyle(
                                    color: mindfulBrown['Brown80'],
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Seconds Wheel
                                ClipRect(
                                  child: SizedBox(
                                    width: 80,
                                    height: 240,
                                    child: ListWheelScrollView.useDelegate(
                                      itemExtent: 80,
                                      physics: FixedExtentScrollPhysics(),
                                      perspective: 0.005,
                                      diameterRatio: 2.5,
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          selectedSeconds = index;
                                        });
                                      },
                                      childDelegate:
                                          ListWheelChildBuilderDelegate(
                                        builder: (context, index) {
                                          final double difference =
                                              (index - selectedSeconds)
                                                  .abs()
                                                  .toDouble();
                                          final double scaleFactor = 1.0 -
                                              (difference * 0.2)
                                                  .clamp(0.0, 0.4);
                                          final double opacityFactor = 1.0 -
                                              (difference * 0.3)
                                                  .clamp(0.0, 0.6);

                                          return Transform.scale(
                                            scale: scaleFactor,
                                            child: Opacity(
                                              opacity: opacityFactor,
                                              child: Center(
                                                child: Text(
                                                  '${index.toString().padLeft(2, '0')}',
                                                  style: TextStyle(
                                                    color: difference == 0
                                                        ? mindfulBrown[
                                                            'Brown80']
                                                        : optimisticGray[
                                                            'Gray50'],
                                                    fontSize: 54 * scaleFactor,
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
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Spacer(),
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            LoadingScreen.show(context);
                            final response = await recommenderApi.queryResponse(
                                goal.text, selectedMinutes);
                            await supabase.insertMindfulness(
                                goal.text,
                                selectedSeconds,
                                selectedMinutes,
                                response['recommended_exercise'],
                                response['soundtrack_id'],
                                uid);

                            LoadingScreen.hide(context);
                            print(response);
                            context.go('/bottom-nav');
                            Future.microtask(() {
                              context.push('/mindful-home');
                              context.push('/mindful-player', extra: {
                                'song': response['sound_name'],
                                'min': selectedMinutes,
                                'sec': selectedSeconds,
                                'url': response['soundtrack_url']
                              }); // Adds Profile on top of Home
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
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ))));
      }),
    );
  }
}
