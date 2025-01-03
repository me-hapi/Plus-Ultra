import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/journaling/data/supabse_db.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';
import 'package:lingap/features/journaling/ui/journal_collection.dart';

class JournalInsightPage extends StatefulWidget {
  final int currentStreak;
  final int recordStreak;

  const JournalInsightPage({
    Key? key,
    required this.currentStreak,
    required this.recordStreak,
  }) : super(key: key);

  @override
  State<JournalInsightPage> createState() => _JournalInsightPageState();
}

class _JournalInsightPageState extends State<JournalInsightPage> {
  final SupabaseDB supabase = SupabaseDB(client);
  late List<Map<String, dynamic>> journals = [];
  DateTime _currentDate = DateTime.now();
  late List<DateTime> displayDates;

  final dummyDates = List.generate(6, (index) {
    final date = DateTime.now().subtract(Duration(days: index));
    return {
      'selected': index == 0, // Only the first date is selected
      'date': date,
      'emotion': [
        'Happy',
        'Excited',
        'Calm',
        'Sad',
        'Anxious',
        'Relaxed'
      ][index % 6],
      'title': '${date.month}/${date.day}/${date.year}',
      'time': '08:30 AM', // Single time value
      'content': [
        JournalItem(type: 'text', text: 'Started the day with a smile!')
      ],
    };
  });

