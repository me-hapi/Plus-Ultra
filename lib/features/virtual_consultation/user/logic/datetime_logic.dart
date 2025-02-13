import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DateTimeLogic {
  late DateTime selectedDate;
  String? selectedTimeSlot;
  late List<String> timeSlots;

  Map<String, List<Map<String, String>>> parsedTimeSlots = {};
  List<String> availableDays = [];
  Map<String, List<String>> parsedBreakTimes = {};

  DateTimeLogic() {
    selectedDate = DateTime.now();
    timeSlots = [];
  }

  void parseData({
    List<dynamic>? timeSlot,
    List<dynamic>? availableDays,
    List<dynamic>? breakTime,
  }) {
    if (timeSlot != null) {
      for (var slot in timeSlot) {
        final data = jsonDecode(slot);
        final day = data['day'];
        if (!parsedTimeSlots.containsKey(day)) {
          parsedTimeSlots[day] = [];
        }
        parsedTimeSlots[day]?.add({
          'start_time': data['start_time'],
          'end_time': data['end_time'],
        });
      }
    }

    if (availableDays != null) {
      this.availableDays = List<String>.from(availableDays);
    }

    if (breakTime != null) {
      for (int i = 0; i < this.availableDays.length; i++) {
        parsedBreakTimes[this.availableDays[i]] =
            List<String>.from(breakTime[i]);
      }
    }
  }

  void generateTimeSlots(BuildContext context) {
    final dayOfWeek = selectedDate.weekday;
    final selectedDay = getDayName(dayOfWeek);
    final slots = parsedTimeSlots[selectedDay] ?? [];
    final breakTimes = parsedBreakTimes[selectedDay] ?? [];
    List<String> generatedTimeSlots = [];

    for (var slot in slots) {
      final startTime = parseTime(slot['start_time']!);
      final endTime = parseTime(slot['end_time']!);
      DateTime currentTime = startTime;

      while (currentTime.isBefore(endTime)) {
        final formattedTime = formatTime(context, currentTime);
        if (!breakTimes.contains(formattedTime)) {
          generatedTimeSlots.add(formattedTime);
        }
        currentTime = currentTime.add(Duration(minutes: 60));
      }
    }

    timeSlots = generatedTimeSlots;
  }

  DateTime parseTime(String time) {
    final formattedDate = selectedDate.toIso8601String().split('T').first;
    final dateTimeString = '$formattedDate $time';
    final inputFormat = DateFormat("yyyy-MM-dd h:mm a");
    return inputFormat.parse(dateTimeString);
  }

  String formatTime(BuildContext context, DateTime time) {
    return TimeOfDay.fromDateTime(time).format(context);
  }

  String getDayName(int dayOfWeek) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[dayOfWeek - 1];
  }
}
