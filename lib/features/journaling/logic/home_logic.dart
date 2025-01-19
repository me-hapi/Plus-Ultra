import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingap/features/journaling/data/supabse_db.dart';

class HomeLogic {
  final SupabaseDB supabase;
  late List<Map<String, dynamic>> classifications = [];
  late Map<String, int> counts = {};

  HomeLogic({required this.supabase});

  Future<void> getClassifications(String uid) async {
    List<DateTime> dates = getDatesForCurrentAndPastTwoWeeks();
    final result = await supabase.getClassifications(
        uid: uid, startDate: dates[0], endDate: dates[dates.length - 1]);
    classifications = result;

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

  
}
