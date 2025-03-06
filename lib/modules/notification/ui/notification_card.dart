import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class NotificationCard extends StatelessWidget {
  final String category;
  final String content;
  final String time_ago;

  const NotificationCard(
      {Key? key,
      required this.category,
      required this.content,
      required this.time_ago})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> categories = {
      'Appointments': {
        'title': 'Appointment Set',
        'content':
            'You have set an appointment. Check your schedule for details.',
        'color': optimisticGray['Gray50'],
        'image': 'assets/notification/appoint.png'
      },
      'session': {
        'title': 'Session Created',
        'content':
            'You have created a session. Get ready to take a step forward!',
        'color': reflectiveBlue['Blue50'],
        'image': 'assets/notification/session.png'
      },
      'Journaling': {
        'title': 'New Journal Entry',
        'content':
            'You have written a new journal entry. Keep expressing yourself!',
        'color': serenityGreen['Green50'],
        'image': 'assets/notification/journal.png'
      },
      'mindfulness': {
        'title': 'Mindfulness Started',
        'content':
            'You have started a mindfulness exercise. Stay present and breathe.',
        'color': mindfulBrown['Brown60'],
        'image': 'assets/notification/exercise.png'
      },
      'Messaging': {
        'title': 'Message Sent',
        'content':
            'Someone sent you a message. Connecting with others is important!',
        'color': zenYellow['Yellow50'],
        'image': 'assets/notification/peer.png'
      },
      'Mood Tracking': {
        'title': 'Mood Logged',
        'content': 'Tracking your emotions helps with self-awareness.',
        'color': empathyOrange['Orange50'],
        'image': 'assets/notification/data.png'
      },
      'Sleep Monitoring': {
        'title': 'Sleep Data Recorded',
        'content': 'Understanding your sleep patterns is key to well-being.',
        'color': kindPurple['Purple50'],
        'image': 'assets/notification/data.png'
      }
    };

    return Card(
      color: mindfulBrown['Brown10'],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Image asset on the left
            Container(
              width: 30, // Adjust size as needed
              height: 30,
              decoration: BoxDecoration(
                color: categories[category]['color'], // White background
                shape: BoxShape.circle, // Makes it circular
              ),
              child: Center(
                child: Image.asset(
                  categories[category]['image'],
                  width: 20, // Adjust image size as needed
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(width: 12),
            // Column for category and content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      color: mindfulBrown['Brown80'],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: optimisticGray['Gray50'],
                    ),
                  ),
                ],
              ),
            ),

            Text(
              time_ago,
              style: TextStyle(fontSize: 12, color: mindfulBrown['Brown50']),
            )
          ],
        ),
      ),
    );
  }
}
