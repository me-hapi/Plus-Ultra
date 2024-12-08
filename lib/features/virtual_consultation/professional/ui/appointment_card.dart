import 'package:flutter/material.dart';

class AppointmentCard extends StatefulWidget {
  final String name;
  final String notes;
  final String date;
  final String timeSlot;
  final String status; // Added status parameter
  final void Function() onApprove;
  final void Function(String reason) onDecline;
  final void Function() onJoinCall; // Callback for Join Call

  const AppointmentCard({
    Key? key,
    required this.name,
    required this.notes,
    required this.date,
    required this.timeSlot,
    required this.status, // Added status parameter
    required this.onApprove,
    required this.onDecline,
    required this.onJoinCall, // Added Join Call callback
  }) : super(key: key);

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool _isExpanded = false;

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
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onDecline(declineReason); // Call decline callback
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.name),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notes: ${widget.notes}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Date: ${widget.date}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Time Slot: ${widget.timeSlot}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: widget.status == 'approved'
                        ? [
                            ElevatedButton(
                              onPressed: widget.onJoinCall,
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
                                  onPressed: widget.onApprove,
                                  child: const Text('Approve'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _showDeclineDialog,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: const Text('Decline'),
                                ),
                              ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
