import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lingap/core/const/colors.dart';

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
      backgroundColor: mindfulBrown['Brown10'],
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
                      style: TextStyle(
                          color: mindfulBrown['Brown80'],
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat('MMMM yyyy').format(DateTime.now()),
                      style: TextStyle(
                          color: optimisticGray['Gray60'], fontSize: 18),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      child: SizedBox(
                        height: 60,
                        child: Image.asset('assets/journal/more.png'),
                      ),
                      onTap: () {
                        context.push('/journal-insight', extra: {
                          'current': 2,
                          'record': 12,
                        });
                      },
                    )),
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
                        icon: 'assets/journal/ekis.png',
                        color: mindfulBrown['Brown80']!,
                        highestCount: highestCount,
                      ),
                      _buildBar(
                        count: negativeCount,
                        label: 'Negative',
                        icon: 'assets/journal/negative.png',
                        color: empathyOrange['Orange40']!,
                        highestCount: highestCount,
                      ),
                      _buildBar(
                        count: positiveCount,
                        label: 'Positive',
                        icon: 'assets/journal/positive.png',
                        color: serenityGreen['Green50']!,
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
    required String icon,
    required Color color,
    required int highestCount,
  }) {
    double barHeight = highestCount > 0 ? (count / highestCount) * 550 : 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 80,
          height:
              barHeight.clamp(0.0, 550.0), // Ensure height stays within bounds
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
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    height: 30,
                    child: Image.asset(icon),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
