import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatefulWidget {
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
          title: const Text('Decline Appointment'),
          content: TextField(
            onChanged: (value) {
              declineReason = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter reason for declining',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onDecline(declineReason);
                Navigator.of(context).pop();
              },
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
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatDate(widget.date)),
                  Text(_formatTime(widget.timeSlot)),
                ],
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Age: ${widget.age}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Gender: ${widget.gender}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Email: ${widget.email}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Number: ${widget.number}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Notes: ${widget.notes}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: widget.status == 'approved'
                          ? [
                              ElevatedButton(
                                onPressed: widget.onJoinCall,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Join Call'),
                              ),
                            ]
                          : widget.status == 'completed'
                              ? [
                                  const Text(
                                    'Completed',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ]
                              : [
                                  ElevatedButton(
                                    onPressed: _showDeclineDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Decline'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: widget.onApprove,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
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
