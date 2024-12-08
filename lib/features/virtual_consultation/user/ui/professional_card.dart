import 'package:flutter/material.dart';
import 'package:lingap/features/virtual_consultation/user/ui/profile_page.dart';

class ProfessionalCard extends StatelessWidget {
  final String name;
  final bool availability;
  final String job;
  final String imageUrl;

  const ProfessionalCard({
    Key? key,
    required this.name,
    required this.availability,
    required this.job,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Getting screen size to make font sizes adaptive
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        // Navigate to the ProfessionalPage with data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              name: name,
              jobTitle: job,
              bio:
                  'This is a bio for $name.', // Replace with actual data if needed
              profileImagePath: imageUrl,
              unavailableHours: [
                DateTime(2024, 12, 10, 10, 0), // December 10, 2024, 10:00 AM
                DateTime(2024, 12, 10, 11, 0), // December 10, 2024, 11:00 AM
                DateTime(2024, 12, 11, 9, 0), // December 11, 2024, 9:00 AM
                DateTime(2024, 12, 11, 2, 0), // December 11, 2024, 2:00 PM
                DateTime(2024, 12, 12, 3, 0), // December 12, 2024, 3:00 PM
              ],

              startTime: TimeOfDay(hour: 8, minute: 0),
              endTime: TimeOfDay(hour: 17, minute: 0),
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        child: Stack(
          children: [
            Padding(
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
                      fontSize: name.length > 15
                          ? screenWidth *
                              0.040 // Use smaller font size for names longer than 16 characters
                          : screenWidth * 0.045, // Default font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Job
                  Text(
                    job,
                    style: TextStyle(
                      fontSize: screenWidth * 0.03, // Adaptive font size
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            // Availability Indicator
            if (availability)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
