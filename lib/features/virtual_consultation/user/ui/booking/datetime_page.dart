// date_time_page.dart
import 'package:flutter/material.dart';
import 'package:lingap/features/virtual_consultation/user/logic/datetime_logic.dart';
import 'package:table_calendar/table_calendar.dart';

class DateTimePage extends StatefulWidget {
  final void Function(Map<String, dynamic> data)? onDataChanged;
  final List<dynamic>? timeSlot;
  final List<dynamic>? availableDays;
  final List<dynamic>? breakTime;

  const DateTimePage({
    Key? key,
    this.onDataChanged,
    this.timeSlot,
    this.availableDays,
    this.breakTime,
  }) : super(key: key);

  @override
  _DateTimePageState createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  final DateTimeLogic _logic = DateTimeLogic();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logic.parseData(
      timeSlot: widget.timeSlot,
      availableDays: widget.availableDays,
      breakTime: widget.breakTime,
    );
    _logic.generateTimeSlots(context);
  }

  void _triggerDataChanged() {
    widget.onDataChanged?.call({
      'selectedDate': _logic.selectedDate,
      'selectedTimeSlot': _logic.selectedTimeSlot,
    });
  }

  void _onDateSelected(DateTime date, DateTime? focusedDate) {
    setState(() {
      _logic.selectedDate = date;
    });
    _logic.generateTimeSlots(context);
    _triggerDataChanged();
  }

  void _onTimeSlotSelected(String timeSlot) {
    setState(() {
      _logic.selectedTimeSlot = timeSlot;
    });
    _triggerDataChanged();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Time Slot Selected'),
        content: Text('You selected $timeSlot'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Select Date',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
       NotificationListener<OverscrollIndicatorNotification>(
  onNotification: (OverscrollIndicatorNotification notification) {
    notification.disallowIndicator(); // Prevent default glow behavior
    return true;
  },
  child: NotificationListener<ScrollNotification>(
    onNotification: (ScrollNotification notification) {
      // Allow the parent to scroll when the calendar reaches its limits
      Scrollable.of(context)?.position.moveTo(
        Scrollable.of(context)!.position.pixels - notification.metrics.pixels,
      );
      return false; // Let the default behavior continue
    },
    child: Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TableCalendar(
        focusedDay: _logic.selectedDate,
        firstDay: DateTime.now().subtract(Duration(days: 365)),
        lastDay: DateTime.now().add(Duration(days: 365)),
        selectedDayPredicate: (day) => isSameDay(_logic.selectedDate, day),
        onDaySelected: _onDateSelected,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(color: Colors.black),
        ),
        enabledDayPredicate: (day) =>
            _logic.availableDays.contains(_logic.getDayName(day.weekday)),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            if (_logic.availableDays
                .contains(_logic.getDayName(day.weekday))) {
              return Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
            return null;
          },
          disabledBuilder: (context, day, focusedDay) {
            return Center(
              child: Text(
                '${day.day}',
                style: TextStyle(color: Colors.black),
              ),
            );
          },
        ),
      ),
    ),
  ),
),


        Divider(color: Colors.grey, height: 1),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Select a Time Slot',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _logic.timeSlots.map((timeSlot) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: 120,
                  child: TextButton(
                    onPressed: () => _onTimeSlotSelected(timeSlot),
                    style: TextButton.styleFrom(
                      backgroundColor: _logic.selectedTimeSlot == timeSlot
                          ? Colors.blue
                          : Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(
                      timeSlot,
                      style: TextStyle(
                        color: _logic.selectedTimeSlot == timeSlot
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
