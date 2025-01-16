import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/journaling/data/supabse_db.dart';
import 'package:lingap/features/journaling/ui/create_journal.dart';
import 'package:lingap/features/journaling/ui/journal_stat.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseDB supabase = SupabaseDB(client);
  late List<Map<String, dynamic>> classifications = [];
  late Map<String, int> counts = {};

  @override
  void initState() {
    super.initState();
    getClassifications();
  }

  void getClassifications() async {
    List<DateTime> dates = getDatesForCurrentAndPastTwoWeeks();
    final result = await supabase.getClassifications(
        uid: uid, startDate: dates[0], endDate: dates[dates.length - 1]);
    setState(() {
      classifications = result;
    });

    calculateMonthlyCounts();
  }

  void calculateMonthlyCounts() {
  // Initialize counts
  counts = {'positive': 0, 'negative': 0, 'skipped': 0};

  if (classifications.isEmpty) return;

  // Get the current date (today)
  final now = DateTime.now().toUtc();

  // Parse and sort classification dates
  List<DateTime> classifiedDates = classifications.map((entry) {
    DateTime parsedDate = DateTime.parse(entry['created_at']).toUtc();
    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
  }).toList()
    ..sort();

  print(
      'Classified Dates: $classifiedDates'); // Debugging: Check parsed dates

  // Filter dates for the current month and the past month
  List<DateTime> currentMonthDates = classifiedDates
      .where((date) => date.month == now.month && date.year == now.year)
      .toList();
  List<DateTime> pastMonthDates = classifiedDates.where((date) =>
      (date.month == now.month - 1 && date.year == now.year) ||
      (now.month == 1 && date.month == 12 && date.year == now.year - 1)).toList();

  // Check for positive or negative classifications in the past month
  bool hasPastMonthPositiveOrNegative = classifications.any((entry) {
    DateTime createdAt = DateTime.parse(entry['created_at']).toLocal();
    return (createdAt.month == now.month - 1 ||
            (now.month == 1 && createdAt.month == 12 && createdAt.year == now.year - 1)) &&
        (entry['classification'] == 'positive' ||
            entry['classification'] == 'negative');
  });

  // Count positive and negative classifications for the current month
  for (var entry in classifications) {
    DateTime createdAt = DateTime.parse(entry['created_at']).toLocal();
    if (createdAt.month == now.month && createdAt.year == now.year) {
      String classification = entry['classification'];
      if (classification == 'positive') {
        counts['positive'] = counts['positive']! + 1;
      } else if (classification == 'negative') {
        counts['negative'] = counts['negative']! + 1;
      }
    }
  }

  // Count skipped days from the first day of the current month
  if (hasPastMonthPositiveOrNegative) {
    DateTime startOfCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime firstRelevantDay;

    if (currentMonthDates.isNotEmpty) {
      // Use the first classification day of the current month
      firstRelevantDay = currentMonthDates.first;
    } else {
      // Use today if there are no classifications in the current month
      firstRelevantDay = DateTime(now.year, now.month, now.day);
    }

    int skippedDays = firstRelevantDay.difference(startOfCurrentMonth).inDays;

    print(
        'Skipped days from start of month to $firstRelevantDay: $skippedDays days');

    if (skippedDays > 0) {
      counts['skipped'] = counts['skipped']! + skippedDays;
    }
  }

  // Count skipped days between classifications in the current month
  for (int i = 0; i < currentMonthDates.length - 1; i++) {
    DateTime start = currentMonthDates[i];
    DateTime end = currentMonthDates[i + 1];

    int skippedDays =
        end.difference(start).inDays - 1; // Subtract 1 for the start day
    print(
        'Gap between $start and $end: $skippedDays days'); // Debugging: Check gaps

    if (skippedDays > 0) {
      counts['skipped'] = counts['skipped']! + skippedDays;
    }
  }

  // Count skipped days between the last classification of the current month and today
  if (currentMonthDates.isNotEmpty) {
    DateTime lastClassifiedDate = currentMonthDates.last;
    DateTime lastDay = DateTime(lastClassifiedDate.year,
        lastClassifiedDate.month, lastClassifiedDate.day);
    DateTime currentDay = DateTime(now.year, now.month, now.day);

    if (currentDay.isAfter(lastDay)) {
      int skippedDays = currentDay.difference(lastDay).inDays -
          1; // Subtract 1 for the last classified day
      print(
          'Gap between $lastDay and today: $skippedDays days'); // Debugging: Check gap to today

      if (skippedDays > 0) {
        counts['skipped'] = counts['skipped']! + skippedDays;
      }
    }
  }

  print('Counts: $counts'); // Debugging: Final counts
}


  List<DateTime> getDatesForCurrentAndPastTwoWeeks() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(
        Duration(days: now.weekday % 7)); // Start of current week (Sunday)
    DateTime startOfThreeWeeksAgo = startOfWeek.subtract(
        Duration(days: 21)); // Start of two weeks before the current week

    return List.generate(
        28, (index) => startOfThreeWeeksAgo.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<DateTime> dates = getDatesForCurrentAndPastTwoWeeks().sublist(7);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Journaling',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF473c38),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upper Section: Open Book Icon and Journal Count
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book,
                  size: 80,
                ),
                SizedBox(width: 8),
                Text(
                  '25',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                'Journals this year',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Streak Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flash_on,
                  color: Colors.amber,
                ),
                SizedBox(width: 8),
                Text(
                  '28 days streak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            // Floating Plus Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateJournalPage()));
                },
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: 32),
            // Journal Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Journal Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JournalStatPage(
                                skipCount: counts['skipped'] as int,
                                negativeCount: counts['negative'] as int,
                                positiveCount: counts['positive'] as int)));
                  },
                  child: Text('See All'),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Calendar with Days of the Week
            Center(
              child: Column(
                children: [
                  // Days of the week row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                        .map((day) => Text(
                              day,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 8),
                  // Calendar Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      DateTime date = dates[index];
                      bool isToday = date.day == now.day &&
                          date.month == now.month &&
                          date.year == now.year;

                      // Determine classification for the current date
                      String? classification;
                      if (classifications.isNotEmpty) {
                        for (var entry in classifications) {
                          DateTime createdAt =
                              DateTime.parse(entry['created_at']);
                          if (createdAt.year == date.year &&
                              createdAt.month == date.month &&
                              createdAt.day == date.day) {
                            classification = entry['classification'];
                            break;
                          }
                        }
                      }

                      // Identify gaps in classifications and skipped days up to today
                      bool isSkipped = false;
                      if (classifications.isNotEmpty) {
                        // Parse and sort the classified dates
                        List<DateTime> classifiedDates = classifications
                            .map((entry) => DateTime.parse(entry['created_at']))
                            .toList()
                          ..sort();

                        // Check for skipped dates between classified dates
                        for (int i = 0; i < classifiedDates.length - 1; i++) {
                          DateTime start = classifiedDates[i];
                          DateTime end = classifiedDates[i + 1];

                          if (!date.isBefore(start) && !date.isAfter(end)) {
                            if (date.isAfter(start) && date.isBefore(end)) {
                              isSkipped = true;
                              break;
                            } else if (date == start.add(Duration(days: 1)) ||
                                date == end.subtract(Duration(days: 1))) {
                              isSkipped = true;
                              break;
                            }
                          }
                        }

                        // Check for skipped dates between the last classified date and today
                        DateTime? lastClassifiedDate;
                        for (var classifiedDate in classifiedDates.reversed) {
                          if (classifiedDate.isBefore(now)) {
                            lastClassifiedDate = classifiedDate;
                            break;
                          }
                        }

                        if (lastClassifiedDate != null &&
                            date.isAfter(lastClassifiedDate) &&
                            date.isBefore(now)) {
                          isSkipped = true;
                        }
                      }

                      // Determine color based on classification and skip status
                      Color backgroundColor;
                      if (isToday && classification == null) {
                        backgroundColor =
                            Colors.blue; // Today with no classification
                      } else if (classification == 'positive') {
                        backgroundColor = Colors.green;
                      } else if (classification == 'negative') {
                        backgroundColor = Colors.orange;
                      } else if (isSkipped) {
                        backgroundColor = Colors.brown[200]!; // Skipped dates
                      } else {
                        backgroundColor = Colors.grey[300]!;
                      }

                      return CircleAvatar(
                        backgroundColor: backgroundColor,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isToday && classification == null
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LegendItem(color: Colors.brown[200], label: 'Skipped'),
                LegendItem(color: Colors.green, label: 'Positive'),
                LegendItem(color: Colors.orange, label: 'Negative'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color? color;
  final String label;

  const LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
