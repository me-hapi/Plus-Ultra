import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class AppointmentCard extends StatefulWidget {
  final String job;
  final String imageUrl;
  final String name;
  final List<Map<String, dynamic>> dates;

  const AppointmentCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.dates,
    required this.job,
  }) : super(key: key);

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool _isExpanded = false;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return reflectiveBlue['Blue50']!;
      case 'declined':
        return presentRed['Red50']!;
      case 'canceled':
        return empathyOrange['Orange']!;
      case 'completed':
        return serenityGreen['Green50']!;
      case 'pending':
        return zenYellow['Yellow50']!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image with rounded corners
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
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
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: mindfulBrown['Brown80'],
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.job,
                      style: TextStyle(
                        color: optimisticGray['Gray50'],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),

                // Expand/Collapse Icon
                if (widget.dates.length > 1)
                  IconButton(
                    icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more),
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
                  Icon(Icons.circle,
                      size: 12,
                      color: _getStatusColor(widget.dates[0]['status']!)),
                  const SizedBox(width: 8),
                  Text(
                    widget.dates[0]['date']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.dates[0]['status']!,
                    style: TextStyle(
                        fontSize: 14,
                        color: _getStatusColor(widget.dates[0]['status']!)),
                  ),
                  if (widget.dates.length > 1)
                    const Text('  ...',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
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
                        Icon(Icons.circle,
                            size: 12,
                            color: _getStatusColor(dateInfo['status']!)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dateInfo['date']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          dateInfo['status']!,
                          style: TextStyle(
                              fontSize: 14,
                              color: _getStatusColor(dateInfo['status']!)),
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
