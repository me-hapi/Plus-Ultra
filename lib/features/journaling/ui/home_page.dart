import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/journaling/logic/home_logic.dart';
import 'package:lingap/features/journaling/ui/create_journal.dart';
import 'package:lingap/features/journaling/ui/journal_stat.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/journaling/data/supabse_db.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeLogic homeLogic;
  List<Map<String, dynamic>> classifications = [];
  late Map<String, int> counts;

  @override
  void initState() {
    super.initState();
    homeLogic = HomeLogic(supabase: SupabaseDB(client));
    // classifications = homeLogic.classifications;
    // counts = homeLogic.counts;
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    final classResult = await homeLogic.getClassifications(uid);
    final countResult = homeLogic.calculateMonthlyCounts(classResult);
    if (mounted) {
      setState(() {
        classifications = classResult;
        counts = countResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<DateTime> dates =
        homeLogic.getDatesForCurrentAndPastTwoWeeks().sublist(7);

    return Scaffold(
        body: Stack(children: [
      // Color overlay
      Container(
        color: mindfulBrown['Brown60'], // Semi-transparent overlay
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/journal/homebg.png'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
      ),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Text(
              'Journaling',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          // Upper Section: Open Book Icon and Journal Count
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                child: Image.asset('assets/journal/book.png'),
              ),
              SizedBox(width: 8),
              Text(
                '25',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              'Journals this year',
              style: TextStyle(
                color: Colors.white,
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
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                '28 days streak',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Spacer(),
          // Floating Plus Button

          Stack(
            clipBehavior: Clip.none,
            children: [
              // CustomPaint Background
              CustomPaint(
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
                painter: ConvexArcPainter(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 360,
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Journal Statistics',
                            style: TextStyle(
                              color: mindfulBrown['Brown80'],
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => JournalStatPage(
                              //       skipCount: counts['skipped'] as int,
                              //       negativeCount: counts['negative'] as int,
                              //       positiveCount: counts['positive'] as int,
                              //     ),
                              //   ),
                              // );
                              context.push('/journal-stats', extra: {
                                'skip': counts['skipped'] as int,
                                'negative': counts['negative'] as int,
                                'positive': counts['positive'] as int,
                              });
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                  color: serenityGreen['Green50'],
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      // Calendar with Days of the Week
                      Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                                  .map((day) => Text(
                                        day,
                                        style: TextStyle(
                                          color: optimisticGray['Gray40'],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ))
                                  .toList(),
                            ),
                            // Calendar Grid
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
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
                                  List<DateTime> classifiedDates =
                                      classifications
                                          .map((entry) => DateTime.parse(
                                              entry['created_at']))
                                          .toList()
                                        ..sort();

                                  // Check for skipped dates between classified dates
                                  for (int i = 0;
                                      i < classifiedDates.length - 1;
                                      i++) {
                                    DateTime start = classifiedDates[i];
                                    DateTime end = classifiedDates[i + 1];

                                    if (!date.isBefore(start) &&
                                        !date.isAfter(end)) {
                                      if (date.isAfter(start) &&
                                          date.isBefore(end)) {
                                        isSkipped = true;
                                        break;
                                      } else if (date ==
                                              start.add(Duration(days: 1)) ||
                                          date ==
                                              end.subtract(Duration(days: 1))) {
                                        isSkipped = true;
                                        break;
                                      }
                                    }
                                  }

                                  // Check for skipped dates between the last classified date and today
                                  DateTime? lastClassifiedDate;
                                  for (var classifiedDate
                                      in classifiedDates.reversed) {
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
                                  backgroundColor = reflectiveBlue['Blue50']!;
                                } else if (classification == 'positive') {
                                  backgroundColor = serenityGreen['Green50']!;
                                } else if (classification == 'negative') {
                                  backgroundColor = empathyOrange['Orange50']!;
                                } else if (isSkipped) {
                                  backgroundColor = mindfulBrown['Brown50']!;
                                } else {
                                  backgroundColor = optimisticGray['Gray30']!;
                                }

                                return CircleAvatar(
                                  backgroundColor: backgroundColor,
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: (isSkipped || isToday)
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          LegendItem(
                              color: mindfulBrown['Brown50'], label: 'Skipped'),
                          LegendItem(
                              color: serenityGreen['Green50'],
                              label: 'Positive'),
                          LegendItem(
                              color: empathyOrange['Orange50'],
                              label: 'Negative'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Elevated Button at the Top
              Positioned(
                top: -40, // Adjust the top value to overlap the button
                left: MediaQuery.of(context).size.width / 2 -
                    40, // Center horizontally
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateJournalPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: mindfulBrown['Brown80']),
                  child: Icon(
                    color: Colors.white,
                    Icons.add,
                    size: 50,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ]));
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

class ConvexArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = mindfulBrown['Brown10']!
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 30) // Start slightly below the top edge
      ..quadraticBezierTo(
        size.width / 2, // Control point x
        -30, // Control point y (above the canvas for a convex arc)
        size.width, // End point x
        30, // End point y
      )
      ..lineTo(size.width, size.height) // Go to the bottom right
      ..lineTo(0, size.height) // Go to the bottom left
      ..close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
