import 'package:flutter/material.dart';

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

    return Card(
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
                    fontSize: screenWidth * 0.045, // Reduced adaptive font size to avoid overflow
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
    );
  }
}
