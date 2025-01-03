import 'package:flutter/material.dart';
import 'package:lingap/features/journaling/ui/journal_insights.dart';

class JournalStatPage extends StatelessWidget {
  final int skipCount;
  final int negativeCount;
  final int positiveCount;

  JournalStatPage({
    required this.skipCount,
    required this.negativeCount,
    required this.positiveCount,
  });

  @override
  Widget build(BuildContext context) {
    final int highestCount = [skipCount, negativeCount, positiveCount]
        .reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Journal Stats',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your Journal Stats for ${DateTime.now().month}/${DateTime.now().year}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JournalInsightPage(
                                  currentStreak: 2,
                                  recordStreak: 12)));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Expanded(
              child: Stack(
                children: [
                  // Horizontal broken lines
                  Positioned.fill(
                    child: Column(
                      children: List.generate(5, (index) {
                        double lineHeight = (highestCount / 4) * index;
                        return Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                    endIndent: 10,
                                    indent: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Bars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(
                        count: skipCount,
                        label: 'Skipped',
                        icon: Icons.close,
                        color: Colors.brown.shade300,
                        highestCount: highestCount,
                      ),
                      _buildBar(
                        count: negativeCount,
                        label: 'Negative',
                        icon: Icons.sentiment_dissatisfied,
                        color: Colors.orange,
                        highestCount: highestCount,
                      ),
                      _buildBar(
                        count: positiveCount,
                        label: 'Positive',
                        icon: Icons.sentiment_satisfied,
                        color: Colors.green,
                        highestCount: highestCount,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildBar({
  required int count,
  required String label,
  required IconData icon,
  required Color color,
  required int highestCount,
}) {
  double barHeight = highestCount > 0 ? (count / highestCount) * 550 : 0;

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 80,
        height: barHeight.clamp(0.0, 550.0), // Ensure height stays within bounds
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Text(
                    count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

}
