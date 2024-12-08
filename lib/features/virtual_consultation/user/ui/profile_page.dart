import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String jobTitle;
  final String bio;
  final String profileImagePath;
  final List<DateTime> unavailableHours;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const ProfilePage({
    Key? key,
    required this.name,
    required this.jobTitle,
    required this.bio,
    required this.profileImagePath,
    required this.unavailableHours,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  @override
  _ProfessionalPageState createState() => _ProfessionalPageState();
}

class _ProfessionalPageState extends State<ProfilePage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  String? _selectedTimeSlot;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  List<String> _generateTimeSlots(TimeOfDay startTime, TimeOfDay endTime) {
    List<String> timeSlots = [];
    int startHour = startTime.hour;
    int endHour = endTime.hour;

    for (int hour = startHour; hour < endHour; hour++) {
      String startSlot = _format12Hour(TimeOfDay(hour: hour, minute: 0));
      String endSlot = _format12Hour(TimeOfDay(hour: hour + 1, minute: 0));
      timeSlots.add('$startSlot - $endSlot');
    }
    return timeSlots;
  }

  String _format12Hour(TimeOfDay time) {
    final int hour = time.hour;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final int hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${hour12.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  bool _isTimeSlotUnavailable(DateTime day, String slot) {
    // Parse the start hour of the time slot
    int hour = int.parse(slot.split(':')[0]);
    return widget.unavailableHours.any((unavailableDateTime) =>
        unavailableDateTime.year == day.year &&
        unavailableDateTime.month == day.month &&
        unavailableDateTime.day == day.day &&
        unavailableDateTime.hour == hour);
  }

  @override
  Widget build(BuildContext context) {
    List<String> timeSlots =
        _generateTimeSlots(widget.startTime, widget.endTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Professional Page'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is UserScrollNotification) {
            FocusScope.of(context).unfocus(); // Unfocus input fields on scroll
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(widget.profileImagePath),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.jobTitle,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.bio,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Set an Appointment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Listener(
                  onPointerMove: (details) {
                    if (details.delta.dy < 0) {
                      _scrollController.jumpTo(_scrollController.offset + 15);
                    } else if (details.delta.dy > 0) {
                      _scrollController.jumpTo(_scrollController.offset - 15);
                    }
                  },
                  child: TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2024, 1, 1),
                    lastDay: DateTime(2030, 1, 1),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedTimeSlot = null; // Reset time slot on new date
                      });
                    },
                    calendarStyle: CalendarStyle(
                      todayTextStyle: TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text('Select Time Slot:'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    String slot = timeSlots[index];
                    bool isUnavailable =
                        _isTimeSlotUnavailable(_selectedDay, slot);
                    return GestureDetector(
                      onTap: isUnavailable
                          ? null
                          : () {
                              setState(() {
                                _selectedTimeSlot = slot;
                              });
                            },
                      child: Card(
                        color: isUnavailable
                            ? Colors.grey.shade300
                            : (_selectedTimeSlot == slot
                                ? Colors.blue
                                : Colors.white),
                        child: Center(
                          child: Text(
                            slot,
                            style: TextStyle(
                              color: isUnavailable
                                  ? Colors.black
                                  : (_selectedTimeSlot == slot
                                      ? Colors.white
                                      : Colors.black),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Notes',
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedTimeSlot != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Appointment set for $_selectedDay at $_selectedTimeSlot'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please select a time slot before setting an appointment.'),
                          ),
                        );
                      }
                    },
                    child: Text('Set Appointment'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
