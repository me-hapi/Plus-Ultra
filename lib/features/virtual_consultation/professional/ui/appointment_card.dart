import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingap/core/const/colors.dart';

class AppointmentCard extends StatefulWidget {
  final String room_id;
  final String name;
  final String date;
  final String timeSlot;
  final String status;
  final String notes;
  final int age;
  final String gender;
  final String email;
  final String number;
  final void Function() onApprove;
  final void Function(String reason) onDecline;
  final void Function() onJoinCall;

  const AppointmentCard({
    Key? key,
    required this.name,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.notes,
    required this.age,
    required this.gender,
    required this.email,
    required this.number,
    required this.onApprove,
    required this.onDecline,
    required this.onJoinCall,
    required this.room_id,
  }) : super(key: key);

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool _isExpanded = false;

  void _toggleCard() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _showDeclineDialog() {
    String declineReason = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Decline Appointment',
            style: TextStyle(color: mindfulBrown['Brown80']),
          ),
          content: TextField(
            onChanged: (value) {
              declineReason = value;
            },
            decoration: InputDecoration(
                hintText: 'Enter reason for declining',
                hintStyle: TextStyle(color: optimisticGray['Gray50'])),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(presentRed['Red50']),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onDecline(declineReason);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(serenityGreen['Green50']),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('MMMM dd, yyyy').format(parsedDate);
  }

  String _formatTime(String time) {
    final DateTime parsedTime = DateFormat('HH:mm').parse(time);
    return DateFormat('h:mm a').format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: Card(
        color: Colors.white,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.name,
                style: TextStyle(
                    fontSize: 18,
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(widget.date),
                    style: TextStyle(color: optimisticGray['Gray50']),
                  ),
                  Text(
                    _formatTime(widget.timeSlot),
                    style: TextStyle(color: optimisticGray['Gray50']),
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Age: ${widget.age}',
                      style: TextStyle(
                        fontSize: 16,
                        color: mindfulBrown['Brown80'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gender: ${widget.gender}',
                      style: TextStyle(
                        fontSize: 16,
                        color: mindfulBrown['Brown80'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: ${widget.email}',
                      style: TextStyle(
                        fontSize: 16,
                        color: mindfulBrown['Brown80'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Number: ${widget.number}',
                      style: TextStyle(
                        fontSize: 16,
                        color: mindfulBrown['Brown80'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Notes: ${widget.notes}',
                      style: TextStyle(
                        fontSize: 16,
                        color: mindfulBrown['Brown80'],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: widget.status == 'approved'
                          ? [
                              ElevatedButton(
                                onPressed: widget.onJoinCall,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: serenityGreen['Green50'],
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Join Call'),
                              ),
                            ]
                          : widget.status == 'completed'
                              ? [
                                  Text(
                                    'Completed',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: serenityGreen['Green50'],
                                    ),
                                  ),
                                ]
                              : [
                                  ElevatedButton(
                                    onPressed: _showDeclineDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: presentRed['Red50'],
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Decline'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: widget.onApprove,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: serenityGreen['Green50'],
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Approve'),
                                  ),
                                ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
