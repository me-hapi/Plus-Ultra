import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/ui/profile_page.dart';

class ProfessionalCard extends StatelessWidget {
  final Map<String, dynamic> professionalData;

  const ProfessionalCard({
    Key? key,
    required this.professionalData,
  }) : super(key: key);

  double calculateDistance(
      double userLat, double userLong, double clinicLat, double clinicLong) {
    print('userlat: $userLat, $userLong \n cliniclat: $clinicLat, $clinicLong');
    const double earthRadius = 6371; // Radius of the Earth in km

    double dLat = _degreesToRadians(clinicLat - userLat);
    double dLon = _degreesToRadians(clinicLong - userLong);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(userLat)) *
            cos(_degreesToRadians(clinicLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in km
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    // Getting screen size to make font sizes adaptive
    final screenWidth = MediaQuery.of(context).size.width;

    final String name = professionalData['name'] ?? '';
    final String job = professionalData['job'] ?? '';
    final String imageUrl = professionalData['profileUrl'] ?? '';
    final String location =
        professionalData['professional_clinic']['clinic_address'] ?? '';
    final String? clinicName =
        professionalData['professional_clinic']['clinic_name'];
    final double? clinicLat =
        professionalData['professional_clinic']['clinic_lat'] ?? 0;
    final double? clinicLong =
        professionalData['professional_clinic']['clinic_long'] ?? 0;
    final String distance =
        calculateDistance(userLat, userLong, clinicLat!, clinicLong!)
            .toStringAsFixed(2);

    return GestureDetector(
      onTap: () {
        // Navigate to the ProfessionalPage with data
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         ProfilePage(professionalData: professionalData),
        //   ),
        // );
        context.push('/professional_profile', extra: professionalData);
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
                child:
                    // Image.asset(
                    //   'assets/doctor.jpg',
                    //   width: 70,
                    //   height: 70,
                    // )

                    Image.network(
                  imageUrl,
                  width: 70, // Adjust size for responsiveness
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, StackTrace) {
                    return const Icon(Icons.person, size: 50);
                  },
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
                        color: mindfulBrown['Brown80'],
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Job Title
                    Text(
                      job,
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Location and Distance or Teleconsultation
                    clinicName != null
                        ? Row(
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
                                  fontSize: screenWidth * 0.030,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$distance km',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.030,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Teleconsultation Only',
                            style: TextStyle(
                              fontSize: screenWidth * 0.030,
                              color: Colors.grey[700],
                            ),
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
