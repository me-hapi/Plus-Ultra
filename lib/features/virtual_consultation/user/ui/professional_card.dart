import 'package:flutter/material.dart';
import 'package:lingap/features/virtual_consultation/user/ui/profile_page.dart';

class ProfessionalCard extends StatelessWidget {
  final String name;
  final String job;
  final String imageUrl;
  final String location;
  final String distance;

  const ProfessionalCard({
    Key? key,
    required this.name,
    required this.job,
    required this.imageUrl,
    required this.location,
    required this.distance,
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
              imageUrl: imageUrl,
              name: name,
              job: job,
              location: location,
              distance: distance,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Picture on the left
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  imageUrl,
                  width: screenWidth * 0.2, // Adjust size for responsiveness
                  height: screenWidth * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              // Text details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF473c38),
                        fontSize: screenWidth * 0.050,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Job Title
                    Text(
                      job,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Location and Distance
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: screenWidth * 0.04,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          distance,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow on the right
              Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.05,
                color: Color(0xFF473c38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
