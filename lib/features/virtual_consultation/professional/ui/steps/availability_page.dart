import 'package:flutter/material.dart';

class AvailabilityPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const AvailabilityPage({Key? key, required this.onDataChanged})
      : super(key: key);

  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  List<String> availableDays = [];
  Map<String, Map<String, dynamic>> timeSlotData = {};
  final List<String> allDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  final Map<String, String> dayShortcuts = {
    'Sunday': 'S',
    'Monday': 'M',
    'Tuesday': 'T',
    'Wednesday': 'W',
    'Thursday': 'Th',
    'Friday': 'F',
    'Saturday': 'S'
  };

  final List<String> timeOptions = [
    '7:00 AM',
    '7:30 AM',
    '8:00 AM',
    '8:30 AM',
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '8:00 PM',
    '8:30 PM',
    '9:00 PM',
    '9:30 PM',
    '10:00 PM'
  ];

  void _triggerDataChanged() {
    widget.onDataChanged({
      'availableDays': availableDays,
      'timeSlotData': timeSlotData,
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Days',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: allDays.map((day) {
                final isSelected = availableDays.contains(day);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        availableDays.remove(day);
                        timeSlotData.remove(day);
                      } else {
                        availableDays.add(day);
                        timeSlotData[day] = {
                          'start_time': null,
                          'end_time': null,
                          'break_time': [],
                        };
                      }
                      _triggerDataChanged();
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      dayShortcuts[day]!,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            if (availableDays.isNotEmpty)
              ...availableDays.map((day) {
                final slotData = timeSlotData[day];
                return Container(
                  width: screenWidth,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              value: slotData!['start_time'],
                              hint: Text('Start Time'),
                              onChanged: (value) {
                                setState(() {
                                  timeSlotData[day]!['start_time'] = value;
                                  _triggerDataChanged();
                                });
                              },
                              items: timeOptions
                                  .map((time) => DropdownMenuItem(
                                        value: time,
                                        child: Text(time),
                                      ))
                                  .toList(),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButton<String>(
                              value: slotData['end_time'],
                              hint: Text('End Time'),
                              onChanged: (value) {
                                setState(() {
                                  timeSlotData[day]!['end_time'] = value;
                                  _triggerDataChanged();
                                });
                              },
                              items: timeOptions
                                  .map((time) => DropdownMenuItem(
                                        value: time,
                                        child: Text(time),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Breaks',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<String>(
                        hint: Text('Add Break Time'),
                        onChanged: (value) {
                          if (value != null &&
                              !slotData['break_time'].contains(value)) {
                            setState(() {
                              timeSlotData[day]!['break_time'].add(value);
                              _triggerDataChanged();
                            });
                          }
                        },
                        items: timeOptions
                            .map((time) => DropdownMenuItem(
                                  value: time,
                                  child: Text(time),
                                ))
                            .toList(),
                      ),
                      if (slotData['break_time'].isNotEmpty)
                        Wrap(
                          spacing: 10,
                          children: slotData['break_time'].map<Widget>((bt) {
                            return Chip(
                              label: Text(bt),
                              onDeleted: () {
                                setState(() {
                                  timeSlotData[day]!['break_time'].remove(bt);
                                  _triggerDataChanged();
                                });
                              },
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
