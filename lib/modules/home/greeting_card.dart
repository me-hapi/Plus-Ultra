import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';

class GreetingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current date formatted as "January 15, 2025"
    final currentDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: mindfulBrown['Brown80'],
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentDate,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: Colors.white,
                  onPressed: () {
                    // NOTIFICATION FUNCTION
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    context.push('/profile');
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.person, size: 24, color: Colors.white),
                    backgroundColor: Colors.grey,
                    radius: 40,
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Shinomiya!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'How was you sleep?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEmojiButton('Cheerful', 'assets/mood/cheerful.png'),
                _buildEmojiButton('Happy', 'assets/mood/happy.png'),
                _buildEmojiButton('Neutral', 'assets/mood/neutral.png'),
                _buildEmojiButton('Sad', 'assets/mood/sad.png'),
                _buildEmojiButton('Awful', 'assets/mood/awful.png'),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String label, String assetPath) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Handle emoji button click
            print('$label clicked');
          },
          child: Image.asset(
            assetPath,
            height: 40, // Adjust icon size
            width: 40,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
      ],
    );
  }
}
