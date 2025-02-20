import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';

class MoodModal extends StatelessWidget {
  final String mood;

  MoodModal({required this.mood});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> moodData = getMoodData(mood);

    return GestureDetector(
      onTap: () {
        context.go('/bottom-nav'); 
      },
      child: Container(
        child: Center(
          child: Container(
            width: 350,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display image based on mood
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/tracker/set_mood.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                // Mood-based title
                Text(
                  moodData['title'],
                  style: TextStyle(fontSize: 24, color: mindfulBrown['Brown80']),
                ),
                SizedBox(height: 8),
                // Mood-based message
                Text(
                  moodData['message'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: optimisticGray['Gray50']),
                ),
                SizedBox(height: 20),
                // "Go to Profile" button
                Container(
                  decoration: BoxDecoration(
                    color: mindfulBrown['Brown80'],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: TextButton(
                    onPressed: () {
                      context.go('/bottom-nav');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Go to Home',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns a message, title, and image path based on the mood
  Map<String, dynamic> getMoodData(String mood) {
    switch (mood.toLowerCase()) {
      case 'cheerful':
        return {
          'title': 'You’re Radiating Joy!',
          'message': 'Your cheerful mood is contagious! Keep spreading positivity.',
          'image': 'assets/mood/cheerful.png',
        };
      case 'happy':
        return {
          'title': 'Feeling Good!',
          'message': 'It’s great to hear that you’re happy! Enjoy your day!',
          'image': 'assets/mood/happy.png',
        };
      case 'neutral':
        return {
          'title': 'A Balanced Mood',
          'message': 'You’re feeling neutral today. Hope something brightens your day!',
          'image': 'assets/mood/neutral.png',
        };
      case 'sad':
        return {
          'title': 'It’s Okay to Feel Sad',
          'message': 'Take your time to process your emotions. You’re not alone.',
          'image': 'assets/mood/sad.png',
        };
      case 'awful':
        return {
          'title': 'Rough Day?',
          'message': 'Hang in there. Remember, tough times don’t last forever. We’re here for you.',
          'image': 'assets/mood/awful.png',
        };
      default:
        return {
          'title': 'Mood Recorded',
          'message': 'Your mood has been noted. Hope you have a good day!',
          'image': 'assets/mood/default.png',
        };
    }
  }
}
