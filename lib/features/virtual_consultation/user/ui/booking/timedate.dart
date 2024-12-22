import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateTimeSelector extends StatefulWidget {
  final void Function(Map<String, dynamic> data)? onDataChanged;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<String>? availableDays;
  final List<String>? breakTime;

  const DateTimeSelector({
    Key? key,
    this.onDataChanged,
    this.startTime,
    this.endTime,
    this.availableDays,
    this.breakTime,
  }) : super(key: key);

  @override
  _DateTimeSelectorState createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  final List<String> _timeSlots = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '6:00 PM',
    '7:00 PM'
  ];

  void _triggerDataChanged() {
    widget.onDataChanged?.call({
      'selectedDate': _selectedDate,
      'selectedTimeSlot': _selectedTimeSlot,
    });
  }

  void _onDateSelected(DateTime date, DateTime? focusedDate) {
    setState(() {
      _selectedDate = date;
    });
    _triggerDataChanged();
  }

  void _onTimeSlotSelected(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
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
        // Transparent Calendar with Gesture Handling
        NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification notification) {
            // Disable glow effect in Android
            notification.disallowIndicator();
            return true;
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
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
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
              ),
              availableGestures:
                  AvailableGestures.none, // Disable TableCalendar gestures
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
            children: _timeSlots.map((timeSlot) {
              return Padding(
                padding: const EdgeInsets.all(2.0), // Adjust padding as needed
                child: SizedBox(
                  width: 120, // Uniform width
                  child: TextButton(
                    onPressed: () => _onTimeSlotSelected(timeSlot),
                    style: TextButton.styleFrom(
                      backgroundColor: _selectedTimeSlot == timeSlot
                          ? Colors.blue
                          : Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(
                      timeSlot,
                      style: TextStyle(
                        color: _selectedTimeSlot == timeSlot
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
