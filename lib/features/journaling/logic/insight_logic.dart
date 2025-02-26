// insight_logic.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingap/features/journaling/data/supabse_db.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';

class InsightLogic {
  final SupabaseDB supabase;

  InsightLogic(this.supabase);

  Future<List<Map<String, dynamic>>> fetchJournalCount() async {
    return await supabase.fetchJournalCount();
  }

  int fetchCurrentStreak(List<Map<String, dynamic>> journal) {
    if (journal.isEmpty) return 0;

    // Extract and sort dates in descending order (latest first)
    List<DateTime> dates = journal
        .map((entry) => DateTime.parse(entry['created_at']).toLocal())
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Sort descending

    DateTime today = DateTime.now();
    int currentStreak = 0;

    for (int i = 0; i < dates.length; i++) {
      if (i == 0 && dates[i].difference(today).inDays != 0) {
        // If first date is not today, no current streak
        return 0;
      }

      if (i > 0 && dates[i - 1].difference(dates[i]).inDays > 1) {
        // Break if a gap is found
        break;
      }

      currentStreak++;
    }

    return currentStreak;
  }

  int fetchStreak(List<Map<String, dynamic>> journal) {
    if (journal.isEmpty) return 0;

    // Extract and sort the dates
    List<DateTime> dates = journal
        .map((entry) => DateTime.parse(entry['created_at']))
        .toList()
      ..sort();

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < dates.length; i++) {
      Duration diff = dates[i].difference(dates[i - 1]);

      if (diff.inDays == 1) {
        currentStreak++;
      } else if (diff.inDays > 1) {
        longestStreak =
            currentStreak > longestStreak ? currentStreak : longestStreak;
        currentStreak = 1;
      }
    }

    return currentStreak > longestStreak ? currentStreak : longestStreak;
  }

  List<Map<String, dynamic>> generateJournalEntries(
      DateTime clickedDate, List<Map<String, dynamic>> journals) {
    List<DateTime> dateRange = List.generate(6, (index) {
      return clickedDate.subtract(Duration(days: 2 - index));
    });

    return dateRange.map((date) {
      Map<String, dynamic>? journalEntry = journals.firstWhere(
        (entry) {
          DateTime createdAt = DateTime.parse(entry['created_at']);
          return createdAt.year == date.year &&
              createdAt.month == date.month &&
              createdAt.day == date.day;
        },
        orElse: () => {},
      );

      return {
        'selected': date.isAtSameMomentAs(clickedDate),
        'date': date,
        'emotion': journalEntry.isNotEmpty ? journalEntry['emotion'] : 'None',
        'title': journalEntry.isNotEmpty ? journalEntry['title'] : 'Untitled',
        'time': journalEntry.isNotEmpty
            ? DateTime.parse(journalEntry['created_at'])
                .toLocal()
                .toIso8601String()
                .split('T')[1]
                .substring(0, 5)
            : null,
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
              ],
      };
    }).toList();
  }

  List<DateTime> generateDatesForDisplay(DateTime currentDate) {
    List<DateTime> dates = [];

    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    int firstDayWeekday = firstDayOfMonth.weekday;

    DateTime lastDayOfPreviousMonth =
        DateTime(currentDate.year, currentDate.month, 0);
    int daysInPreviousMonth = lastDayOfPreviousMonth.day;

    for (int i = firstDayWeekday - 2; i >= 0; i--) {
      dates.add(DateTime(lastDayOfPreviousMonth.year,
          lastDayOfPreviousMonth.month, daysInPreviousMonth - i));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      dates.add(DateTime(currentDate.year, currentDate.month, day));
    }

    int remainingDays = 7 - (dates.length % 7);
    for (int i = 1; i <= remainingDays && remainingDays < 7; i++) {
      dates.add(DateTime(currentDate.year, currentDate.month + 1, i));
    }

    return dates;
  }

  Future<List<Map<String, dynamic>>> getJournals(String uid,
      {required DateTime startDate, required DateTime endDate}) async {
    return await supabase.getJournalsWithItems(
        uid: uid, startDate: startDate, endDate: endDate);
  }
}

bool isSkippedDate(DateTime date, List<Map<String, dynamic>> journals) {
  List<DateTime> classifiedDates = journals
      .map((entry) => DateTime.parse(entry['created_at']))
      .toList()
    ..sort();

  for (int i = 0; i < classifiedDates.length - 1; i++) {
    DateTime start = classifiedDates[i];
    DateTime end = classifiedDates[i + 1];

    if (date.isAfter(start) && date.isBefore(end)) {
      return true;
    }
  }

  DateTime? lastClassifiedDate;
  for (var classifiedDate in classifiedDates.reversed) {
    if (classifiedDate.isBefore(DateTime.now())) {
      lastClassifiedDate = classifiedDate;
      break;
    }
  }

  if (lastClassifiedDate != null &&
      date.isAfter(lastClassifiedDate) &&
      date.isBefore(DateTime.now())) {
    return true;
  }

  return false;
}

Color determineBackgroundColor(
    DateTime date, bool isToday, String? classification, bool isSkipped) {
  if (isToday && classification == null) {
    return Colors.blue;
  } else if (classification == 'positive') {
    return Colors.green;
  } else if (classification == 'negative') {
    return Colors.orange;
  } else if (isSkipped) {
    return Colors.brown[200]!;
  } else {
    return Colors.transparent;
  }
}
