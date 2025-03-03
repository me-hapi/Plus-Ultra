import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class MatchCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String emotion;

  MatchCard({
    required this.avatarUrl,
    required this.name,
    required this.emotion,
  });

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'cheerful':
        return Colors.green;
      case 'happy':
        return Colors.yellow;
      case 'neutral':
        return Colors.brown;
      case 'sad':
        return Colors.orange;
      case 'awful':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              child: Image.asset(avatarUrl),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: mindfulBrown['Brown80'],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getEmotionColor(emotion),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      emotion,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
