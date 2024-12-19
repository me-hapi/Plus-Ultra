import 'package:flutter/material.dart';

class AvailabilityPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const AvailabilityPage({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  String consultationFrequency = 'Everyday';
  List<String> availableDays = [];
  String? startTime;
  String? endTime;
  List<String> breaks = [];

  final List<String> weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'
  ];

  final List<String> weekends = ['Saturday', 'Sunday'];

  final List<String> allDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  final List<String> timeOptions = [
    '7:00 AM', '7:30 AM', '8:00 AM', '8:30 AM', '9:00 AM', '9:30 AM', '10:00 AM',
    '10:30 AM', '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM', '1:00 PM',
    '1:30 PM', '2:00 PM', '2:30 PM', '3:00 PM', '3:30 PM', '4:00 PM',
    '4:30 PM', '5:00 PM', '5:30 PM', '6:00 PM', '6:30 PM', '7:00 PM',
    '7:30 PM', '8:00 PM', '8:30 PM', '9:00 PM', '9:30 PM', '10:00 PM'
  ];

  void _updateAvailableDays() {
    switch (consultationFrequency) {
      case 'Everyday':
        availableDays = List.from(allDays);
        break;
      case 'Weekdays':
        availableDays = List.from(weekdays);
        break;
      case 'Weekends':
        availableDays = List.from(weekends);
        break;
      case 'Custom Days':
        // Keep the custom selection as-is
        break;
    }
  }

  void _triggerDataChanged() {
    widget.onDataChanged({
      'consultationFrequency': consultationFrequency,
      'availableDays': availableDays,
      'startTime': startTime,
      'endTime': endTime,
      'breaks': breaks,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consultation Frequency',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                value: consultationFrequency,
                onChanged: (value) {
                  setState(() {
                    consultationFrequency = value!;
                    if (value != 'Custom Days') {
                      _updateAvailableDays();
                    } else {
                      availableDays.clear();
                    }
                    _triggerDataChanged();
                  });
                },
                items: ['Everyday', 'Weekdays', 'Weekends', 'Custom Days']
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
              ),
              if (consultationFrequency == 'Custom Days') ...[
                SizedBox(height: 16),
                Text(
                  'Select Custom Days',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: allDays.map((day) {
                    final isSelected = availableDays.contains(day);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            availableDays.remove(day);
                          } else {
                            availableDays.add(day);
                          }
                          _triggerDataChanged();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected ? Colors.blue.withOpacity(0.2) : null,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(day),
                      ),
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 16),
              Text(
                'Time Slots per Day',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: startTime,
                      hint: Text('Start Time'),
                      onChanged: (value) {
                        setState(() {
                          startTime = value;
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
                      value: endTime,
                      hint: Text('End Time'),
                      onChanged: (value) {
                        setState(() {
                          endTime = value;
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
                'Breaks or Excluded Hours (Optional)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                hint: Text('Add Break Time'),
                onChanged: (value) {
                  if (value != null && !breaks.contains(value)) {
                    setState(() {
                      breaks.add(value);
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
              SizedBox(height: 8),
              if (breaks.isNotEmpty)
                Wrap(
                  spacing: 10,
                  children: breaks.map((breakTime) {
                    return Chip(
                      label: Text(breakTime),
                      onDeleted: () {
                        setState(() {
                          breaks.remove(breakTime);
                          _triggerDataChanged();
                        });
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
