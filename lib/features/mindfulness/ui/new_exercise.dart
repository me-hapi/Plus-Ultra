import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/mindfulness/data/supabase.dart';

class NewExercisePage extends StatefulWidget {
  @override
  _NewExercisePageState createState() => _NewExercisePageState();
}

class _NewExercisePageState extends State<NewExercisePage> {
  int selectedMinutes = 0;
  int selectedSeconds = 0;
  final SupabaseDB supabase = SupabaseDB(client);

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
            fontSize: 24,
            color: mindfulBrown['Brown80'],
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Padding(
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
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12), // Padding for better spacing
              child: TextField(
                style: TextStyle(
                  color: mindfulBrown['Brown80'],
                ),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter your goal...',
                  hintStyle: TextStyle(
                    color: mindfulBrown['Brown80'],
                  ),
                  border: InputBorder.none, // No border
                  enabledBorder: InputBorder.none, // No border when not focused
                  focusedBorder: InputBorder.none, // No border when focused
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
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRect(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 80,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedMinutes = index;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Center(
                                child: Text(
                                  '${index.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                      color: mindfulBrown['Brown80'],
                                      fontSize: 54,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                            childCount: 60,
                          ),
                        ),
                      ),
                    ),
                    Text(":",
                        style: TextStyle(
                            color: mindfulBrown['Brown80'],
                            fontSize: 48,
                            fontWeight: FontWeight.bold)),
                    ClipRect(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 80,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedSeconds = index;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Center(
                                child: Text(
                                  '${index.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                      color: mindfulBrown['Brown80'],
                                      fontSize: 54,
                                      fontWeight: FontWeight.bold),
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
              ),
            ),
            SizedBox(height: 20),
            // Center(
            //   child: Text(
            //     "Selected Time: ${selectedMinutes.toString().padLeft(2, '0')}:${selectedSeconds.toString().padLeft(2, '0')}",
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
            Spacer(),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  context.push('/mindful-player',
                      extra: {'song': 'Zen Yoga', 'min': 5, 'sec': 50});
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
      ),
    );
  }
}
