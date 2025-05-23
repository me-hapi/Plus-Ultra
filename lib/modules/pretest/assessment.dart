import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/const/custom_button.dart';
import 'package:lingap/core/utils/shared/shared_pref.dart';
import 'package:lingap/services/database/global_supabase.dart';

// Import the question components
import 'display_name.dart';
import 'display_age.dart';
import 'display_weight.dart';
import 'display_mood.dart';
import 'display_sleep.dart';
import 'display_things.dart';

class AssessmentScreen extends StatefulWidget {
  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final GlobalSupabase supabase = GlobalSupabase(client);
  int currentIndex = 0;
  final Map<String, dynamic> responses = {};
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Set your display name and choose an avatar!',
      'widget':
          (Function(String) onNameUpdate, Function(String?) onProfileUpdate) =>
              DisplayName(
                onNameChanged: (name) {
                  onNameUpdate(name); // Update the name in responses
                },
                onProfileChanged: (profilePicture) {
                  onProfileUpdate(
                      profilePicture); // Update the profile picture in responses
                },
              ),
      'key': 'name', // Key for the name
      'profilePictureKey': 'profilePicture', // Key for the profile picture
    },
    {
      'question': 'What\'s your age?',
      'widget': (Function(int) onUpdate) => DisplayAge(
            onAgeSelected: (age) {
              onUpdate(age); // Update the responses map
            },
          ),
      'key': 'age', // Key to identify this response
    },
    {
      'question': 'What\'s your weight?',
      'widget': (Function(Map<String, dynamic>) onUpdate) => DisplayWeight(
            onWeightSelected: (weight, unit) {
              onUpdate(
                  {'weight': weight, 'unit': unit}); // Update the responses map
            },
          ),
      'key': 'weight', // Key to identify this response
    },
    {
      'question': 'How would you describe your mood?',
      'widget': (Function(String) onUpdate) => DisplayMood(
            onMoodSelected: (mood) {
              onUpdate(mood); // Update the responses map
            },
          ),
      'key': 'mood', // Key to identify this response
    },
    {
      'question': 'How would you rate your sleep quality?',
      'widget': (Function(String) onUpdate) => DisplaySleep(
            onSleepSelected: (sleepQuality) {
              onUpdate(sleepQuality); // Update the responses map
            },
          ),
      'key': 'sleepQuality', // Key to identify this response
    },
    // {
    //   'question': 'What are the things that make you happy?',
    //   'widget': (Function(List<String>) onUpdate) => DisplayThings(
    //     onThingsUpdated: (updatedThingsList) {
    //       onUpdate(updatedThingsList); // Update the responses map
    //     },
    //   ),
    //   'key': 'happyThings', // Key to identify this response
    // },
  ];

  @override
  void initState() {
    super.initState();

    responses['profilePicture'] = 'assets/profile/profile1.png';
    for (var question in questions) {
      if (!responses.containsKey(question['key'])) {
        // Assign default values based on the expected type
        if (question['key'] == 'name') {
          responses['name'] = 'Anonymous';
        } else if (question['key'] == 'age') {
          responses['age'] = 18; // Default age
        } else if (question['key'] == 'weight') {
          responses['weight'] = {'weight': 60, 'unit': 'kg'}; // Default weight
        } else if (question['key'] == 'mood') {
          responses['mood'] = 'Neutral'; // Default mood
        } else if (question['key'] == 'sleepQuality') {
          responses['sleepQuality'] = 'Fair'; // Default sleep quality
        }
      }
    }
  }

  Future<void> nextQuestion() async {
    print(responses);
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      if (await supabase.insertResponses(responses)) {
        context.go('/test-intro');
      }
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: previousQuestion,
        ),
        title: Container(
          width: 280,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: mindfulBrown['Brown20'],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              backgroundColor: Colors.transparent,
              valueColor:
                  AlwaysStoppedAnimation<Color>(serenityGreen['Green50']!),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: mindfulBrown['Brown10'],
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            Text(
              questions[currentIndex]['question'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Center(
                  child: currentIndex == 0
                      ? questions[currentIndex]['widget'](
                          (value) {
                            setState(() {
                              // Update the response for the current question's key
                              responses[questions[currentIndex]['key']] = value;
                            });
                          },
                          (profilePicture) {
                            setState(() {
                              responses[questions[currentIndex]
                                  ['profilePictureKey']] = profilePicture;
                            });
                          },
                        )
                      : questions[currentIndex]['widget']((value) {
                          setState(() {
                            // Update the response for the current question's key
                            responses[questions[currentIndex]['key']] = value;
                          });
                        })),
            ),

            CustomButton(text: 'Continue', onPressed: nextQuestion, isPadding: false,),
            // SizedBox(
            //   height: 55,
            //   width: double.infinity,
            //   child: TextButton(
            //     onPressed: nextQuestion,
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
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
