import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';

class MindfulCard extends StatelessWidget {
  final String goal;
  final String song;
  final int minutes;
  final int seconds;
  final String exercise;
  final String url;

  const MindfulCard({
    Key? key,
    required this.goal,
    required this.song,
    required this.minutes,
    required this.seconds,
    required this.exercise,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define color mapping for categories
    final Map<String, Color> categoryColors = {
      'Breathing': serenityGreen['Green50'] ?? Colors.green,
      'Meditation': zenYellow['Yellow50'] ?? Colors.yellow,
      'Relax': empathyOrange['Orange40'] ?? Colors.orange,
      'Sleep': mindfulBrown['Brown80'] ?? Colors.brown,
    };

    String duration = "$minutes min ${seconds == 0 ? "" : "$seconds sec"}";

    final Color categoryColor = categoryColors[exercise] ?? Colors.blueAccent;

    return GestureDetector(
      onTap: () {
        context.push('/mindful-player',
            extra: {'song': song, 'min': minutes, 'sec': seconds, 'url': url});
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular icon with category color
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: categoryColor.withOpacity(0.2),
                ),
                child: Icon(Icons.music_note, color: categoryColor),
              ),
              const SizedBox(width: 12),

              // Make sure the Column is wrapped in Expanded
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Goal with ellipsis effect
                    Text(
                      goal,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: mindfulBrown['Brown80'],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      song,
                      style: TextStyle(
                        fontSize: 14,
                        color: optimisticGray['Gray50'],
                      ),
                    ),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 12,
                        color: optimisticGray['Gray50'],
                      ),
                    ),
                  ],
                ),
              ),

              // Category label with corresponding color
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  exercise,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
