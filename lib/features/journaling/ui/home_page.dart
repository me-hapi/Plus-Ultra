import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingap/features/journaling/ui/create_journal.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DateTime> getDatesForCurrentAndNextTwoWeeks() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(
        Duration(days: now.weekday % 7)); // Start of current week (Sunday)
    return List.generate(
        21,
        (index) => startOfWeek
            .add(Duration(days: index))); // Generate 3 weeks (21 days)
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<DateTime> dates = getDatesForCurrentAndNextTwoWeeks();

    return Scaffold(
      appBar: AppBar(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateJournalPage()));
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
                  onPressed: () {},
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

                      return CircleAvatar(
                        backgroundColor:
                            isToday ? Colors.blue : Colors.grey[300],
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isToday ? Colors.white : Colors.black,
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