  List<Map<String, dynamic>> generateJournalEntries(
      DateTime clickedDate, List<Map<String, dynamic>> journals) {
    // Generate a range of dates: previous 2, clicked, and next 3
    List<DateTime> dateRange = List.generate(6, (index) {
      return clickedDate.subtract(Duration(days: 2 - index));
    });

    // Map date range to journal entries
    return dateRange.map((date) {
      // Find matching journal entry for this date
      Map<String, dynamic>? journalEntry = journals.firstWhere(
        (entry) {
          DateTime createdAt = DateTime.parse(entry['created_at']);
          return createdAt.year == date.year &&
              createdAt.month == date.month &&
              createdAt.day == date.day;
        },
        orElse: () => {}, // Return empty map if no matching journal
      );

      // Build journal entry data
      return {
        'selected':
            date.isAtSameMomentAs(clickedDate), // Mark clicked date as selected
        'date': date,
        'emotion': journalEntry.isNotEmpty
            ? journalEntry['emotion']
            : 'None', // Default emotion if no classification
        'title': journalEntry.isNotEmpty ? journalEntry['title'] : 'Untitled',
        'time': journalEntry.isNotEmpty
            ? DateTime.parse(journalEntry['created_at'])
                .toLocal()
                .toIso8601String()
                .split('T')[1]
                .substring(0, 5)
            : null, // Extract time if journal exists
        'content': journalEntry.isNotEmpty
            ? journalEntry['journalItems']
                .map((item) => JournalItem(
                      type: item['content_type'],
                      text: item['content'],
                    ))
                .toList()
                .cast<JournalItem>()
            : [
                JournalItem(
                    type: 'text', text: 'No journal entry for this day.')
              ], // Use default content if no journal
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _updateDisplayDates();
  }

  void getJournals() async {
    final result = await supabase.getJournalsWithItems(
        uid: uid,
        startDate: displayDates[0],
        endDate: displayDates[displayDates.length - 1]);
    setState(() {
      journals = result;
    });

    print(journals);
  }

  void _updateDisplayDates() {
    displayDates = _generateDatesForDisplay(_currentDate);
    getJournals();
  }

  List<DateTime> _generateDatesForDisplay(DateTime currentDate) {
    List<DateTime> dates = [];

    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    int firstDayWeekday = firstDayOfMonth.weekday;

    DateTime lastDayOfPreviousMonth =
        DateTime(currentDate.year, currentDate.month, 0);
    int daysInPreviousMonth = lastDayOfPreviousMonth.day;

    // Add days from the previous month
    for (int i = firstDayWeekday - 2; i >= 0; i--) {
      dates.add(DateTime(lastDayOfPreviousMonth.year,
          lastDayOfPreviousMonth.month, daysInPreviousMonth - i));
    }

    // Add days for the current month
    for (int day = 1; day <= daysInMonth; day++) {
      dates.add(DateTime(currentDate.year, currentDate.month, day));
    }

    // Add days for the next month to complete the week
    int remainingDays = 7 - (dates.length % 7);
    for (int i = 1; i <= remainingDays && remainingDays < 7; i++) {
      dates.add(DateTime(currentDate.year, currentDate.month + 1, i));
    }

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Journal Insights',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left),
                      onPressed: () {
                        setState(() {
                          _currentDate = DateTime(
                              _currentDate.year, _currentDate.month - 1);
                          _updateDisplayDates();
                        });
                      },
                    ),
                    Text(
                      '${DateFormat('MMMM yyyy').format(_currentDate)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right),
                      onPressed: () {
                        setState(() {
                          _currentDate = DateTime(
                              _currentDate.year, _currentDate.month + 1);
                          _updateDisplayDates();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCalendar(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Streak',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(7, (index) {
                        return CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              index % 2 == 0 ? Colors.brown : Colors.grey,
                        );
                      }),
                    ),
                    const Divider(height: 32, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${widget.currentStreak}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text('Current Streak',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${widget.recordStreak}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text('Record',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    List<Widget> daysOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S']
        .map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ))
        .toList();

    return Column(
      children: [
        Row(children: daysOfWeek),
        const SizedBox(height: 8),
        ...List.generate((displayDates.length / 7).ceil(), (index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: displayDates
                .skip(index * 7)
                .take(7)
                .map((date) => _buildDay(date))
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildDay(DateTime date) {
    DateTime today = DateTime.now();
    bool isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    bool isCurrentMonth = date.month == _currentDate.month;

    // Determine classification for the current date
    String? classification;
    if (journals.isNotEmpty) {
      for (var entry in journals) {
        DateTime createdAt = DateTime.parse(entry['created_at']);
        if (createdAt.year == date.year &&
            createdAt.month == date.month &&
            createdAt.day == date.day) {
          classification = entry['classification'];
          break;
        }
      }
    }

    // Identify gaps in classifications
    bool isSkipped = false;
    if (journals.isNotEmpty) {
      // Parse and sort the classified dates
      List<DateTime> classifiedDates = journals
          .map((entry) => DateTime.parse(entry['created_at']))
          .toList()
        ..sort();

      // Check if the current date is within a gap
      for (int i = 0; i < classifiedDates.length - 1; i++) {
        DateTime start = classifiedDates[i];
        DateTime end = classifiedDates[i + 1];

        // If the current date is between start and end, it's skipped
        if (date.isAfter(start) && date.isBefore(end)) {
          isSkipped = true;
          break;
        }
      }

      // Check for skipped dates between the last classified date and today
      DateTime? lastClassifiedDate;
      for (var classifiedDate in classifiedDates.reversed) {
        if (classifiedDate.isBefore(today)) {
          lastClassifiedDate = classifiedDate;
          break;
        }
      }

      if (lastClassifiedDate != null &&
          date.isAfter(lastClassifiedDate) &&
          date.isBefore(today)) {
        isSkipped = true;
      }
    }

    // Determine color based on classification and skip status
    Color backgroundColor;
    if (isToday && classification == null) {
      backgroundColor = Colors.blue; // Today with no classification
    } else if (classification == 'positive') {
      backgroundColor = Colors.green;
    } else if (classification == 'negative') {
      backgroundColor = Colors.orange;
    } else if (isSkipped) {
      backgroundColor = Colors.brown[200]!; // Skipped dates
    } else {
      backgroundColor = Colors.transparent;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isCurrentMonth) {
            print('Tapped on: ${date.year}-${date.month}-${date.day}');

            print(generateJournalEntries(date, journals));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JournalCollection(
                  dates: generateJournalEntries(date, journals),
                ),
              ),
            );
          }
        },
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: TextStyle(
                color: isCurrentMonth ? Colors.black : Colors.grey,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
