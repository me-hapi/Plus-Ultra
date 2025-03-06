// journal_insight.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/journaling/data/supabse_db.dart';
import 'package:lingap/features/journaling/logic/insight_logic.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';
import 'package:lingap/features/journaling/ui/journal_collection.dart';

class JournalInsightPage extends StatefulWidget {
  const JournalInsightPage({Key? key}) : super(key: key);

  @override
  State<JournalInsightPage> createState() => _JournalInsightPageState();
}

class _JournalInsightPageState extends State<JournalInsightPage> {
  final InsightLogic logic = InsightLogic(SupabaseDB(client));
  List<Map<String, dynamic>> journals = [];
  DateTime _currentDate = DateTime.now();
  late List<DateTime> displayDates;
  int currentStreak = 0;
  int longestStreak = 0;

  @override
  void initState() {
    super.initState();
    _updateDisplayDates();
    fetchStreak();
  }

  void _updateDisplayDates() {
    setState(() {
      displayDates = logic.generateDatesForDisplay(_currentDate);
    });
    _fetchJournals();
  }

  void _fetchJournals() async {
    final result = await logic.getJournals(uid,
        startDate: displayDates.first, endDate: displayDates.last);
    setState(() {
      journals = result;
    });
  }

  Future<void> fetchStreak() async {
    final result = await logic.fetchJournalCount();
    final resultLong = logic.fetchStreak(result);
    final resultCurrent = logic.fetchCurrentStreak(result);
    setState(() {
      longestStreak = resultLong;
      currentStreak = resultCurrent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.asset(
            'assets/utils/brownBack.png',
            width: 25,
            height: 25,
          ),
        ),
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Journal Insights',
                style: TextStyle(
                  fontSize: 32,
                  color: mindfulBrown['Brown80']!,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              _buildMonthSelector(),
              const SizedBox(height: 16),
              _buildCalendar(),
              const SizedBox(height: 16),
              _buildStreakSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () {
              setState(() {
                _currentDate =
                    DateTime(_currentDate.year, _currentDate.month - 1);
                _updateDisplayDates();
              });
            },
          ),
          Text(
            '${DateFormat('MMMM yyyy').format(_currentDate)}',
            style: TextStyle(
                color: mindfulBrown['Brown80']!,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                _currentDate =
                    DateTime(_currentDate.year, _currentDate.month + 1);
                _updateDisplayDates();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    List<Widget> daysOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S']
        .map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                      color: optimisticGray['Gray60']!,
                      fontWeight: FontWeight.bold),
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
      backgroundColor =
          reflectiveBlue['Blue50']!; // Today with no classification
    } else if (classification == 'positive') {
      backgroundColor = serenityGreen['Green50']!;
    } else if (classification == 'negative') {
      backgroundColor = empathyOrange['Orange50']!;
    } else if (isSkipped) {
      backgroundColor = mindfulBrown['Brown50']!; // Skipped dates
    } else {
      backgroundColor = Colors.transparent;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isCurrentMonth &&
              (classification == 'positive' || classification == 'negative')) {
            print('Tapped on: ${date.year}-${date.month}-${date.day}');
            print(logic.generateJournalEntries(date, journals));

            context.push('/journal-collection',
                extra: logic.generateJournalEntries(date, journals));
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
                color: isCurrentMonth
                    ? (isSkipped || classification != null)
                        ? Colors.white
                        : mindfulBrown['Brown80']
                    : mindfulBrown['Brown30'],
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Your Streak',
            style: TextStyle(
                color: mindfulBrown['Brown80']!,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              return index < currentStreak
                  ? Image.asset(
                      'assets/utils/streak.png',
                      width: 24,
                    )
                  : CircleAvatar(
                      radius: 12,
                      backgroundColor: optimisticGray['Gray50'],
                    );
            }),
          ),
          Divider(
            height: 32,
            thickness: 1,
            color: optimisticGray['Gray50'],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    currentStreak.toString(),
                    style: TextStyle(
                        color: mindfulBrown['Brown80']!,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('Current Streak',
                      style: TextStyle(
                          color: optimisticGray['Gray60']!, fontSize: 14)),
                ],
              ),
              Column(
                children: [
                  Text(
                    longestStreak.toString(),
                    style: TextStyle(
                        color: mindfulBrown['Brown80']!,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('Record',
                      style: TextStyle(
                          color: optimisticGray['Gray60'], fontSize: 14)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
