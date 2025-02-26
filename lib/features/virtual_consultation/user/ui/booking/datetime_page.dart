// date_time_page.dart
import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/virtual_consultation/user/logic/datetime_logic.dart';
import 'package:intl/intl.dart';

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
  late DateTime _focusedDate;

  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
    _logic.parseData(
      timeSlot: widget.timeSlot,
      availableDays: widget.availableDays,
      breakTime: widget.breakTime,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logic.generateTimeSlots(context); // Move here to avoid FlutterError
  }

  void _triggerDataChanged() {
    widget.onDataChanged?.call({
      'selectedDate': _logic.selectedDate,
      'selectedTimeSlot': _logic.selectedTimeSlot,
    });
  }

  void _onDateSelected(DateTime date) {
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
  }

  Widget buildMonthSelector() {
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
              icon: Icon(Icons.arrow_back_ios, color: mindfulBrown['Brown80']),
              onPressed: () {
                setState(() {
                  _focusedDate =
                      DateTime(_focusedDate.year, _focusedDate.month - 1);
                });
              },
            ),
            Text(
              DateFormat.yMMMM().format(_focusedDate),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mindfulBrown['Brown80']),
            ),
            IconButton(
              icon:
                  Icon(Icons.arrow_forward_ios, color: mindfulBrown['Brown80']),
              onPressed: () {
                setState(() {
                  _focusedDate =
                      DateTime(_focusedDate.year, _focusedDate.month + 1);
                });
              },
            ),
          ],
        ));
  }

  Widget buildDayHeaders() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        return Text(
          day,
          style: TextStyle(
            color: optimisticGray['Gray50'],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList(),
    );
  }

  Widget buildMonth() {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final daysInMonth =
        DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
    final startDay = firstDayOfMonth.weekday;
    final List<Widget> days = [];

    // Add empty spaces for the first week
    for (int i = 0; i < startDay - 1; i++) {
      days.add(SizedBox(width: 40));
    }

    for (int i = 1; i <= daysInMonth; i++) {
      final day = DateTime(_focusedDate.year, _focusedDate.month, i);
      final isAvailable =
          widget.availableDays?.contains(_logic.getDayName(day.weekday)) ??
              false;

      days.add(buildDay(day, isAvailable));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: days,
    );
  }

  Widget buildDay(DateTime day, bool isAvailable) {
    final isSelected = _logic.selectedDate != null &&
        _logic.selectedDate!.isAtSameMomentAs(day);
    final today = DateTime.now();

    return GestureDetector(
      onTap: isAvailable ? () => _onDateSelected(day) : null,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isAvailable
              ? day.isBefore(today)
                  ? optimisticGray['Gray50']
                  : isSelected
                      ? reflectiveBlue['Blue50']
                      : serenityGreen['Green50']
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: isAvailable ? Colors.white : mindfulBrown['Brown80'],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: buildMonthSelector(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: buildDayHeaders(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: buildMonth(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Select a Time Slot',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _logic.timeSlots.map((timeSlot) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: () => _onTimeSlotSelected(timeSlot),
                    style: TextButton.styleFrom(
                      backgroundColor: _logic.selectedTimeSlot == timeSlot
                          ? serenityGreen['Green50']
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(
                      timeSlot,
                      style: TextStyle(
                        color: _logic.selectedTimeSlot == timeSlot
                            ? Colors.white
                            : mindfulBrown['Brown80'],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
