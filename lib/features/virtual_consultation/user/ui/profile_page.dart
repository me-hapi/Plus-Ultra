import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/ui/booking_page.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> professionalData;

  const ProfilePage({
    Key? key,
    required this.professionalData,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, String>> experiencestest = [
    {
      'id': '1',
      'uid': '3d5badb2-9a5f-427d-a6a0-32ea86d1559c',
      'date': '2021-2025',
      'description': 'Bachelor of Science in Social Science',
      'institution': 'Don Mariano Marcos Memorial State University'
    },
    {
      'id': '2',
      'uid': 'abcd-1234',
      'date': '2017-2021',
      'description': 'High School Diploma',
      'institution': 'XYZ High School'
    }
  ];
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

  final Map<String, String> categories = {
    "Addiction": "assets/consultation/addiction.png",
    "Anxiety": "assets/consultation/anxiety.png",
    "Children": "assets/consultation/children.png",
    "Depression": "assets/consultation/depression.png",
    "Food": "assets/consultation/food.png",
    "Grief": "assets/consultation/grief.png",
    "LGBTQ": "assets/consultation/lgbtq.png",
    "Psychosis": "assets/consultation/psychosis.png",
    "Sleep": "assets/consultation/sleep.png",
    "Relationship": "assets/consultation/relationship.png",
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final String imageUrl = widget.professionalData['profileUrl'] ?? '';
    final String name = widget.professionalData['name'] ?? '';
    final String job = widget.professionalData['job'] ?? '';
    int sessionFee = 0;
    List specialty = [];
    List experiences = [];

    sessionFee = widget.professionalData['professional_payment']
            ['consultation_fee'] ??
        'Free';
    specialty = widget.professionalData['specialty'][0]['specialty'];
    experiences = widget.professionalData['experience'];
    final String completedSessions =
        widget.professionalData['completedSessions'] ?? '25';
    final String personalBio = widget.professionalData['bio'] ??
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin id arcu aliquet, elementum nisi quis, condimentum nibh.';
    String location = '';
    String? clinicName = '';
    String distance = '';

    if (widget.professionalData['professional_clinic'] != null) {
      location = widget.professionalData['professional_clinic']
              ['clinic_address'] ??
          '';
      clinicName =
          widget.professionalData['professional_clinic']['clinic_name'];
      final double? clinicLat =
          widget.professionalData['professional_clinic']['clinic_lat'] ?? 0;
      final double? clinicLong =
          widget.professionalData['professional_clinic']['clinic_long'] ?? 0;
      distance = calculateDistance(userLat, userLong, clinicLat!, clinicLong!)
          .toStringAsFixed(2);
    }

    // final String location =
    //     widget.professionalData['professional_clinic']['clinic_address'] ?? '';
    // final String? clinicName =
    //     widget.professionalData['professional_clinic']['clinic_name'];
    // final double? clinicLat =
    //     widget.professionalData['professional_clinic']['clinic_lat'] ?? 0;
    // final double? clinicLong =
    //     widget.professionalData['professional_clinic']['clinic_long'] ?? 0;
    // final String distance =
    //     calculateDistance(userLat, userLong, clinicLat!, clinicLong!)
    //         .toStringAsFixed(2);
    // print(experiences);
    Map<String, String> filteredCategories = categories.entries
        .where((entry) => specialty.contains(entry.key))
        .fold<Map<String, String>>({}, (map, entry) {
      map[entry.key] = entry.value;
      return map;
    });

    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top image covering full width
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip
                      .none, // Ensures content extending outside Stack is visible
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Container(
                        width: screenWidth,
                        height: screenWidth,
                        child:
                            // Image.asset('assets/doctor.jpg')
                            Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, StackTrace) {
                            return const Icon(Icons.person, size: 50);
                          },
                        ),
                      ),
                    ),
                    // Positioned Card
                    Positioned(
                      bottom:
                          -screenWidth * 0.12, // Position card below the image
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Container(
                          width: screenWidth * 0.8, // Adjust card width
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Adjust to fit content
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: mindfulBrown['Brown80']),
                              ),
                              Text(
                                job,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: mindfulBrown['Brown80']),
                              ),
                              clinicName != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.location_on,
                                            size: screenWidth * 0.04,
                                            color: mindfulBrown['Brown80']),
                                        const SizedBox(width: 4),
                                        Text(
                                          location,
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.035,
                                              color: mindfulBrown['Brown80']),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          distance,
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.035,
                                              color: mindfulBrown['Brown80']),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'Teleconsultation Only',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //Button
                    Positioned(
                      top: 42,
                      left: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(Icons.arrow_back,
                              color: mindfulBrown['Brown80']),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenWidth * 0.12),
                // Fee and Completed Sessions
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Column(
                          children: [
                            Text(
                              '₱ ${sessionFee.toString()}.00',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                  color: mindfulBrown['Brown80'],
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Session Fee',
                              style: TextStyle(
                                  color: optimisticGray['Gray60'],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        child: VerticalDivider(
                          color: optimisticGray['Gray30'],
                          thickness: 1,
                          width: 1,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Column(
                          children: [
                            Text(
                              completedSessions,
                              style: TextStyle(
                                  color: mindfulBrown['Brown80'],
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Completed Sessions',
                              style: TextStyle(
                                  color: optimisticGray['Gray60'],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // Personal Bio
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Bio',
                        style: TextStyle(
                            color: mindfulBrown['Brown80'],
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        personalBio, // Placeholder for bio
                        style: TextStyle(
                            color: optimisticGray['Gray60'], fontSize: 14.0),
                      ),
                    ],
                  ),
                ),

                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 64.0, vertical: 8.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingPage(
                                  professionalData: widget.professionalData)),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            serenityGreen['Green50'], // Button background color
                        foregroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16),
                        minimumSize: const Size(
                            double.infinity, 52.0), // Set minimum height
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/consultation/schedule.png',
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Set Appointment',
                            style: const TextStyle(
                              fontSize: 18.0, // Set font size
                              fontWeight: FontWeight
                                  .bold, // Optional: Make the text bold
                            ),
                          ),
                        ],
                      )),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Specializations',
                    style: TextStyle(
                        color: mindfulBrown['Brown80'],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: filteredCategories.entries.map((entry) {
                      final String category = entry.key;
                      final String imagePath = entry.value;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              imagePath,
                              height: 25,
                              width: 25,
                            ),
                            SizedBox(width: 8),
                            Text(
                              category,
                              style: TextStyle(
                                color: mindfulBrown['Brown80'],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Experience & History',
                          style: TextStyle(
                              color: mindfulBrown['Brown80'],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    )),

                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: experiences.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final Map<String, dynamic> experience = entry.value;
                        final bool isLast = index == experiences.length - 1;

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return IntrinsicHeight(
                              // Makes sure the row adapts to text height
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      // Green Dot
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: serenityGreen['Green50'],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      if (!isLast)
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            color: serenityGreen['Green50'],
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          experience['institution']!,
                                          style: TextStyle(
                                              color: mindfulBrown['Brown80'],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          experience['description']!,
                                          style: TextStyle(
                                              color: mindfulBrown['Brown80'],
                                              fontSize: 12),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          experience['date']!,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: optimisticGray['Gray50']),
                                        ),
                                        if (!isLast)
                                          SizedBox(
                                              height:
                                                  16), // Add spacing except for the last item
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    )),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
