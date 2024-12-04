import 'package:flutter/material.dart';

class ProfessionalCard extends StatelessWidget {
  final String name;
  final String availability;
  final String imageUrl;
  final VoidCallback onSetAppointment;

  const ProfessionalCard({
    Key? key,
    required this.name,
    required this.availability,
    required this.imageUrl,
    required this.onSetAppointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Getting screen size to make font and button sizes adaptive
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Picture at the center top
            Center(
              child: CircleAvatar(
                radius: screenWidth * 0.15,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            const SizedBox(height: 12),
            // Name
            Text(
              name,
              style: TextStyle(
                fontSize: screenWidth * 0.045, // Reduced adaptive font size to avoid overflow
                fontWeight: FontWeight.bold,
              ),
            ),
            // Availability
            Text(
              availability,
              style: TextStyle(
                fontSize: screenWidth * 0.03, // Adaptive font size
                color: Colors.grey[700],
              ),
            ),
            // Set Appointment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSetAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.03, // Reduced adaptive button padding
                  ),
                ),
                child: Text(
                  'Set Appointment',
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
