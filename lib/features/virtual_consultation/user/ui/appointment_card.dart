import 'package:flutter/material.dart';

class AppointmentCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final List<Map<String, String>> dates;

  const AppointmentCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.dates,
  }) : super(key: key);

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool _isExpanded = false;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'canceled':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'pending':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image with rounded corners
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    widget.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 50);
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Name
                Expanded(
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Expand/Collapse Icon
                if (widget.dates.length > 1)
                  IconButton(
                    icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Dates
            if (!_isExpanded)
              Row(
                children: [
                  Icon(Icons.circle, size: 12, color: _getStatusColor(widget.dates[0]['status']!)),
                  const SizedBox(width: 8),
                  Text(
                    widget.dates[0]['date']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.dates[0]['status']!,
                    style: TextStyle(fontSize: 14, color: _getStatusColor(widget.dates[0]['status']!)),
                  ),
                  if (widget.dates.length > 1)
                    const Text('  ...', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.dates.map((dateInfo) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 12, color: _getStatusColor(dateInfo['status']!)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dateInfo['date']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          dateInfo['status']!,
                          style: TextStyle(fontSize: 14, color: _getStatusColor(dateInfo['status']!)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
